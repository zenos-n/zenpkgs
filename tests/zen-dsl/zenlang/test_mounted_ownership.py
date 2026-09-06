from pathlib import Path
import tempfile
import unittest

from zenlang.compiler import CompilationError, compile_tree


class MountedOwnershipTests(unittest.TestCase):
    def compile(self, files):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name, text in files.items():
                path = root / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(text, encoding="utf-8")
            return compile_tree(root)

    def collision(self, files, path, sources):
        with self.assertRaises(CompilationError) as error:
            self.compile(files)
        self.assertIn("duplicate mounted option zenos." + path, str(error.exception))
        for source in sources:
            self.assertRegex(str(error.exception), source + r":\d+:\d+")

    def test_structure_and_module_duplicate_even_with_identical_types(self):
        self.collision({
            "structure.zstr": "system._meta.type = (zmdl system);\nsystem.demo.port._meta.type = $type.int;",
            "modules/system/demo.zmdl": "port._meta.type = $type.int;",
        }, "system.demo.port", ["structure.zstr", "modules/system/demo.zmdl"])

    def test_two_module_trees_cannot_own_the_same_option(self):
        self.collision({
            "structure.zstr": "system._meta.type = (zmdl first); system.demo._meta.type = (zmdl second);",
            "modules/first/demo.zmdl": "port._meta.type = $type.int;",
            "modules/second.zmdl": "port._meta.type = $type.int;",
        }, "system.demo", ["modules/first/demo.zmdl", "modules/second.zmdl"])

    def test_duplicate_imported_leaf_fields_retain_both_spans(self):
        self.collision({
            "structure.zstr": "system._meta.type = (zmdl system);",
            "modules/system/demo.zmdl": '_import "../parts/base.zmdl";\nport._meta.type = $type.int;',
            "modules/parts/base.zmdl": "port._meta.type = $type.int;",
        }, "system.demo.port", ["modules/parts/base.zmdl", "modules/system/demo.zmdl"])

    def test_duplicate_structure_mounts_retain_both_spans(self):
        self.collision({
            "structure.zstr": 'legacy._meta.type = (alias nixpkgs);\nlegacy._meta.type = (alias nixpkgs);',
        }, "legacy", ["structure.zstr"])

    def test_incompatible_imported_defaults_also_have_both_mounted_spans(self):
        self.collision({
            "structure.zstr": "system._meta.type = (zmdl system);",
            "modules/system/demo.zmdl": '_import "../parts/base.zmdl";\nport._meta.default = "wrong";',
            "modules/parts/base.zmdl": "port._meta.default = 1;",
        }, "system.demo.port", ["modules/parts/base.zmdl", "modules/system/demo.zmdl"])

    def test_split_metadata_within_one_source_is_not_two_definitions(self):
        self.compile({
            "structure.zstr": "system._meta.type = (zmdl system);",
            "modules/system/demo.zmdl": 'port._meta.name = "Port"; port._meta.type = $type.int;',
        })

    def test_disjoint_imported_default_fields_still_merge(self):
        self.compile({
            "structure.zstr": "system._meta.type = (zmdl system);",
            "modules/system/demo.zmdl": '_import "../parts/base.zmdl"; settings._meta.default = { right = 2; }; settings.right._meta.type = $type.int;',
            "modules/parts/base.zmdl": "settings._meta.default = { left = 1; }; settings.left._meta.type = $type.int;",
        })

    def test_alias_value_operations_have_concrete_backend_limitations(self):
        for local in ("_meta.default = {};", "s!! { result = true; };"):
            with self.subTest(local=local), self.assertRaisesRegex(CompilationError, "unsupported by the forwarding backend"):
                self.compile({
                    "structure.zstr": "system._meta.type = (zmdl demo);",
                    "modules/demo.zmdl": "ssh = { _meta.type = (alias nixpkgs.services); " + local + " };",
                })

    def test_leaf_shorthand_is_an_owned_option(self):
        self.collision({
            "structure.zstr": "system._meta.type = (zmdl system); system.demo.port._meta.default = 1;",
            "modules/system/demo.zmdl": "port = 1;",
        }, "system.demo.port", ["structure.zstr", "modules/system/demo.zmdl"])

    def test_generated_enable_is_an_owned_option(self):
        self.collision({
            "structure.zstr": "system._meta.type = (zmdl system); system.demo.enable._meta.default = false;",
            "modules/system/demo.zmdl": "port._meta.default = 1;",
        }, "system.demo.enable", ["structure.zstr", "modules/system/demo.zmdl"])

    def test_split_metadata_and_import_fragments_are_one_definition(self):
        bundle = self.compile({
            "structure.zstr": "system._meta.type = (zmdl system);",
            "modules/system/demo.zmdl": '_import "../parts/base.zmdl";\nport._meta.name = "Port"; port._meta.default = 4;',
            "modules/parts/base.zmdl": "port._meta.type = $type.int;",
        })
        self.assertEqual(1, sum(owner["path"] == ["system", "demo", "port"]
                                for owner in bundle["mountedOwnership"]["ownership"]))

    def test_disjoint_children_share_an_implicit_namespace(self):
        self.compile({
            "structure.zstr": "system._meta.type = (zmdl system); system.demo.settings.right._meta.default = 2;",
            "modules/system/demo.zmdl": "settings.left._meta.default = 1;",
        })

    def test_same_module_at_different_mount_paths_is_valid(self):
        bundle = self.compile({
            "structure.zstr": "system.one._meta.type = (zmdl shared); system.two._meta.type = (zmdl shared);",
            "modules/shared.zmdl": "port._meta.default = 1;",
        })
        self.assertIn(["system", "one", "port"], [o["path"] for o in bundle["mountedOwnership"]["ownership"]])
        self.assertIn(["system", "two", "port"], [o["path"] for o in bundle["mountedOwnership"]["ownership"]])

    def test_same_module_at_overlapping_mounts_reports_both_mount_sites(self):
        with self.assertRaises(CompilationError) as error:
            self.compile({
                "structure.zstr": "system._meta.type = (zmdl system);\nsystem.demo._meta.type = (zmdl system.demo);",
                "modules/system/demo.zmdl": "port._meta.default = 1;",
            })
        self.assertIn("duplicate mounted option zenos.system.demo", str(error.exception))
        self.assertIn("structure.zstr:1:1-", str(error.exception))
        self.assertIn("structure.zstr:2:1-", str(error.exception))

    def test_config_values_and_priorities_do_not_claim_schema(self):
        self.compile({
            "structure.zstr": "system._meta.type = (zmdl system);",
            "modules/system/demo.zmdl": "port._meta = { type = $type.int; default = 1; weight = 20; };",
            "first.zcfg": "system.demo.port = 2;",
            "second.zcfg": "system.demo.port = 3;",
        })

    def test_imported_priority_change_does_not_redeclare_the_option(self):
        self.compile({
            "structure.zstr": "system._meta.type = (zmdl system);",
            "modules/system/demo.zmdl": '_import "../parts/base.zmdl"; port._meta.weight = 20;',
            "modules/parts/base.zmdl": "port._meta = { type = $type.int; default = 1; weight = 10; };",
        })

    def test_upstream_alias_overlap_is_retained_for_trusted_validation(self):
        bundle = self.compile({
            "structure.zstr": "legacy._meta.type = (alias nixpkgs); legacy.networking.hostName._meta.default = \"local\";",
        })
        self.assertEqual(["nixpkgs"], bundle["mountedOwnership"]["ownershipAliases"][0]["target"])
        self.assertIn(["legacy", "networking", "hostName"], [o["path"] for o in bundle["mountedOwnership"]["ownership"]])

    def test_module_alias_children_are_deferred_to_trusted_schema(self):
        bundle = self.compile({
            "structure.zstr": "system._meta.type = (zmdl demo);",
            "modules/demo.zmdl": "ssh._meta.type = (alias nixpkgs.services.openssh); ssh.enable._meta.default = false;",
        })
        self.assertIn(["system", "ssh", "enable"], [o["path"] for o in bundle["mountedOwnership"]["ownership"]])


if __name__ == "__main__":
    unittest.main()
