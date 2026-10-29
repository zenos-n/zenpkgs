"""Reject machine-local flake sources before evaluating or publishing ZenPkgs."""
import json
from pathlib import Path
import re
import sys


def local_reference(value):
    return isinstance(value, str) and (
        value.startswith(("path:", "file:", "git+file:", "/", "./", "../", "~/"))
        or bool(re.match(r"[A-Za-z]:[\\/]", value))
    )


def check(root):
    errors = []
    lock = json.loads((root / "flake.lock").read_text())
    for name, node in lock["nodes"].items():
        for section in ("locked", "original"):
            source = node.get(section, {})
            if source.get("type") == "path" or local_reference(source.get("url")):
                errors.append(f"flake.lock: {name}.{section} uses a local source")
    for url in re.findall(r'\burl\s*=\s*"([^"\n]+)"', (root / "flake.nix").read_text()):
        if local_reference(url):
            errors.append(f"flake.nix: local input URL {url}")
    return errors


if __name__ == "__main__":
    for value in ["path:/tmp/source", "path:../source", "file:///tmp/a", "git+file:///tmp/a?rev=123", "/Users/test/a", "../a", r"C:\source"]:
        assert local_reference(value), value
    for value in ["github:zenos-n/blankbox/123", "https://github.com/zenos-n/zenpkgs.git", "git@github.com:zenos-n/zenpkgs.git", None]:
        assert not local_reference(value), value
    errors = check(Path(__file__).resolve().parents[1])
    if errors:
        sys.exit("\n".join(errors))
    print("All flake inputs use remote sources")
