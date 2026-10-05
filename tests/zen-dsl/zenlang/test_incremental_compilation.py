"""Cache correctness and deterministic concurrent frontend compilation."""
from io import StringIO
import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from zenlang import CompilationError, ZenLangError, check_tree, compile_tree
from zenlang.api import parse_file
from zenlang.cli import main


class IncrementalCompilationTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.base = Path(self.temporary.name)
        self.root = self.base / "sources"
        self.root.mkdir()
        self.cache = self.base / "cache"
        self.write("base.zcfg", "system.base = true;")
        self.write("entry.zcfg", '_import "base.zcfg"; system.local = true;')
        self.write("other.zcfg", "system.other = true;")

    def write(self, name, text):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")
        return path

    def compile(self, **options):
        return compile_tree(self.root, cache_dir=self.cache, use_cache=True, **options)

    def test_warm_cache_skips_parser_and_emitter(self):
        first = self.compile()
        with patch("zenlang.compiler.parse_file", side_effect=AssertionError("unexpected parse")), \
             patch("zenlang.compiler.compile_document", side_effect=AssertionError("unexpected emission")):
            self.assertEqual(first, self.compile())

    def test_import_edit_invalidates_only_dependents_even_with_same_stat_times(self):
        first = self.compile()
        path = self.root / "base.zcfg"
        previous = path.stat()
        self.write("base.zcfg", "system.base = null;")
        os.utime(path, ns=(previous.st_atime_ns, previous.st_mtime_ns))
        with patch("zenlang.compiler.parse_file", wraps=parse_file) as parser:
            second = self.compile()
        self.assertEqual({"base.zcfg", "entry.zcfg"}, {Path(call.args[0]).name for call in parser.call_args_list})
        self.assertNotEqual(first, second)
        self.assertEqual(compile_tree(self.root), second)

    def test_markdown_edit_invalidates_importer(self):
        self.write("pkgs/demo.zpkg", 'import $pkgs.legacy.hello; _meta.description = _import "description.md";')
        self.write("pkgs/description.md", "first description")
        first = self.compile()
        self.write("pkgs/description.md", "other description")
        with patch("zenlang.compiler.parse_file", wraps=parse_file) as parser:
            second = self.compile()
        self.assertEqual(["demo.zpkg"], [Path(call.args[0]).name for call in parser.call_args_list])
        self.assertNotEqual(first, second)
        self.assertEqual(compile_tree(self.root), second)

    def test_serial_parallel_and_warm_bundles_are_identical(self):
        self.write("pkgs/demo.zpkg", "import $pkgs.legacy.hello;")
        self.write("modules/demo.zmdl", "enabled = true;")
        serial = compile_tree(self.root, mode="interface")
        parallel = self.compile(jobs=2, mode="interface")
        self.assertEqual(serial, parallel)
        self.assertEqual(serial, self.compile(jobs=2, mode="interface"))
        self.assertEqual(list(check_tree(self.root)), list(check_tree(self.root, jobs=2)))

    def test_parallel_errors_preserve_source_order_and_locations(self):
        self.write("base.zcfg", "system.base = ;")
        self.write("other.zcfg", "system.other = ;")
        errors = []
        for jobs in (1, 2):
            with self.assertRaises(ZenLangError) as raised:
                compile_tree(self.root, jobs=jobs)
            errors.append((raised.exception.diagnostic, raised.exception.sources))
        self.assertEqual(errors[0], errors[1])

    def test_deleted_import_does_not_reuse_cached_document(self):
        self.compile()
        (self.root / "base.zcfg").unlink()
        with self.assertRaises(ZenLangError) as raised:
            self.compile()
        self.assertEqual("ZEN304", raised.exception.diagnostic.code)

    def test_added_removed_and_moved_sources_are_rediscovered(self):
        self.compile()
        self.write("new.zcfg", "system.new = true;")
        self.assertIn("new.zcfg", [source["path"] for source in self.compile()["sources"]])
        (self.root / "other.zcfg").rename(self.root / "moved.zcfg")
        self.assertEqual(compile_tree(self.root), self.compile())

    def test_global_ownership_is_checked_on_cached_sources(self):
        self.write("structure.zstr", "system._meta.type = (zmdl system);")
        self.write("modules/system/demo.zmdl", "port._meta.type = $type.int;")
        self.compile()
        self.write("structure.zstr", "system._meta.type = (zmdl system); system.demo.port._meta.type = $type.int;")
        with self.assertRaisesRegex(CompilationError, "duplicate mounted option zenos.system.demo.port"):
            self.compile()

    def test_corrupt_cache_is_rebuilt(self):
        first = self.compile()
        for path in self.cache.rglob("*.json"):
            payload = json.loads(path.read_text())
            payload["payload"]["source"]["compiledNix"] = "corrupted"
            path.write_text(json.dumps(payload))
        with patch("zenlang.compiler.parse_file", wraps=parse_file) as parser:
            self.assertEqual(first, self.compile())
        self.assertEqual(3, parser.call_count)

    def test_unavailable_cache_and_cache_bypass_are_supported(self):
        cache_file = self.base / "cache-file"
        cache_file.write_text("not a directory")
        self.assertEqual(compile_tree(self.root), compile_tree(self.root, cache_dir=cache_file, use_cache=True))
        self.compile()
        with patch("zenlang.compiler.parse_file", wraps=parse_file) as parser:
            self.assertEqual(compile_tree(self.root), compile_tree(self.root, cache_dir=self.cache, use_cache=False))
        self.assertEqual(6, parser.call_count)

    def test_mode_root_and_compiler_changes_cannot_reuse_cache(self):
        self.write("pkgs/demo.zpkg", "import $pkgs.legacy.hello;")
        self.compile(mode="interface")
        with patch("zenlang.compiler.parse_file", wraps=parse_file) as parser:
            self.compile(mode="build")
        self.assertEqual(4, parser.call_count)
        with patch("zenlang.cache.compiler_fingerprint", return_value="changed implementation"), \
             patch("zenlang.compiler.parse_file", wraps=parse_file) as parser:
            self.compile(mode="interface")
        self.assertEqual(4, parser.call_count)
        alias = self.base / "alias"
        alias.symlink_to(self.root, target_is_directory=True)
        with patch("zenlang.compiler.parse_file", wraps=parse_file) as parser:
            compile_tree(alias, cache_dir=self.cache, use_cache=True, mode="interface")
        self.assertEqual(4, parser.call_count)

    def test_cache_cannot_be_created_inside_source_tree(self):
        with self.assertRaisesRegex(CompilationError, "outside the editable source root"):
            compile_tree(self.root, cache_dir=self.root / "cache", use_cache=True)

    def test_cyclic_cache_path_falls_back_to_compilation(self):
        loop = self.base / "loop"
        loop.symlink_to(loop)
        self.assertEqual(compile_tree(self.root), compile_tree(self.root, cache_dir=loop, use_cache=True))

    def test_invalid_workers_are_rejected_even_on_a_complete_cache_hit(self):
        from zenlang.compiler import compile_tree_output
        compile_tree_output(self.root, cache_dir=self.cache, use_cache=True)
        with self.assertRaisesRegex(CompilationError, "jobs must be"):
            compile_tree_output(self.root, jobs=-1, cache_dir=self.cache, use_cache=True)

    def test_symlink_retargeting_and_directory_replacement_are_rechecked(self):
        target = self.base / "external.zcfg"
        target.write_text("system.base = true;")
        (self.root / "base.zcfg").unlink()
        (self.root / "base.zcfg").symlink_to(target)
        self.compile()
        # Introduce a physical import cycle while keeping the cached entry's
        # own bytes unchanged. Inode identity must invalidate the old cache.
        (self.root / "base.zcfg").unlink()
        (self.root / "base.zcfg").symlink_to(self.root / "entry.zcfg")
        with self.assertRaises(ZenLangError) as raised:
            self.compile()
        self.assertEqual("ZEN305", raised.exception.diagnostic.code)

    def test_markdown_symlink_cannot_escape_root_after_cache_hit(self):
        self.write("pkgs/demo.zpkg", 'import $pkgs.legacy.hello; _meta.description = _import "description.md";')
        description = self.write("pkgs/description.md", "description")
        self.compile()
        external = self.base / "outside.md"
        external.write_text("description")
        description.unlink()
        description.symlink_to(external)
        with self.assertRaises(ZenLangError) as raised:
            self.compile()
        self.assertEqual("ZEN306", raised.exception.diagnostic.code)

    def test_cli_parses_once_and_preserves_output_after_validation_error(self):
        output = self.base / "bundle.json"
        arguments = ["compile-tree", "--root", str(self.root), "--output", str(output),
                     "--jobs", "1", "--cache-dir", str(self.cache)]
        with patch("zenlang.compiler.parse_file", wraps=parse_file) as parser:
            self.assertEqual(0, main(arguments, StringIO(), StringIO()))
        self.assertEqual(3, parser.call_count)
        first = output.read_bytes()
        with patch("zenlang.compiler.compile_tree", side_effect=AssertionError("unexpected tree compilation")):
            self.assertEqual(0, main(arguments, StringIO(), StringIO()))
        self.assertEqual(first, output.read_bytes())
        self.write("base.zcfg", "system.base = ;")
        self.assertEqual(1, main(arguments, StringIO(), StringIO()))
        self.assertEqual(first, output.read_bytes())

    def test_serialized_cache_rechecks_imports_inventory_and_diagnostics(self):
        output = self.base / "bundle.json"
        self.write("pkgs/demo.zpkg", "import $pkgs.legacy.hello;")
        arguments = ["compile-tree", "--root", str(self.root), "--output", str(output),
                     "--jobs", "1", "--cache-dir", str(self.cache), "--diagnostic-format", "json"]
        cold_stderr = StringIO()
        self.assertEqual(0, main(arguments, StringIO(), cold_stderr))
        warm_stderr = StringIO()
        with patch("zenlang.compiler.compile_tree", side_effect=AssertionError("unexpected compilation")):
            self.assertEqual(0, main(arguments, StringIO(), warm_stderr))
        self.assertEqual(cold_stderr.getvalue(), warm_stderr.getvalue())
        previous = output.read_bytes()
        self.write("base.zcfg", "system.base = false;")
        self.assertEqual(0, main(arguments, StringIO(), StringIO()))
        self.assertNotEqual(previous, output.read_bytes())
        self.write("added.zcfg", "system.added = true;")
        self.assertEqual(0, main(arguments, StringIO(), StringIO()))
        self.assertIn("added.zcfg", [source["path"] for source in json.loads(output.read_text())["sources"]])

    def test_serialized_cache_corruption_and_bypass_recompile(self):
        from zenlang.compiler import compile_tree_output
        first = compile_tree_output(self.root, cache_dir=self.cache, use_cache=True)
        cached_output = next(self.cache.rglob("bundle-output.json"))
        cached_output.write_text("corrupt output")
        with patch("zenlang.compiler.compile_tree", wraps=compile_tree) as compiler:
            self.assertEqual(first, compile_tree_output(self.root, cache_dir=self.cache, use_cache=True))
        self.assertEqual(1, compiler.call_count)
        with patch("zenlang.compiler.parse_file", wraps=parse_file) as parser:
            self.assertEqual(first, compile_tree_output(self.root, cache_dir=self.cache, use_cache=False))
        self.assertEqual(3, parser.call_count)

    def test_directory_symlinks_cannot_hide_cached_inputs(self):
        self.write("nested/entry.zcfg", "system.nested = true;")
        self.write("entry.zcfg", '_import "nested/entry.zcfg"; system.local = true;')
        self.compile()
        (self.root / "nested").rename(self.base / "outside")
        (self.root / "nested").symlink_to(self.base / "outside", target_is_directory=True)
        with self.assertRaises(ZenLangError) as raised:
            self.compile()
        self.assertEqual("ZEN304", raised.exception.diagnostic.code)

    def test_concurrent_cache_writers_do_not_leave_partial_entries(self):
        # Duplicate workers race on the same entry, as separate compiler runs do.
        from concurrent.futures import ProcessPoolExecutor
        with ProcessPoolExecutor(max_workers=2) as executor:
            futures = [executor.submit(compile_tree, self.root, cache_dir=self.cache, use_cache=True)
                       for _ in range(2)]
            bundles = [future.result() for future in futures]
        self.assertEqual(bundles[0], bundles[1])
        with patch("zenlang.compiler.parse_file", side_effect=AssertionError("unexpected parse")):
            self.assertEqual(bundles[0], self.compile())
        self.assertEqual([], list(self.cache.rglob(".entry-*")))


if __name__ == "__main__":
    unittest.main()
