"""Run search ownership acceptance in a VM without production flake outputs."""
import argparse
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

from zenlang import compile_tree


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--nixpkgs", required=True)
    parser.add_argument("--home-manager", required=True)
    tests = Path(__file__).resolve().parent
    cases = [
        ("disjoint-alias-child", "", "", None, None),
        ("disjoint-local-children", "", "", None, None),
        ("duplicate-alias-leaf", "system.syncthing.enable._meta.default = true;", "",
         "system.syncthing.enable", "syncthing.nix"),
        ("duplicate-alias-mount", "", '''{
          _file = "search-upstream-collision.nix";
          options.homeManager.upstreamOnly = (import (nixpkgs + "/lib")).mkEnableOption "upstream child";
        }''', "legacy.homeManager", "search-upstream-collision.nix"),
    ]
    parser.add_argument("--case", choices=[case[0] for case in cases])
    args = parser.parse_args()
    if args.case:
        cases = [case for case in cases if case[0] == args.case]
    with tempfile.TemporaryDirectory(prefix="search-ownership-", dir="/tmp") as temporary:
        for name, declaration, extra_module, collision, upstream_source in cases:
            fixture = Path(temporary) / name
            shutil.copytree(tests / "fixtures", fixture)
            structure = fixture / "structure.zstr"
            text = structure.read_text(encoding="utf-8") + declaration
            if name == "disjoint-alias-child":
                text = '''system.syncthing = {
                  _meta.type = (alias nixpkgs.services.syncthing);
                  _meta.name = "Syncthing";
                  localEnabled._meta.default = true;
                };'''
            structure.write_text(text, encoding="utf-8")
            bundle = fixture / "bundle.json"
            bundle.write_text(json.dumps(compile_tree(fixture)), encoding="utf-8")
            expression = f'''let
              nixpkgs = builtins.toPath {json.dumps(args.nixpkgs)};
            in import {tests / "acceptance.nix"} {{
              inherit nixpkgs;
              home-manager = builtins.toPath {json.dumps(args.home_manager)};
              bundle = import {tests.parent.parent / "lib/read-dsl-bundle.nix"} {bundle};
              extraModules = [ {extra_module} ];
            }}'''
            if name == "disjoint-alias-child":
                expression = f'''let
                  nixpkgs = builtins.toPath {json.dumps(args.nixpkgs)};
                  lib = import (nixpkgs + "/lib");
                  runtime = import {tests.parent.parent / "lib/zstr-runtime.nix"} {{ inherit lib; }};
                  search = import {tests.parent.parent / "lib/search-index.nix"} {{ inherit lib; }};
                  bundle = import {tests.parent.parent / "lib/read-dsl-bundle.nix"} {bundle};
                  evaluated = import (nixpkgs + "/nixos/lib/eval-config.nix") {{
                    system = "x86_64-linux";
                    modules = [ (runtime.moduleFromBundle {{ inherit bundle; }}) ];
                  }};
                  index = search.mkIndex {{ inherit evaluated bundle; }};
                  alias = index.options.system.sub.syncthing;
                in {{
                  localChildKept = !alias.sub.localEnabled.meta.upstream
                    && alias.sub.localEnabled.meta.default == true;
                  upstreamChildKept = alias.sub.enable.meta.upstream
                    && alias.sub.enable.meta.typeName == "bool";
                  localMetadata = alias.meta.name == "Syncthing";
                  aliasProvenance = alias.meta.upstream;
                  aliasPathCount = map (mount: mount.path) bundle.structure.mounts
                    == [ [ "system" "syncthing" ] ];
                }}'''
            result = subprocess.run(
                ["nix", "eval", "--impure", "--json", "--expr", expression],
                capture_output=True, text=True, timeout=180,
            )
            if collision is None:
                assert result.returncode == 0, (name, result.stderr)
                checks = json.loads(result.stdout)
                assert checks and all(value is True for value in checks.values()), (name, checks)
                print(f"PASS {name}: {len(checks)} acceptance checks", flush=True)
            else:
                assert result.returncode != 0, (name, result.stdout)
                assert result.stdout == "", (name, "search emitted output before rejection", result.stdout)
                assert "duplicate mounted option zenos." + collision in result.stderr, (name, result.stderr)
                assert "structure.zstr:" in result.stderr, (name, result.stderr)
                assert upstream_source in result.stderr, (name, result.stderr)
                if name == "duplicate-alias-mount":
                    assert "modules/programs/demo.zmdl:" in result.stderr, (name, result.stderr)
                print(f"PASS {name}: rejected before JSON output with both sources", flush=True)
    print(f"PASS {len(cases)} search ownership cases", flush=True)


if __name__ == "__main__":
    main()
