from pathlib import Path
import tempfile
import re
import unittest
from unittest.mock import patch

from zenlang.compiler import _discover_tree

from zenlang import check_tree, compile_tree, parse, parse_file, ZenLangError
from zenlang.compiler import CompilationError, compile_zcfg, compile_zpkg


class PackageIdentityTests(unittest.TestCase):
    def test_required_in_complete_files_and_both_compiler_modes(self):
        source = 'import $pkgs.legacy.hello;'
        document = parse(source, 'tool.zpkg')  # Parsing still permits fragments.
        for mode in ('interface', 'build'):
            with self.subTest(mode=mode), self.assertRaisesRegex(ZenLangError, '_meta.id'):
                compile_zpkg(document, mode=mode)
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'tool.zpkg'
            path.write_text(source)
            with self.assertRaisesRegex(ZenLangError, '_meta.id'):
                parse_file(path)

    def test_literal_reverse_dns_grammar(self):
        for identity in ('org.gnome.Nautilus', 'io.example', 'org.example.my_tool-v2'):
            source = f'_meta.id = "{identity}"; import $pkgs.legacy.hello;'
            interface = compile_zpkg(parse(source, 'tool.zpkg'), mode='interface')
            self.assertIn(f'id = "pkgs.{identity}";', interface)
        for value in ('""', '"single"', '"org..Tool"', '"org.example."',
                      '"org.2Tool"', '"org.-Tool"', '"org.example/tool"',
                      '"legacy.example"', '"byCategories.example"',
                      '42', '[ "org.example.Tool" ]', '$name', '"org.${$name}"',
                      "''org.example.Tool''"):
            with self.subTest(value=value), self.assertRaisesRegex(ZenLangError, 'reverse-DNS'):
                parse(f'_meta.id = {value}; import $pkgs.legacy.hello;', 'tool.zpkg')

    def test_manifest_has_one_record_with_both_paths_in_both_modes(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            path = root / 'pkgs/apps/files/nautilus.zpkg'
            path.parent.mkdir(parents=True)
            path.write_text('_meta = { id = "org.gnome.Nautilus"; }; import $pkgs.legacy.nautilus;')
            (root / 'structure.zstr').write_text('system.packages._meta.type = (packages);')
            for mode in ('interface', 'build'):
                with self.subTest(mode=mode):
                    records = [s for s in compile_tree(root, mode=mode)['sources'] if s['kind'] == 'zpkg']
                    self.assertEqual(1, len(records))
                    record = records[0]
                    self.assertEqual('pkgs.org.gnome.Nautilus', record['id'])
                    self.assertEqual(['org', 'gnome', 'Nautilus'], record['target'])
                    self.assertEqual(['apps', 'files', 'nautilus'], record['categoryTarget'])
                    self.assertIn('pkgs.zenos.legacy.nautilus', record['buildNix'])

    def test_duplicates_and_prefix_collisions_rejected_case_is_preserved(self):
        for identities in (('org.example.Tool', 'org.example.Tool'),
                           ('org.example', 'org.example.Tool'),
                           ('org.example.Tool', 'org.example')):
            with tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                (root / 'pkgs').mkdir()
                for index, identity in enumerate(identities):
                    (root / f'pkgs/tool{index}.zpkg').write_text(
                        f'_meta.id = "{identity}"; import $pkgs.legacy.hello;')
                for operation in (check_tree, compile_tree):
                    with self.subTest(identities=identities, operation=operation), self.assertRaisesRegex(CompilationError, 'ZPKG identities'):
                        operation(root)
                (root / 'pkgs/tool1.zpkg').write_text(
                    '_meta.id = "org.example.tool"; import $pkgs.legacy.hello;')
                if identities[0] == 'org.example.Tool':
                    self.assertEqual(2, len(compile_tree(root)['sources']))

    def test_category_ancestor_collision_with_distinct_identities(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            paths = ('pkgs/foo.zpkg', 'pkgs/foo/bar.zpkg')
            for index, relative in enumerate(paths):
                path = root / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(f'_meta.id = "org.example.Tool{index}"; import $pkgs.legacy.hello;')
            discovered = _discover_tree(root)
            for order in (discovered, list(reversed(discovered))):
                with patch('zenlang.compiler._discover_tree', return_value=order):
                    for operation in (check_tree, compile_tree):
                        with self.subTest(order=[item[0] for item in order], operation=operation):
                            with self.assertRaisesRegex(CompilationError, 'ZPKG category paths') as raised:
                                operation(root)
                            for relative in paths:
                                self.assertIn(relative, str(raised.exception))
            # A textual prefix is not an ancestor when path segments differ.
            (root / paths[1]).rename(root / 'pkgs/foo-bar.zpkg')
            self.assertEqual(2, len(check_tree(root)))
            self.assertEqual(2, len(compile_tree(root)['sources']))

    def test_selectors_preserve_canonical_category_and_legacy_paths(self):
        for scope in ('system', 'users.alice'):
            for path in ('org.gnome.Nautilus', 'byCategories.apps.files.nautilus', 'legacy.hello'):
                source = f'{scope}.packages.{path} = true;'
                compiled = compile_zcfg(parse(source, 'host.zcfg'))
                segments = ('zenos.' + scope + '.packages.' + path).split('.')
                pattern = r"\s*=\s*\{\s*".join(re.escape(part) for part in segments)
                self.assertRegex(compiled, pattern + r"\s*=\s*true;")

    def test_identity_can_come_from_bare_metadata_import(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'metadata.zpkg').write_text('_meta.id = "org.example.Tool";')
            path = root / 'tool.zpkg'
            path.write_text('_import "metadata.zpkg"; import $pkgs.legacy.hello;')
            self.assertIn('id = "pkgs.org.example.Tool";', compile_zpkg(parse_file(path), mode='interface'))
