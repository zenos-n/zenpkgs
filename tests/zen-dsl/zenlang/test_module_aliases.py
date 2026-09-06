from pathlib import Path
import tempfile
import unittest

from zenlang import compile_tree, parse
from zenlang.model import ZenLangError
from zenlang.compiler import CompilationError, compile_zmdl_mount, document_descriptor


class ModuleAliasTests(unittest.TestCase):
    def document(self, text):
        return parse(text, "/fixture/modules/system/demo.zmdl")

    def test_nested_and_root_alias_descriptors(self):
        for text, path in (("_meta.type = (alias nixpkgs.services.openssh);", []),
                           ("settings.ssh._meta.type = (alias nixpkgs.services.openssh);", ["settings", "ssh"])):
            with self.subTest(path=path):
                self.assertEqual(document_descriptor(self.document(text))["aliases"], [
                    {"kind": "alias", "path": path, "target": ["nixpkgs", "services", "openssh"]}
                ])

    def test_alias_schema_is_supplied_by_the_mount_runtime(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "modules/system/demo.zmdl"
            source.parent.mkdir(parents=True)
            text = "ssh._meta.type = (alias nixpkgs.services.openssh);"
            source.write_text(text, encoding="utf-8")
            bundle = compile_tree(root)
            self.assertFalse(bundle["structure"]["present"])
            self.assertEqual(bundle["structure"]["mounts"], [])
            mounted = bundle["sources"][0]["mountNix"]
            self.assertIn('ssh = moduleAliasOption [ "nixpkgs" "services" "openssh" ]', mounted)
            self.assertNotIn("config.zenos.system.demo", mounted)

    def test_freeform_targets_retain_lexical_keys_and_exclude_fixed_children(self):
        aliases = document_descriptor(self.document('''
            accounts = {
                label._meta.default = "fixed";
                (freeform account) = {
                    home._meta.type = (alias nixpkgs.home-manager.users.($f.account));
                };
            };
        '''))["aliases"]
        self.assertEqual(aliases[0]["path"], ["accounts", {"freeform": "account", "exclude": ["label"]}, "home"])
        self.assertEqual(aliases[0]["target"][-1], {"freeform": "account"})

    def test_alias_actions_and_defaults_are_rejected_by_forwarding_backend(self):
        for declaration in ("_meta.default = {};", "_meta = { default = {}; };", "s!! { services.openssh.enable = true; };"):
            with self.subTest(declaration=declaration), self.assertRaisesRegex(
                CompilationError, "ZMDL alias actions and defaults are unsupported by the forwarding backend"
            ):
                document_descriptor(self.document("ssh = { _meta.type = (alias nixpkgs.services.openssh); " + declaration + " };"))

    def test_alias_local_children_are_retained_for_runtime_ownership_validation(self):
        for child in ("enable", "local"):
            with self.subTest(child=child), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                source = root / "modules/system/demo.zmdl"
                source.parent.mkdir(parents=True)
                source.write_text(
                    "ssh._meta.type = (alias nixpkgs.services.openssh); "
                    f"ssh.{child}._meta.default = true;", encoding="utf-8"
                )
                (root / "structure.zstr").write_text(
                    "system.demo._meta.type = (zmdl system.demo);", encoding="utf-8"
                )
                bundle = compile_tree(root)
                self.assertEqual(bundle["sources"][0]["descriptor"]["aliases"], [
                    {"kind": "alias", "path": ["ssh"], "target": ["nixpkgs", "services", "openssh"]}
                ])
                ownership = bundle["mountedOwnership"]
                self.assertIn(["system", "demo", "ssh", child], [
                    owner["path"] for owner in ownership["ownership"]
                ])
                self.assertEqual([alias["path"] for alias in ownership["ownershipAliases"]], [
                    ["system", "demo", "ssh"]
                ])

    def test_non_upstream_targets_are_rejected(self):
        with self.assertRaisesRegex(CompilationError, "must target nixpkgs"):
            document_descriptor(self.document("ssh._meta.type = (alias zenos.system.ssh);"))

    def test_implicit_and_ancestor_defaults_do_not_silently_override_aliases(self):
        for text, diagnostic in (
            ("ssh = enableOption { _meta.type = (alias nixpkgs.services.openssh); };",
             "ZMDL alias actions and defaults are unsupported by the forwarding backend"),
            ("_meta.default = { ssh.enable = true; }; ssh._meta.type = (alias nixpkgs.services.openssh);",
             "ZMDL aliases below local defaults are unsupported by the forwarding backend"),
        ):
            with self.subTest(text=text), self.assertRaisesRegex(CompilationError, diagnostic):
                document_descriptor(self.document(text))

    def test_metadata_block_alias_is_allowed(self):
        self.assertEqual(document_descriptor(self.document(
            "ssh = { _meta = { type = (alias nixpkgs.services.openssh); }; };"
        ))["aliases"][0]["path"], ["ssh"])

    def test_direct_freeform_alias_has_an_explicit_diagnostic(self):
        with self.assertRaisesRegex(CompilationError, "declare a named alias child"):
            document_descriptor(self.document(
                "(freeform account) = { _meta.type = (alias nixpkgs.users.users.($f.account)); };"
            ))

    def test_bare_imported_alias_is_collected_at_the_importing_module(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            imported = root / "modules/hidden/alias.zmdl"
            imported.parent.mkdir(parents=True)
            imported.write_text("ssh._meta.type = (alias nixpkgs.services.openssh);", encoding="utf-8")
            source = root / "modules/system/demo.zmdl"
            source.parent.mkdir(parents=True)
            source.write_text('_import "../hidden/alias.zmdl";', encoding="utf-8")
            (root / "structure.zstr").write_text("system.demo._meta.type = (zmdl system.demo);", encoding="utf-8")
            bundle = compile_tree(root)
            module = next(item for item in bundle["sources"] if item["path"] == "modules/system/demo.zmdl")
            self.assertEqual(module["descriptor"]["aliases"][0]["path"], ["ssh"])
            self.assertEqual(bundle["structure"]["mounts"][0]["target"], ["system", "demo"])

    def test_markers_remain_forbidden_in_expressions(self):
        for text in (
            "value = (alias nixpkgs.services);",
            "value._meta.default = (alias nixpkgs.services);",
            "value._meta.type = (freeform account);",
            "value._meta.type = (zmdl programs);",
            "value._meta.type = if true then (alias nixpkgs.services) else $type.bool;",
            "_let value: $type.set = { _meta.type = (alias nixpkgs.services); };",
            "enable = enableOption { s!! { data._meta.type = (alias nixpkgs.services); }; };",
            "value._meta.default = { _meta.type = (alias nixpkgs.services); };",
            "_meta = { arbitrary._meta.type = (alias nixpkgs.services); };",
            "_meta = { arbitrary._meta = { type = (alias nixpkgs.services); }; };",
        ):
            with self.subTest(text=text), self.assertRaises(ZenLangError):
                self.document(text)

    def test_record_form_is_not_silently_mounted(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            document = parse('(alias legacy.demo) = { target = "nixos"; path = "services.demo"; };',
                             str(root / "modules/system/demo.zmdl"))
            self.assertIn("value", document_descriptor(document)["aliases"][0])
            with self.assertRaisesRegex(CompilationError, "record-form ZMDL alias mounting is unspecified"):
                compile_zmdl_mount(document, root=root)


if __name__ == "__main__":
    unittest.main()
