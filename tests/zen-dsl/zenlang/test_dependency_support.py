from io import StringIO
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

from zenlang import parse, parse_file
from zenlang.cli import main
from zenlang.compiler import compile_zpkg


SCOPES = ("general", "build", "runtime")
SOURCE = "/repo/pkgs/apps/tools/example.zpkg"
META = '''_meta = {
  name = "Example"; summary = "Example package"; description = ''Example'';
  zenosVersion = "1.0.0"; tags = []; maintainers = []; license = $l.mit;
};
'''
IMPORT = "\nimport $pkgs.legacy.hello;"


class DependencySupportTests(unittest.TestCase):
    def test_all_scopes_compile_to_shared_backend(self):
        for scope in SCOPES:
            for declaration in (
                f"_meta = {{ dependencies = {{ {scope} = [ $pkgs.legacy.hello ]; }}; }};",
                f"_meta.dependencies.{scope} = [ $pkgs.apps.tools.hello ];",
                f'_meta."dependencies"."{scope}" = [ $pkgs.legacy."hello" ];',
                f"_meta = ({{ dependencies.{scope} = [ $pkgs.legacy.hello ]; }});",
                f"_meta.dependencies.{scope} = ([ $pkgs.legacy.hello ]);",
            ):
                with self.subTest(scope=scope, declaration=declaration):
                    compiled = compile_zpkg(parse(declaration + IMPORT, SOURCE))
                    self.assertIn("dependenciesDeclared = true;", compiled)
                    self.assertIn("zpkgRuntime { provider = package;", compiled)
                    self.assertIn(SOURCE, compiled)

    @unittest.skipUnless(shutil.which("nix-instantiate"), "Nix evaluation requires the VM")
    def test_data_only_interface_retains_structured_dependency_references(self):
        for scope in SCOPES:
            document = parse(META + f'_meta.dependencies.{scope} = [ $pkgs.legacy."hello.world" ];' + IMPORT, SOURCE)
            self.assertEqual((), document.diagnostics)
            interface = compile_zpkg(document, mode="interface")
            result = subprocess.run(
                ["nix-instantiate", "--store", "dummy://", "--eval", "--strict", "--json", "--expr", f"({interface}) {{ }}"],
                capture_output=True, text=True,
            )
            self.assertEqual(0, result.returncode, result.stderr)
            descriptor = json.loads(result.stdout)
            self.assertTrue(descriptor["dependenciesDeclared"])
            reference = descriptor["metadata"]["dependencies"]["statements"][0]["value"]["items"][0]
            self.assertEqual(["legacy", "hello.world"], [part["value"] for part in reference["path"]])

    @unittest.skipUnless(shutil.which("nix-instantiate"), "Nix evaluation requires the VM")
    def test_omitted_scopes_preserve_imported_identity(self):
        compiled = compile_zpkg(parse(META + IMPORT, SOURCE))
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

    def test_explicit_empty_scopes_are_replacement_not_inheritance(self):
        for declaration in ("_meta.dependencies = {};", *(f"_meta.dependencies.{scope} = [];" for scope in SCOPES)):
            compiled = compile_zpkg(parse(declaration + IMPORT, SOURCE))
            self.assertIn("dependenciesDeclared = true;", compiled)
        self.assertIn("dependenciesDeclared = false;", compile_zpkg(parse(IMPORT, SOURCE)))

    def test_coalesced_assignments_use_effective_scope_values(self):
        for scope in SCOPES:
            for first, last in (("[]", "[ $pkgs.legacy.hello ]"), ("[ $pkgs.legacy.hello ]", "[]")):
                document = parse(
                    f"_meta = {{ dependencies = {{ {scope} = {first}; }}; }};\n"
                    f"_meta.dependencies.{scope} = {last};" + IMPORT, SOURCE,
                )
                compiled = compile_zpkg(document)
                self.assertIn("dependenciesDeclared = true;", compiled)
                supplied = " ".join(compiled.split("suppliedMetadata = ", 1)[1].split())
                self.assertIn(f"{scope} = " + ("[ ]" if last == "[]" else "[ pkgs.zenos.legacy.hello ]"), supplied)

    def test_bare_imports_preserve_dependency_source_location(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            imported = root / "dependencies.zpkg"
            entry = root / "example.zpkg"
            imported.write_text("_meta.dependencies.build = [ $pkgs.legacy.hello ];\n")
            entry.write_text('_import "./dependencies.zpkg";' + IMPORT)
            compiled = compile_zpkg(parse_file(entry, import_root=root))
            self.assertIn(str(imported) + ":1:", compiled)

    def test_cli_writes_executable_artifact_for_nonempty_scopes(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            entry, output = root / "example.zpkg", root / "example.nix"
            entry.write_text(META + "_meta.dependencies.build = [ $pkgs.legacy.hello ];" + IMPORT)
            stdout, stderr = StringIO(), StringIO()
            result = main(["compile", str(entry), "-o", str(output)], stdout=stdout, stderr=stderr)
            self.assertEqual(0, result, stderr.getvalue())
            self.assertIn("zpkgRuntime", output.read_text())


if __name__ == "__main__":
    unittest.main()
