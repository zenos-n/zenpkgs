"""Run module-local alias acceptance inside a private ZenOS VM checkout."""
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
    parser.add_argument("--case")
    args = parser.parse_args()
    tests = Path(__file__).resolve().parent
    with tempfile.TemporaryDirectory(prefix="zmdl-alias-acceptance-") as temporary:
        bundle = Path(temporary) / "bundle.json"
        bundle.write_text(json.dumps(compile_tree(tests / "module-alias-fixtures")), encoding="utf-8")
        expression = (
            f"import {tests / 'module-aliases.nix'} {{ "
            f"nixpkgsPath = {args.nixpkgs}; homeManagerPath = {args.home_manager}; "
            f"runtimePath = {tests.parent.parent / 'lib/zstr-runtime.nix'}; bundlePath = {bundle}; }}"
        )
        if args.case:
            expression = f"({expression}).{json.dumps(args.case)}"
        subprocess.run(["nix", "eval", "--impure", "--json", "--show-trace", "--expr", expression], check=True)


if __name__ == "__main__":
    main()
