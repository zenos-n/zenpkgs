import unittest

from zcfg import ZcfgError, document_to_dict, parse
from zcfg.model import AttrSet, ListExpr, PkgsRef


class ParserTests(unittest.TestCase):
    def test_parses_supported_document_with_source_spans(self) -> None:
        source = """# base settings
import ./base.zcfg;
system = {
  enabled = true;
  count = -2;
  packages = [ $pkgs.catalog.git "literal" null ];
};
"""

        document = parse(source, "system.zcfg")

        self.assertEqual("./base.zcfg", document.imports[0].path)
        self.assertEqual(2, document.imports[0].span.start.line)
        self.assertEqual(("system",), document.assignments[0].path)
        self.assertEqual(3, document.assignments[0].path_span.start.line)
        attr_set = document.assignments[0].value
        self.assertIsInstance(attr_set, AttrSet)
        packages = attr_set.assignments[2].value
        self.assertIsInstance(packages, ListExpr)
        self.assertIsInstance(packages.items[0], PkgsRef)
        self.assertEqual(("catalog", "git"), packages.items[0].path)
        self.assertEqual(len(source), document.span.end.offset)

        ast = document_to_dict(document)
        self.assertEqual("document", ast["type"])
        package_ast = ast["assignments"][0]["value"]["assignments"][2]["value"]
        self.assertEqual("pkgs_ref", package_ast["items"][0]["type"])

    def test_supports_dotted_and_hyphenated_attributes(self) -> None:
        document = parse("services.gnome-shell.enable = false;")

        self.assertEqual(
            ("services", "gnome-shell", "enable"),
            document.assignments[0].path,
        )

    def test_rejects_import_after_assignment(self) -> None:
        with self.assertRaises(ZcfgError) as raised:
            parse("a = 1; import ./base.zcfg;", "bad.zcfg")

        self.assertEqual("ZCFG102", raised.exception.diagnostic.code)
        self.assertEqual(1, raised.exception.diagnostic.span.start.line)
        self.assertEqual(8, raised.exception.diagnostic.span.start.column)

    def test_rejects_quoted_import(self) -> None:
        with self.assertRaises(ZcfgError) as raised:
            parse('import "./base.zcfg";')

        self.assertEqual("ZCFG101", raised.exception.diagnostic.code)
        self.assertIn("bare relative path", raised.exception.diagnostic.message)

    def test_rejects_arbitrary_references_and_calls(self) -> None:
        unsupported = (
            "value = pkgs.git;",
            "value = $config.foo;",
            "value = [ 1, 2 ];",
            "value = f(1);",
            "value = 1.5;",
        )
        for source in unsupported:
            with self.subTest(source=source), self.assertRaises(ZcfgError):
                parse(source)

    def test_rejects_pkgs_root_and_out_of_range_integer(self) -> None:
        with self.assertRaises(ZcfgError) as missing_path:
            parse("value = $pkgs;")
        self.assertEqual("ZCFG101", missing_path.exception.diagnostic.code)

        with self.assertRaises(ZcfgError) as out_of_range:
            parse(f"value = {2**63};")
        self.assertEqual("ZCFG103", out_of_range.exception.diagnostic.code)

        with self.assertRaises(ZcfgError) as enormous:
            parse("value = " + "9" * 5000 + ";")
        self.assertEqual("ZCFG103", enormous.exception.diagnostic.code)

    def test_string_escapes_are_literal_values(self) -> None:
        document = parse(r'value = "line\nquote: \" and \u263a";')

        self.assertEqual(
            'line\nquote: " and ' + chr(0x263A),
            document.assignments[0].value.value,
        )

        with self.assertRaises(ZcfgError) as control:
            parse(r'value = "\u0000";')
        self.assertEqual("ZCFG003", control.exception.diagnostic.code)


if __name__ == "__main__":
    unittest.main()
