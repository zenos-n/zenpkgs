"""Run inside the ZenOS VM, with pinned Nixpkgs and Home Manager source paths."""
import argparse
import json
from pathlib import Path
import subprocess
import tempfile

from zenlang.compiler import compile_tree


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--nixpkgs", required=True)
    parser.add_argument("--home-manager", required=True)
    parser.add_argument("--case", help="Evaluate one named acceptance result")
    args = parser.parse_args()
    tests = Path(__file__).resolve().parent
    root = tests.parent.parent
    with tempfile.TemporaryDirectory(prefix="zstr-acceptance-") as temporary:
        bundle = Path(temporary) / "bundle.json"
        bundle.write_text(json.dumps(compile_tree(tests / "fixtures")), encoding="utf-8")
        expression = (
            f"import {tests / 'acceptance.nix'} {{ "
            f"nixpkgsPath = {args.nixpkgs}; homeManagerPath = {args.home_manager}; "
            f"runtimePath = {root / 'lib/zstr-runtime.nix'}; bundlePath = {bundle}; }}"
        )
        if args.case:
            expression = f"({expression}).{json.dumps(args.case)}"
        subprocess.run(["nix", "eval", "--impure", "--json", "--expr", expression], check=True)


if __name__ == "__main__":
    main()
