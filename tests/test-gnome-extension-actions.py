"""Compile the real modules and exercise their mounted action merge, not source snippets."""

import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

from zenlang import parse_file
from zenlang.compiler import compile_tree, compile_zcfg, compile_zmdl_mount


def main():
    assert os.environ.get("ZENOS_ACCEPTANCE_VM") == "1", "Run in the dedicated acceptance VM"
    root = Path(sys.argv[1]).resolve()
    home_manager = Path(sys.argv[2]).resolve()
    appearance = Path(sys.argv[3]).resolve() if len(sys.argv) > 3 else None
    directory = root / "modules/desktops/gnome/extensions"
    modules = sorted(directory.glob("*.zmdl"))
    assert modules and (directory / "dash-stacks.zmdl").is_file()
    enabled = [
        "compiz-alike-magic-lamp-effect", "compiz-windows-effect", "coverflow-alt-tab",
        "date-menu-formatter", "gsconnect", "hide-cursor", "hide-minimized", "mouse-tail",
        "notification-timeout", "rounded-window-corners-reborn", "user-themes", "window-is-ready-remover",
    ]
    disabled = ["alphabetical-app-grid", "app-hider", "burn-my-windows", "clipboard-indicator", "hide-top-bar", "dash-stacks", "forge"]
    prepared = ["alphabetical-app-grid", "burn-my-windows", "clipboard-indicator", "hide-top-bar", "forge", "dash-stacks"]
    expected = None
    uuids = {module.stem: module.stem + "@fixture" for module in modules}
    oobe = "oobe@fixture"
    if appearance is not None:
        expected = json.loads((appearance.parent / "fixtures/appearance-expected.json").read_text())
        oobe = "zenos-oobe-mode@neg-zero.com"
        assert oobe in expected["enabled"]
        uuids.update(zip(enabled, [uuid for uuid in expected["enabled"] if uuid != oobe], strict=True))
        uuids.update(zip(disabled, expected["disabled"], strict=True))
    with tempfile.TemporaryDirectory(prefix="gnome-actions-") as temp:
        sources = []
        packages = []
        for module in modules:
            text = module.read_text()
            # Only the package identity is mocked. The real schema and generated actions are evaluated.
            matches = re.findall(r"\$pkgs\.([\w.-]+)\.extensionUuid", text)
            assert len(matches) == 1, f"{module.name}: expected one package-derived UUID contribution"
            path = matches[0].removeprefix("zenos.").split(".")
            uuid = uuids[module.stem]
            packages.append("(lib.setAttrByPath [ " + " ".join(map(json.dumps, path)) + " ]"
                            + ' { type = "derivation"; name = "fixture"; outPath = "/nix/store/fixture"; extensionUuid = '
                            + json.dumps(uuid) + "; })")
            output = Path(temp) / (module.stem + ".nix")
            output.write_text(compile_zmdl_mount(parse_file(module, import_root=root), root=root))
            sources.append(f'{json.dumps(module.stem)} = import {output};')
        core = Path(temp) / "gnome-base.nix"
        core.write_text(compile_zmdl_mount(parse_file(directory.parent.parent / "gnome.zmdl", import_root=root), root=root))
        sources.append(f'"gnome-base" = import {core};')
        live = "{}"
        if appearance is not None:
            generated = compile_zcfg(parse_file(appearance, import_root=appearance.parent))
            live = f'(({generated}) {{ inherit pkgs lib; config.zenos = {{}}; }}).zenos.desktops.gnome.extensions'
        nix = '''
          let
            lib = import <nixpkgs/lib>;
            hmTypes = import (HOME_MANAGER + "/modules/lib/types.nix") { inherit lib; };
            gvariant = import (HOME_MANAGER + "/modules/lib/gvariant.nix") { inherit lib; };
            unpack = value: if (value._type or "") == "gvariant" then unpack value.value
              else if builtins.isList value then map unpack value else value;
            pkgs.zenos = lib.foldl' lib.recursiveUpdate {} [ PACKAGES ];
            sources = { SOURCES };
            systemOptions = { config._module.freeformType = lib.types.attrsOf lib.types.anything;
              options.home-manager.sharedModules = lib.mkOption { type = lib.types.listOf lib.types.unspecified; default = []; };
            };
            homeOptions = { options.dconf.settings = lib.mkOption {
              type = lib.types.attrsOf (lib.types.attrsOf hmTypes.gvariant); default = {};
            }; config._module.freeformType = lib.types.attrsOf lib.types.anything; };
            mountedWith = overrides: name: on: configure:
              let
                instance = sources.${name} { inherit pkgs lib; config.zenos = {}; inherit cfg; };
                cfg = (lib.evalModules { modules = [ instance.schema { config = (overrides.${name} or {})
                  // { enable = on; } // lib.optionalAttrs configure { configure = true; }; } ]; }).config;
              in (lib.evalModules { modules = [ systemOptions ] ++ instance.actions; }).config.home-manager.sharedModules;
            mounted = mountedWith { rounded-window-corners-reborn = {
              focused-shadow = "{\\"horizontalOffset\\":0,\\"opacity\\":60}";
              unfocused-shadow = "{\\"verticalOffset\\":2,\\"opacity\\":65}";
            }; };
            home = modules: (lib.evalModules { modules = [ homeOptions ] ++ modules; }).config;
            uuids = modules: unpack ((home modules).dconf.settings."org/gnome/shell".enabled-extensions or []);
            names = lib.remove "gnome-base" (builtins.attrNames sources);
            enabled = ENABLED;
            prepared = PREPARED;
            live = LIVE;
            liveModules = lib.concatMap (name: mountedWith live name live.${name}.enable false) (builtins.attrNames live)
              ++ mounted "gnome-base" true false
              ++ [{ dconf.settings."org/gnome/shell".enabled-extensions = lib.mkDefault [ OOBE_UUID ]; }];
            combined = lib.concatMap (name: mounted name true false) enabled
              ++ lib.concatMap (name: mounted name false true) prepared
              ++ mounted "gnome-base" true false
              ++ [{ dconf.settings."org/gnome/shell".enabled-extensions = lib.mkDefault [ OOBE_UUID ]; }];
          in {
            individually = lib.genAttrs names (name: uuids (mounted name true false));
            disabled = lib.genAttrs names (name: uuids (mounted name false false));
            configured = lib.genAttrs prepared (name: uuids (mounted name false true));
            configuredSettings = lib.genAttrs prepared (name:
              builtins.attrNames (home (mounted name false true)).dconf.settings);
            baseEmpty = uuids (mounted "gnome-base" true false);
            merged = uuids combined;
            dateType = (home combined).dconf.settings."org/gnome/shell/extensions/date-menu-formatter".font-size.type;
            timeoutType = (home combined).dconf.settings."org/gnome/shell/extensions/notification-timeout".timeout.type;
            borderType = (home combined).dconf.settings."org/gnome/shell/extensions/rounded-window-corners-reborn".border-width.type;
            corners = toString (home combined).dconf.settings."org/gnome/shell/extensions/rounded-window-corners-reborn".global-rounded-corner-settings;
            focusedShadow = toString (home combined).dconf.settings."org/gnome/shell/extensions/rounded-window-corners-reborn".focused-shadow;
            unfocusedShadow = toString (home combined).dconf.settings."org/gnome/shell/extensions/rounded-window-corners-reborn".unfocused-shadow;
            stacks = (home combined).dconf.settings."org/gnome/shell/extensions/dash-stacks".stacks;
            liveEnabled = uuids liveModules;
            liveSettings = lib.mapAttrs (_: lib.mapAttrs (_: value: {
              type = (gvariant.mkValue value).type; value = unpack value;
            })) (home liveModules).dconf.settings;
          }
        '''.replace("PACKAGES", " ".join(packages)).replace("SOURCES", "\n".join(sources))
        nix = nix.replace("ENABLED", "[ " + " ".join(map(json.dumps, enabled)) + " ]")
        nix = nix.replace("PREPARED", "[ " + " ".join(map(json.dumps, prepared)) + " ]")
        nix = nix.replace("HOME_MANAGER", json.dumps(str(home_manager)))
        nix = nix.replace("OOBE_UUID", json.dumps(oobe))
        nix = nix.replace("LIVE", live)
        expression = Path(temp) / "check.nix"
        expression.write_text(nix)
        result = subprocess.run(["nix-instantiate", "--eval", "--strict", "--json", "--show-trace", str(expression)],
                                text=True, capture_output=True, timeout=180)
        assert result.returncode == 0, result.stderr
        actual = json.loads(result.stdout)
        for module in modules:
            assert actual["individually"][module.stem] == [uuids[module.stem]]
            assert actual["disabled"][module.stem] == []
        assert all(value == [] for value in actual["configured"].values())
        assert all(value and "org/gnome/shell" not in value for value in actual["configuredSettings"].values())
        assert actual["baseEmpty"] == []
        assert sorted(actual["merged"]) == sorted([uuids[name] for name in enabled] + [oobe])
        assert len(actual["merged"]) == 13
        assert actual["dateType"] == actual["timeoutType"] == actual["borderType"] == "i"
        assert actual["corners"].startswith("@a{sv}")
        assert actual["focusedShadow"].startswith("@a{si}")
        assert actual["unfocusedShadow"].startswith("@a{si}")
        assert json.loads(actual["stacks"]) == []
        if appearance is not None:
            assert sorted(actual["liveEnabled"]) == sorted(expected["enabled"])
            assert not set(actual["liveEnabled"]) & set(expected["disabled"])
            for schema, settings in expected["settings"].items():
                if not schema.startswith("org/gnome/shell/extensions/"):
                    continue
                for key, (kind, value) in settings.items():
                    observed = actual["liveSettings"][schema][key]
                    assert observed == {"type": kind, "value": value}, (schema, key, observed)
            print("Verified current appearance.zcfg extension declarations and expected values/types against the real mounted schemas.")
        print(f"Verified on/off activation for {len(modules)} modules, settings-only configuration, typed values/shadows, empty GNOME base, and 12+OOBE merge.")
    # Match the production bundle's source filter; test fixtures are not public modules.
    with tempfile.TemporaryDirectory(prefix="gnome-module-inventory-") as temp:
        canonical = Path(temp)
        for name in ("modules", "pkgs", "docs"):
            shutil.copytree(root / name, canonical / name)
        shutil.copyfile(root / "structure.zstr", canonical / "structure.zstr")
        bundle = compile_tree(canonical, mode="interface")
    count = len(bundle["modules"])
    source_count = sum(source["kind"] == "zmdl" for source in bundle["sources"])
    assert count == source_count
    print(f"Canonical module inventory: {count} bundle modules, {source_count} ZMDL sources, {len(modules)} extension modules.")


if __name__ == "__main__":
    main()
