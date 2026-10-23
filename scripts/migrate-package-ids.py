#!/usr/bin/env python3
"""Add/check catalog IDs without Nix, network access, or store traversal.

Filesystem categories stay intact. Consumers use registry id ``pkgs.`` + id,
target id.split('.'), and categoryTarget from the relative file path. The
pkgs.byCategories view must alias that same derivation, not register it twice;
pkgs.legacy stays upstream and old root category aliases are not retained.
This script migrates declarations only, not the registry implementation.
"""

import argparse
from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[1] / "pkgs"
# Explicit user-provided identities; do not infer ownership from package names.
KNOWN = {
    "apps/browsers/firefox": "org.mozilla.firefox",
    "apps/ai/codex": "com.openai.codex.cli",
    "apps/ai/codex-desktop": "com.openai.codex.desktop",
    # modules/desktops/gnome.zmdl lists org.gnome.Nautilus.desktop.
    "apps/system/nautilus": "org.gnome.Nautilus",
    # ../jupiter/meson.build: application_id (default, unprofiled target).
    "apps/browsers/jupiter": "io.github.doromiert.Jupiter",
    # ../select-for-figma/data/io.github.doromiert.SelectForFigma.metainfo.xml.
    "apps/graphics/select-for-figma": "io.github.doromiert.SelectForFigma",
    # Verified against /run/current-system/sw/share/applications/<id>.desktop:
    # Name/Exec identify these applications; preserve upstream ID capitalization.
    "apps/development/gnome-builder": "org.gnome.Builder",
    "apps/science/gnome-calculator": "org.gnome.Calculator",
    "apps/office/gnome-calendar": "org.gnome.Calendar",
    "apps/office/gnome-characters": "org.gnome.Characters",
    "apps/recovery/gnome-disks": "org.gnome.DiskUtility",
    "apps/system/gnome-extensions-app": "org.gnome.Extensions",
    "apps/system/administration/gnome-logs": "org.gnome.Logs",
    "apps/system/gnome-control-center": "org.gnome.Settings",
    "apps/system/gnome-system-monitor": "org.gnome.SystemMonitor",
    "apps/editors/gnome-text-editor": "org.gnome.TextEditor",
    "apps/storage/baobab": "org.gnome.baobab",
    "apps/office/gnome-clocks": "org.gnome.clocks",
    "apps/system/administration/gnome-font-viewer": "org.gnome.font-viewer",
    "apps/system/gnome-tweaks": "org.gnome.tweaks",
    "apps/graphics/loupe": "org.gnome.Loupe",
    "apps/office/papers": "org.gnome.Papers",
    "apps/office/simple-scan": "org.gnome.SimpleScan",
    "apps/video/snapshot": "org.gnome.Snapshot",
    "apps/office/geary": "org.gnome.Geary",
    "apps/audio/decibels": "org.gnome.Decibels",
    "apps/video/showtime": "org.gnome.Showtime",
}
SEGMENT = re.compile(r"[A-Za-z][A-Za-z0-9_-]*\Z")
META = re.compile(r"\A(?:\s|#[^\n]*\n)*_meta\s*=\s*\{[^\S\n]*\n")
ID = re.compile(r'^  id = "([^"\n]+)";\s*$', re.MULTILINE)


def normalize(segment):
    """Retain spelling/case; encode punctuation and prefix leading digits.

    Escapes retain distinctions such as ahk_x11 versus ahk-x11. All generated
    identifiers are also checked globally, including against upstream IDs.
    """
    value = "".join(c if c.isascii() and (c.isalnum() or c == "-")
                    else f"-u{ord(c):x}-" for c in segment)
    if not value or not value[0].isascii() or not value[0].isalpha():
        value = "p-" + value
    return value


def fallback(category):
    return "org.zenos.packages." + ".".join(map(normalize, category.split("/")))


def catalog(write=False):
    seen = {}
    changes = []
    paths = sorted(ROOT.rglob("*.zpkg"))
    for path in paths:
        category = path.relative_to(ROOT).with_suffix("").as_posix()
        text = path.read_text()
        original = text
        match = META.match(text)
        if not match:
            raise ValueError(f"{path}: expected leading _meta block")
        ids = ID.findall(text)
        assignments = re.findall(r"^\s*id\s*=", text, re.MULTILINE)
        if len(assignments) != len(ids) or len(ids) > 1:
            raise ValueError(f"{path}: malformed or repeated id assignment")
        expected = KNOWN.get(category, fallback(category))
        if ids:
            value = ids[0]
            if write and category in KNOWN and value == fallback(category):
                text = ID.sub(lambda m: m.group(0).replace(value, expected, 1),
                              text, count=1)
                value = expected
                changes.append((path, original, text))
            if category in KNOWN and value != expected:
                raise ValueError(f"{path}: expected known ID {expected}, got {value}")
        elif write:
            value = expected
            changes.append((path, text, text[:match.end()] +
                            f'  id = "{value}";\n' + text[match.end():]))
        else:
            raise ValueError(f"{path}: missing required _meta.id")
        parts = value.split(".")
        if len(parts) < 2 or not all(SEGMENT.fullmatch(p) for p in parts):
            raise ValueError(f"{path}: invalid reverse-DNS ID {value!r}")
        if parts[0] in {"legacy", "byCategories"}:
            raise ValueError(f"{path}: reserved package root {parts[0]!r}")
        if value in seen:
            raise ValueError(f"duplicate ID {value}: {seen[value]} and {path}")
        seen[value] = path
    for value, path in seen.items():
        parts = value.split(".")
        for end in range(1, len(parts)):
            prefix = ".".join(parts[:end])
            if prefix in seen:
                raise ValueError(f"prefix collision: {prefix} ({seen[prefix]}) "
                                 f"and {value} ({path})")
    # Validate the entire plan before editing. Refuse to overwrite concurrent edits.
    for path, original, updated in changes:
        if path.read_text() != original:
            raise ValueError(f"{path}: changed during migration; rerun")
        path.write_text(updated)
    print(f"Validated {len(paths)} unique required IDs; updated {len(changes)} files.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true",
                        help="insert missing IDs and upgrade known namespace fallbacks")
    args = parser.parse_args()
    catalog(write=args.write)
