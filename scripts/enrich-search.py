#!/usr/bin/env python3
"""Enrich a schema archive without building packages.

The optional cache reader is NixOS/nixos-search's desktop-entries-index.py,
loaded from the exact revision recorded by CI, not copied into ZenPkgs.
"""
import argparse
import concurrent.futures
import hashlib
import gzip
import importlib.util
import json
import os
from pathlib import Path
import re
import sys
import threading
from xml.etree import ElementTree


def nodes(tree):
    for node in tree.values():
        if not isinstance(node, dict):
            continue
        yield node
        yield from nodes(node.get("sub", {}))


def source_url(path, revision, nixpkgs_revision, roots=()):
    if not isinstance(path, str):
        return None
    if path.startswith("https://"):
        return path
    for source in roots:
        source_revision = source.get("revision") or (revision if source["repository"] == "zenos-n/zenpkgs" else None)
        if path.startswith(source["root"] + "/") and source_revision:
            relative = path[len(source["root"]) + 1:]
            if ".." in relative.split("/"):
                return None
            relative = re.sub(r":(\d+)$", r"#L\1", relative)
            return f'https://github.com/{source["repository"]}/blob/{source_revision}/{relative}'
    match = re.match(r"/nix/store/[^/]+/(.*)", path)
    relative = match.group(1) if match else path
    relative = relative.removeprefix("builds/").removesuffix(".nix") if relative.endswith(".zmdl.nix") else relative
    if relative.startswith(("pkgs/", "modules/", "nixos/", "lib/")):
        # Generated DSL definitions belong to ZenPkgs, ordinary Nix to Nixpkgs.
        own = relative.endswith((".zpkg", ".zmdl", ".zstr"))
        if match and not own:
            return None
        repo, rev = ("zenos-n/zenpkgs", revision) if own else ("NixOS/nixpkgs", nixpkgs_revision)
        location = re.sub(r":(\d+)$", r"#L\1", relative)
        if rev and ".." not in relative.split("/"):
            return f"https://github.com/{repo}/blob/{rev}/{location}"
    return None


def cached_directory(scanner, path, remaining=16):
    """Resolve directory symlinks, including wrappers' bin -> another output."""
    if remaining == 0 or not path.startswith("/nix/store/"):
        return None
    head, _, inner = path.removeprefix("/nix/store/").partition("/")
    listing = scanner.listing(head.split("-", 1)[0])
    if listing is None:
        return None
    node = listing.get("root", {})
    walked = Path("/nix/store") / head
    parts = inner.split("/") if inner else []
    if node.get("type") == "symlink":
        target = node["target"]
        if not target.startswith("/"):
            target = os.path.normpath(str(walked.parent / target))
        return cached_directory(scanner, str(Path(target).joinpath(*parts)), remaining - 1)
    for index, part in enumerate(parts):
        node = node.get("entries", {}).get(part, {})
        walked /= part
        if node.get("type") == "symlink":
            target = node["target"]
            if not target.startswith("/"):
                target = os.path.normpath(str(walked.parent / target))
            return cached_directory(scanner, str(Path(target).joinpath(*parts[index + 1:])), remaining - 1)
    return node.get("entries", {}) if node.get("type") == "directory" else {}


def local_artwork(output, reader, icons):
    entries, screenshots, components = [], [], []
    for file in sorted((output / "share/applications").glob("*.desktop")):
        entry = reader.parse_desktop_file(file.read_text(errors="replace"))
        if not entry:
            continue
        icon = entry.get("icon")
        candidates = []
        if icon:
            if icon.startswith("/"):
                candidates = [Path(icon)]
            else:
                for directory in ("share/icons", "share/pixmaps"):
                    candidates.extend((output / directory).rglob(f"{icon}.*"))
            candidates = sorted((p for p in candidates if p.suffix.lower() in (".png", ".svg", ".webp", ".jpg") and p.is_file()), key=lambda p: ("symbolic" in str(p), -p.stat().st_size))
            if candidates:
                data = candidates[0].read_bytes()
                name = hashlib.sha256(data).hexdigest() + candidates[0].suffix.lower()
                (icons / name).write_bytes(data)
                entry["iconFile"] = name
        entries.append(entry)
    for directory in ("share/metainfo", "share/appdata"):
        for file in sorted((output / directory).glob("*.xml")):
            component = reader.parse_metainfo(file.read_text(errors="replace"))
            if component:
                if component["id"]:
                    components.append(component["id"])
                screenshots.extend(component["screenshots"])
    return entries, screenshots, components


