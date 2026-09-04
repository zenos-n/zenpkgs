from io import StringIO
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from zcfg.cli import main


class CliTests(unittest.TestCase):
    def test_check_compile_and_ast_commands(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "system.zcfg"
            source.write_text("system.enabled = true;", encoding="utf-8")

            stdout = StringIO()
            stderr = StringIO()
            self.assertEqual(
                0,
                main(
                    ["check", str(source), "--diagnostic-format", "json"],
                    stdout,
                    stderr,
                ),
            )
            self.assertEqual({"diagnostics": []}, json.loads(stdout.getvalue()))
            self.assertEqual("", stderr.getvalue())

            stdout = StringIO()
            self.assertEqual(
                0, main(["compile", str(source)], stdout, StringIO())
            )
            self.assertIn("zenos = {", stdout.getvalue())
            self.assertIn("system = {", stdout.getvalue())

            stdout = StringIO()
            self.assertEqual(0, main(["ast", str(source)], stdout, StringIO()))
            ast = json.loads(stdout.getvalue())
            self.assertEqual("document", ast["type"])
            self.assertEqual(["system", "enabled"], ast["assignments"][0]["path"])

    def test_compile_writes_output_file(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "system.zcfg"
            output = Path(directory) / "system.nix"
            source.write_text("enabled = true;", encoding="utf-8")

            status = main(
                ["compile", str(source), "--output", str(output)],
                StringIO(),
                StringIO(),
            )

            self.assertEqual(0, status)
            compiled = output.read_text(encoding="utf-8")
            self.assertTrue(compiled.startswith("{ pkgs }:\n"))
            self.assertIn("zenos = {", compiled)

    def test_compile_output_replacement_is_atomic(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "system.zcfg"
            output = root / "system.nix"
            source.write_text("enabled = true;", encoding="utf-8")
            output.write_text("previous\n", encoding="utf-8")

            with patch("zcfg.cli.os.replace", side_effect=OSError("replace failed")):
                status = main(
                    ["compile", str(source), "--output", str(output)],
                    StringIO(),
                    StringIO(),
                )

            self.assertEqual(1, status)
            self.assertEqual("previous\n", output.read_text(encoding="utf-8"))
            self.assertEqual([], list(root.glob(".system.nix.*")))

    def test_human_and_json_diagnostics(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "bad.zcfg"
            source.write_text("enabled = nope;", encoding="utf-8")

            stderr = StringIO()
            self.assertEqual(1, main(["check", str(source)], StringIO(), stderr))
            human = stderr.getvalue()
            self.assertIn("error[ZCFG101]", human)
            self.assertIn("enabled = nope;", human)
            self.assertIn("^", human)

            stderr = StringIO()
            self.assertEqual(
                1,
                main(
                    ["check", str(source), "--diagnostic-format", "json"],
                    StringIO(),
                    stderr,
                ),
            )
            diagnostic = json.loads(stderr.getvalue())["diagnostics"][0]
            self.assertEqual("ZCFG101", diagnostic["code"])
            self.assertEqual(1, diagnostic["span"]["start"]["line"])

    def test_human_diagnostic_caret_accounts_for_tabs(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "bad.zcfg"
            source.write_text("value =\tnope;", encoding="utf-8")
            stderr = StringIO()

            self.assertEqual(1, main(["check", str(source)], StringIO(), stderr))

        caret_line = stderr.getvalue().splitlines()[2]
        self.assertEqual(17, caret_line.index("^"))


if __name__ == "__main__":
    unittest.main()
