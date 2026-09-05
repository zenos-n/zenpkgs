from dataclasses import FrozenInstanceError
from io import StringIO
import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from zenlang import FileKind, ZenLangError, ast_to_dict, parse, parse_file, tokenize
from zenlang.cli import main
from zenlang.model import (
    ActionStatement,
    Assignment,
    AttrSet,
    BinaryExpr,
    CallExpr,
    ConditionalStatement,
    DefaultExpr,
    DynamicSegment,
    EnableOption,
    IfExpr,
    ImportStatement,
    LambdaExpr,
    LetExpr,
    LetStatement,
    ListExpr,
    Literal,
    ResolvedImport,
    StringExpr,
    StructuralMarker,
    WithExpr,
)


FIXTURES = Path(__file__).parent / "fixtures"


class FixtureSyntaxTests(unittest.TestCase):
    def test_all_strategy_fixtures_parse_as_syntax(self) -> None:
        expected = {
            "host.zcfg": FileKind.ZCFG,
            "modules/desktops/gnome.zmdl": FileKind.ZMDL,
            "bat.zpkg": FileKind.ZPKG,
            "structure.zstr": FileKind.ZSTR,
            "typed-aliases.zstr": FileKind.ZSTR,
        }
        for name, kind in expected.items():
            with self.subTest(name=name):
                document = parse_file(FIXTURES / name, validate_semantics=False)
                self.assertEqual(kind, document.kind)
                self.assertTrue(document.statements)

    def test_gnome_fixture_contains_actions_enable_option_and_with(self) -> None:
        document = parse_file(FIXTURES / "modules" / "desktops" / "gnome.zmdl", validate_semantics=False)
        enable = document.statements[1]
        self.assertIsInstance(enable, Assignment)
        self.assertIsInstance(enable.value, EnableOption)
        action = enable.value.body.statements[2]
        self.assertIsInstance(action, ActionStatement)
        packages = action.body.statements[2]
        self.assertIsInstance(packages, Assignment)
        self.assertIsInstance(packages.value, WithExpr)
        self.assertIsInstance(packages.value.body, BinaryExpr)

    def test_structure_fixtures_contain_the_draft_marker_kinds(self) -> None:
        documents = (
            parse_file(FIXTURES / "structure.zstr", validate_semantics=False),
            parse_file(FIXTURES / "typed-aliases.zstr", validate_semantics=False),
        )
        serialized = json.dumps(
            [ast_to_dict(document) for document in documents], sort_keys=True
        )
        for marker in ("freeform", "alias", "packages", "zmdl"):
            self.assertIn(f'"kind": "{marker}"', serialized)

    def test_zstr_accepts_zmdl_mount_markers(self) -> None:
        document = parse("desktops._meta.type = (zmdl desktops.gnome);", "structure.zstr")
        self.assertIsInstance(document.statements[0].value, StructuralMarker)
        self.assertEqual("zmdl", document.statements[0].value.kind)


