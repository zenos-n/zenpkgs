"""Compare a freshly compiled package bundle with the registry contract in a VM."""

import json
import re
import subprocess
import sys
from pathlib import Path
from tempfile import TemporaryDirectory


def validate_records(packages):
    """Check data-only identities without evaluating or building packages."""
    identities, categories, outputs = set(), set(), set()
    for entry in packages:
        identity = entry["meta"]["id"]
        assert isinstance(identity, str) and re.fullmatch(
            r"[A-Za-z][A-Za-z0-9_-]*(?:\.[A-Za-z][A-Za-z0-9_-]*)+", identity
        ), "invalid reverse-DNS identity"
        target = identity.split(".")
        assert target[0] not in ("legacy", "byCategories"), "reserved identity root"
        assert entry["id"] == "pkgs." + identity, "noncanonical registry ID"
        assert entry["target"] == target, "canonical target differs from identity"
        category = entry["categoryTarget"]
        assert isinstance(category, list) and category and all(
            isinstance(part, str) and re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9_-]*", part)
            for part in category
        ), "invalid category target"
        assert category[0] != "legacy" and category[-1] != "package", "reserved category target"
        canonical, category = tuple(target), tuple(category)
        assert canonical not in identities, "duplicate package identity"
        assert category not in categories, "duplicate category target"
        output = "zenos-" + "-".join(target)
        assert output not in outputs, "ambiguous flattened public output"
        identities.add(canonical)
        categories.add(category)
        outputs.add(output)
    for paths in (identities, categories):
        assert all(path[:length] not in paths for path in paths
                   for length in range(1, len(path))), "package leaf/branch collision"


def main():
    bundle_path, fixture_path, adapter_root, nixpkgs = map(Path, sys.argv[1:])
    bundle = json.loads(bundle_path.read_text())
    expected = json.loads(fixture_path.read_text())
    with TemporaryDirectory(prefix="catalog-interfaces-") as temporary:
        root = Path(temporary)
        for source in bundle["sources"]:
            if source["kind"] != "zpkg":
                continue
            relative = Path(source["path"])
            assert not relative.is_absolute() and ".." not in relative.parts
            assert relative.parts[0] == "pkgs" and relative.suffix == ".zpkg"
            destination = root / "interfaces" / (str(relative) + ".nix")
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_text(source["compiledNix"])

        expression = f'''
          let
            lib = import {nixpkgs}/lib;
            adapter = import {adapter_root}/dsl-bundle.nix {{ inherit lib; }};
            interface = import {adapter_root}/interface.nix {{ inherit lib; }};
            registry = adapter.registryFromBundle {{
              bundle = builtins.fromJSON (builtins.readFile {bundle_path});
              bundlePath = {root};
            }};
          in interface.registryDocs registry
        '''
        result = subprocess.run(
            ["nix-instantiate", "--eval", "--strict", "--json", "--expr", expression],
            capture_output=True, text=True,
        )
        if result.returncode:
            sys.stderr.write(result.stderr)
            result.check_returncode()
        actual = json.loads(result.stdout)
    validate_records(actual["packages"])
    validate_records(expected["packages"])
    actual_records = {entry["id"]: entry for entry in actual["packages"]}
    expected_records = {entry["id"]: entry for entry in expected["packages"]}
    assert len(actual_records) == len(actual["packages"]), "duplicate package identities"
    assert actual_records == expected_records, "compiled registry differs from fixture"
    assert all(not entry["categoryTarget"][:2] in (["apps", "advanced"], ["apps", "utilities"])
               and entry["categoryTarget"][0] != "programs" for entry in actual["packages"])
    print(f"Verified {len(actual_records)} freshly compiled package records")


if __name__ == "__main__":
    main()
