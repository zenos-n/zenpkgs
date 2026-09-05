from pathlib import Path
import tempfile
import unittest

from zenlang import compile_tree, parse
from zenlang.compiler import CompilationError, compile_zcfg


class MountingCompilerTests(unittest.TestCase):
    def compile(self, structure=None):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "modules/programs/demo.zmdl"
            source.parent.mkdir(parents=True)
            source.write_text("enable = enableOption { u! { home.sessionVariables.TEST = \"yes\"; }; };", encoding="utf-8")
            if structure is not None:
                (root / "structure.zstr").write_text(structure, encoding="utf-8")
            return compile_tree(root)

    def test_discovery_without_structure_has_no_mounts(self):
        bundle = self.compile()
        self.assertFalse(bundle["structure"]["present"])
        self.assertEqual(bundle["structure"]["mounts"], [])
        self.assertEqual(bundle["modules"][0]["identity"], "zenos.programs.demo")

    def test_file_and_subtree_mounts_do_not_change_identity(self):
        bundle = self.compile("""
            system.programs._meta.type = (zmdl programs);
            system.single._meta.type = (zmdl programs.demo);
        """)
        self.assertEqual([mount["target"] for mount in bundle["structure"]["mounts"]],
                         [["programs"], ["programs", "demo"]])
        self.assertEqual(len(bundle["modules"]), 1)
        source = next(source for source in bundle["sources"] if source["kind"] == "zmdl")
        self.assertIn("schema =", source["mountNix"])
        self.assertIn("home-manager.users.${user}", source["mountNix"])
        self.assertNotIn("config.zenos.programs.demo", source["mountNix"])

    def test_lexical_alias_target_is_not_a_string_substitution(self):
        bundle = self.compile("""
            users = { (freeform account) = {
                legacy._meta.type = (alias nixpkgs.users.users.($f.account));
                programs._meta.type = (zmdl programs);
                packages._meta.type = (packages);
            }; };
        """)
        mounts = bundle["structure"]["mounts"]
        self.assertEqual(mounts[0]["path"], ["users", "{account}", "legacy"])
        self.assertEqual(mounts[0]["target"][-1], {"freeform": "account"})
        self.assertEqual(mounts[2]["target"], [])

    def test_structure_ordinary_options_are_compiled(self):
        bundle = self.compile("system.port._meta = { type = $type.int; default = 8080; };")
        node = next(node for node in bundle["structure"]["nodes"] if node["path"] == ["system", "port"])
        self.assertIn("lib.types.int", node["optionNix"])
        self.assertIn("default = 8080", node["optionNix"])

    def test_structure_default_inference_and_bindings(self):
        bundle = self.compile("""
            _let port: $type.int = 8080;
            system.port._meta = { type = $type.int; default = $v.port; };
            system.retries._meta.default = 3;
        """)
        nodes = {tuple(node["path"]): node for node in bundle["structure"]["nodes"]}
        self.assertIn("let port = 8080; in", nodes[("system", "port")]["optionNix"])
        self.assertIn("lib.types.int", nodes[("system", "retries")]["optionNix"])

    def test_package_mounts_require_an_approved_selector_scope(self):
        with self.assertRaisesRegex(CompilationError, "package selectors require"):
            self.compile("packages._meta.type = (packages);")

    def test_legacy_program_marker_is_not_silently_activated(self):
        with self.assertRaisesRegex(CompilationError, "no mounting semantics"):
            self.compile("system.programs._meta.type = (programs);")

    def test_zcfg_cannot_bypass_zstr_alias_mounts(self):
        compiled = compile_zcfg(parse("""
            legacy.networking.hostName = "mounted";
            users.alice.legacy.homeManager.home.stateVersion = "26.05";
        """, "host.zcfg"))
        self.assertIn("zenos = {", compiled)
        self.assertIn("legacy = {", compiled)
        self.assertIn("homeManager = {", compiled)
        self.assertNotIn("home-manager =", compiled)

    def test_bundle_diagnostics_retain_relative_source_locations(self):
        bundle = self.compile("system.programs._meta.type = (zmdl programs);")
        source = next(item for item in bundle["sources"] if item["kind"] == "zmdl")
        self.assertTrue(source["diagnostics"])
        self.assertEqual(source["diagnostics"][0]["source"], "modules/programs/demo.zmdl")
        self.assertGreater(source["diagnostics"][0]["line"], 0)
        self.assertIn(source["diagnostics"][0], bundle["diagnostics"])


if __name__ == "__main__":
    unittest.main()