def reference_catalog(xml, reader):
    references = {}
    for component in ElementTree.fromstring(xml).findall("component"):
        identifier = component.findtext("id")
        if not identifier:
            continue
        identifier = identifier.removesuffix(".desktop")
        remote_icons = [icon for icon in component.findall("icon") if icon.get("type") == "remote" and (icon.text or "").startswith("https://")]
        icon = max(remote_icons, key=lambda icon: int(icon.get("width", "0")), default=None)
        parsed = reader.parse_metainfo(ElementTree.tostring(component, encoding="unicode")) or {}
        release = component.find("releases/release")
        references[identifier.removesuffix(".desktop")] = {
            "iconUrl": icon.text if icon is not None else None,
            "screenshots": parsed.get("screenshots", []),
            "reference": {"componentId": identifier, "url": "https://flathub.org/apps/" + identifier, "version": release.get("version") if release is not None else None},
        }
    return references


def load_references(reader, cache):
    target = cache / "flathub.xml.gz"
    try:
        response = reader.requests.get("https://dl.flathub.org/repo/appstream/x86_64/appstream.xml.gz", timeout=30)
        response.raise_for_status()
        references = reference_catalog(gzip.decompress(response.content), reader)
        staged = target.with_suffix(".tmp")
        staged.write_bytes(response.content)
        staged.replace(target)
        return references
    except Exception as error:
        print(f"Reference artwork catalog: {type(error).__name__}", file=sys.stderr)
        if target.exists():
            try:
                return reference_catalog(gzip.decompress(target.read_bytes()), reader)
            except (OSError, ValueError, ElementTree.ParseError):
                pass
        return {}


def reference_artwork(reference, scanner, icons):
    if not reference:
        return None
    result = dict(reference)
    url = result.get("iconUrl")
    if url:
        record = scanner.cache_dir / ("reference-icon-" + hashlib.sha256(url.encode()).hexdigest() + ".json")
        try:
            file = json.loads(record.read_text()) if record.exists() else None
        except (ValueError, OSError):
            file = None
        if file and (icons / file).is_file():
            result["iconFile"] = file
        else:
            try:
                response = scanner.session.get(url, timeout=20)
                response.raise_for_status()
                data = response.content
                if len(data) <= 1024 * 1024 and data.startswith(b"\x89PNG\r\n\x1a\n"):
                    file = scanner.store_image(data, ".png", icons)
                    record.write_text(json.dumps(file))
                    result["iconFile"] = file
            except Exception:
                pass
    return result if result.get("iconFile") or result["screenshots"] else None


