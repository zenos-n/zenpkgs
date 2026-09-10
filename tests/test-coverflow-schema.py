"""Exercise the production ZMDL through Home Manager and installed Gio schemas in a VM.

Usage: test-coverflow-schema.py ZENPKGS HOME_MANAGER INSTALLED_EXTENSION
Set PYTHONPATH to lib/zen-dsl and NIX_PATH to the acceptance graph's nixpkgs.
"""

import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

from gi.repository import Gio, GLib
from zenlang import parse_file
from zenlang.compiler import compile_zmdl_mount


def main():
    assert os.environ.get("ZENOS_ACCEPTANCE_VM") == "1", "Run in the dedicated acceptance VM"
    root, home_manager, extension = map(lambda path: Path(path).resolve(), sys.argv[1:])
    schema_id = "org.gnome.shell.extensions.coverflowalttab"
    source = Gio.SettingsSchemaSource.new_from_directory(
        str(extension / "schemas"), Gio.SettingsSchemaSource.get_default(), False
    )
    schema = source.lookup(schema_id, False)
    assert schema is not None
    assert not schema.has_key("preview-scaling-factor")
    # Verify the replacement is actually consumed, not merely declared by the schema.
    assert 'settings.get_double("coverflow-preview-scaling-factor")' in (extension / "platform.js").read_text()
    assert "this._settings.coverflow_preview_scaling_factor" in (extension / "coverflowSwitcher.js").read_text()
    colors = ["highlight-color", "tint-color", "switcher-background-color"]
    valid = [
        ("#000000", [0, 0, 0]),
        ("#FFFFFF", [1, 1, 1]),
        ("#aB80fF", [171 / 255, 128 / 255, 1]),
        ("#aB80fF00", [171 / 255, 128 / 255, 1]),
        ("#112233aF", [17 / 255, 34 / 255, 51 / 255]),
        ([0.0, 0.25, 1.0], [0, 0.25, 1]),
        ([0.0, 0.25, 1.0, 0.4], [0, 0.25, 1]),
        ([0.0, 0.25, 1.0, 0.4, 0.5], [0, 0.25, 1]),
        ("(0.0,0.25,1.0)", [0, 0.25, 1]),
        (" \t( 0, 2.5e-1, 1 )\n", [0, 0.25, 1]),
        ("(-0.0,1e-3,1.0)", [0, 1e-3, 1]),
    ]
    invalid = [
        "#123", "#1234567", "#GG0000", "#112233GG", "red", "112233",
        [], [0.0, 1.0], [0, 0.25, 1], [-0.1, 0.0, 1.0], [0.0, 1.1, 1.0],
        [0.0, 0.0, 0.0, 2.0], [True, 0.0, 0.0], ["0", 0.0, 0.0],
        "(0,0)", "(0,0,0,1)", "(0,0,1.1)", "(-0.1,0,0)",
        "(true,0,0)", '("0",0,0)', "(null,0,0)", "(nan,0,0)",
        "[0,0,0]", "(0,0,0) trailing", "((0),0,0)",
    ]
    with tempfile.TemporaryDirectory(prefix="coverflow-schema-") as temp:
        module = root / "modules/desktops/gnome/extensions/coverflow-alt-tab.zmdl"
        compiled = Path(temp) / "coverflow.nix"
        compiled.write_text(compile_zmdl_mount(parse_file(module, import_root=root), root=root))
        expression = Path(temp) / "check.nix"
        nix = '''
          let
            lib = import <nixpkgs/lib>;
            gvariant = import (HOME_MANAGER + "/modules/lib/gvariant.nix") { inherit lib; };
            hmTypes = import (HOME_MANAGER + "/modules/lib/types.nix") { inherit lib; };
            pkgs.zenos.apps.gnome-extensions.coverflow-alt-tab = {
              type = "derivation"; name = "fixture"; outPath = "/nix/store/fixture";
              extensionUuid = "CoverflowAltTab@palatis.blogspot.com";
            };
            settings = overrides: let
              instance = import COMPILED { inherit lib pkgs cfg; config.zenos = {}; };
              cfg = (lib.evalModules { modules = [ instance.schema { config = overrides // { enable = true; }; } ]; }).config;
              system = lib.evalModules { modules = [ {
                config._module.freeformType = lib.types.attrsOf lib.types.anything;
                options.home-manager.sharedModules = lib.mkOption { type = lib.types.listOf lib.types.unspecified; default = []; };
              } ] ++ instance.actions; };
              home = lib.evalModules { modules = [ {
                options.dconf.settings = lib.mkOption { type = lib.types.attrsOf (lib.types.attrsOf hmTypes.gvariant); default = {}; };
              } ] ++ system.config.home-manager.sharedModules; };
            in lib.mapAttrs (_: value: toString (gvariant.mkValue value))
              home.config.dconf.settings."org/gnome/shell/extensions/coverflowalttab";
          in map settings (builtins.fromJSON INPUT)
        '''.replace("HOME_MANAGER", json.dumps(str(home_manager))).replace("COMPILED", str(compiled))

        def evaluate(inputs):
            expression.write_text(nix.replace("INPUT", json.dumps(json.dumps(inputs))))
            return subprocess.run(
                ["nix-instantiate", "--eval", "--strict", "--json", "--show-trace", str(expression)],
                text=True, capture_output=True, timeout=180,
            )

        inputs = [{}] + [dict.fromkeys(colors, value) for value, _ in valid]
        inputs += [{"preview-scaling-factor": 0.63}]
        result = evaluate(inputs)
        assert result.returncode == 0, result.stderr
        actual = json.loads(result.stdout)
        checked = 0
        for settings in actual:
            assert "preview-scaling-factor" not in settings
            assert "timeline-preview-scaling-factor" not in settings
            for key, text in settings.items():
                assert schema.has_key(key), key
                variant = GLib.Variant.parse(None, text, None, None)
                schema_key = schema.get_key(key)
                assert variant.get_type_string() == schema_key.get_value_type().dup_string(), (key, text)
                assert schema_key.range_check(variant), (key, text)
                checked += 1
        for index, (_, expected) in enumerate(valid, start=1):
            for key in colors:
                variant = GLib.Variant.parse(None, actual[index][key], None, None)
                assert variant.get_type_string() == "(ddd)"
                assert all(abs(a - b) < 1e-6 for a, b in zip(variant.unpack(), expected, strict=True))
        for key in colors:
            expected = (1.0, 1.0, 1.0) if key == "highlight-color" else (0.0, 0.0, 0.0)
            assert GLib.Variant.parse(None, actual[0][key], None, None).unpack() == expected
        assert GLib.Variant.parse(None, actual[-1]["coverflow-preview-scaling-factor"], None, None).unpack() == 0.63
        for key in colors:
            for value in invalid:
                result = evaluate([{key: value}])
                assert result.returncode != 0, (key, value, result.stdout)
                assert "error:" in result.stderr
    print(f"Coverflow: {len(valid)} input forms across all 3 colors, defaults, scaling override, "
          f"{len(invalid) * len(colors)} rejected inputs, {checked} installed-schema type/range checks passed.")


if __name__ == "__main__":
    main()