class LexerParserTests(unittest.TestCase):
    def test_tokens_have_character_accurate_spans(self) -> None:
        tokens = tokenize("# comment\nalpha = 12.5;", "span.zpkg")
        self.assertEqual("alpha", tokens[0].text)
        self.assertEqual((2, 1, 10), (tokens[0].span.start.line, tokens[0].span.start.column, tokens[0].span.start.offset))
        self.assertEqual("float", tokens[2].kind.value)

    def test_common_expressions_and_statement_forms(self) -> None:
        source = r'''
_import "base.zcfg";
_import defaults: $type.set [ $type.string ] = ./defaults.zcfg;
_let port: $type.int = 8080;
result = let
  f = { value ? 1, ... }: value * 2;
in if !$deps.disabled && $v.port >= 10 then f ($v.port) else 0;
message = "port=${$v.port}";
script = ''line
${$v.port}
'';
merged = { "quoted" = true; };
removed = [ $pkgs.zenos.old ];
'''
        document = parse(source, "expressions.zpkg")
        self.assertEqual(8, len(document.statements))
        self.assertIsInstance(document.statements[0], ImportStatement)
        self.assertIsNotNone(document.statements[1].annotation)
        self.assertIsInstance(document.statements[2], LetStatement)
        result = document.statements[3]
        self.assertIsInstance(result.value, LetExpr)
        self.assertIsInstance(result.value.statements[0].value, LambdaExpr)
        self.assertIsInstance(result.value.body, IfExpr)
        self.assertIsInstance(document.statements[4].value, StringExpr)
        self.assertTrue(document.statements[5].value.multiline)
        self.assertEqual("=", document.statements[6].operator)

    def test_paths_calls_defaults_and_dynamic_segments(self) -> None:
        source = '''
_let user: $type.string = "alice";
(alias users.($f.user)."shell-name") = $v.user.shell or "sh";
build = $lib.id { owner = "zenos-n"; };
'''
        source = source.replace("$f.user", "$v.user")
        document = parse(source, "paths.zstr")
        alias = document.statements[1]
        self.assertIsInstance(alias.target, StructuralMarker)
        self.assertTrue(any(isinstance(part, DynamicSegment) for part in alias.target.argument))
        self.assertIsInstance(document.statements[2].value, CallExpr)

    def test_lists_are_whitespace_separated_and_prefix_cascades_are_rejected(self) -> None:
        document = parse("value = [ 1 2 3 ];", "list.zpkg")
        self.assertEqual(3, len(document.statements[0].value.items))

        for source, code in (
            ("value = [ 1, 2 ];", "ZEN117"),
            ('value = [ 1"two" ];', "ZEN117"),
            ("value = ++[ 1 ];", "ZEN107"),
            ("value = --[ 1 ];", "ZEN107"),
        ):
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zpkg")
            self.assertEqual(code, raised.exception.diagnostic.code)

    def test_list_operators_and_unary_values_require_grouping(self) -> None:
        document = parse("first = [ (1 + 2) 3 ]; second = [ (-1) 2 ];", "list.zpkg")
        first = document.statements[0].value
        second = document.statements[1].value

        self.assertIsInstance(first, ListExpr)
        self.assertEqual(2, len(first.items))
        self.assertIsInstance(first.items[0].value, BinaryExpr)
        self.assertIsInstance(first.items[1], Literal)
        self.assertIsInstance(second, ListExpr)
        self.assertEqual(2, len(second.items))
        self.assertEqual("-", second.items[0].value.operator)
        self.assertEqual(1, second.items[0].value.operand.value)

        for source in (
            "value = [ 1 + 2 ];",
            "value = [ -1 ];",
            "value = [ if true then 1 else 2 ];",
        ):
            with self.subTest(source=source), self.assertRaises(ZenLangError):
                parse(source, "bad.zpkg")

    def test_application_requires_a_gap_and_rejects_comma_calls(self) -> None:
        parsed = parse("value = $lib.id (1);", "call.zpkg")
        self.assertIsInstance(parsed.statements[0].value, CallExpr)
        for source in ('value = $lib.id"x";', "value = fn(1, 2);"):
            with self.subTest(source=source), self.assertRaises(ZenLangError):
                parse(source, "bad.zpkg", validate_semantics=False)

    def test_let_expressions_accept_only_assignments_and_typed_bindings(self) -> None:
        parse("value = let item = 1; _let typed: $type.int = 2; in item;", "let.zpkg")
        for statement in (
            "inherit item;",
            '_import "other.zpkg";',
            "(alias item) = true;",
        ):
            with self.subTest(statement=statement), self.assertRaises(ZenLangError) as raised:
                parse(f"value = let {statement} in 1;", "bad.zpkg", validate_semantics=False)
            self.assertEqual("ZEN121", raised.exception.diagnostic.code)

    def test_additive_operators_share_left_associative_precedence(self) -> None:
        value = parse(
            "value = a ++ b + c;",
            "precedence.zpkg",
            validate_semantics=False,
        ).statements[0].value
        self.assertEqual("+", value.operator)
        self.assertEqual("++", value.left.operator)

    def test_selection_defaults_bind_before_binary_operators(self) -> None:
        document = parse(
            "first = $cfg.enabled or true && false; second = $cfg.settings.enabled or false;",
            "defaults.zmdl",
        )
        first = document.statements[0].value
        second = document.statements[1].value

        self.assertIsInstance(first, BinaryExpr)
        self.assertEqual("&&", first.operator)
        self.assertIsInstance(first.left, DefaultExpr)
        self.assertIsInstance(second, DefaultExpr)

        with self.assertRaises(ZenLangError) as raised:
            parse("value = true or false;", "bad.zmdl")
        self.assertEqual("ZEN119", raised.exception.diagnostic.code)

    def test_zpkg_dependencies_use_fixed_unprefixed_scopes(self) -> None:
        document = parse(
            "_meta.dependencies = { general = [ $pkgs.legacy.a ]; build = [ $pkgs.legacy.b ]; runtime = [ $pkgs.legacy.c ]; };",
            "cascade.zpkg",
        )
        operators = [statement.operator for statement in document.statements[0].value.statements]
        self.assertEqual(["=", "=", "="], operators)

    def test_dynamic_segments_require_variables(self) -> None:
        for source in (
            "value.foo.(bar) = true;",
            'value.foo.("bar") = true;',
            "value.foo.($v.name || true) = true;",
        ):
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zstr", validate_semantics=False)
            self.assertEqual("ZEN118", raised.exception.diagnostic.code)

    def test_multiline_string_inside_interpolation_handles_escaped_apostrophes(self) -> None:
        document = parse("value = ''outer ${''can'''t''} done'';", "apostrophe.zpkg")
        outer = document.statements[0].value
        self.assertIsInstance(outer, StringExpr)
        interpolation = outer.parts[1]
        self.assertIsInstance(interpolation.expression, StringExpr)

    def test_zcfg_conditional_statement(self) -> None:
        document = parse(
            "if $cfg.desktop.enable or false { system.audio = true; };",
            "host.zcfg",
        )
        self.assertIsInstance(document.statements[0], ConditionalStatement)
        with self.assertRaises(ZenLangError) as raised:
            parse("if true or false { system.audio = true; };", "bad.zcfg")
        self.assertEqual("ZEN119", raised.exception.diagnostic.code)

    def test_all_six_zmdl_action_forms(self) -> None:
        source = """option = {
  _meta.type = $type.bool;
  ! [ true ] { generic = true; };
  !! { genericAlways = true; };
  s! [ $path.option ($cfg.ready or false) ] { system = true; };
  s!! { systemAlways = true; };
  u! [ (!($cfg.locked or false)) ] { user = true; };
  u!! { userAlways = true; };
};
"""
        document = parse(source, "actions.zmdl")
        option = document.statements[0]
        self.assertIsInstance(option.value, AttrSet)
        actions = option.value.statements[1:]
        self.assertEqual(6, len(actions))
        self.assertEqual(
            [
                ("shared", False),
                ("shared", True),
                ("system", False),
                ("system", True),
                ("user", False),
                ("user", True),
            ],
            [(action.scope, action.unconditional) for action in actions],
        )

    def test_ast_is_deeply_immutable_and_json_serializable(self) -> None:
        document = parse("value = [ 1 true null ];", "immutable.zpkg")
        with self.assertRaises(FrozenInstanceError):
            document.kind = FileKind.ZCFG
        value = document.statements[0].value
        self.assertIsInstance(value, ListExpr)
        with self.assertRaises(TypeError):
            value.items[0] = value.items[1]
        self.assertEqual("document", ast_to_dict(document)["type"])
        self.assertEqual("1.0.0Na", document.grammar_version)
        self.assertEqual("1.0.0Na", ast_to_dict(document)["ir_version"])

    def test_lexical_and_syntax_diagnostics_are_stable(self) -> None:
        cases = (
            ('value = "unterminated;', "bad.zpkg", "ZEN003"),
            ("value = @;", "bad.zpkg", "ZEN001"),
            ("value = 1.2.3.4;", "bad.zpkg", "ZEN006"),
            ("value = 1.2.3Nbeta;", "bad.zpkg", "ZEN006"),
            ("value = [ 1 2;", "bad.zpkg", "ZEN111"),
            ("_let x = 1;", "bad.zpkg", "ZEN101"),
        )
        for source, name, code in cases:
            with self.subTest(code=code):
                with self.assertRaises(ZenLangError) as raised:
                    parse(source, name)
                self.assertEqual(code, raised.exception.diagnostic.code)

    def test_control_character_diagnostics_use_the_exact_character_span(self) -> None:
        for source in ('value = "a\x01b";', "value = ''a\x7fb'';"):
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "control.zpkg")
            diagnostic = raised.exception.diagnostic
            self.assertEqual("ZEN004", diagnostic.code)
            self.assertEqual(1, diagnostic.span.end.offset - diagnostic.span.start.offset)