def inventory(details, reader, scanner, icons, asset_url, references=None, identity=None):
    programs, entries, screenshots, component_ids = set(), [], [], []
    missing, errors = False, []
    references = references or {}
    reference = reference_artwork(references.get(identity), scanner, icons)
    for output_path in details.get("outputPaths", []):
        output = Path(output_path)
        binaries_read = False
        try:
            if output.is_dir():
                for directory in ("bin", "sbin"):
                    programs.update(p.name for p in (output / directory).glob("*") if not p.name.startswith(".") and p.is_file() and os.access(p, os.X_OK))
                binaries_read = True
                apps, shots, components = local_artwork(output, reader, icons)
                entries.extend(apps); screenshots.extend(shots); component_ids.extend(components)
            else:
                binaries = cached_directory(scanner, output_path + "/bin")
                if binaries is None:
                    missing = True
                    continue
                programs.update(name for name, node in binaries.items() if not name.startswith(".") and (node.get("type") == "symlink" or (node.get("type") == "regular" and node.get("executable", False))))
                programs.update(name for name, node in (cached_directory(scanner, output_path + "/sbin") or {}).items() if not name.startswith(".") and (node.get("type") == "symlink" or (node.get("type") == "regular" and node.get("executable", False))))
                binaries_read = True
                targets = {}
                by_nar = {}
                inners = scanner.indexed_files(output_path) or []
                if not reference:
                    for inner in inners:
                        identifier = Path(inner).name.removesuffix(".metainfo.xml").removesuffix(".appdata.xml").removesuffix(".desktop")
                        reference = reference_artwork(references.get(identifier), scanner, icons)
                        if reference:
                            break
                if reference:
                    continue
                for inner in inners:
                    resolved = scanner.resolve(f"{output_path}/{inner}")
                    if resolved is None:
                        errors.append("unresolved")
                        continue
                    targets[inner] = resolved
                    by_nar.setdefault(resolved[0], []).append(resolved[1])
                contents = {nar: scanner.fetch_entries(nar, paths) for nar, paths in by_nar.items()}
                for inner, (nar, path) in targets.items():
                    data = contents[nar].get(path)
                    if data is None:
                        errors.append("unresolved")
                    elif inner.endswith(".desktop"):
                        entries.append(data)
                    else:
                        screenshots.extend(data["screenshots"])
                        if data["id"]:
                            component_ids.append(data["id"])
        except Exception as error:
            # A bad/uncached output must not discard other packages' metadata.
            errors.append(type(error).__name__)
            if not binaries_read:
                missing = True
    result = {"binaryStatus": "partial" if missing else "complete", "desktopEntries": entries, "componentIds": sorted(set(component_ids))}
    if not missing or programs:
        result["programs"] = sorted(programs)
    result["artworkStatus"] = "indexed" if entries or screenshots else "unavailable" if missing or errors else "no-entries"
    for entry in entries:
        file = entry.pop("iconFile", None)
        if file and not entry.get("noDisplay") and "icon" not in result:
            result["icon"] = asset_url.rstrip("/") + "/icons/" + file
    if reference:
        used_reference = False
        if "icon" not in result and reference.get("iconFile"):
            result["icon"] = asset_url.rstrip("/") + "/icons/" + reference["iconFile"]
            used_reference = True
        if not screenshots and reference["screenshots"]:
            screenshots = reference["screenshots"]
            used_reference = True
        if used_reference:
            result["artworkReference"] = reference["reference"]
            result["artworkStatus"] = "indexed"
    result["screenshots"] = list({shot["url"]: {"url": shot["url"], "caption": shot.get("caption"), "source": shot["url"]} for shot in screenshots if shot["url"].startswith("https://")}.values())
    if errors:
        result["indexErrors"] = sorted(set(errors))
    return result


def enrich(catalog, manifest, reader, scanner, icons, asset_url, previous=None, references=None):
    revision = catalog.get("metadata", {}).get("zenpkgsVersion")
    nixpkgs_revision = manifest.get("nixpkgsRevision")
    packages = [node for node in nodes(catalog.get("pkgs", {})) if node.get("meta", {}).get("kind") == "package"]
    prior = {node.get("meta", {}).get("id"): node.get("meta", {}) for node in nodes((previous or {}).get("pkgs", {}))}
    def update(node):
        meta = node["meta"]
        details = manifest["packages"].get(meta.get("id"), {})
        if details.get("status") == "evaluated":
            # Authored descriptions, maintainers and version remain authoritative.
            for key, value in details.items():
                if key not in ("status", "outputPaths", "maintainers", "version", "drvPath") and value is not None:
                    meta[key] = value
            meta["resolvedVersion"] = details.get("version")
            if not meta.get("sourceRepository"):
                repository = re.match(r"https://(?:github\.com|codeload\.github\.com)/([^/]+/[^/]+)", details.get("sourceArchive") or "")
                if repository:
                    meta["sourceRepository"] = "https://github.com/" + repository.group(1).removesuffix(".git")
            meta["indexedOutputPaths"] = details["outputPaths"]
            meta.update(inventory(details, reader, scanner, icons, asset_url, references, meta.get("id", "").removeprefix("pkgs.")))
            saved = prior.get(meta.get("id"), {})
            # Reuse only identical store outputs, never a similarly named release.
            if saved.get("indexedOutputPaths") == details["outputPaths"]:
                if meta["binaryStatus"] != "complete" and saved.get("binaryStatus") == "complete" and isinstance(saved.get("programs"), list):
                    meta["programs"] = saved["programs"]
                    meta["binaryStatus"] = "complete"
                if meta["artworkStatus"] == "unavailable" and saved.get("artworkStatus") == "indexed":
                    for key in ("icon", "screenshots", "desktopEntries", "componentIds", "artworkStatus", "artworkReference"):
                        if key in saved:
                            meta[key] = saved[key]
        else:
            meta["binaryStatus"] = "unavailable"
            meta["artworkStatus"] = "unavailable"
        meta["sourceUrl"] = source_url(meta.get("sourcePath"), revision, nixpkgs_revision, manifest.get("sourceRoots", []))
        if details.get("position"):
            meta["upstreamDefinition"] = source_url(details["position"], revision, nixpkgs_revision, manifest.get("sourceRoots", []))
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        pending = [pool.submit(update, package) for package in packages]
        for completed, future in enumerate(concurrent.futures.as_completed(pending), 1):
            future.result()
            if completed % 100 == 0:
                print(f"Indexed {completed}/{len(packages)} packages", file=sys.stderr, flush=True)
    for node in nodes(catalog.get("options", {})):
        meta = node.get("meta", {})
        meta["declarations"] = list(filter(None, (source_url(path, revision, nixpkgs_revision, manifest.get("sourceRoots", [])) for path in meta.get("declarations", []))))
    catalog.setdefault("metadata", {})["packageEnrichment"] = {"system": manifest["system"], "packages": len(packages), "complete": sum(node["meta"].get("binaryStatus") == "complete" for node in packages)}
    return catalog


