from pathlib import Path
import os
import tempfile
import unittest
from unittest.mock import patch

from zenlang import ZenLangError, parse, parse_file
from zenlang.compiler import compile_zmdl, compile_zpkg
from zenlang.emitter import NixEmissionError, emit_expression, quote_nix_string, semantic_descriptor
from zenlang.model import MarkdownImport, ResolvedImport, StringExpr, StringText


class MarkdownImportTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.parent = Path(self.temporary.name)
        self.root = self.parent / "repo"
        self.root.mkdir()
        self.entry = self.root / "entry.zmdl"

    def write(self, path, text):
        path.write_text(text, encoding="utf-8")
        return path

    def load(self, source='_meta.description = _import "./description.md";'):
        self.write(self.entry, source)
        return parse_file(self.entry, import_root=self.root)

    def assert_failure(self, code, source='_meta.description = _import "./description.md";'):
        with self.assertRaises(ZenLangError) as raised:
            self.load(source)
        error = raised.exception
        self.assertEqual(code, error.diagnostic.code)
        self.assertEqual(str(self.entry), error.diagnostic.span.source)
        self.assertEqual(1, error.diagnostic.span.start.line)
        self.assertIn(str(self.entry), error.sources)
        return error

    def test_relative_nested_and_dotted_metadata_preserve_raw_markdown(self):
        text = '# Caf\u00e9 \u65e5\u672c\u8a9e\r\n${builtins.abort "never"} ${$cfg.nope}\n_import "not-dsl"; \'\' \\ "\n'
        docs = self.root / "docs"
        docs.mkdir()
        (docs / "description.md").write_bytes(text.encode("utf-8"))
        for source in (
            '_meta.description = _import "./docs/description.md";',
            '_meta = { description = _import "./docs/description.md"; };',
            'option._meta.description = _import "./docs/description.md"; option._meta.type = $type.string;',
            'option = { _meta = { description = _import "./docs/description.md"; type = $type.string; }; };',
        ):
            with self.subTest(source=source):
                document = self.load(source)
                value = document.statements[0].value
                while not isinstance(value, StringExpr):
                    value = value.statements[0].value
                self.assertTrue(value.multiline)
                self.assertEqual(1, len(value.parts))
                self.assertIsInstance(value.parts[0], StringText)
                self.assertEqual(text, value.parts[0].value)
                self.assertEqual(quote_nix_string(text), emit_expression(value))
                self.assertIn(r'\${builtins.abort', emit_expression(value))

    def test_zpkg_block_and_dotted_description_compile(self):
        text = 'Markdown ${builtins.abort "never"}\n'
        self.write(self.root / "description.md", text)
        self.entry = self.root / "entry.zpkg"
        fields = ('name = "demo"; summary = "demo"; zenosVersion = "1.0.0"; '
                  'tags = []; maintainers = []; license = $l.mit; '
                  'dependencies = { general = []; build = []; runtime = []; };')
        for source in (
            '_meta = { ' + fields + ' description = _import "./description.md"; };',
            '_meta = { ' + fields + ' }; _meta.description = _import "./description.md";',
        ):
            with self.subTest(source=source):
                document = self.load(source + ' import $pkgs.legacy.demo;')
                self.assertEqual((), document.diagnostics)
                self.assertIn(quote_nix_string(text), compile_zpkg(document, mode="interface"))
                build = compile_zpkg(document, mode="build")
                self.assertIn('description = ' + quote_nix_string(text) + ';', build)
                self.assertIn("package = pkgs.zenos.legacy.demo;", build)
                self.assertIn("(package.meta or { }) // suppliedMetadata", build)

    def test_unresolved_expression_is_explicit_and_not_emitted(self):
        value = parse('_meta.description = _import "./description.md";', "entry.zmdl").statements[0].value
        self.assertIsInstance(value, MarkdownImport)
        with self.assertRaisesRegex(NixEmissionError, "unresolved Markdown import"):
            emit_expression(value)
        with self.assertRaisesRegex(NixEmissionError, "unresolved Markdown import"):
            semantic_descriptor(value)

    def test_zmdl_option_description_compiles_as_literal_text(self):
        modules = self.root / "modules"
        modules.mkdir()
        self.entry = modules / "demo.zmdl"
        text = 'Option **Markdown** ${builtins.abort "never"}\n'
        self.write(modules / "description.md", text)
        document = self.load('enable = { _meta.type = $type.bool; _meta.description = _import "./description.md"; };')
        output = compile_zmdl(document, root=self.root)
        self.assertIn('description = ' + quote_nix_string(text) + ';', output)

    def test_rejects_other_contexts_even_without_semantic_validation(self):
        sources = (
            'description = _import "./description.md";',
            '_meta._description = _import "./description.md";',
            '_meta.summary = _import "./description.md";',
            '_meta.dependencies.description = _import "./description.md";',
            '_meta.foo._meta.description = _import "./description.md";',
            'option._meta = { extra.($name) = { description = _import "./description.md"; }; };',
            '_meta.description = [ (_import "./description.md") ];',
            '_meta.description = "x" + (_import "./description.md");',
            'value = let _meta.description = _import "./description.md"; in true;',
            'value = [ { _meta.description = _import "./description.md"; } ];',
            'option = { !! { _meta.description = _import "./description.md"; }; };',
        )
        for source in sources:
            for semantics in (True, False):
                with self.subTest(source=source, semantics=semantics):
                    with self.assertRaises(ZenLangError) as raised:
                        parse(source, "entry.zmdl", validate_semantics=semantics)
                    self.assertEqual("ZEN224", raised.exception.diagnostic.code)
        for kind in ("zcfg", "zstr"):
            with self.subTest(kind=kind), self.assertRaises(ZenLangError) as raised:
                parse('_meta.description = _import "./description.md";', "entry." + kind)
            self.assertEqual("ZEN224", raised.exception.diagnostic.code)

    def test_path_diagnostics(self):
        self.write(self.parent / "outside.md", "outside")
        for relative, code in (
            ("../outside.md", "ZEN306"),
            (str(self.parent / "outside.md"), "ZEN302"),
            ("https://example.org/description.md", "ZEN302"),
            ("", "ZEN302"),
            ("./missing.md", "ZEN304"),
            ("./description.zmdl", "ZEN303"),
            ("./description.MD", "ZEN303"),
            ("./${$name}.md", "ZEN302"),
        ):
            with self.subTest(relative=relative):
                self.assert_failure(code, f'_meta.description = _import "{relative}";')

    def test_nonregular_and_invalid_utf8(self):
        markdown = self.root / "description.md"
        markdown.mkdir()
        self.assert_failure("ZEN304")
        markdown.rmdir()
        os.mkfifo(markdown)
        self.assert_failure("ZEN304")
        markdown.unlink()
        markdown.write_bytes(b"\xff")
        self.assert_failure("ZEN304")

    def test_file_and_aggregate_budgets_include_markdown(self):
        self.write(self.root / "description.md", "x" * 129)
        with patch("zenlang.api._MAX_SOURCE_BYTES", 128):
            self.assert_failure("ZEN308")
        source = '_meta.description = _import "./description.md";'
        with patch("zenlang.api._MAX_TOTAL_SOURCE_BYTES", len(source) + 128):
            self.assert_failure("ZEN310", source)
        repeated = ('one._meta.description = _import "./description.md"; '
                    'two._meta.description = _import "./description.md";')
        with patch("zenlang.api._MAX_TOTAL_SOURCE_BYTES", len(repeated) + 129):
            self.assert_failure("ZEN310", repeated)

    def test_cached_dsl_expansion_counts_markdown_bytes(self):
        child = '_meta.description = _import "./description.md";'
        source = '_import "./child.zmdl"; _import "./child.zmdl";'
        self.write(self.root / "child.zmdl", child)
        self.write(self.root / "description.md", "x" * 100)
        with patch("zenlang.api._MAX_TOTAL_SOURCE_BYTES", len(source) + len(child) + 100):
            self.assert_failure("ZEN310", source)

    def test_physical_escape_and_internal_final_symlinks(self):
        outside = self.write(self.parent / "outside.md", "outside")
        markdown = self.root / "description.md"
        for target in (outside, Path("../outside.md")):
            with self.subTest(target=target):
                markdown.symlink_to(target)
                self.assert_failure("ZEN306")
                markdown.unlink()
        inside = self.write(self.root / "inside.md", "inside")
        markdown.symlink_to(inside)
        self.assertEqual("inside", self.load().statements[0].value.parts[0].value)

    def test_directory_symlink_escape(self):
        (self.root / "linked").symlink_to(self.parent, target_is_directory=True)
        self.write(self.parent / "outside.md", "outside")
        self.assert_failure("ZEN304", '_meta.description = _import "./linked/outside.md";')
        (self.root / "description.md").symlink_to("linked/outside.md")
        self.assert_failure("ZEN306")

    def test_relative_to_imported_document_and_explicit_root(self):
        nested = self.root / "nested"
        nested.mkdir()
        self.write(nested / "child.zmdl", '_meta.description = _import "../description.md";')
        self.write(self.root / "description.md", "parent Markdown")
        document = self.load('_import "./nested/child.zmdl";')
        self.assertIsInstance(document.statements[0], ResolvedImport)
        value = document.statements[0].document.statements[0].value
        self.assertEqual("parent Markdown", value.parts[0].value)
        self.assertEqual(str(nested / "child.zmdl"), value.span.source)
        with self.assertRaises(ZenLangError) as raised:
            parse_file(nested / "child.zmdl")
        self.assertEqual("ZEN306", raised.exception.diagnostic.code)
        (self.root / "description.md").unlink()
        with self.assertRaises(ZenLangError) as raised:
            parse_file(self.entry, import_root=self.root)
        self.assertEqual(str(nested / "child.zmdl"), raised.exception.diagnostic.span.source)
        self.assertIn(str(nested / "child.zmdl"), raised.exception.sources)

    def test_dsl_symlink_uses_logical_parent_without_changing_existing_rules(self):
        outside = self.write(self.parent / "source.zmdl", '_meta.description = _import "./description.md";')
        self.entry.symlink_to(outside)
        self.write(self.root / "description.md", "logical Markdown")
        self.write(self.parent / "description.md", "physical Markdown")
        value = parse_file(self.entry, import_root=self.root).statements[0].value
        self.assertEqual("logical Markdown", value.parts[0].value)
        alias = self.parent / "alias"
        alias.symlink_to(self.root, target_is_directory=True)
        value = parse_file(alias / self.entry.name, import_root=alias).statements[0].value
        self.assertEqual("logical Markdown", value.parts[0].value)


if __name__ == "__main__":
    unittest.main()