class SemanticValidationTests(unittest.TestCase):
    def test_rejects_wrong_file_kind_statements(self) -> None:
        cases = (
            ("! { x = true; };", "bad.zcfg", "ZEN202"),
            ("if true { x = true; };", "bad.zmdl", "ZEN202"),
            ("(packages) = true;", "bad.zpkg", "ZEN204"),
            ("(programs) = true;", "bad.zmdl", "ZEN204"),
            ("value = enableOption { };", "bad.zcfg", "ZEN205"),
        )
        for source, name, code in cases:
            with self.subTest(name=name, code=code):
                with self.assertRaises(ZenLangError) as raised:
                    parse(source, name)
                self.assertEqual(code, raised.exception.diagnostic.code)

    def test_rejects_actions_outside_zmdl_option_attrsets(self) -> None:
        invalid = (
            ("s! { x = true; };", "ZEN203"),
            ("_meta = { s! { x = true; }; };", "ZEN203"),
            ("option = { nested = { s! { x = true; }; }; };", "ZEN217"),
        )
        for source, code in invalid:
            with self.subTest(source=source):
                with self.assertRaises(ZenLangError) as raised:
                    parse(source, "bad.zmdl")
                self.assertEqual(code, raised.exception.diagnostic.code)

    def test_file_kind_comes_only_from_supported_extension(self) -> None:
        with self.assertRaises(ZenLangError) as raised:
            parse("value = true;", "config.nix")
        self.assertEqual("ZEN201", raised.exception.diagnostic.code)

    def test_local_variables_are_source_ordered_and_lexically_scoped(self) -> None:
        valid = '''
_let first: $type.string = "one";
value = $v.first;
scope = {
  _let second: $type.int = 2;
  nested = $v.first;
  local = $v.second;
};
'''
        parse(valid, "vars.zpkg")

        invalid = (
            "value = $v.later; _let later: $type.int = 1;",
            "scope = { _let inner: $type.int = 1; }; value = $v.inner;",
            '_import item: $type.string = "item.zpkg"; value = $v.missing;',
        )
        for source in invalid:
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zpkg")
            self.assertEqual("ZEN208", raised.exception.diagnostic.code)
            self.assertEqual("$", source[raised.exception.diagnostic.span.start.offset])

    def test_bound_import_defines_a_local_after_its_statement(self) -> None:
        parse(
            '_import settings: $type.set [ $type.string ] = "settings.zcfg"; value = $v.settings.name;',
            "bound.zcfg",
        )
        with self.assertRaises(ZenLangError) as raised:
            parse(
                'value = $v.settings.name; _import settings: $type.set [ $type.string ] = "settings.zcfg";',
                "bound.zcfg",
            )
        self.assertEqual("ZEN208", raised.exception.diagnostic.code)

    def test_builtin_variable_allowlists_are_format_specific(self) -> None:
        parse("_let value: $type.string = $name; result = $v.value;", "types.zstr")
        parse("(freeform item) = { value = $f.item; };", "freeform.zstr")

        cases = (
            ("value = $deps.zlib;", "bad.zcfg"),
            ("value = $deps.zlib;", "bad.zmdl"),
            ("value = $f.name;", "bad.zpkg"),
            ("value = $cfg.foo;", "bad.zpkg"),
            ("value = $cfg.foo;", "bad.zstr"),
        )
        for source, name in cases:
            with self.subTest(name=name), self.assertRaises(ZenLangError) as raised:
                parse(source, name)
            self.assertEqual("ZEN208", raised.exception.diagnostic.code)

    def test_freeform_variables_follow_lexical_scope(self) -> None:
        parse(
            "(freeform outer) = { value = $f.outer; (freeform inner) = { both = [ $f.outer $f.inner ]; }; };",
            "freeform.zstr",
        )
        with self.assertRaises(ZenLangError) as raised:
            parse("value = $f.missing;", "bad.zstr")
        self.assertEqual("ZEN208", raised.exception.diagnostic.code)

    def test_type_annotations_are_rooted_and_parameterized(self) -> None:
        valid = (
            ("$type.string", '"value"'),
            ("$type.list [ $type.string ]", '[ "value" ]'),
            ("$type.set [ $type.int ]", "{ value = 1; }"),
            ("$type.set", '{ count = 1; label = "record"; }'),
            ("$type.either [ $type.string $type.int ]", "1"),
            ('$type.enum [ "dark" "light" ]', '"dark"'),
            ("$type.functionTo [ $type.bool ]", "item: true"),
            ("$type.function [ $type.string ]", "item: item"),
        )
        for annotation, value in valid:
            with self.subTest(annotation=annotation):
                parse(f"_let value: {annotation} = {value};", "type.zmdl")

        invalid = (
            "$v.type",
            "$type.list",
            "$type.either [ $type.string ]",
            "$type.enum [ ]",
            "$type.function",
            "$type.functionTo",
            "$type.list [ $type.string $type.int ]",
        )
        for annotation in invalid:
            with self.subTest(annotation=annotation), self.assertRaises(ZenLangError) as raised:
                parse(f"_let value: {annotation} = null;", "bad.zmdl")
            self.assertEqual("ZEN209", raised.exception.diagnostic.code)

    def test_guards_and_conditions_reject_obviously_non_boolean_values(self) -> None:
        invalid = (
            ('option = { _meta.type = $type.bool; s! [ "yes" ] { value = true; }; };', "bad.zmdl"),
            ("option = { _meta.type = $type.bool; s! [ 1 ] { value = true; }; };", "bad.zmdl"),
            ("option = { _meta.type = $type.bool; s! [ [ true ] ] { value = true; }; };", "bad.zmdl"),
            ("if [ true ] { value = true; };", "bad.zcfg"),
        )
        for source, name in invalid:
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, name)
            self.assertEqual("ZEN210", raised.exception.diagnostic.code)

        parse("if ($cfg.enabled or false) && true { value = true; };", "condition.zcfg")
        parse(
            "option = { _meta.type = $type.bool; s! [ $path.option (1 < 2) ] { value = true; }; };",
            "guard.zmdl",
        )

    def test_guards_use_declared_types_and_deferred_cfg_markers(self) -> None:
        parse(
            "_let ready: $type.bool = true; ready = { _meta.type = $type.bool; }; enable = enableOption { s! [ $v.ready $path.ready ($cfg.external.enable or false) ] { value = true; }; };",
            "typed-guards.zmdl",
        )
        invalid = (
            "_let port: $type.int = 1; enable = enableOption { s! [ $v.port ] { value = true; }; };",
            "port = { _meta.type = $type.int; }; enable = enableOption { s! [ $path.port ] { value = true; }; };",
            "enable = enableOption { s! [ $cfg.external.enable ] { value = true; }; };",
            "enable = enableOption { s! [ ($lib.id true) ] { value = true; }; };",
        )
        for source in invalid:
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zmdl")
            self.assertEqual("ZEN220", raised.exception.diagnostic.code)

    def test_reserved_backend_names_cannot_enter_lexical_scope(self) -> None:
        valid = "value = item: { inherit item; };"
        parse(valid, "inherit.zpkg")
        invalid = (
            "_let builtins: $type.int = 1;",
            '_import import: $type.string = "other.zpkg";',
            "value = abort: abort;",
            "value = { derivation ? 1 }: derivation;",
            "value = let builtins = 1; in builtins;",
            "value = { inherit builtins; };",
            "value = item: { inherit missing; };",
            'value = builtins.abort "boom";',
        )
        for source in invalid:
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zpkg")
            self.assertIn(raised.exception.diagnostic.code, ("ZEN216", "ZEN219"))

    def test_zcfg_rejects_evaluator_constructs_but_keeps_data_expressions(self) -> None:
        parse(
            'value = { enabled = true; packages = [ $pkgs.zenos.git ]; message = "${$cfg.name}"; }; if $cfg.enabled == true { other = -2; };',
            "allowed.zcfg",
        )
        invalid = (
            ("value = $lib.id (true);", "ZEN211"),
            ("value = x: x;", "ZEN211"),
            ("value = with $pkgs; git;", "ZEN211"),
            ("value = let x = 1; in x;", "ZEN211"),
            ("value = if true then 1 else 2;", "ZEN211"),
            ("value = foo;", "ZEN211"),
            ("value = [ 1 ] ++ [ 2 ];", "ZEN211"),
        )
        for source, code in invalid:
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zcfg")
            self.assertEqual(code, raised.exception.diagnostic.code)

    def test_interpolation_rejects_statically_non_scalar_values(self) -> None:
        for source in (
            'value = "${[ 1 2 ]}";',
            'value = "${{ nested = true; }}";',
            'value = "${null}";',
            'value = "${($value: $value)}";',
        ):
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zpkg")
            self.assertEqual("ZEN212", raised.exception.diagnostic.code)

        for source in (
            'value = "${[ 1 ] ++ [ 2 ]}";',
            'value = "${{ first = 1; } // { second = 2; }}";',
        ):
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zpkg")
            self.assertEqual("ZEN212", raised.exception.diagnostic.code)

    def test_enable_option_and_actions_do_not_gain_nested_context(self) -> None:
        parse(
            "outer = { nested = enableOption { s! { x = true; }; }; };",
            "nested-option.zmdl",
        )
        invalid = (
            "outer = enableOption { nested = { s! { x = true; }; }; };",
            "_meta = enableOption { s! { x = true; }; };",
        )
        expected = ("ZEN217", "ZEN206")
        for source, code in zip(invalid, expected):
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zmdl")
            self.assertEqual(code, raised.exception.diagnostic.code)

        parse("option = enableOption { s! { x = true; }; };", "option.zmdl")

        with self.assertRaises(ZenLangError) as raised:
            parse('option = { _meta.type = $type.string; s! { x = true; }; };', "bad.zmdl")
        self.assertEqual("ZEN217", raised.exception.diagnostic.code)

        parse(
            '(freeform user) = { _meta.type = $type.bool; s! { x = true; }; };',
            "freeform.zmdl",
        )

    def test_dotted_paths_cannot_bypass_metadata_or_action_context(self) -> None:
        invalid = (
            'option._meta = { zenosVersion = "bad"; };',
            'option._meta.zenosVersion = "bad";',
            "option.nested = { s! { x = true; }; };",
            "option._meta = enableOption { s! { x = true; }; };",
        )
        expected = ("ZEN213", "ZEN213", "ZEN217", "ZEN206")
        for source, code in zip(invalid, expected):
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zmdl")
            self.assertEqual(code, raised.exception.diagnostic.code)

    def test_zenos_version_metadata_uses_strict_version_literals(self) -> None:
        for version in ("1.0.0", "1.0.0N", "1.0.0Na", "2.4.1b"):
            parse(f'_meta.zenosVersion = "{version}";', "version.zpkg")
        for value in ('"not-a-version"', "1", "null"):
            with self.subTest(value=value), self.assertRaises(ZenLangError) as raised:
                parse(f"_meta.zenosVersion = {value};", "bad.zpkg")
            self.assertEqual("ZEN213", raised.exception.diagnostic.code)
        parse('_meta."zenosVersion" = "1.0.0";', "version.zpkg")

    def test_non_zpkg_assignment_cascades_are_rejected(self) -> None:
        for name in ("bad.zcfg", "bad.zmdl", "bad.zstr"):
            with self.subTest(name=name), self.assertRaises(ZenLangError) as raised:
                parse("value ++ [ 1 ];", name)
            self.assertEqual("ZEN207", raised.exception.diagnostic.code)

        for source in ("value ++ [ 1 ];", "_meta.dependencies = { runtime ++ true; };"):
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zpkg")
            self.assertEqual("ZEN207", raised.exception.diagnostic.code)


