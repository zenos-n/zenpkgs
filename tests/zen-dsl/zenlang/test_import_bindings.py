from __future__ import annotations

import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

from zenlang import ZenLangError, parse, parse_file
from zenlang.compiler import compile_zcfg, compile_zmdl, compile_zmdl_mount
from zenlang.emitter import NixEmitter


class ImportBindingTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)

    def source(self, name, text):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")
        return path

    def evaluate(self, expression, *, failure=False):
        if not shutil.which("nix-instantiate"):
            self.skipTest("Nix evaluation requires the ZenOS VM")
        result = subprocess.run(
            ["nix-instantiate", "--eval", "--strict", "--json", "--expr",
             "let lib = import <nixpkgs/lib>; pkgs = { inherit lib; }; in " + expression],
            capture_output=True, text=True,
        )
        if failure:
            self.assertNotEqual(0, result.returncode)
            return result.stderr
        self.assertEqual(0, result.returncode, result.stderr)
        return json.loads(result.stdout)

    def config(self, text):
        output = compile_zcfg(parse(text, "host.zcfg"))
        return self.evaluate_config(output)

    def evaluate_config(self, output):
        return self.evaluate("""(lib.evalModules {
          specialArgs = { inherit pkgs; };
          modules = [ (""" + output + """) {
            options.zenos = lib.mkOption { type = lib.types.attrsOf lib.types.anything; };
          } ];
        }).config.zenos""")

    def test_bound_values_are_records_in_every_format(self):
        for kind in ("zcfg", "zmdl", "zpkg", "zstr"):
            with self.subTest(kind=kind):
                self.source(f"data.{kind}", '_let hidden: $type.string = "blue"; color = $v.hidden;')
                package = "import $pkgs.legacy.demo;" if kind == "zpkg" else ""
                entry = self.source(f"entry.{kind}", f'_import palette: $type.set [ $type.string ] = "data.{kind}"; {package}')
                document = parse_file(entry, import_root=self.root)
                if kind != "zpkg":
                    self.assertEqual({}, self.evaluate(NixEmitter().document_value(document)))
                binding = document.statements[0]
                self.assertEqual({"color": "blue"}, self.evaluate(
                    NixEmitter().document_value(binding.document, annotation=binding.annotation)))

    def test_bound_record_selection_does_not_merge_into_config(self):
        self.source("palette.zcfg", '_let hidden: $type.string = "blue"; color = $v.hidden;')
        entry = self.source("host.zcfg", '''
          _import palette: $type.set [ $type.string ] = "palette.zcfg";
          system.selected = $v.palette.color;
        ''')
        self.assertEqual({"system": {"selected": "blue"}}, self.evaluate_config(
            compile_zcfg(parse_file(entry, import_root=self.root))))

    def test_bound_annotation_validation_is_universal(self):
        for kind in ("zcfg", "zmdl", "zpkg", "zstr"):
            with self.subTest(kind=kind):
                self.source(f"data.{kind}", "port = 8080;")
                package = "import $pkgs.legacy.demo;" if kind == "zpkg" else ""
                entry = self.source(f"entry.{kind}", f'_import data: $type.set [ $type.string ] = "data.{kind}"; {package}')
                with self.assertRaises(ZenLangError) as raised:
                    parse_file(entry)
                self.assertEqual("ZEN229", raised.exception.diagnostic.code)

    def test_untyped_import_has_record_type_in_later_initializers(self):
        self.source("data.zcfg", "port = 8080;")
        entry = self.source("host.zcfg", '_import data = "data.zcfg"; _let copy: $type.int = $v.data;')
        with self.assertRaises(ZenLangError) as raised:
            parse_file(entry)
        self.assertEqual("ZEN229", raised.exception.diagnostic.code)

    def test_open_record_annotation_accepts_heterogeneous_fields(self):
        self.source("data.zcfg", 'port = 8080; label = "demo";')
        entry = self.source("host.zcfg", '_import data: $type.set = "data.zcfg"; selected = $v.data;')
        self.assertEqual({"selected": {"port": 8080, "label": "demo"}},
                         self.evaluate_config(compile_zcfg(parse_file(entry))))

    def test_bound_imports_merge_bare_imports_before_local_fields(self):
        self.source("base.zcfg", 'nested.first = "first"; nested.color = "red";')
        self.source("data.zcfg", '_import "base.zcfg"; nested = { color = "blue"; second = "second"; };')
        entry = self.source("host.zcfg", '_import data = "data.zcfg"; result = $v.data;')
        self.assertEqual({"result": {"nested": {"first": "first", "color": "blue", "second": "second"}}},
                         self.evaluate_config(compile_zcfg(parse_file(entry))))

    def test_nested_bound_import_values(self):
        self.source("leaf.zcfg", "port = 8080;")
        self.source("middle.zcfg", '_import leaf = "leaf.zcfg"; result = $v.leaf.port;')
        entry = self.source("host.zcfg", '_import middle = "middle.zcfg"; selected = $v.middle.result;')
        self.assertEqual({"selected": 8080}, self.evaluate_config(compile_zcfg(parse_file(entry))))

    def test_bound_annotations_reject_incompatible_document_values(self):
        cases = (
            ("$type.int", "port = 8080;"),
            ("$type.set [ $type.string ]", "port = 8080;"),
            ("$type.set [ ($type.list [ $type.int ]) ]", 'ports = [ 80 "bad" ];'),
            ("$type.set [ $type.int ]", "nested.port = 80;"),
            ("$type.set [ $type.int ]", '_let text: $type.string = "bad"; value = $v.text;'),
            ("$type.set [ $type.int ]", 'if true { value = "bad"; };'),
            ("$type.set [ ($type.set [ $type.int ]) ]", 'nested = { _let text: $type.string = "bad"; value = $v.text; };'),
        )
        for annotation, source in cases:
            with self.subTest(annotation=annotation, source=source):
                self.source("data.zcfg", source)
                entry = self.source("host.zcfg", f'_import data: {annotation} = "data.zcfg";')
                with self.assertRaises(ZenLangError) as raised:
                    parse_file(entry)
                self.assertEqual("ZEN229", raised.exception.diagnostic.code)
                self.assertIn("bound import data", raised.exception.diagnostic.message)

    def test_dynamic_import_annotation_is_enforced_when_value_is_used(self):
        self.source("data.zcfg", "port = $cfg.port;")
        entry = self.source("host.zcfg", '_import data: $type.set [ $type.int ] = "data.zcfg"; selected = $v.data.port;')
        output = compile_zcfg(parse_file(entry))
        error = self.evaluate("(" + output + ') { inherit pkgs lib; config.zenos.port = "bad"; }', failure=True)
        self.assertIn("bound-import annotation mismatch", error)

    def test_nested_config_and_conditional_bindings_are_lexical(self):
        self.assertEqual({"system": {"first": "outer", "nested": {"value": "inner"}, "last": "outer", "active": 42}}, self.config('''
          _let outer: $type.string = "outer";
          system = {
            first = $v.outer;
            nested = { _let local: $type.string = "inner"; value = $v.local; };
            last = $v.outer;
            _let enabled: $type.bool = true;
            if $v.enabled {
              _let answer: $type.int = 42;
              active = $v.answer;
            };
          };
        '''))

    def test_imported_conditions_produce_values_not_module_wrappers(self):
        self.source("data.zcfg", '''
          _let enabled: $type.bool = true;
          nested = {
            if $v.enabled { _let number: $type.int = 42; present = $v.number; };
            if false { absent = 0; };
          };
        ''')
        entry = self.source("host.zcfg", '_import data = "data.zcfg"; selected = $v.data.nested;')
        self.assertEqual({"selected": {"present": 42}}, self.evaluate_config(compile_zcfg(parse_file(entry))))

    def test_binding_only_config_block_remains_an_empty_record(self):
        self.assertEqual({"empty": {}}, self.config("empty = { _let local: $type.int = 1; };"))

    def test_action_guard_sees_option_scope_binding(self):
        entry = self.source("modules/demo.zmdl", '''
          enable = enableOption {
            _let guard: $type.bool = true;
            s! [ $v.guard ] { _let local: $type.int = 42; result.answer = $v.local; };
          };
        ''')
        output = compile_zmdl_mount(parse_file(entry, import_root=self.root), root=self.root)
        for enabled, expected in (("true", {"answer": 42}), ("false", {})):
            with self.subTest(enabled=enabled):
                result = self.evaluate("""let mounted = (""" + output + """) {
                  inherit pkgs lib; cfg.enable = """ + enabled + """; config = {};
                }; in (lib.evalModules { modules = mounted.actions ++ [{
                  options.result = lib.mkOption { type = lib.types.attrsOf lib.types.int; default = {}; };
                }]; }).config.result""")
                self.assertEqual(expected, result)

    def test_weighted_actions_preserve_nested_bindings(self):
        entry = self.source("modules/demo.zmdl", '''
          option = {
            _meta.type = $type.bool;
            _meta.weight = 50;
            s!! {
              _let outer: $type.int = 42;
              result = { _let local: $type.int = $v.outer; answer = $v.local; };
            };
          };
        ''')
        output = compile_zmdl_mount(parse_file(entry, import_root=self.root), root=self.root)
        self.assertEqual({"answer": 42}, self.evaluate("""let mounted = (""" + output + """) {
          inherit pkgs lib; cfg = {}; config = {};
        }; in (lib.evalModules { modules = mounted.actions ++ [{
          options.result = lib.mkOption { type = lib.types.attrsOf lib.types.int; };
          config.result.answer = 1;
        }]; }).config.result"""))

    def test_nested_schema_defaults_see_parent_bindings(self):
        entry = self.source("modules/demo.zmdl", '''
          group = {
            _let parent: $type.int = 42;
            child = {
              _let local: $type.int = $v.parent;
              _meta.type = $type.int;
              _meta.default = $v.local;
            };
          };
        ''')
        output = compile_zmdl_mount(parse_file(entry, import_root=self.root), root=self.root)
        self.assertEqual({"group": {"child": 42}}, self.evaluate("""let mounted = (""" + output + """) {
          inherit pkgs lib; cfg = {}; config = {};
        }; in (lib.evalModules { modules = [ mounted.schema ]; }).config"""))

    def test_sibling_config_bindings_do_not_capture_each_other(self):
        self.assertEqual({"left": {"value": 1}, "right": {"value": 2}}, self.config('''
          left = { _let local: $type.int = 1; value = $v.local; };
          right = { _let local: $type.int = 2; value = $v.local; };
        '''))

    def test_local_bindings_do_not_escape_their_block(self):
        for text in (
            'left = { _let local: $type.int = 1; value = $v.local; }; result = $v.local;',
            'if true { _let local: $type.int = 1; value = $v.local; }; result = $v.local;',
        ):
            with self.subTest(text=text), self.assertRaises(ZenLangError) as raised:
                parse(text, "host.zcfg")
            self.assertEqual("ZEN208", raised.exception.diagnostic.code)

    def test_zmdl_option_and_action_locals_work_in_both_lowerings(self):
        entry = self.source("modules/demo.zmdl", '''
          _let outer: $type.string = "outer";
          option = {
            _let local: $type.string = "local";
            _meta.type = $type.string;
            _meta.default = $v.local;
            s!! {
              _let actionLocal: $type.string = $v.local;
              result = {
                _let nested: $type.string = $v.actionLocal;
                value = $v.nested;
                parent = $v.outer;
              };
            };
          };
        ''')
        document = parse_file(entry, import_root=self.root)
        output = compile_zmdl(document, root=self.root)
        result = self.evaluate("""(lib.evalModules {
          specialArgs = { inherit pkgs; };
          modules = [ (""" + output + """) {
            options.result = lib.mkOption { type = lib.types.attrsOf lib.types.str; };
          } ];
        }).config""")
        self.assertEqual("local", result["zenos"]["demo"]["option"])
        self.assertEqual({"value": "local", "parent": "outer"}, result["result"])
        mount = compile_zmdl_mount(document, root=self.root)
        mounted = self.evaluate("""let mounted = (""" + mount + """) {
          inherit pkgs lib; cfg = {}; config = {}; };
          in (lib.evalModules { modules = mounted.actions ++ [{
            options.result = lib.mkOption { type = lib.types.attrsOf lib.types.str; };
          }]; }).config.result""")
        self.assertEqual(result["result"], mounted)

    def test_freeform_option_locals_stay_inside_their_key_scope(self):
        entry = self.source("modules/demo.zmdl", '''
          (freeform item) = {
            _let label: $type.string = $f.item;
            child = {
              _let local: $type.string = $v.label;
              _meta.type = $type.string;
              _meta.default = $v.local;
              s!! { result.($f.item) = $v.local; };
            };
          };
        ''')
        output = compile_zmdl_mount(parse_file(entry, import_root=self.root), root=self.root)
        result = self.evaluate("""let mounted = (""" + output + """) {
          inherit pkgs lib; cfg = { alpha.child = "alpha"; beta.child = "beta"; }; config = {};
        }; in (lib.evalModules { modules = mounted.actions ++ [{
          options.result = lib.mkOption { type = lib.types.attrsOf lib.types.str; };
        }]; }).config.result""")
        self.assertEqual({"alpha": "alpha", "beta": "beta"}, result)

    def test_typed_let_normalizes_colors_in_every_format(self):
        for kind in ("zcfg", "zmdl", "zpkg", "zstr"):
            with self.subTest(kind=kind):
                document = parse('_let tone: $type.color = "#AaBBcc";', f"colors.{kind}")
                binding = NixEmitter().statement(document.statements[0])
                self.assertEqual("aabbcc", self.evaluate(f"let {binding} in tone"))

    def test_typed_let_checks_dynamic_values_with_shared_types(self):
        cases = (
            ("$type.int", "42", 42, '"42"'),
            ("$type.bool", "true", True, "1"),
            ("$type.string", '"text"', "text", "false"),
            ("$type.null", "null", None, '"null"'),
            ("$type.enum [ \"dark\" \"light\" ]", '"dark"', "dark", '"other"'),
            ("$type.color", '"#AaBBccDD"', "aabbccdd", '"#abc"'),
            ("$type.list [ $type.color ]", '[ "#AaBBcc" "DDEEFF" ]', ["aabbcc", "ddeeff"], '[ "#abc" ]'),
            ("$type.set [ ($type.list [ $type.color ]) ]", '{ accent = [ "#ABCDEF" ]; }', {"accent": ["abcdef"]}, '{ accent = [ "bad" ]; }'),
            ("$type.either [ $type.color $type.int ]", '"#AaBBcc"', "aabbcc", "false"),
        )
        for annotation, supplied, expected, invalid in cases:
            with self.subTest(annotation=annotation):
                statement = parse(f"_let checked: {annotation} = $cfg.input;", "runtime.zmdl").statements[0]
                binding = NixEmitter().statement(statement)
                self.assertEqual(expected, self.evaluate(f"let config.zenos.input = {supplied}; {binding} in checked"))
                error = self.evaluate(f"let config.zenos.input = {invalid}; {binding} in checked", failure=True)
                self.assertIn("_let checked annotation mismatch: runtime.zmdl:1:1", error)
                self.assertIn("not of type", error)

    def test_typed_let_checks_all_declared_collection_members(self):
        statement = parse("_let checked: $type.set [ $type.int ] = $cfg.input;", "runtime.zmdl").statements[0]
        binding = NixEmitter().statement(statement)
        error = self.evaluate(f'let config.zenos.input = {{ good = 1; bad = "wrong"; }}; {binding} in checked.good', failure=True)
        self.assertIn("_let checked annotation mismatch", error)

    def test_typed_let_function_result_is_checked_and_normalized(self):
        statement = parse("_let callable: $type.functionTo [ $type.color ] = $cfg.input;", "runtime.zmdl").statements[0]
        binding = NixEmitter().statement(statement)
        self.assertEqual("aabbcc", self.evaluate(f'let config.zenos.input = ignored: "#AABBCC"; {binding} in callable null'))
        error = self.evaluate(f'let config.zenos.input = ignored: "bad"; {binding} in callable null', failure=True)
        self.assertIn("not of type", error)

    def test_typed_let_internal_name_does_not_capture_an_initializer(self):
        document = parse('''
          _let _zenCheckedValue: $type.color = "#AABBCC";
          _let tone: $type.color = $v._zenCheckedValue;
        ''', "names.zmdl")
        bindings = " ".join(NixEmitter().statement(item) for item in document.statements)
        self.assertEqual("aabbcc", self.evaluate(f"let {bindings} in tone"))

    def test_typed_let_normalization_reaches_expression_bindings(self):
        document = parse('''
          record = let _let tone: $type.color = "#AABBCC"; in { value = $v.tone; };
        ''', "colors.zmdl")
        emitted = NixEmitter().expression(document.statements[0].value)
        self.assertEqual({"value": "aabbcc"}, self.evaluate(emitted))

    def test_typed_let_normalization_reaches_option_and_action_scopes(self):
        entry = self.source("modules/colors.zmdl", '''
          option = {
            _let tone: $type.color = "#AABBCC";
            _meta.type = $type.color;
            _meta.default = $v.tone;
            s!! {
              _let colors: $type.list [ $type.color ] = [ "#DDEEFF" ];
              result = { _let nested: $type.color = $v.tone; value = $v.nested; list = $v.colors; };
            };
          };
        ''')
        output = compile_zmdl_mount(parse_file(entry, import_root=self.root), root=self.root)
        self.assertEqual({"defaults": {"option": "aabbcc"}, "result": {"value": "aabbcc", "list": ["ddeeff"]}}, self.evaluate("""
          let mounted = (""" + output + """) { inherit pkgs lib; cfg = {}; config = {}; };
          in {
            defaults = (lib.evalModules { modules = [ mounted.schema ]; }).config;
            result = (lib.evalModules { modules = mounted.actions ++ [{
              options.result = lib.mkOption { type = lib.types.attrsOf lib.types.anything; };
            }]; }).config.result;
          }
        """))

    def test_typed_let_rejects_dynamic_nested_config_values(self):
        output = compile_zcfg(parse('''
          system = { _let checked: $type.int = $cfg.input; result = $v.checked; };
        ''', "runtime.zcfg"))
        error = self.evaluate(f'({output}) {{ inherit pkgs lib; config.zenos.input = "wrong"; }}', failure=True)
        self.assertIn("_let checked annotation mismatch", error)


if __name__ == "__main__":
    unittest.main()