def mirror_screenshots(catalog, scanner, asset_url):
    shots = [shot for node in nodes(catalog.get("pkgs", {})) for shot in node.get("meta", {}).get("screenshots", [])]
    def mirror(url):
        try:
            return url, scanner.fetch_screenshot(url)
        except Exception:
            return url, None
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        mirrored = dict(pool.map(mirror, sorted({shot["url"] for shot in shots if not shot["url"].startswith(asset_url.rstrip("/") + "/")})))
    for shot in shots:
        files = mirrored.get(shot["url"])
        if files:
            small, large = files
            shot["thumbnail"] = asset_url.rstrip("/") + "/screenshots/" + small
            shot["url"] = asset_url.rstrip("/") + "/screenshots/" + (large or small)
    return catalog


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("catalog", type=Path)
    parser.add_argument("manifest", type=Path)
    parser.add_argument("--scanner", type=Path, required=True)
    parser.add_argument("--assets", type=Path, required=True)
    parser.add_argument("--asset-url", required=True)
    parser.add_argument("--cache", type=Path, required=True)
    parser.add_argument("--previous", type=Path)
    parser.add_argument("--popularity", type=Path)
    args = parser.parse_args()
    spec = importlib.util.spec_from_file_location("nixos_search_desktop", args.scanner)
    reader = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = reader
    spec.loader.exec_module(reader)
    icons = args.assets / "icons"
    icons.mkdir(parents=True, exist_ok=True)
    class Scanner(reader.Scanner):
        # Different NARs can run concurrently; one NAR's cache has one writer.
        locks = {}
        guard = threading.Lock()
        def fetch_entries(self, *args):
            with self.guard:
                lock = self.locks.setdefault(args[0], threading.Lock())
            with lock:
                return super().fetch_entries(*args)
    scanner = Scanner(args.cache, icon_dir=icons, icon_extensions=(".png", ".svg"), icon_pixel_size=96, icon_colors=256, icon_svg_max_bytes=32768, screenshot_dir=args.assets / "screenshots", screenshot_pixel_size=400, screenshot_quality=82, screenshot_large_pixel_size=1200, screenshot_large_quality=80)
    previous = json.loads(args.previous.read_text()) if args.previous and args.previous.is_file() else None
    references = load_references(reader, args.cache)
    catalog = enrich(json.loads(args.catalog.read_text()), json.loads(args.manifest.read_text()), reader, scanner, icons, args.asset_url, previous, references)
    if args.popularity:
        popularity = json.loads(args.popularity.read_text())
        for node in nodes(catalog.get("pkgs", {})):
            meta = node.get("meta", {})
            meta.update(popularity["packages"].get(meta.get("id"), {}))
    mirror_screenshots(catalog, scanner, args.asset_url)
    staged = args.catalog.with_suffix(".tmp")
    staged.write_text(json.dumps(catalog, ensure_ascii=False))
    staged.replace(args.catalog)
    print(json.dumps(catalog["metadata"]["packageEnrichment"]))


if __name__ == "__main__":
    main()
