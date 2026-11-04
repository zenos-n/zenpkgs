import importlib.util
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("cursor", os.environ.get("ZENOS_CURSOR_HELPER", Path(__file__).parent.parent / "lib/gnome-cursor.py"))
cursor = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cursor)


class CursorTests(unittest.TestCase):
    def test_export_dereferences_store_links_and_keeps_inherited_cursors(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            store = root / "store"
            store.mkdir()
            (store / "left_ptr").write_bytes(b"cursor")
            icons = root / "icons"
            for name, parent in [("Chosen", "Parent"), ("Parent", "Chosen")]:
                theme = icons / name
                (theme / "cursors").mkdir(parents=True)
                (theme / "index.theme").write_text(f"[Icon Theme]\nInherits={parent}\n")
                (theme / "cursors/left_ptr").symlink_to(store / "left_ptr")
                (theme / "cursors").chmod(0o555)
            export = root / "export"
            cursor.export_theme("Chosen", [icons], export)
            cursor.export_theme("Chosen", [icons], export)
            shutil_target = root / "sandbox-icons"
            export.rename(shutil_target)
            # No store directory exists in the sandbox; both themes still load.
            (store / "left_ptr").unlink()
            for name in ("Chosen", "Parent"):
                image = shutil_target / name / "cursors/left_ptr"
                self.assertFalse(image.is_symlink())
                self.assertEqual(image.read_bytes(), b"cursor")
            self.assertIn("Inherits=Chosen", (shutil_target / "default/index.theme").read_text())
            self.assertEqual((root / "default/cursors/left_ptr").read_bytes(), b"cursor")
            self.assertFalse((root / "default/cursors/left_ptr").is_symlink())

    def test_missing_theme_preserves_previous_export(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            root.joinpath("default").mkdir()
            old = root / "default/index.theme"
            old.write_text("previous")
            with self.assertRaises(FileNotFoundError):
                cursor.export_theme("Missing", [], root)
            self.assertEqual(old.read_text(), "previous")

    def test_theme_path_and_resource_injection_are_rejected(self):
        for name in ("../outside", "/absolute", "..", "bad\nXcursor.size: 2", "foo,bar"):
            with self.assertRaises(ValueError):
                cursor.theme_name(name)

    def test_unmanaged_default_is_not_overwritten(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "default").mkdir()
            old = root / "default/index.theme"
            old.write_text("personal override")
            with self.assertRaises(FileExistsError):
                cursor.export_theme("Chosen", [], root / "zenos-cursors")
            self.assertEqual(old.read_text(), "personal override")

    def test_private_path_precedes_existing_host_paths(self):
        with patch.dict(os.environ, {"XCURSOR_PATH": "/extra/icons:/extra/icons", "XDG_DATA_DIRS": "/system/share"}):
            env = cursor.environment("Chosen", 24, Path("/Users/test"), Path("/Users/test/.private/Packages"))
        paths = env["XCURSOR_PATH"].split(":")
        self.assertEqual(paths[0], "/Users/test/.private/Packages/icons/zenos-cursors")
        self.assertEqual(paths.count("/extra/icons"), 1)
        self.assertIn("/system/share/icons", paths)
        self.assertEqual(env["XCURSOR_SIZE"], "24")
        self.assertNotIn("/nix/store", cursor.SANDBOX_PATH)


if __name__ == "__main__":
    unittest.main()
