from io import StringIO
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

from zenlang import ZenLangError, parse, parse_file
from zenlang.cli import main
from zenlang.compiler import (
    CompilationError, compile_tree, compile_zmdl, compile_zmdl_mount,
    compile_zpkg, document_descriptor,
)


class FoundationSemanticsTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.modules = self.root / "modules"
        self.modules.mkdir()
        self.source = self.modules / "demo.zmdl"

    def module(self, source):
        self.source.write_text(source, encoding="utf-8")
        return parse_file(self.source, import_root=self.root)

    def test_effective_versions_cover_branches_children_and_freeforms_only(self):
        document = self.module('''
_meta = { zenosVersion = 1.2.3; name = "Root"; weight = 42; };
branch = {
  _meta.summary = "Branch";
  child = { _meta.type = $type.bool; !! { target = true; }; };
  overridden = {
    _meta.zenosVersion = "2.0.0Al";
    leaf._meta = { type = $type.int; default = 1; };
  };
  (freeform key) = {
    _meta.type = $type.set;
    _meta.description = ''A freeform record.'';
  };
};
sibling = enableOption {};
''')
        descriptor = document_descriptor(document)
        records = descriptor["nodeMetadata"]
        by_path = {json.dumps(item["path"]): item["metadata"] for item in records}
        self.assertEqual(7, len(records))
        root_version = by_path['[]']["zenosVersion"]
        for path in (["branch"], ["branch", "child"], ["sibling"], ["branch", {"freeform": "key"}]):
            metadata = by_path[json.dumps(path)]
            self.assertEqual(root_version, metadata["zenosVersion"])
            self.assertNotIn("name", metadata)
            self.assertNotIn("weight", metadata)
        self.assertEqual(
            by_path[json.dumps(["branch", "overridden"])]["zenosVersion"],
            by_path[json.dumps(["branch", "overridden", "leaf"])]["zenosVersion"],
        )
        self.assertNotIn("summary", by_path[json.dumps(["branch", "child"])])
        self.assertFalse(any("target" in item["path"] or "_meta" in item["path"] for item in records))
        output = compile_zmdl(document, root=self.root)
        self.assertIn("nodeMetadata =", output)
        self.assertEqual(descriptor, document_descriptor(document))

    def test_effective_metadata_is_span_free_and_does_not_rewrite_authored_nodes(self):
        text = '_meta.zenosVersion = "1.0.0"; child._meta.type = $type.int;'
        first = parse(text, "first.zmdl")
        second = parse(text, "/different/second.zmdl")
        self.assertEqual(document_descriptor(first), document_descriptor(second))
        self.assertEqual(2, len(first.statements))
        child = document_descriptor(first)["nodeMetadata"][1]
        self.assertEqual({"zenosVersion", "type"}, set(child["metadata"]))
        self.assertNotIn("span", json.dumps(child))

    def test_import_merging_precedes_version_inheritance(self):
        (self.modules / "base.zmdl").write_text(
            '_meta.zenosVersion = "1.0.0"; nested.child._meta.type = $type.bool;', encoding="utf-8"
        )
        document = self.module('_import "base.zmdl"; _meta.zenosVersion = "2.0.0";')
        records = document_descriptor(document)["nodeMetadata"]
        self.assertEqual([[], ["nested"], ["nested", "child"]], [record["path"] for record in records])
        for record in records:
            self.assertEqual("2.0.0", record["metadata"]["zenosVersion"]["parts"][0]["value"])

    def test_bundle_carries_effective_metadata_without_a_search_side_channel(self):
        self.module('_meta.zenosVersion = "1.0.0"; child._meta.type = $type.bool;')
        bundle = compile_tree(self.root)
        records = bundle["sources"][0]["descriptor"]["nodeMetadata"]
        self.assertEqual([[], ["child"]], [record["path"] for record in records])
        self.assertEqual(records[0]["metadata"]["zenosVersion"], records[1]["metadata"]["zenosVersion"])

    def test_unresolved_version_is_absent_not_fabricated(self):
        document = self.module('child._meta.type = $type.bool;')
        self.assertTrue(any(item.code == "ZEN228" for item in document.diagnostics))
        self.assertTrue(all("zenosVersion" not in item["metadata"] for item in document_descriptor(document)["nodeMetadata"]))

    def test_option_inference_uses_defaults_not_the_metadata_container(self):
        for default, expected in (
            ("true", "lib.types.bool"), ("3", "lib.types.int"), ("3.5", "lib.types.float"),
            ('"value"', "lib.types.str"), ("null", "(lib.types.enum [ null ])"),
            ("./file", "lib.types.path"), ("{}", "lib.types.attrs"),
            ("[ 1 2 ]", "(lib.types.listOf lib.types.int)"),
            ('[ 1 "two" ]', "(lib.types.listOf (lib.types.either lib.types.int lib.types.str))"),
            ("[ [ 1 ] [ 2 ] ]", "(lib.types.listOf (lib.types.listOf lib.types.int))"),
        ):
            with self.subTest(default=default):
                document = self.module("child._meta.default = " + default + ";")
                for compile_module in (compile_zmdl, compile_zmdl_mount):
                    output = compile_module(document, root=self.root)
                    self.assertIn("type = " + expected + ";", output)
                    self.assertNotIn("lib.types.anything", output)

    def test_lexical_annotation_is_available_for_default_inference(self):
        document = self.module('_let number: $type.int = 3; child._meta.default = $v.number;')
        self.assertIn("type = lib.types.int;", compile_zmdl(document, root=self.root))

    def test_unknown_leaves_fail_full_validation_and_direct_compilation(self):
        for source in (
            "child = {};", 'child._meta.name = "Documentation only";',
            "child._meta.default = [];", "child = [];", "child._meta.default = [ [] ];",
            "child._meta.default = $lib.id 1;",
            "child._meta.default = $cfg.untyped or false;",
            '(freeform key) = { _meta.summary = "Open?"; };',
        ):
            with self.subTest(source=source):
                with self.assertRaises(ZenLangError) as raised:
                    self.module(source)
                self.assertEqual("ZEN230", raised.exception.diagnostic.code)
                self.assertEqual(str(self.source), raised.exception.diagnostic.span.source)
                document = parse(source, str(self.source))
                for compile_module in (compile_zmdl, compile_zmdl_mount):
                    with self.assertRaisesRegex(CompilationError, "cannot infer option type") as compiled:
                        compile_module(document, root=self.root)
                    self.assertIsNotNone(compiled.exception.span)

    def test_namespaces_and_explicit_open_records_remain_valid(self):
        for source in (
            '_meta.name = "Module namespace";',
            'branch = { _meta.name = "Namespace"; nested.leaf = true; };',
            '(freeform key) = { child._meta.type = $type.int; };',
            '(freeform key) = { _meta.type = $type.set; };',
            'child._meta = { type = $type.list [ $type.int ]; default = []; };',
            'child._meta.type = $type.int;',
        ):
            with self.subTest(source=source):
                document = self.module(source)
                compile_zmdl(document, root=self.root)

    def test_cli_and_tree_check_do_not_skip_uninferable_source(self):
        self.source.write_text('child._meta.name = "No type";', encoding="utf-8")
        for command in ("check", "compile"):
            stderr = StringIO()
            arguments = [command, str(self.source)]
            if command == "compile":
                arguments += ["--root", str(self.root)]
            self.assertEqual(1, main(arguments, StringIO(), stderr))
            self.assertIn("ZEN230", stderr.getvalue())
        with self.assertRaises(ZenLangError):
            compile_tree(self.root)

    @unittest.skipUnless(shutil.which("nix-instantiate"), "Nix evaluation requires the VM")
    def test_package_build_metadata_and_derivation_identity_match_interface(self):
        for package_version, expected in ((None, "1.2.3"), ('""', "1.2.3"), ('"upstream-9"', "upstream-9")):
            with self.subTest(package_version=package_version):
                fields = '''name = "Authored"; summary = "Summary"; description = ''Markdown'';
                    zenosVersion = 1.2.3; tags = [ "test" ]; maintainers = [ $m.doromiert ]; license = $l.mit;
                    dependencies = { general = []; build = []; runtime = []; };'''
                if package_version is not None:
                    fields += "packageVersion = " + package_version + ";"
                document = parse("_meta = { " + fields + " }; import $pkgs.legacy.demo;", "demo.zpkg")
                build = compile_zpkg(document, mode="build")
                interface = compile_zpkg(document, mode="interface")
                expression = '''let
                    original = (builtins.derivation {
                        name = "metadata-parity"; system = builtins.currentSystem; builder = "/bin/sh";
                    }) // { meta = { upstreamOnly = true; summary = "Upstream"; }; passthru.keep = 42; };
                    maintainers.doromiert = { name = "Maintainer"; };
                    licenses.mit = { spdxId = "MIT"; };
                    decorated = (''' + build + ''') { pkgs.zenos.legacy.demo = original; inherit maintainers licenses; };
                    descriptor = (''' + interface + ''') {};
                    decode = value: if value.type == "literal" then value.value else
                        builtins.concatStringsSep "" (map (part: part.value) value.parts);
                in {
                    sameDrv = decorated.drvPath == original.drvPath;
                    sameOutput = decorated.outPath == original.outPath;
                    keep = decorated.passthru.keep;
                    upstreamOnly = decorated.meta.upstreamOnly;
                    name = decorated.meta.name;
                    summary = decorated.meta.summary;
                    description = decorated.meta.description;
                    tags = decorated.meta.tags;
                    maintainer = (builtins.head decorated.meta.maintainers).name;
                    license = decorated.meta.license.spdxId;
                    version = decorated.meta.zenosVersion;
                    packageVersion = decorated.meta.packageVersion;
                    interfacePackageVersion = decode descriptor.metadata.packageVersion;
                    dependencies = decorated.meta.dependencies;
                }'''
                result = subprocess.run(
                    ["nix-instantiate", "--store", "dummy://", "--eval", "--strict", "--json", "--expr", expression],
                    capture_output=True, text=True,
                )
                self.assertEqual(0, result.returncode, result.stderr)
                self.assertEqual({
                    "sameDrv": True, "sameOutput": True, "keep": 42, "upstreamOnly": True,
                    "name": "Authored", "summary": "Summary", "description": "Markdown", "tags": ["test"],
                    "maintainer": "Maintainer", "license": "MIT", "version": "1.2.3",
                    "packageVersion": expected, "interfacePackageVersion": expected,
                    "dependencies": {"general": [], "build": [], "runtime": []},
                }, json.loads(result.stdout))

    def test_package_import_metadata_merges_before_normalizing_version(self):
        (self.root / "base.zpkg").write_text('_meta = { name = "Base"; zenosVersion = "1.0.0"; };', encoding="utf-8")
        entry = self.root / "demo.zpkg"
        entry.write_text('_import "base.zpkg"; _meta.zenosVersion = "2.0.0"; import $pkgs.legacy.demo;', encoding="utf-8")
        document = parse_file(entry, import_root=self.root)
        self.assertIn('packageVersion = "2.0.0";', compile_zpkg(document))
        self.assertIn('value = "2.0.0";', compile_zpkg(document, mode="interface"))

    @unittest.skipUnless(shutil.which("nix-instantiate"), "Nix evaluation requires the VM")
    def test_package_reference_resolution_cannot_be_skipped_by_requesting_drv_path(self):
        for metadata, arguments, expected in (
            ('maintainers = [ $m.missing ];', 'maintainers = {}; licenses = {};', "missing"),
            ('license = $l.missing;', 'maintainers = {}; licenses = {};', "missing"),
        ):
            with self.subTest(metadata=metadata):
                document = parse("_meta = { " + metadata + " }; import $pkgs.legacy.demo;", "demo.zpkg")
                output = compile_zpkg(document)
                expression = "((" + output + ") { pkgs.zenos.legacy.demo = { type = \"derivation\"; drvPath = \"unchanged\"; }; " + arguments + " }).drvPath"
                result = subprocess.run(["nix-instantiate", "--store", "dummy://", "--eval", "--strict", "--expr", expression], capture_output=True, text=True)
                self.assertNotEqual(0, result.returncode)
                self.assertIn(expected, result.stderr)

    @unittest.skipUnless(shutil.which("nix-instantiate"), "Nix evaluation requires the VM")
    def test_package_import_must_resolve_to_a_derivation(self):
        output = compile_zpkg(parse("import $pkgs.legacy.demo;", "demo.zpkg"))
        result = subprocess.run(
            ["nix-instantiate", "--store", "dummy://", "--eval", "--strict", "--expr", "(" + output + ") { pkgs.zenos.legacy.demo = {}; }"],
            capture_output=True, text=True,
        )
        self.assertNotEqual(0, result.returncode)
        self.assertIn("assertion", result.stderr)

    @unittest.skipUnless(shutil.which("nix-instantiate"), "Nix evaluation requires the VM")
    def test_real_imported_package_uses_explicit_repository_registry_context(self):
        available = subprocess.run(["nix-instantiate", "--find-file", "nixpkgs"], capture_output=True, text=True)
        if available.returncode:
            self.skipTest("the VM must provide a Nixpkgs evaluation context")
        registry = Path(os.environ["ZEN_MAINTAINERS"]) if "ZEN_MAINTAINERS" in os.environ else Path(__file__).parents[3] / "lib" / "maintainers.nix"
        document = parse('''
_meta = {
  name = "Authored Hello"; summary = "Imported package";
  description = ''Markdown for Hello.''; zenosVersion = "1.2.3";
  maintainers = [ $m.doromiert ]; license = $l.mit;
};
import $pkgs.legacy.hello;
''', "hello.zpkg")
        output = compile_zpkg(document)
        expression = '''let
            upstream = import <nixpkgs> {};
            lib = upstream.lib;
            maintainers = import ''' + str(registry) + ''' {};
            decorated = (''' + output + ''') {
              pkgs = upstream // { zenos.legacy = upstream; };
              inherit lib maintainers;
              licenses = lib.licenses;
            };
        in {
            sameDrv = decorated.drvPath == upstream.hello.drvPath;
            sameOutput = decorated.outPath == upstream.hello.outPath;
            maintainer = (builtins.head decorated.meta.maintainers).github;
            license = decorated.meta.license.spdxId;
            version = decorated.meta.packageVersion;
            name = decorated.meta.name;
        }'''
        result = subprocess.run(
            ["nix-instantiate", "--eval", "--strict", "--read-write-mode", "--json", "--expr", expression],
            capture_output=True, text=True,
        )
        self.assertEqual(0, result.returncode, result.stderr)
        self.assertEqual({
            "sameDrv": True, "sameOutput": True, "maintainer": "doromiert",
            "license": "MIT", "version": "1.2.3", "name": "Authored Hello",
        }, json.loads(result.stdout))


if __name__ == "__main__":
    unittest.main()
