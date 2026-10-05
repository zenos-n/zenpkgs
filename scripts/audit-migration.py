#!/usr/bin/env python3
"""Read-only migration inventory. Never read credential files or unit contents."""
import argparse
import datetime
import json
import os
import re
from pathlib import Path
import shutil
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, help="Write JSON here instead of stdout")
    parser.add_argument("--check", action="store_true", help="Fail if a Nix profile package lacks a catalog match")
    args = parser.parse_args()
    repo = Path(__file__).resolve().parent.parent
    home = Path.home()
    warnings = []

    def run(*command):
        if not shutil.which(command[0]):
            warnings.append(f"Unavailable command: {command[0]}")
            return ""
        result = subprocess.run(command, text=True, capture_output=True, timeout=60, check=False)
        if result.returncode:
            warnings.append(f"Could not collect {command[0]} {command[1]} (exit {result.returncode})")
            return ""
        return result.stdout

    catalog = {}
    for path in (repo / "pkgs").rglob("*.zpkg"):
        identity = "pkgs." + ".".join(path.relative_to(repo / "pkgs").with_suffix("").parts)
        catalog.setdefault(path.stem, []).append(identity)
        provider = re.search(r"import \$pkgs\.legacy\.([\w.-]+)\s*;", path.read_text())
        if provider:
            leaf = provider.group(1).split(".")[-1]
            if identity not in catalog.setdefault(leaf, []):
                catalog[leaf].append(identity)

    profile = json.loads(run("nix", "profile", "list", "--json") or '{"elements":{}}')
    profile_entries = []
    for name, entry in sorted(profile.get("elements", {}).items()):
        leaf = (entry.get("attrPath") or name).split(".")[-1]
        profile_entries.append({
            "name": name,
            "attribute": entry.get("attrPath"),
            "active": entry.get("active", True),
            "storePaths": entry.get("storePaths", []),
            "catalogMatches": sorted(catalog.get(leaf, catalog.get(name, []))),
        })

    flatpaks = []
    for scope in ("user", "system"):
        for line in run("flatpak", "list", f"--{scope}", "--app", "--columns=application,origin,branch").splitlines():
            fields = line.split("\t")
            if len(fields) == 3:
                flatpaks.append(dict(zip(("appId", "origin", "branch"), fields), scope=scope))

    extensions = []
    extension_root = home / ".local/share/gnome-shell/extensions"
    for path in sorted(extension_root.glob("*/metadata.json")):
        try:
            metadata = json.loads(path.read_text())
            extensions.append({
                "uuid": metadata.get("uuid", path.parent.name),
                "version": metadata.get("version"),
                "shellVersions": metadata.get("shell-version", []),
            })
        except (ValueError, OSError):
            warnings.append(f"Cannot read extension metadata: {path.parent.name}")

    units = [line.split()[0] for line in run(
        "systemctl", "--user", "list-unit-files", "--state=enabled", "--no-legend", "--no-pager"
    ).splitlines() if line.strip()]
    local_bin = home / ".local/bin"
    report = {
        "collectedAt": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "currentSystem": os.path.realpath("/run/current-system"),
        "nixProfile": profile_entries,
        "unmatchedProfilePackages": [entry["name"] for entry in profile_entries if not entry["catalogMatches"]],
        "flatpakApplications": flatpaks,
        "localExtensions": extensions,
        "enabledUserUnits": units,
        "localExecutables": sorted(path.name for path in local_bin.iterdir()) if local_bin.is_dir() else [],
        "localDesktopEntries": sorted(path.name for path in (home / ".local/share/applications").glob("*.desktop")),
        "warnings": warnings,
    }
    output = json.dumps(report, indent=2) + "\n"
    if args.output:
        args.output.write_text(output)
    else:
        print(output, end="")
    return int(args.check and (report["unmatchedProfilePackages"] or warnings) != [])


if __name__ == "__main__":
    raise SystemExit(main())
