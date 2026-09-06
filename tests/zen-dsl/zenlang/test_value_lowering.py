from __future__ import annotations

import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

from zenlang import ZenLangError, parse, parse_file
from zenlang.compiler import _option_type, compile_zcfg, compile_zmdl
from zenlang.emitter import NixEmissionError, NixEmitter, emit_expression


def expression(source: str, filename: str = "value.zmdl"):
    return parse(f"value = {source};", filename, validate_semantics=False).statements[0].value


@unittest.skipUnless(shutil.which("nix-instantiate"), "Nix evaluation requires the ZenOS VM")
class ValueLoweringTests(unittest.TestCase):
    def evaluate(self, source: str, *, failure: str | None = None, write_store: bool = False):
        include = []
        if "<nixpkgs/lib>" in source:
            available = subprocess.run(["nix-instantiate", "--find-file", "nixpkgs"], capture_output=True, text=True)
            if available.returncode:
                self.skipTest("the VM must provide a Nixpkgs evaluation context")
            include = ["-I", "nixpkgs=" + available.stdout.strip()]
        if write_store:
            available = subprocess.run(["nix", "--extra-experimental-features", "nix-command", "store", "ping"], capture_output=True, text=True)
            if available.returncode:
                self.skipTest("path string context requires a writable VM Nix store")
        result = subprocess.run(
            ["nix-instantiate", *include, *(["--read-write-mode"] if write_store else ["--store", "dummy://"]),
             "--eval", "--strict", "--json", "--expr", source],
            capture_output=True, text=True, timeout=120,
        )
        if failure is not None:
            self.assertNotEqual(0, result.returncode, result.stdout)
            self.assertIn(failure, result.stderr)
            return None
        self.assertEqual(0, result.returncode, result.stderr)
        return json.loads(result.stdout)

    def test_absolute_and_relative_paths_are_backend_paths(self):
        with tempfile.TemporaryDirectory(prefix="zen-value-path-") as directory:
            root = Path(directory)
            (root / "nested").mkdir()
            asset = root / "asset"
            asset.write_text("path payload", encoding="utf-8")
            for literal in (str(asset), "../asset", "../nested/../asset"):
                with self.subTest(literal=literal):
                    emitted = emit_expression(expression(literal, str(root / "nested" / "source.zmdl")))
                    result = self.evaluate("let value = " + emitted + "; in { "
                        "kind = builtins.typeOf value; text = builtins.readFile value; "
                        "path = builtins.toString value; }")
                    self.assertEqual({"kind": "path", "text": "path payload", "path": str(asset)}, result)

    def test_existing_callable_parameter_labels_remain_supported(self):
        for value in ("value: value", "42"):
            statement = parse('_let identity: $type.function "value" = ' + value + ';',
                              "value.zmdl", validate_semantics=False).statements[0]
            emitted = NixEmitter().statement(statement)
            result = self.evaluate("let lib = import <nixpkgs/lib>; " + emitted + " in identity 42",
                                   failure="not of type" if value == "42" else None)
            if value != "42":
                self.assertEqual(42, result)

    def test_path_interpolation_copies_the_source_and_retains_store_context(self):
        with tempfile.TemporaryDirectory(prefix="zen-value-path-") as directory:
            root = Path(directory)
            (root / "asset").write_text("interpolated asset", encoding="utf-8")
            emitted = emit_expression(expression('"${./asset}"', str(root / "source.zmdl")))
            result = self.evaluate("let value = " + emitted + "; in { "
                "text = builtins.readFile value; context = builtins.hasContext value; "
                'stored = builtins.substring 0 11 value == "/nix/store/"; }', write_store=True)
            self.assertEqual({"text": "interpolated asset", "context": True, "stored": True}, result)

    def test_source_path_characters_cannot_create_backend_interpolation(self):
        with tempfile.TemporaryDirectory(prefix="zen-value-path-") as directory:
            root = Path(directory) / 'quoted" ${notCode}'
            root.mkdir()
            (root / "asset").write_text("literal source path", encoding="utf-8")
            emitted = emit_expression(expression("./asset", str(root / "source.zmdl")))
            self.assertEqual("literal source path", self.evaluate("builtins.readFile " + emitted))

    def test_scalar_interpolation_formats_values_and_preserves_literal_escapes(self):
        cases = (
            ('"${true}/${false}/${42}/${-7}/${3.5}"', "true/false/42/-7/3.5"),
            ('"${1 + 2}/${2 > 1}"', "3/true"),
            ('"${if true then 2 else 3}"', "2"),
            ('"${let x = 4; in x}"', "4"),
            ('"literal \\${notCode} ${"quote\\\"\\n"}"', 'literal ${notCode} quote"\n'),
            ("''value=${true}\nnumber=${12}''", "value=true\nnumber=12"),
        )
        for source, expected in cases:
            with self.subTest(source=source):
                self.assertEqual(expected, self.evaluate(emit_expression(expression(source))))

    def test_dynamic_interpolation_rejects_non_scalar_coercion_hooks(self):
        emitted = emit_expression(expression('"${$v.input}"'))
        for value in (
            "null", "[ 1 2 ]", "(x: x)", "{ answer = 42; }",
            '{ __toString = _: "unsafe"; }', '{ outPath = "/tmp/not-a-package"; }',
            '{ type = "derivation"; outPath = [ "bad" ]; }',
        ):
            with self.subTest(value=value):
                self.evaluate(f"let input = {value}; in {emitted}", failure="string interpolation requires a scalar, path, or package")

    def test_interpolation_wrapper_does_not_capture_authored_bindings(self):
        emitted = emit_expression(expression('let value = 7; kind = true; in "${value}/${kind}"'))
        self.assertEqual("7/true", self.evaluate(emitted))
        emitted = emit_expression(expression('"${$v.value}/${$v.kind}"'))
        self.assertEqual("9/false", self.evaluate("let value = 9; kind = false; in " + emitted))

    def test_package_interpolation_preserves_context_without_calling_custom_coercion(self):
        emitted = emit_expression(expression('"${$pkgs.legacy.demo}/bin/demo"'))
        result = self.evaluate('''let
          original = builtins.derivation { name = "zen-value-package"; system = builtins.currentSystem; builder = "/bin/sh"; };
          pkgs.zenos.legacy.demo = original // { __toString = _: throw "coercion hook invoked"; };
          value = ''' + emitted + ''';
        in { same = value == original.outPath + "/bin/demo";
             context = builtins.getContext value == builtins.getContext original.outPath; }''')
        self.assertEqual({"same": True, "context": True}, result)

    def test_full_library_remains_available(self):
        emitted = emit_expression(expression('"${$lib.toUpper "hello"}"'))
        self.assertEqual("HELLO", self.evaluate("let lib = import <nixpkgs/lib>; in " + emitted))

    def test_css_named_colors_and_transparent_are_values_not_config_references(self):
        names = emit_expression(expression("$c"))
        result = self.evaluate("let colors = " + names + "; names = builtins.removeAttrs colors "
            '[ "alpha" "mix" "lighten" "darken" ]; in { count = builtins.length (builtins.attrNames names); '
            'valid = builtins.all (value: builtins.match "[0-9a-f]{6}([0-9a-f]{2})?" value != null) (builtins.attrValues names); '
            "inherit (colors) aliceblue rebeccapurple darkslategrey white transparent; }")
        self.assertEqual({"count": 149, "valid": True, "aliceblue": "f0f8ff", "rebeccapurple": "663399",
            "darkslategrey": "2f4f4f", "white": "ffffff", "transparent": "00000000"}, result)
        self.assertEqual("ff0000", self.evaluate(emit_expression(expression("$c.red"))))

    def test_color_operations_use_premultiplied_srgb_and_round_bytes(self):
        cases = (
            ("$c.alpha $c.red 0.5", "ff000080"),
            ("$c.alpha $c.red 0.0", "ff000000"),
            ('$c.alpha "#AABBCC80" 1.0', "aabbccff"),
            ("$c.mix $c.red $c.blue 0.5", "800080ff"),
            ("$c.mix $c.transparent $c.red 0.5", "ff000080"),
            ('$c.mix "ff000000" "0000ff00" 0.5', "00000000"),
            ("$c.mix ($c.alpha $c.red 0.5) $c.blue 0.5", "5500aac0"),
            ("$c.lighten $c.black 0.25", "404040ff"),
            ("$c.darken $c.white 0.2", "ccccccff"),
            ("let f = $c.mix $c.red; in f $c.white 1.0", "ffffffff"),
        )
        for source, expected in cases:
            with self.subTest(source=source):
                self.assertEqual(expected, self.evaluate(emit_expression(expression(source))))

    def test_dynamic_color_arguments_are_checked_at_evaluation(self):
        for value in ('"red"', '"#abc"', '"1234567"', "[]", "null"):
            with self.subTest(value=value):
                emitted = emit_expression(expression("$c.alpha $v.input 0.5"))
                self.evaluate(f"let input = {value}; in {emitted}", failure="Zen color requires")
        for amount in ("1", "-0.1", "1.1", '"0.5"', "true", "null"):
            with self.subTest(amount=amount):
                emitted = emit_expression(expression("$c.alpha $c.red $v.input"))
                self.evaluate(f"let input = {amount}; in {emitted}", failure="Zen color amount must be a float")

    def test_primitive_and_nested_type_mappings_evaluate(self):
        cases = (
            ("$type.color", '"#AABBCC"', "aabbcc"),
            ("$type.color", '"#AABBCC80"', "aabbcc80"),
            ("$type.packages", '{ nested.tool = "package tree"; }', {"nested": {"tool": "package tree"}}),
            ("$type.list [ $type.color ]", '[ "#AABBCC" "00112280" ]', ["aabbcc", "00112280"]),
            ("$type.set [ $type.color ]", '{ accent = "#ABCDEF"; }', {"accent": "abcdef"}),
            ("$type.either [ $type.color $type.int ]", '"#ABCDEF"', "abcdef"),
            ("$type.functionTo [ $type.color ]", '(_: "#ABCDEF")', "abcdef"),
            ("$type.list [ $type.packages ]", '[ { tree = {}; } ]', [{"tree": {}}]),
        )
        for annotation, value, expected in cases:
            with self.subTest(annotation=annotation):
                ast = expression(annotation)
                emitted = _option_type(ast, None, NixEmitter())
                self.assertEqual(emitted, emit_expression(ast))
                projection = "result.config.value null" if "functionTo" in annotation else "result.config.value"
                result = self.evaluate("let lib = import <nixpkgs/lib>; result = lib.evalModules { modules = [ { "
                    f"options.value = lib.mkOption {{ type = {emitted}; }}; config.value = {value}; "
                    f"}} ]; }}; in {projection}")
                self.assertEqual(expected, result)

    def test_option_types_reject_invalid_colors_and_non_records(self):
        for annotation, value in (("$type.color", '"#abc"'), ("$type.color", '"not-a-color"'),
                                  ("$type.packages", "[ ]"), ("$type.packages", "true")):
            with self.subTest(annotation=annotation, value=value):
                emitted = _option_type(expression(annotation), None, NixEmitter())
                self.evaluate("let lib = import <nixpkgs/lib>; in (lib.evalModules { modules = [ { "
                    f"options.value = lib.mkOption {{ type = {emitted}; }}; config.value = {value}; "
                    "} ]; }).config.value", failure="not of type")

    def test_repeated_color_type_declarations_keep_validation_and_normalization(self):
        emitted = _option_type(expression("$type.color"), None, NixEmitter())
        definition = f"{{ options.value = lib.mkOption {{ type = {emitted}; }}; }}"
        for value, expected in (('"#AABBCC"', "aabbcc"), ('"bad"', None)):
            source = "let lib = import <nixpkgs/lib>; in (lib.evalModules { modules = [ " + definition + " " + definition
            source += f" {{ config.value = {value}; }} ]; }}).config.value"
            if expected is None:
                self.evaluate(source, failure="not of type")
            else:
                self.assertEqual(expected, self.evaluate(source))

    def test_compiled_module_normalizes_colors_and_resolves_imported_paths(self):
        with tempfile.TemporaryDirectory(prefix="zen-value-module-") as directory:
            root = Path(directory)
            module_dir = root / "modules" / "system"
            module_dir.mkdir(parents=True)
            (module_dir / "helper").mkdir()
            (module_dir / "helper" / "asset").write_text("import-relative asset", encoding="utf-8")
            (module_dir / "helper" / "base.zmdl").write_text('''
source._meta = { type = $type.path; default = ./asset; };
''', encoding="utf-8")
            source = module_dir / "demo.zmdl"
            source.write_text('''
_import "./helper/base.zmdl";
accent._meta = { type = $type.color; default = "#AABBCC"; };
palette._meta = { type = $type.list [ $type.color ]; default = [ $c.red "#FFFFFF" ]; };
tree._meta = { type = $type.packages; default = { nested = {}; }; };
overlay._meta.default = $c.alpha $c.red 0.5;
enable = enableOption { s!! { observed = "${$path.accent}/${$path.overlay}/${false}/${12}"; }; };
''', encoding="utf-8")
            output = compile_zmdl(parse_file(source, import_root=root), root=root)
            result = self.evaluate("let lib = import <nixpkgs/lib>; result = lib.evalModules { "
                "specialArgs.pkgs = {}; modules = [ (" + output + ") "
                "{ options.observed = lib.mkOption { type = lib.types.str; }; } ]; }; "
                "in { inherit (result.config.zenos.system.demo) accent palette tree overlay; "
                "pathType = builtins.typeOf result.config.zenos.system.demo.source; "
                "text = builtins.readFile result.config.zenos.system.demo.source; "
                "inherit (result.config) observed; }")
            self.assertEqual({"accent": "aabbcc", "palette": ["ff0000", "ffffff"], "tree": {"nested": {}},
                "overlay": "ff000080", "pathType": "path", "text": "import-relative asset",
                "observed": "aabbcc/ff000080/false/12"}, result)

    def test_bound_color_records_use_the_same_type_mapping(self):
        with tempfile.TemporaryDirectory(prefix="zen-value-import-") as directory:
            root = Path(directory)
            (root / "colors.zcfg").write_text('accent = "#AABBCC";', encoding="utf-8")
            source = root / "host.zcfg"
            source.write_text('_import palette: $type.set [ $type.color ] = "./colors.zcfg"; result = $v.palette;', encoding="utf-8")
            output = compile_zcfg(parse_file(source, import_root=root))
            result = self.evaluate("let lib = import <nixpkgs/lib>; in ((" + output
                + ") { pkgs = {}; inherit lib; }).zenos.result")
            self.assertEqual({"accent": "aabbcc"}, result)

    def test_validation_rejects_invalid_colors_and_accepts_package_records(self):
        for value in ('"red"', '"#abc"', '"123456789"', "true", "$c.alpha"):
            with self.subTest(value=value), self.assertRaises(ZenLangError):
                parse(f"_let color: $type.color = {value};", "color.zmdl")
        for value in ("$c.slate", "$c.zinc", "$c.notacolor", "$c.red.extra", "$c.alpha $c.red 1",
                      "$c.mix $c.red $c.blue 1.5", '$c.lighten "bad" 0.5', '$c.alpha $c.red (-"bad")'):
            with self.subTest(value=value), self.assertRaises(ZenLangError):
                parse(f"_let color: $type.color = {value};", "color.zmdl")
        for source in ('_let color: $type.color = "#AABBCC80";', "_let color: $type.color = $c.red;",
                       "_let color: $type.color = $c.alpha $c.red 0.5;",
                       '_let color: $type.color = $c."alpha" $c."red" 0.5;',
                       "_let tree: $type.packages = $pkgs.legacy;",
                       "_let tree: $type.packages = { nested = {}; };"):
            parse(source, "valid.zmdl")
        with self.assertRaises(NixEmissionError):
            emit_expression(expression("$c.slate"))

    def test_validation_rejects_non_scalar_defaults_and_color_functions(self):
        for value in ("$v.item or []", "$v.item or null", "$c.alpha", "$c", "$c.alpha $c.red"):
            with self.subTest(value=value), self.assertRaises(ZenLangError) as raised:
                parse('_let item: $type.set = {}; result = "${' + value + '}";', "bad.zmdl")
            self.assertEqual("ZEN212", raised.exception.diagnostic.code)


if __name__ == "__main__":
    unittest.main()
