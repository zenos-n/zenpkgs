from pathlib import Path
import tempfile
import unittest

from zcfg import Loader, ZcfgError, compile_nix, parse
from zcfg.engine import _resolve_assignments


class EngineTests(unittest.TestCase):
    def test_imports_deep_merge_in_order_then_apply_local_precedence(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "first.zcfg").write_text(
                """desktop = {
  enabled = false;
  packages = [ $pkgs.catalog.nano ];
  nested.left = 1;
};
""",
                encoding="utf-8",
            )
            (root / "second.zcfg").write_text(
                """desktop.packages = [ $pkgs.catalog.git ];
desktop.nested.right = 2;
""",
                encoding="utf-8",
            )
            entry = root / "system.zcfg"
            entry.write_text(
                """import ./first.zcfg;
import ./second.zcfg;
desktop.enabled = true;
desktop.nested.local = 3;
""",
                encoding="utf-8",
            )

            output = compile_nix(Loader().load(entry))

        self.assertEqual(
            """{ pkgs }:
{
  zenos = {
    desktop = {
      enabled = true;
      nested = {
        left = 1;
        local = 3;
        right = 2;
      };
      packages = [
        pkgs.zenos.catalog.git
      ];
    };
  };
}
""",
            output,
        )

    def test_compiler_sorts_attributes_and_escapes_nix_strings(self) -> None:
        document = parse(
            'z = "${unsafe}"; a.quote = "a\\\"b\\\\c\\n"; empty = [ ];'
        )

        output = compile_nix(_resolve_assignments(document.assignments))

        self.assertEqual(
            """{ pkgs }:
{
  zenos = {
    a = {
      quote = "a\\"b\\\\c\\n";
    };
    empty = [ ];
    z = "\\${unsafe}";
  };
}
""",
            output,
        )

    def test_legacy_compiles_to_the_nixos_root(self) -> None:
        document = parse(
            'legacy.disko.devices.disk.main.type = "disk"; '
            'legacy.zenfs.enable = true; system.release.stateVersion = "26.05";'
        )

        output = compile_nix(_resolve_assignments(document.assignments))

        self.assertIn("  disko = {", output)
        self.assertIn("  zenfs = {", output)
        self.assertIn("  zenos = {", output)
        self.assertNotIn("legacy = {", output)

    def test_rejects_conflicting_local_leaves(self) -> None:
        documents = (
            "a.b = 1; a.b = 2;",
            "a = 1; a.b = 2;",
            "a = { b = 1; }; a.b = 2;",
        )
        for source in documents:
            with self.subTest(source=source):
                document = parse(source, "conflict.zcfg")
                with self.assertRaises(ZcfgError) as raised:
                    _resolve_assignments(document.assignments)
                self.assertEqual("ZCFG201", raised.exception.diagnostic.code)

    def test_rejects_import_cycle_with_chain(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            first = root / "first.zcfg"
            first.write_text("import ./second.zcfg;", encoding="utf-8")
            (root / "second.zcfg").write_text(
                "import ./first.zcfg;", encoding="utf-8"
            )

            with self.assertRaises(ZcfgError) as raised:
                Loader().load(first)

        diagnostic = raised.exception.diagnostic
        self.assertEqual("ZCFG303", diagnostic.code)
        self.assertIn("first.zcfg", diagnostic.notes[0])
        self.assertIn("second.zcfg", diagnostic.notes[0])

    def test_rejects_non_zcfg_import_and_missing_import(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            wrong_extension = root / "wrong.zcfg"
            wrong_extension.write_text("import ./base.nix;", encoding="utf-8")
            with self.assertRaises(ZcfgError) as raised:
                Loader().load(wrong_extension)
            self.assertEqual("ZCFG302", raised.exception.diagnostic.code)

            missing = root / "missing.zcfg"
            missing.write_text("import ./base.zcfg;", encoding="utf-8")
            with self.assertRaises(ZcfgError) as raised:
                Loader().load(missing)
            self.assertEqual("ZCFG301", raised.exception.diagnostic.code)


if __name__ == "__main__":
    unittest.main()
