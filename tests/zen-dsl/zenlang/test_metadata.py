from io import StringIO
import json
from pathlib import Path
import tempfile
import unittest

from zenlang import ZenLangError, parse, parse_file
from zenlang.cli import main
from zenlang.compiler import compile_zmdl
from zenlang.emitter import semantic_descriptor
from zenlang.model import MarkdownImport, StructuralMarker
from zenlang.validation import validate


DESCRIPTION = '''
name = "Example";
summary = "Example node";
description = ''A plain Markdown paragraph.'';
tags = [ "example" ];
maintainers = [ $m.doromiert ];
license = $l.mit;
'''
META = "_meta = { " + DESCRIPTION + ' zenosVersion = "1.0.0"; };'


class MetadataTests(unittest.TestCase):
    def assert_error(self, source, kind="zmdl", code="ZEN225"):
        with self.assertRaises(ZenLangError) as raised:
            parse(source, "entry." + kind)
        self.assertEqual(code, raised.exception.diagnostic.code)

    def test_complete_metadata_is_unprefixed_and_has_no_optional_warnings(self):
        for kind in ("zpkg", "zmdl", "zstr"):
            with self.subTest(kind=kind):
                document = parse(META, "entry." + kind)
                self.assertEqual((), document.diagnostics)
                self.assertEqual((), validate(document))

    def test_missing_metadata_warns_with_identity_and_source_span(self):
        for source in ("/repo/modules/a/tool.zmdl", "/repo/pkgs/a/tool.zpkg", "/repo/structure.zstr"):
            with self.subTest(source=source):
                document = parse("child = { };", source)
                warnings = [item for item in document.diagnostics if item.code == "ZEN226"]
                self.assertEqual(2, len(warnings))
                root = "zenos.a.tool" if source.endswith("zmdl") else "pkgs.a.tool" if source.endswith("zpkg") else "structure"
                self.assertTrue(warnings[0].message.startswith(root + ":"))
                self.assertTrue(warnings[1].message.startswith(root + ".child:"))
                for warning in warnings:
                    self.assertEqual("warning", warning.severity)
                    self.assertEqual(source, warning.span.source)
                    for name in ("_meta", "name", "summary", "description", "tags", "maintainers", "license"):
                        self.assertIn(name, warning.message)
                    self.assertNotIn("weight", warning.message)

    def test_each_missing_descriptive_field_warns_instead_of_failing(self):
        for field in ("name", "summary", "description", "tags", "maintainers", "license"):
            declarations = [line for line in DESCRIPTION.splitlines() if not line.startswith(field + " =")]
            source = "_meta = { " + "\n".join(declarations) + ' zenosVersion = "1.0.0"; };'
            with self.subTest(field=field):
                document = parse(source, "entry.zpkg")
                self.assertEqual(1, len(document.diagnostics))
                self.assertTrue(document.diagnostics[0].message.endswith("missing metadata: " + field))

    def test_only_declaration_nodes_warn_not_metadata_or_action_targets(self):
        source = META + '''
branch.child = { _meta.type = $type.bool; !! { target = { nested = true; }; }; };
users = { (freeform user) = { _meta.type = $type.bool; s! { target.($f.user) = true; }; }; };
'''
        document = parse(source, "entry.zmdl")
        paths = {item.message.split(": missing metadata:")[0] for item in document.diagnostics if item.code == "ZEN226"}
        self.assertEqual({"entry.branch", "entry.branch.child", "entry.users", "entry.users.{freeform:user}"}, paths)
        self.assertFalse(any("target" in item.message or "entry._meta" in item.message for item in document.diagnostics))
        document = parse(META + '_meta.dependencies = { general = []; build = []; runtime = []; };', "entry.zpkg")
        self.assertEqual((), document.diagnostics)

    def test_normal_children_are_not_renamed_or_treated_as_metadata(self):
        document = parse(META + 'name = true; summary = false; description = 42; _name = "child";', "entry.zmdl")
        self.assertEqual(["name", "summary", "description", "_name"], [statement.target[0].name for statement in document.statements[1:]])
        self.assertEqual(4, len(document.diagnostics))

    def test_zcfg_values_are_not_exposed_option_declarations(self):
        self.assertEqual((), parse('legacy.name = "host"; value = { child = true; };', "entry.zcfg").diagnostics)

    def test_dotted_metadata_and_inherited_versions_are_order_independent(self):
        source = 'branch.child._meta = { ' + DESCRIPTION + ' type = $type.int; };'
        source += 'branch._meta = { ' + DESCRIPTION + ' };' + META
        self.assertEqual((), parse(source, "entry.zmdl").diagnostics)
        document = parse('child = {};', "entry.zmdl")
        self.assertEqual(2, len([item for item in document.diagnostics if item.code == "ZEN228"]))

    def test_legacy_prefixed_metadata_is_rejected_without_renaming(self):
        for kind in ("zpkg", "zmdl", "zstr"):
            for source in ('_meta._name = "legacy";', '_meta = { _name = "legacy"; };'):
                with self.subTest(kind=kind, source=source):
                    self.assert_error(source, kind, "ZEN223")

    def test_unknown_metadata_warns_with_a_spelling_suggestion(self):
        document = parse(META + '_meta.summmary = "typo";', "entry.zpkg")
        self.assertEqual(1, len(document.diagnostics))
        diagnostic = document.diagnostics[0]
        self.assertEqual("ZEN227", diagnostic.code)
        self.assertEqual("warning", diagnostic.severity)
        self.assertIn("summary", diagnostic.notes[0])

    def test_malformed_blocks_and_supplied_types_are_errors(self):
        for source in (
            "_meta = false;", "_meta = [];", "_meta = { _let item: $type.int = 1; };",
            "_meta.name = 1;", "_meta.summary = [];", "_meta.tags = [ 1 ];",
            '_meta.maintainers = [ "doromiert" ];', "_meta.maintainers = $m.doromiert;",
            '_meta.license = "MIT";', "_meta.license = [ $l.mit ];", "_meta.weight = true;",
            "_meta.weight = 1.5;", "_meta.name.child = true;",
        ):
            with self.subTest(source=source):
                self.assert_error(source)
        self.assert_error("_meta.packageVersion = 42;", "zpkg")
        self.assertEqual((), parse(META + '_meta.packageVersion = "";', "entry.zpkg").diagnostics)
        parse(META + "_meta.weight = -10;", "entry.zmdl")

    def test_description_representation_and_empty_markdown(self):
        for kind in ("zpkg", "zmdl", "zstr"):
            self.assert_error('_meta.description = "quoted";', kind)
            document = parse(META + "_meta.description = '' \n '';", "entry." + kind)
            self.assertEqual(1, len(document.diagnostics))
            self.assertIn("empty metadata description", document.diagnostics[0].message)
        for path in ('"./description.md"', "./description.md"):
            value = parse("_meta.description = _import " + path + ";", "entry.zmdl").statements[0].value
            self.assertIsInstance(value, MarkdownImport)
        for path, code in (("/absolute.md", "ZEN302"), ("", "ZEN302"), ("./source.nix", "ZEN303")):
            self.assert_error('_meta.description = _import "' + path + '";', code=code)

    def test_grouping_does_not_change_supplied_metadata_types(self):
        document = parse(META + '_meta.name = ("Grouped"); _meta.zenosVersion = ("1.0.0"); _meta.description = (\'\'Markdown\'\'); _meta.weight = (-1);', "entry.zmdl")
        self.assertEqual((), document.diagnostics)

    def test_supplied_versions_remain_strict_and_overrides_are_checked(self):
        for version in ("1.2.3", '"1.2.3Al"', '"1.2.3b"'):
            parse("_meta.zenosVersion = " + version + ";", "entry.zmdl")
        for value in ('"wrong"', "true", "1"):
            self.assert_error(META + "child._meta.zenosVersion = " + value + ";", code="ZEN213")

    def test_type_annotations_are_validated_in_metadata(self):
        for annotation in ("$type.noSuchType", "$type.list", "$type.set [ ]", "$type.either [ $type.int ]", "42", '"bool"'):
            with self.subTest(annotation=annotation):
                self.assert_error("child._meta.type = " + annotation + ";", code="ZEN209")

    def test_defaults_are_checked_when_statically_known(self):
        for annotation, value in (
            ("$type.bool", "1"), ("$type.int", "true"), ("$type.string", "null"),
            ("$type.list [ $type.int ]", '[ 1 "bad" ]'),
            ("$type.set [ $type.bool ]", "{ a = 1; }"),
            ("$type.set [ $type.int ]", "{ a.b = 1; }"),
            ('$type.enum [ "dark" "light" ]', '"wrong"'),
            ("$type.either [ $type.int $type.string ]", "false"),
            ("$type.package", '"bat"'), ("$type.float", "false"),
            ("$type.functionTo [ $type.int ]", "42"),
            ("$type.functionTo [ $type.int ]", 'item: "wrong"'),
        ):
            with self.subTest(annotation=annotation, value=value):
                self.assert_error("child._meta = { type = " + annotation + "; default = " + value + "; };", code="ZEN229")
        self.assert_error('child = enableOption { _meta.default = "bad"; };', code="ZEN229")
        parse('child._meta = { type = $type.bool; default = $cfg.deferred; };', "entry.zmdl")
        parse('child._meta.type = $type.bool;', "entry.zmdl")
        parse('child._meta = { type = $type.set [ ($type.set [ $type.int ]) ]; default = { a.b = 1; }; };', "entry.zmdl")

    def test_bare_set_accepts_open_records_for_defaults_and_initializers(self):
        for value in (
            "{}",
            '{ count = 1; enabled = true; text = "value"; missing = null; nested.items = [ 1 "two" ]; }',
        ):
            for annotation in ("$type.set", "($type.set)"):
                with self.subTest(value=value, annotation=annotation):
                    parse("child._meta = { type = " + annotation + "; default = " + value + "; };", "entry.zmdl")
                    parse("_let record: " + annotation + " = " + value + ";", "entry.zmdl")
        parse('_let record: $type.set = {}; child._meta = { type = $type.set; default = $v.record; };', "entry.zmdl")
        parse('child._meta = { type = $type.set; default = $cfg.deferred; };', "entry.zmdl")

    def test_bare_set_rejects_statically_non_record_values(self):
        for value in ('"text"', "true", "1", "null", "[]", "item: item"):
            with self.subTest(value=value):
                self.assert_error("child._meta = { type = $type.set; default = " + value + "; };", code="ZEN229")
                self.assert_error("_let record: $type.set = " + value + ";", code="ZEN229")

    def test_parameterized_sets_keep_arity_and_value_checks(self):
        for annotation in ("$type.set []", "$type.set [ $type.int $type.bool ]", '$type.set [ "int" ]'):
            with self.subTest(annotation=annotation):
                self.assert_error("child._meta.type = " + annotation + ";", code="ZEN209")
        self.assert_error('child._meta = { type = $type.set [ $type.int ]; default = { bad = "text"; }; };', code="ZEN229")
        self.assert_error('_let record: $type.set [ $type.int ] = { bad = false; };', code="ZEN229")
        for annotation, value in (
            ("$type.set [ $type.int ]", "{ count = 1; }"),
            ("$type.set [ $type.set ]", '{ record = { count = 1; text = "value"; }; }'),
            ("$type.list [ $type.set ]", '[ { count = 1; } { text = "value"; } ]'),
            ("$type.either [ $type.set $type.string ]", "{ count = 1; }"),
        ):
            with self.subTest(annotation=annotation):
                parse("child._meta = { type = " + annotation + "; default = " + value + "; };", "entry.zmdl")

    def test_bare_and_parameterized_sets_compile_to_distinct_nix_types(self):
        for annotation, expected in (
            ("$type.set", "lib.types.attrs"),
            ("($type.set)", "lib.types.attrs"),
            ("$type.set [ $type.int ]", "(lib.types.attrsOf lib.types.int)"),
            ("$type.set [ $type.set ]", "(lib.types.attrsOf lib.types.attrs)"),
            ("$type.list [ $type.set ]", "(lib.types.listOf lib.types.attrs)"),
        ):
            with self.subTest(annotation=annotation), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                document = parse(META + "child._meta.type = " + annotation + ";", str(root / "modules" / "example.zmdl"))
                output = compile_zmdl(document, root=root)
                self.assertIn("type = " + expected + ";", output)

    def test_let_initializers_are_validated_in_nested_and_expression_scopes(self):
        for source in (
            '_let value: $type.int = "bad";',
            'child = { _let value: $type.list [ $type.int ] = [ true ]; };',
            'child = let _let value: $type.bool = 1; in $v.value;',
            '_let first: $type.int = 1; _let second: $type.bool = $v.first;',
            '_let first: $type.int = 1; child._meta = { type = $type.bool; default = $v.first; };',
            '_let value: $type.int = "a" + "b";',
        ):
            with self.subTest(source=source):
                self.assert_error(source, code="ZEN229")
        parse('_let value: $type.int = if true then 1 else 2;', "entry.zmdl")
        parse('_let value: $type.int = $lib.id 1;', "entry.zmdl")

    def test_dependencies_use_optional_general_build_runtime_package_lists(self):
        for declaration in (
            '_meta.dependencies = {};',
            '_meta.dependencies = { general = [ $pkgs.a.tool $pkgs.legacy.zlib ]; };',
            '_meta.dependencies.runtime = [ $pkgs.a.tool ];',
        ):
            self.assertEqual((), parse(META + declaration, "entry.zpkg").diagnostics)
        for declaration in (
            '_meta.dependencies = true;',
            '_meta.dependencies = { general = true; };',
            '_meta.dependencies = { global = []; };',
            '_meta.dependencies = { runtime = [ "zlib" ]; };',
            '_meta.dependencies = { build = [ { id = $pkgs.a.tool; } ]; };',
            '_meta.dependencies.runtime = [ $pkgs ];',
            '_meta.dependencies.runtime.bad = [];',
        ):
            with self.subTest(declaration=declaration):
                self.assert_error(declaration, "zpkg", "ZEN215")
        self.assert_error('_meta.dependencies = { runtime ++ []; };', "zpkg", "ZEN207")

    def test_zmdl_marker_is_structured_and_zstr_only(self):
        document = parse('system._meta.type = (zmdl system.services);', "structure.zstr")
        marker = document.statements[0].value
        self.assertIsInstance(marker, StructuralMarker)
        self.assertEqual("zmdl", marker.kind)
        self.assertEqual(["system", "services"], [segment.name for segment in marker.argument])
        self.assertEqual("structural-marker", semantic_descriptor(marker)["type"])
        for kind in ("zmdl", "zpkg"):
            self.assert_error('node._meta.type = (zmdl system);', kind, "ZEN204")
        for marker, code in (("(zmdl)", "ZEN204"), ("(alias)", "ZEN114"), ("(packages extra)", "ZEN114")):
            self.assert_error("node._meta.type = " + marker + ";", "zstr", code)


class MetadataImportAndCliTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)

    def write(self, name, text):
        path = self.root / name
        path.write_text(text, encoding="utf-8")
        return path

    def test_imported_missing_fields_report_once_with_child_source(self):
        child = self.write("child.zmdl", "option = false;")
        entry = self.write("entry.zmdl", META + '_import "child.zmdl";')
        document = parse_file(entry)
        self.assertEqual(1, len(document.diagnostics))
        diagnostic = document.diagnostics[0]
        self.assertIn("entry.option:", diagnostic.message)
        self.assertEqual(str(child), diagnostic.span.source)

    def test_merged_metadata_and_versions_do_not_leave_stale_missing_warnings(self):
        self.write("child.zmdl", '_meta = { ' + DESCRIPTION + ' }; option._meta = { ' + DESCRIPTION + ' type = $type.bool; };')
        entry = self.write("entry.zmdl", '_import "child.zmdl"; _meta.zenosVersion = "1.0.0";')
        self.assertEqual((), parse_file(entry).diagnostics)

    def test_bound_import_warnings_and_parser_warnings_survive_resolution(self):
        self.write("child.zmdl", "option = false;")
        entry = self.write("entry.zmdl", META + 'import ./child.zmdl; _import data = "child.zmdl";')
        document = parse_file(entry)
        self.assertIn("ZEN214", {diagnostic.code for diagnostic in document.diagnostics})
        self.assertTrue(any("child.option:" in item.message for item in document.diagnostics))

    def test_empty_imported_markdown_warns_without_becoming_dsl(self):
        self.write("description.md", " \n ")
        entry = self.write("entry.zpkg", META + '_meta.description = _import ./description.md; import $pkgs.legacy.bat;')
        document = parse_file(entry)
        self.assertEqual(1, len(document.diagnostics))
        self.assertIn("empty metadata description", document.diagnostics[0].message)

    def test_zpkg_import_fragments_merge_before_full_document_contract(self):
        self.write("metadata.zpkg", META)
        entry = self.write("entry.zpkg", '_import "metadata.zpkg"; import $pkgs.legacy.bat;')
        self.assertEqual((), parse_file(entry).diagnostics)

    def test_missing_descriptions_warn_in_human_and_json_cli(self):
        for kind, text in (("zpkg", "import $pkgs.legacy.bat;"), ("zmdl", "option = false;"), ("zstr", "system._meta.type = (zmdl system);")):
            entry = self.write("entry." + kind, text)
            with self.subTest(kind=kind):
                stdout, stderr = StringIO(), StringIO()
                self.assertEqual(0, main(["check", str(entry)], stdout, stderr))
                self.assertIn("warning[ZEN226]", stderr.getvalue())
                stdout, stderr = StringIO(), StringIO()
                self.assertEqual(0, main(["check", str(entry), "--diagnostic-format", "json"], stdout, stderr))
                self.assertTrue(json.loads(stdout.getvalue())["diagnostics"])
                self.assertEqual("", stderr.getvalue())

    def test_cli_keeps_full_package_contract_while_parse_accepts_fragments(self):
        parse(META, "fragment.zpkg")
        for source in (META, META + "value = true; import $pkgs.legacy.bat;", META + "import $pkgs.legacy.bat; import $pkgs.legacy.git;"):
            entry = self.write("entry.zpkg", source)
            with self.subTest(source=source):
                stderr = StringIO()
                self.assertEqual(1, main(["check", str(entry)], StringIO(), stderr))
                self.assertIn("ZEN222", stderr.getvalue())

    def test_successful_compilation_reports_metadata_warnings(self):
        entry = self.write("entry.zpkg", "import $pkgs.legacy.bat;")
        stdout, stderr = StringIO(), StringIO()
        self.assertEqual(0, main(["compile", str(entry)], stdout, stderr))
        self.assertIn("pkgs.zenos.legacy.bat", stdout.getvalue())
        self.assertIn("warning[ZEN226]", stderr.getvalue())

    def test_unprefixed_zpkg_markdown_is_resolved_in_block_and_dotted_forms(self):
        text = '# Markdown\n${builtins.abort "not evaluated"}\n'
        self.write("description.md", text)
        for source in (
            '_meta = { name = "Demo"; description = _import "./description.md"; };',
            '_meta.name = "Demo"; _meta.description = _import "./description.md";',
        ):
            entry = self.write("entry.zpkg", source + " import $pkgs.legacy.bat;")
            document = parse_file(entry)
            value = document.statements[0].value.statements[1].value if len(document.statements) == 2 else document.statements[1].value
            self.assertTrue(value.multiline)
            self.assertEqual(text, value.parts[0].value)


if __name__ == "__main__":
    unittest.main()
