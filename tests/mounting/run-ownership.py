"""VM-only ownership regressions using fresh, private fixture bundles."""
import argparse
import json
from pathlib import Path
import subprocess
import tempfile

from zenlang.compiler import compile_tree


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--nixpkgs", required=True)
    args = parser.parse_args()
    runtime = Path(__file__).resolve().parents[2] / "lib/zstr-runtime.nix"
    cases = [
        ("alias-leaf", "legacy._meta.type = (alias nixpkgs); legacy.service.enable._meta.default = false;",
         "", "options.zenos.type.name", "legacy.service.enable"),
        ("alias-namespace-disjoint", "legacy._meta.type = (alias nixpkgs); legacy.service.local._meta.default = true;",
         "", "config.zenos.legacy.service.local", None),
        ("alias-shared-namespace-forwarding", "legacy._meta.type = (alias nixpkgs); legacy.service.local._meta.default = true;",
         "config.zenos.legacy.service = { enable = true; local = false; };", "config.service.enable", None),
        ("alias-submodule-extension", "legacy._meta.type = (alias nixpkgs.record); legacy.local._meta.default = true;",
         "options.record = lib.mkOption { type = lib.types.submodule { options.enable = lib.mkEnableOption \"record\"; }; default = {}; }; config.zenos.legacy = { enable = true; local = false; };",
         "config.record.enable", None),
        ("alias-child", "legacy._meta.type = (alias nixpkgs); legacy.homeManager._meta.type = (alias nixpkgs.service);",
         "options.homeManager = lib.mkOption { type = lib.types.bool; default = false; };",
         "options.zenos.type.name", "legacy.homeManager"),
        ("alias-child-absent", "legacy._meta.type = (alias nixpkgs); legacy.homeManager._meta.type = (alias nixpkgs.service);",
         "", "config.zenos.legacy.homeManager", None),
        ("alias-module", "legacy._meta.type = (alias nixpkgs); legacy.service._meta.type = (zmdl demo);",
         "", "options.zenos.type.name", "legacy.service"),
        ("alias-module-namespace-collision", "legacy._meta.type = (alias nixpkgs); legacy.homeManager._meta.type = (zmdl demo);",
         "options.homeManager.upstreamOnly = lib.mkEnableOption \"upstream child\";",
         "options.zenos.type.name", "legacy.homeManager"),
        ("dynamic-unused", "users = { (freeform user) = { legacy._meta.type = (alias nixpkgs.accounts.($f.user)); legacy.enable._meta.default = true; }; };",
         "options.accounts = lib.mkOption { type = lib.types.attrsOf (lib.types.submodule { options.enable = lib.mkOption { type = lib.types.bool; }; }); default = {}; };",
         "options.zenos.type.name", "users.\"{user}\".legacy.enable"),
        ("actions-not-forced", "legacy._meta.type = (alias nixpkgs); legacy.service.enable._meta.default = false; system._meta.type = (zmdl demo);",
         "", "config.result", "legacy.service.enable"),
        ("value-priorities", "legacy._meta.type = (alias nixpkgs);",
         "config.zenos.legacy.service.enable = lib.mkForce true; config.service.enable = lib.mkDefault false;",
         "config.service.enable", None),
        ("implicit-namespace", "system._meta.type = (zmdl demo); system.settings.right._meta.default = 2;",
         "", "config.zenos.system.settings", None),
        ("module-alias-collision", "system._meta.type = (zmdl demo);",
         "", "options.zenos.type.name", "system.ssh.enable"),
        ("module-alias-extension", "system._meta.type = (zmdl demo);",
         "config.zenos.system.ssh = { enable = true; local = false; };", "config.service.enable", None),
        ("root-module-alias-collision", "system._meta.type = (zmdl demo);",
         "", "options.zenos.type.name", "system.enable"),
        ("root-module-alias-extension", "system._meta.type = (zmdl demo);",
         "config.zenos.system = { enable = true; local = false; };", "config.service.enable", None),
    ]
    with tempfile.TemporaryDirectory(prefix="zstr-ownership-") as temporary:
        root = Path(temporary)
        for name, structure, extra, query, collision in cases:
            fixture = root / name
            (fixture / "modules").mkdir(parents=True)
            (fixture / "structure.zstr").write_text(structure, encoding="utf-8")
            module = "settings.left._meta.default = 1;"
            if "module-alias" in name:
                prefix = "" if name.startswith("root-") else "ssh."
                child = "enable" if name.endswith("collision") else "local"
                module = f"{prefix}_meta.type = (alias nixpkgs.service); {prefix}{child}._meta.default = false;"
            if name == "actions-not-forced":
                module += ' enable = enableOption { s!! { result = $lib.explode "ACTION WAS EVALUATED"; }; };'
            (fixture / "modules/demo.zmdl").write_text(module, encoding="utf-8")
            bundle = fixture / "bundle.json"
            bundle.write_text(json.dumps(compile_tree(fixture)), encoding="utf-8")
            expression = f'''let
              lib = import ({args.nixpkgs} + "/lib");
              runtime = import {runtime} {{ inherit lib; }};
              evaluated = lib.evalModules {{
                specialArgs.pkgs = {{}};
                modules = [
                  (runtime.moduleFromBundle {{
                    bundle = builtins.fromJSON (builtins.readFile {bundle});
                    extraLib.explode = builtins.throw;
                  }})
                  {{ _file = "upstream-schema.nix";
                     options.service.enable = lib.mkOption {{ type = lib.types.bool; default = false; }};
                     options.result = lib.mkOption {{ type = lib.types.str; default = ""; }};
                     options.warnings = lib.mkOption {{ type = lib.types.listOf lib.types.str; default = []; }};
                  }}
                  {{ _file = "upstream-schema.nix"; {extra} }}
                ];
              }};
            in evaluated.{query}'''
            result = subprocess.run(["nix", "eval", "--impure", "--json", "--expr", expression],
                                    capture_output=True, text=True)
            if collision is not None:
                assert result.returncode != 0, (name, result.stdout)
                assert "duplicate mounted option zenos." + collision in result.stderr, (name, result.stderr)
                assert ("demo.zmdl:" if "module-alias" in name else "structure.zstr:") in result.stderr, (name, result.stderr)
                assert ("upstream-schema.nix" in result.stderr
                        or name in ("dynamic-unused", "alias-module", "alias-module-namespace-collision")), (name, result.stderr)
                assert "ACTION WAS EVALUATED" not in result.stderr, (name, result.stderr)
            else:
                assert result.returncode == 0, (name, result.stderr)
                value = json.loads(result.stdout)
                if name in ("alias-namespace-disjoint", "alias-shared-namespace-forwarding", "alias-submodule-extension", "value-priorities",
                            "module-alias-extension", "root-module-alias-extension"):
                    assert value is True, (name, value)
                if name == "implicit-namespace":
                    assert value == {"left": 1, "right": 2}, (name, value)
            print(f"PASS {name}", flush=True)


if __name__ == "__main__":
    main()
