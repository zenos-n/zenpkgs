"""Compare a freshly compiled package bundle with the registry contract in a VM."""

import json
import subprocess
import sys
from pathlib import Path
from tempfile import TemporaryDirectory


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
    actual_records = {entry["id"]: entry for entry in actual["packages"]}
    expected_records = {entry["id"]: entry for entry in expected["packages"]}
    assert len(actual_records) == len(actual["packages"]), "duplicate package identities"
    assert actual_records == expected_records, "compiled registry differs from fixture"
    assert all(not entry["target"][:2] in (["apps", "advanced"], ["apps", "utilities"])
               and entry["target"][0] != "programs" for entry in actual["packages"])
    print(f"Verified {len(actual_records)} freshly compiled package records")


if __name__ == "__main__":
    main()
