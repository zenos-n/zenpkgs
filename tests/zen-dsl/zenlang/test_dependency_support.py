from io import StringIO
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

from zenlang import parse, parse_file
from zenlang.cli import main
from zenlang.compiler import CompilationError, compile_zpkg


SCOPES = ("general", "build", "runtime")
SOURCE = "/repo/pkgs/apps/tools/example.zpkg"
META = '''_meta = {
  name = "Example"; summary = "Example package"; description = ''Example'';
  zenosVersion = "1.0.0"; tags = []; maintainers = []; license = $l.mit;
};
'''
IMPORT = "\nimport $pkgs.legacy.hello;"


class DependencySupportTests(unittest.TestCase):
    def test_nonempty_scopes_reject_build_with_path_and_span(self):
        for scope in SCOPES:
            for declaration in (
                f"_meta = {{ dependencies = {{ {scope} = [ $pkgs.legacy.hello ]; }}; }};",
                f"_meta.dependencies.{scope} = [ $pkgs.apps.tools.hello ];",
                f'_meta."dependencies"."{scope}" = [ $pkgs.legacy."hello" ];',
                f"_meta = ({{ dependencies.{scope} = [ $pkgs.legacy.hello ]; }});",
                f"_meta.dependencies.{scope} = ([ $pkgs.legacy.hello ]);",
            ):
                with self.subTest(scope=scope, declaration=declaration):
                    text = declaration + IMPORT
                    document = parse(text, SOURCE)
                    with self.assertRaises(CompilationError) as raised:
                        compile_zpkg(document)
                    error = raised.exception
                    self.assertIn(SOURCE, str(error))
                    self.assertIn(f"_meta.dependencies.{scope}", str(error))
                    self.assertIn("unsupported", str(error))
                    self.assertIn("D14", str(error))
                    self.assertEqual(SOURCE, error.span.source)
                    self.assertEqual(text.index("[") + 1, error.span.start.column)
                    self.assertEqual(1, error.span.start.line)

    @unittest.skipUnless(shutil.which("nix-instantiate"), "Nix evaluation requires the VM")
    def test_data_only_interface_retains_structured_dependency_references(self):
        for scope in SCOPES:
            with self.subTest(scope=scope):
                document = parse(
                    META + f'_meta.dependencies.{scope} = [ $pkgs.legacy."hello" ];' + IMPORT,
                    SOURCE,
                )
                self.assertEqual((), document.diagnostics)
                interface = compile_zpkg(document, mode="interface")
                result = subprocess.run(
                    ["nix-instantiate", "--store", "dummy://", "--eval", "--strict", "--json", "--expr",
                     f"({interface}) {{ }}"],
                    capture_output=True, text=True,
                )
                self.assertEqual(0, result.returncode, result.stderr)
                dependencies = json.loads(result.stdout)["metadata"]["dependencies"]
                assignment = dependencies["statements"][0]
                self.assertEqual(scope, assignment["target"][0]["value"])
                reference = assignment["value"]["items"][0]
                self.assertEqual("variable", reference["type"])
                self.assertEqual("pkgs", reference["name"])
                self.assertEqual(["legacy", "hello"], [part["value"] for part in reference["path"]])

    @unittest.skipUnless(shutil.which("nix-instantiate"), "Nix evaluation requires the VM")
    def test_empty_and_omitted_scopes_preserve_imported_identity(self):
        for declaration in (
            "", "_meta.dependencies = {};",
            *(f"_meta.dependencies.{scope} = [];" for scope in SCOPES),
            "_meta.dependencies = { general = []; build = []; runtime = []; };",
        ):
            with self.subTest(declaration=declaration):
                document = parse(META + declaration + IMPORT, SOURCE)
                self.assertEqual((), document.diagnostics)
                compiled = compile_zpkg(document)
                result = subprocess.run(
                    ["nix-instantiate", "--store", "dummy://", "--eval", "--strict", "--json", "--expr",
                     'let upstream = { type = "derivation"; drvPath = "/test.drv"; outPath = "/test"; }; '
                     f'package = ({compiled}) {{ pkgs.zenos.legacy.hello = upstream; '
                     'licenses.mit = "MIT"; }; in '
                     'package.drvPath == upstream.drvPath && package.outPath == upstream.outPath'],
                    capture_output=True, text=True,
                )
                self.assertEqual(0, result.returncode, result.stderr)
                self.assertTrue(json.loads(result.stdout))

    def test_coalesced_assignments_use_effective_scope_values(self):
        for scope in SCOPES:
            for first, last in (("[]", "[ $pkgs.legacy.hello ]"), ("[ $pkgs.legacy.hello ]", "[]")):
                with self.subTest(scope=scope, last=last):
                    document = parse(
                        f"_meta = {{ dependencies = {{ {scope} = {first}; }}; }};\n"
                        f"_meta.dependencies.{scope} = {last};" + IMPORT,
                        SOURCE,
                    )
                    if last == "[]":
                        compile_zpkg(document)
                    else:
                        with self.assertRaises(CompilationError) as raised:
                            compile_zpkg(document)
                        self.assertEqual(2, raised.exception.span.start.line)

    def test_bare_imports_preserve_dependency_source_span(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            imported = root / "dependencies.zpkg"
            entry = root / "example.zpkg"
            for scope in SCOPES:
                with self.subTest(scope=scope):
                    imported.write_text(f"_meta.dependencies.{scope} = [ $pkgs.legacy.hello ];\n")
                    entry.write_text('_import "./dependencies.zpkg";' + IMPORT)
                    document = parse_file(entry, import_root=root)
                    with self.assertRaises(CompilationError) as raised:
                        compile_zpkg(document)
                    self.assertEqual(str(imported), raised.exception.span.source)
                    self.assertEqual(1, raised.exception.span.start.line)
                    entry.write_text(
                        '_import "./dependencies.zpkg";\n'
                        f"_meta.dependencies.{scope} = [];" + IMPORT
                    )
                    compile_zpkg(parse_file(entry, import_root=root))

    def test_cli_build_reports_unsupported_scope_without_writing_output(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            entry = root / "example.zpkg"
            output = root / "example.nix"
            for scope in SCOPES:
                with self.subTest(scope=scope):
                    entry.write_text(META + f"_meta.dependencies.{scope} = [ $pkgs.legacy.hello ];" + IMPORT)
                    stdout, stderr = StringIO(), StringIO()
                    result = main(
                        ["compile", str(entry), "-o", str(output), "--diagnostic-format", "json"],
                        stdout=stdout, stderr=stderr,
                    )
                    self.assertNotEqual(0, result)
                    self.assertIn(f"_meta.dependencies.{scope}", stderr.getvalue())
                    self.assertIn("unsupported", stderr.getvalue())
                    self.assertFalse(output.exists())


if __name__ == "__main__":
    unittest.main()
