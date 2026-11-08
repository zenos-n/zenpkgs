#!/usr/bin/env python3
"""Compute scoped dependency counts and cache Repology's native-attribute map."""
import argparse
from collections import defaultdict
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import time


def dependency_metrics(manifest, load):
    owners = defaultdict(list)
    for identity, package in manifest["packages"].items():
        if package.get("drvPath"):
            owners[Path(package["drvPath"]).name].append(identity)
    paths = sorted({package["drvPath"] for package in manifest["packages"].values() if package.get("drvPath")})
    inputs = {}
    for offset in range(0, len(paths), 128):
        data = load(paths[offset:offset + 128])
        for path, derivation in data.get("derivations", data).items():
            inputs[Path(path).name] = {Path(key).name for key in derivation.get("inputDrvs", derivation.get("inputs", {}).get("drvs", {}))}
    dependents = defaultdict(set)
    for parent, children in inputs.items():
        for child in children - {parent}:
            if child in owners:
                dependents[child].add(parent)
    result = {}
    for drv, identities in owners.items():
        if drv not in inputs:
            continue
        values = {
            "directBuildInputs": len(inputs[drv]),
            "catalogDependents": len(dependents[drv]),
            "catalogDependencies": sorted({identity for child in inputs[drv] - {drv} for identity in owners.get(child, [])}),
        }
        for identity in identities:
            result[identity] = values
    return result


def merge_repology(counts, page):
    for packages in page.values():
        count = len({package["repo"] for package in packages})
        for package in packages:
            if package["repo"] == "nix_unstable" and package.get("srcname"):
                name = package["srcname"]
                counts[name] = max(counts.get(name, 0), count)


def repology_counts(session, cache):
    try:
        saved = json.loads(cache.read_text())
        if 0 <= time.time() - saved["fetchedEpoch"] < 24 * 3600:
            return saved
    except (OSError, ValueError, KeyError):
        pass
    progress = cache.with_suffix(".partial.json")
    try:
        pending = json.loads(progress.read_text())
        if not 0 <= time.time() - pending["startedEpoch"] < 24 * 3600:
            raise ValueError("expired partial crawl")
    except (OSError, ValueError, KeyError):
        pending = {"counts": {}, "cursor": "", "pages": 0, "startedEpoch": time.time()}
    counts, cursor, pages = pending["counts"], pending["cursor"], pending["pages"]
    while True:
        url = "https://repology.org/api/v1/projects/" + cursor + "?inrepo=nix_unstable"
        for attempt in range(3):
            try:
                response = session.get(url, timeout=30)
            except OSError:
                time.sleep(2 ** attempt)
                continue
            if response.status_code == 429 or response.status_code >= 500:
                delay = min(30, int(response.headers.get("Retry-After", 2 ** attempt)))
                time.sleep(delay)
                continue
            response.raise_for_status()
            try:
                page = response.json()
            except ValueError:
                time.sleep(2 ** attempt)
                continue
            break
        else:
            raise RuntimeError("Repology is temporarily unavailable")
        merge_repology(counts, page)
        pages += 1
        if pages % 20 == 0:
            print(f"Repology: {pages} pages, {len(counts)} native attributes", flush=True)
        if len(page) <= 1:
            break
        next_cursor = max(page) + "/"
        if next_cursor == cursor:
            raise ValueError("Repology cursor did not advance")
        cursor = next_cursor
        if pages % 20 == 0:
            cache.parent.mkdir(parents=True, exist_ok=True)
            pending.update({"counts": counts, "cursor": cursor, "pages": pages})
            staged = progress.with_suffix(".tmp")
            staged.write_text(json.dumps(pending))
            staged.replace(progress)
        time.sleep(1)
    saved = {"counts": counts, "fetchedEpoch": time.time(), "fetchedAt": datetime.now(timezone.utc).isoformat()}
    cache.parent.mkdir(parents=True, exist_ok=True)
    staged = cache.with_suffix(".tmp")
    staged.write_text(json.dumps(saved))
    staged.replace(cache)
    progress.unlink(missing_ok=True)
    return saved


def main():
    import requests
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("manifest", type=Path)
    parser.add_argument("--cache", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    manifest = json.loads(args.manifest.read_text())
    def load(paths):
        return json.loads(subprocess.check_output(["nix", "derivation", "show", *paths], stderr=subprocess.PIPE))
    try:
        packages = dependency_metrics(manifest, load)
    except (subprocess.CalledProcessError, ValueError) as error:
        print(f"Dependency counts unavailable: {type(error).__name__}", flush=True)
        packages = {}
    session = requests.Session()
    session.headers["User-Agent"] = "ZenPkgs Search metadata (https://github.com/zenos-n/zenpkgs)"
    try:
        repology = repology_counts(session, args.cache / "repology-counts.json")
        for identity, package in manifest["packages"].items():
            attribute = package.get("nativeAttribute")
            if attribute in repology["counts"]:
                packages.setdefault(identity, {}).update({"repologyRepositories": repology["counts"][attribute], "repologyFetchedAt": repology["fetchedAt"]})
    except (requests.RequestException, RuntimeError, ValueError) as error:
        print(f"Repology unavailable: {type(error).__name__}", flush=True)
    args.output.write_text(json.dumps({"packages": packages, "system": manifest["system"]}))
    print(f"Popularity metadata: {len(packages)} packages", flush=True)


if __name__ == "__main__":
    main()