class ImportGraphTests(unittest.TestCase):
    def test_recursive_bare_and_bound_imports_are_resolved_without_nix_imports(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "leaf.zcfg").write_text("leaf = true;", encoding="utf-8")
            (root / "middle.zcfg").write_text('_import "leaf.zcfg"; middle = true;', encoding="utf-8")
            (root / "bound.zcfg").write_text("bound = true;", encoding="utf-8")
            entry = root / "entry.zcfg"
            entry.write_text(
                '_import "middle.zcfg"; _import data: $type.set [ $type.bool ] = "bound.zcfg"; local = $v.data.bound;',
                encoding="utf-8",
            )

            document = parse_file(entry)
            self.assertEqual(3, len(document.statements))
            self.assertIsInstance(document.statements[0], ResolvedImport)
            self.assertIsNone(document.statements[0].binding)
            self.assertIsInstance(document.statements[1], ResolvedImport)
            self.assertEqual("data", document.statements[1].binding)
            self.assertEqual(entry.as_posix(), document.span.source)

    def test_legacy_import_is_resolved_with_a_deprecation_warning(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "base.zcfg").write_text("base = true;", encoding="utf-8")
            entry = root / "entry.zcfg"
            entry.write_text("import ./base.zcfg; local = true;", encoding="utf-8")
            document = parse_file(entry)
            self.assertEqual("ZEN214", document.diagnostics[0].code)
            self.assertEqual("warning", document.diagnostics[0].severity)

    def test_imported_option_metadata_participates_in_guard_typing(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "base.zmdl").write_text(
                "ready = { _meta.type = $type.bool; };",
                encoding="utf-8",
            )
            entry = root / "entry.zmdl"
            entry.write_text(
                '_import "base.zmdl"; enable = enableOption { s! [ $path.ready ] { value = true; }; };',
                encoding="utf-8",
            )
            parse_file(entry)

    def test_import_merge_rejects_conflicting_freeform_leaves(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "base.zmdl").write_text(
                "(freeform item) = { value = true; };",
                encoding="utf-8",
            )
            entry = root / "entry.zmdl"
            entry.write_text(
                '_import "base.zmdl"; (freeform item) = { value = "bad"; };',
                encoding="utf-8",
            )

            with self.assertRaises(ZenLangError) as raised:
                parse_file(entry)
            self.assertEqual("ZEN218", raised.exception.diagnostic.code)
            self.assertEqual(
                str(entry), raised.exception.diagnostic.span.source
            )
            stderr = StringIO()
            self.assertEqual(
                1,
                main(["check", str(entry)], StringIO(), stderr),
            )
            self.assertIn("ZEN218", stderr.getvalue())

    def test_imported_boolean_freeform_types_conditional_local_actions(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "base.zmdl").write_text(
                "(freeform item) = { _meta.type = $type.bool; };",
                encoding="utf-8",
            )
            entry = root / "entry.zmdl"
            entry.write_text(
                '_import "base.zmdl"; (freeform item) = { s! { result.($f.item) = true; }; };',
                encoding="utf-8",
            )

            parse_file(entry)

    def test_freeform_validation_canonicalizes_dotted_and_nested_scopes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "base.zmdl").write_text(
                "scope.inner = { (freeform item) = { _meta.type = $type.bool; }; };",
                encoding="utf-8",
            )
            entry = root / "entry.zmdl"
            entry.write_text(
                '_import "base.zmdl"; scope = { inner = { (freeform item) = { s! { result.($f.item) = true; }; }; }; };',
                encoding="utf-8",
            )
            parse_file(entry)

            entry.write_text(
                '_import "base.zmdl"; scope = { inner = { (freeform other) = { _meta.type = $type.bool; }; }; };',
                encoding="utf-8",
            )
            with self.assertRaises(ZenLangError) as raised:
                parse_file(entry)
            self.assertEqual("ZEN221", raised.exception.diagnostic.code)

    def test_rejects_arbitrary_evaluator_roots_and_allows_zenos_with_scope(self) -> None:
        parse(
            "value = with $pkgs.zenos; [ git tools.ripgrep ];",
            "packages.zpkg",
        )
        parse("value = with $pkgs.zenos.legacy; [ git ];", "legacy.zpkg")
        for source in (
            'value = builtins.abort "boom";',
            'value = import "payload.nix";',
            "value = with $pkgs; git;",
            "value = with $pkgs.lib; id;",
            "value = with $pkgs.stdenv; mkDerivation;",
            'value = with $pkgs.zenos; builtins.abort "boom";',
            'value = undeclared "argument";',
        ):
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zpkg")
            self.assertEqual("ZEN216", raised.exception.diagnostic.code)

    def test_package_import_and_dependency_scope_diagnostics(self) -> None:
        parse(
            '_meta.dependencies = { general = [ $pkgs.legacy.a ]; build = [ $pkgs.legacy.b ]; runtime = [ $pkgs.legacy.c ]; };',
            "deps.zpkg",
        )
        invalid = (
            "_meta.dependencies = { _general = [ ]; _build = [ ]; _runtime = [ ]; };",
            "_meta.dependencies = { general = [ ]; build ++ [ ]; runtime = [ ]; };",
        )
        for source in invalid:
            with self.subTest(source=source), self.assertRaises(ZenLangError) as raised:
                parse(source, "bad.zpkg")
            self.assertIn(raised.exception.diagnostic.code, ("ZEN207", "ZEN215"))

    def test_imports_must_be_relative_existing_and_same_kind(self) -> None:
        cases = (
            ('_import "/tmp/absolute.zcfg";', None, "ZEN302"),
            ('_import "";', None, "ZEN302"),
            ('_import "missing.zcfg";', None, "ZEN304"),
            ('_import "other.zpkg";', ("other.zpkg", "value = true;"), "ZEN303"),
        )
        for source, child, code in cases:
            with self.subTest(code=code), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                if child is not None:
                    (root / child[0]).write_text(child[1], encoding="utf-8")
                entry = root / "entry.zcfg"
                entry.write_text(source, encoding="utf-8")
                with self.assertRaises(ZenLangError) as raised:
                    parse_file(entry)
                self.assertEqual(code, raised.exception.diagnostic.code)
                self.assertEqual(1, raised.exception.diagnostic.span.start.line)

    def test_imports_are_confined_to_the_default_or_explicit_root(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source_root = root / "source"
            source_root.mkdir()
            outside = root / "shared.zcfg"
            outside.write_text("shared = true;", encoding="utf-8")
            entry = source_root / "entry.zcfg"
            entry.write_text('_import "../shared.zcfg";', encoding="utf-8")

            with self.assertRaises(ZenLangError) as raised:
                parse_file(entry)
            self.assertEqual("ZEN306", raised.exception.diagnostic.code)

            parse_file(entry, import_root=root)

            link = source_root / "link.zcfg"
            link.symlink_to(outside)
            entry.write_text('_import "link.zcfg";', encoding="utf-8")
            parse_file(entry)

            with self.assertRaises(ZenLangError) as raised:
                parse_file(outside, import_root=source_root)
            self.assertEqual("ZEN306", raised.exception.diagnostic.code)

    def test_logical_symlink_root_is_preserved(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            physical_root = base / "physical"
            physical_root.mkdir()
            (physical_root / "entry.zcfg").write_text(
                "value = true;", encoding="utf-8"
            )
            logical_root = base / "logical"
            logical_root.symlink_to(physical_root, target_is_directory=True)

            document = parse_file(
                logical_root / "entry.zcfg", import_root=logical_root
            )
            self.assertEqual(
                str(logical_root / "entry.zcfg"), document.span.source
            )

    def test_relative_imports_from_file_symlinks_use_logical_paths(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            logical_root = base / "logical"
            logical_root.mkdir()
            canonical = base / "canonical"
            canonical.mkdir()
            (canonical / "entry-source").write_text(
                '_import "child.zcfg"; local = true;', encoding="utf-8"
            )
            (canonical / "child-source").write_text(
                "imported = true;", encoding="utf-8"
            )
            (logical_root / "entry.zcfg").symlink_to(canonical / "entry-source")
            (logical_root / "child.zcfg").symlink_to(canonical / "child-source")

            document = parse_file(logical_root / "entry.zcfg")
            self.assertEqual(2, len(document.statements))
            self.assertIsInstance(document.statements[0], ResolvedImport)

    def test_physical_import_cache_keeps_each_logical_parent(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            template = root / "template"
            template.write_text('_import "child.zcfg";', encoding="utf-8")
            for name in ("left", "right"):
                parent = root / name
                parent.mkdir()
                (parent / "alias.zcfg").symlink_to(template)
                (parent / "child.zcfg").write_text(
                    f'{name} = true;', encoding="utf-8"
                )
            entry = root / "entry.zcfg"
            entry.write_text(
                '_import "left/alias.zcfg"; _import "right/alias.zcfg";',
                encoding="utf-8",
            )

            document = parse_file(entry, import_root=root)
            aliases = [
                statement.document
                for statement in document.statements
                if isinstance(statement, ResolvedImport)
            ]
            children = [
                alias.statements[0].document.span.source
                for alias in aliases
                if isinstance(alias.statements[0], ResolvedImport)
            ]
            self.assertEqual(
                [
                    str(root / "left" / "child.zcfg"),
                    str(root / "right" / "child.zcfg"),
                ],
                children,
            )

    def test_import_path_failures_and_depth_have_stable_diagnostics(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            entry = root / "entry.zcfg"
            entry.write_bytes(b"_import ''\x00'';")
            with self.assertRaises(ZenLangError) as raised:
                parse_file(entry)
            self.assertEqual("ZEN004", raised.exception.diagnostic.code)

            (root / "0.zcfg").write_text('_import "1.zcfg";', encoding="utf-8")
            (root / "1.zcfg").write_text('_import "2.zcfg";', encoding="utf-8")
            (root / "2.zcfg").write_text("value = true;", encoding="utf-8")
            with patch("zenlang.api._MAX_IMPORT_DEPTH", 1):
                with self.assertRaises(ZenLangError) as raised:
                    parse_file(root / "0.zcfg")
            self.assertEqual("ZEN307", raised.exception.diagnostic.code)

    def test_import_cycle_reports_complete_trace(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "a.zmdl").write_text('_import "b.zmdl";', encoding="utf-8")
            (root / "b.zmdl").write_text('_import "c.zmdl";', encoding="utf-8")
            (root / "c.zmdl").write_text('_import "a.zmdl";', encoding="utf-8")
            with self.assertRaises(ZenLangError) as raised:
                parse_file(root / "a.zmdl")
            self.assertEqual("ZEN305", raised.exception.diagnostic.code)
            trace = raised.exception.diagnostic.notes[0]
            self.assertIn("a.zmdl", trace)
            self.assertIn("b.zmdl", trace)
            self.assertIn("c.zmdl", trace)

    def test_import_cycle_through_file_aliases_uses_physical_identity(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            canonical = root / "canonical-source"
            canonical.write_text('_import "alias.zcfg";', encoding="utf-8")
            entry = root / "entry.zcfg"
            alias = root / "alias.zcfg"
            entry.symlink_to(canonical)
            alias.symlink_to(canonical)

            with self.assertRaises(ZenLangError) as raised:
                parse_file(entry)
            self.assertEqual("ZEN305", raised.exception.diagnostic.code)
            trace = raised.exception.diagnostic.notes[0]
            self.assertIn("entry.zcfg", trace)
            self.assertIn("alias.zcfg", trace)

    def test_final_component_symlink_loops_are_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            first = root / "first.zcfg"
            second = root / "second.zcfg"
            first.symlink_to(second)
            second.symlink_to(first)

            with self.assertRaises(ZenLangError) as raised:
                parse_file(first)
            self.assertEqual("ZEN301", raised.exception.diagnostic.code)

    def test_final_symlink_targets_may_cross_directory_symlinks(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            home = root / "home"
            home.mkdir()
            source = home / "source.zcfg"
            source.write_text("value = true;", encoding="utf-8")
            users = root / "Users"
            users.symlink_to(home, target_is_directory=True)
            logical = root / "logical"
            logical.mkdir()
            entry = logical / "entry.zcfg"
            entry.symlink_to(users / "source.zcfg")

            document = parse_file(entry)
            self.assertEqual(str(entry), document.span.source)

    def test_final_symlink_target_directories_are_descriptor_pinned(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            target = root / "target"
            target.mkdir()
            (target / "source.zcfg").write_text("inside = true;", encoding="utf-8")
            outside = root / "outside"
            outside.mkdir()
            (outside / "source.zcfg").write_text("outside = true;", encoding="utf-8")
            logical = root / "logical"
            logical.mkdir()
            entry = logical / "entry.zcfg"
            entry.symlink_to(target / "source.zcfg")
            moved = root / "target-original"
            original_open = os.open
            replaced = False

            def replace_target_directory(
                path: Path | str,
                flags: int,
                *,
                dir_fd: int | None = None,
            ) -> int:
                nonlocal replaced
                descriptor = original_open(path, flags, dir_fd=dir_fd)
                if (
                    str(path) == "target"
                    and dir_fd is not None
                    and flags & os.O_PATH
                    and not replaced
                ):
                    replaced = True
                    target.rename(moved)
                    target.symlink_to(outside, target_is_directory=True)
                return descriptor

            with patch("zenlang.api.os.open", new=replace_target_directory):
                document = parse_file(entry)
            self.assertTrue(replaced)
            assignment = document.statements[0]
            self.assertIsInstance(assignment, Assignment)
            self.assertEqual("inside", assignment.target[0].name)

    def test_directory_symlink_loops_in_final_targets_are_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            first = root / "first"
            second = root / "second"
            first.symlink_to(second, target_is_directory=True)
            second.symlink_to(first, target_is_directory=True)
            logical = root / "logical"
            logical.mkdir()
            entry = logical / "entry.zcfg"
            entry.symlink_to(first / "source.zcfg")

            with self.assertRaises(ZenLangError) as raised:
                parse_file(entry)
            self.assertEqual("ZEN301", raised.exception.diagnostic.code)

    def test_source_and_import_graph_limits_have_stable_diagnostics(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            entry = root / "entry.zcfg"
            entry.write_text("value = true;", encoding="utf-8")
            with patch("zenlang.api._MAX_SOURCE_BYTES", 4):
                with self.assertRaises(ZenLangError) as raised:
                    parse_file(entry)
            self.assertEqual("ZEN308", raised.exception.diagnostic.code)
            self.assertEqual(
                f"source file exceeds the maximum size of 4 bytes: {entry}",
                raised.exception.diagnostic.message,
            )

            (root / "a.zcfg").write_text("a = true;", encoding="utf-8")
            (root / "b.zcfg").write_text("b = true;", encoding="utf-8")
            entry.write_text(
                '_import "a.zcfg"; _import "b.zcfg";', encoding="utf-8"
            )
            with patch("zenlang.api._MAX_IMPORTS", 1):
                with self.assertRaises(ZenLangError) as raised:
                    parse_file(entry)
            self.assertEqual("ZEN309", raised.exception.diagnostic.code)
            self.assertEqual(
                "import count exceeds the maximum of 1",
                raised.exception.diagnostic.message,
            )

            entry.write_text('_import "a.zcfg";', encoding="utf-8")
            byte_limit = len(entry.read_bytes()) + len((root / "a.zcfg").read_bytes()) - 1
            with patch("zenlang.api._MAX_TOTAL_SOURCE_BYTES", byte_limit):
                with self.assertRaises(ZenLangError) as raised:
                    parse_file(entry)
            self.assertEqual("ZEN310", raised.exception.diagnostic.code)
            self.assertEqual(
                f"aggregate source size exceeds the maximum of {byte_limit} bytes",
                raised.exception.diagnostic.message,
            )

    def test_effective_import_expansion_obeys_the_import_limit(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "leaf.zcfg").write_text("value = true;", encoding="utf-8")
            (root / "middle.zcfg").write_text(
                '_import "leaf.zcfg"; _import "leaf.zcfg";',
                encoding="utf-8",
            )
            entry = root / "entry.zcfg"
            entry.write_text(
                '_import "middle.zcfg"; _import "middle.zcfg";',
                encoding="utf-8",
            )

            with patch("zenlang.api._MAX_IMPORTS", 5):
                with self.assertRaises(ZenLangError) as raised:
                    parse_file(entry)
            self.assertEqual("ZEN309", raised.exception.diagnostic.code)

    def test_cached_import_expansion_obeys_the_aggregate_byte_limit(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            leaf = root / "leaf.zcfg"
            leaf.write_text("value = true;", encoding="utf-8")
            entry = root / "entry.zcfg"
            entry.write_text(
                '_import "leaf.zcfg"; _import "leaf.zcfg";',
                encoding="utf-8",
            )
            unique_bytes = len(entry.read_bytes()) + len(leaf.read_bytes())

            with patch("zenlang.api._MAX_TOTAL_SOURCE_BYTES", unique_bytes):
                with self.assertRaises(ZenLangError) as raised:
                    parse_file(entry)
            self.assertEqual("ZEN310", raised.exception.diagnostic.code)

    def test_reads_only_regular_files_and_preserves_resolved_symlinks(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            target = root / "target.zcfg"
            target.write_text("value = true;", encoding="utf-8")
            entry = root / "entry.zcfg"
            entry.symlink_to(target)
            parse_file(entry)

            imported_target = root / "imported-target.zcfg"
            imported_target.write_text("imported = true;", encoding="utf-8")
            imported_link = root / "imported.zcfg"
            imported_link.symlink_to(imported_target)
            target.write_text('_import "imported.zcfg";', encoding="utf-8")
            parse_file(entry)

            fifo = root / "pipe.zcfg"
            os.mkfifo(fifo)
            with self.assertRaises(ZenLangError) as raised:
                parse_file(fifo)
            self.assertEqual("ZEN301", raised.exception.diagnostic.code)
            self.assertEqual(
                ("path is not a regular file",), raised.exception.diagnostic.notes
            )

            device = root / "device.zcfg"
            device.symlink_to("/dev/null")
            with self.assertRaises(ZenLangError) as raised:
                parse_file(device, import_root="/")
            self.assertEqual("ZEN301", raised.exception.diagnostic.code)
            self.assertEqual(
                ("path is not a regular file",), raised.exception.diagnostic.notes
            )

    def test_final_component_symlink_replacement_is_not_followed(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            entry = root / "entry.zcfg"
            entry.write_text("value = true;", encoding="utf-8")
            replacement = root / "replacement.zcfg"
            replacement.write_text("replacement = true;", encoding="utf-8")
            original_open = os.open
            replaced = False

            def replace_after_path_open(
                path: Path | str,
                flags: int,
                *,
                dir_fd: int | None = None,
            ) -> int:
                nonlocal replaced
                descriptor = original_open(path, flags, dir_fd=dir_fd)
                if (
                    Path(path).name == entry.name
                    and dir_fd is not None
                    and flags & os.O_PATH
                    and not replaced
                ):
                    replaced = True
                    entry.unlink()
                    entry.symlink_to(replacement)
                return descriptor

            with patch("zenlang.api.os.open", new=replace_after_path_open):
                with self.assertRaises(ZenLangError) as raised:
                    parse_file(entry)
            self.assertTrue(replaced)
            self.assertEqual("ZEN301", raised.exception.diagnostic.code)

    def test_intermediate_directory_symlink_is_not_followed(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            outside = root / "outside"
            outside.mkdir()
            (outside / "entry.zcfg").write_text("outside = true;", encoding="utf-8")
            linked = root / "linked"
            linked.symlink_to(outside, target_is_directory=True)

            with self.assertRaises(ZenLangError) as raised:
                parse_file(linked / "entry.zcfg", import_root=root)
            self.assertEqual("ZEN301", raised.exception.diagnostic.code)

    def test_intermediate_directory_symlink_replacement_is_not_followed(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            nested = root / "nested"
            nested.mkdir()
            entry = nested / "entry.zcfg"
            entry.write_text("inside = true;", encoding="utf-8")
            outside = root / "outside"
            outside.mkdir()
            (outside / "entry.zcfg").write_text("outside = true;", encoding="utf-8")
            moved = root / "nested-original"
            original_open = os.open
            replaced = False

            def replace_directory(path: Path | str, flags: int, *, dir_fd: int | None = None) -> int:
                nonlocal replaced
                if str(path) == "nested" and dir_fd is not None and not replaced:
                    replaced = True
                    nested.rename(moved)
                    nested.symlink_to(outside, target_is_directory=True)
                return original_open(path, flags, dir_fd=dir_fd)

            with patch("zenlang.api.os.open", new=replace_directory):
                with self.assertRaises(ZenLangError) as raised:
                    parse_file(entry, import_root=root)
            self.assertTrue(replaced)
            self.assertEqual("ZEN301", raised.exception.diagnostic.code)


class CliTests(unittest.TestCase):
    def test_check_and_ast_support_all_extensions(self) -> None:
        sources = {
            "zcfg": "legacy.enabled = true;",
            "zmdl": "enabled._meta.type = $type.bool;",
            "zpkg": "import $pkgs.legacy.bat;",
            "zstr": "system._meta.type = (zmdl system);",
        }
        with tempfile.TemporaryDirectory() as directory:
            for kind, source in sources.items():
                fixture = Path(directory) / ("entry." + kind)
                fixture.write_text(source, encoding="utf-8")
                stdout = StringIO()
                self.assertEqual(0, main(["check", str(fixture), "--diagnostic-format", "json"], stdout, StringIO()))
                diagnostics = json.loads(stdout.getvalue())["diagnostics"]
                self.assertEqual(kind != "zcfg", bool(diagnostics))
                self.assertTrue(all(item["severity"] == "warning" for item in diagnostics))
                stdout = StringIO()
                self.assertEqual(0, main(["ast", str(fixture)], stdout, StringIO()))
                self.assertEqual(kind, json.loads(stdout.getvalue())["kind"])

    def test_cli_reports_io_and_semantic_diagnostics(self) -> None:
        stderr = StringIO()
        self.assertEqual(1, main(["check", "/missing/file.zcfg"], StringIO(), stderr))
        self.assertIn("ZEN301", stderr.getvalue())

        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "bad.zstr"
            source.write_text("s! { x = true; };", encoding="utf-8")
            stderr = StringIO()
            self.assertEqual(1, main(["check", str(source)], StringIO(), stderr))
            self.assertIn("ZEN202", stderr.getvalue())

    def test_cli_renders_imported_source_and_compiles_zcfg(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            imported = root / "bad.zcfg"
            imported.write_text("value = @;", encoding="utf-8")
            entry = root / "entry.zcfg"
            entry.write_text('_import "bad.zcfg";', encoding="utf-8")
            stderr = StringIO()

            self.assertEqual(1, main(["check", str(entry)], StringIO(), stderr))
            self.assertIn("value = @;", stderr.getvalue())
            self.assertIn("^", stderr.getvalue())

            source = root / "compile.zcfg"
            output = root / "compile.nix"
            source.write_text("system.enabled = true;", encoding="utf-8")
            self.assertEqual(
                0,
                main(
                    ["compile", str(source), "-o", str(output)],
                    StringIO(),
                    StringIO(),
                ),
            )
            self.assertIn("zenos = {", output.read_text(encoding="utf-8"))

            stdout = StringIO()
            package = root / "bat.zpkg"
            package.write_text("import $pkgs.legacy.bat;", encoding="utf-8")
            self.assertEqual(
                0,
                main(["compile", str(package)], stdout, StringIO()),
            )
            self.assertIn("pkgs.zenos.legacy.bat", stdout.getvalue())


if __name__ == "__main__":
    unittest.main()
