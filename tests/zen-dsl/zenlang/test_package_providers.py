import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

from zenlang import parse, parse_file
from zenlang.compiler import CompilationError, compile_tree, compile_zpkg
from zenlang.model import ZenLangError


class PackageProviderTests(unittest.TestCase):
    def test_provider_count_precedes_coalescing(self):
        for source in (
            "", "build = {}; build = {};", "build = 1; build = 2;",
            "import $pkgs.legacy.hello; build = {};",
            "import $pkgs.legacy.hello; import $pkgs.legacy.hello;",
            "build.foo = {};", "build.foo = {}; build.bar = {};",
        ):
            with self.subTest(source=source), self.assertRaises(CompilationError):
                compile_zpkg(parse(source, "/repo/pkgs/example.zpkg"))

    def test_complete_file_contract_and_imported_duplicates(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            entry = root / "example.zpkg"
            fragment = root / "fragment.zpkg"
            for source in ("build = {}; build = {};", "build.foo = {};", "import $pkgs.legacy.hello; build = {};"):
                entry.write_text(source)
                with self.assertRaises(ZenLangError):
                    parse_file(entry)
            fragment.write_text("build = {};")
            entry.write_text('_import "./fragment.zpkg"; build = {};')
            with self.assertRaises(ZenLangError):
                parse_file(entry, import_root=root)

    def test_build_expression_is_not_a_metadata_node(self):
        document = parse('build = $pkgs.legacy.stdenv.mkDerivation { name = "tiny"; };', "pkgs/tiny.zpkg")
        self.assertTrue(document.diagnostics)
        self.assertFalse(any("pkgs.tiny.build" in diagnostic.message for diagnostic in document.diagnostics))

    @unittest.skipUnless(shutil.which("nix-instantiate"), "Nix evaluation requires the VM")
    def test_interface_never_calls_throwing_provider(self):
        document = parse('build = $lib.trivial.throw "provider was evaluated";', "pkgs/opaque.zpkg")
        interface = compile_zpkg(document, mode="interface")
        result = subprocess.run(
            ["nix-instantiate", "--store", "dummy://", "--eval", "--strict", "--json", "--expr", f"({interface}) {{}}"],
            text=True, capture_output=True,
        )
        self.assertEqual(0, result.returncode, result.stderr)
        descriptor = json.loads(result.stdout)
        self.assertEqual("build", descriptor["provider"]["kind"])
        self.assertNotIn("packageImport", descriptor)
        self.assertFalse(descriptor["dependenciesDeclared"])

    def test_tree_carries_separate_executable_build_artifact(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "pkgs").mkdir()
            (root / "structure.zstr").write_text("")
            (root / "pkgs" / "tiny.zpkg").write_text('build = $pkgs.legacy.runCommand "tiny" {} "mkdir $out";')
            bundle = compile_tree(root, mode="interface")
            source = next(source for source in bundle["sources"] if source["kind"] == "zpkg")
            self.assertIn("buildNix", source)
            self.assertIn("zpkgRuntime", source["buildNix"])
            self.assertNotIn("zpkgRuntime", source["compiledNix"])

    def test_deps_binding_is_executable_only(self):
        document = parse("build = $lib.consumeDeps $deps;", "pkgs/deps.zpkg")
        binding = "deps = { general = [ ]; build = [ ]; runtime = [ ]; } // (suppliedMetadata.dependencies or { });"
        self.assertIn(binding, compile_zpkg(document))
        self.assertNotIn(binding, compile_zpkg(document, mode="interface"))

    def test_deps_namespace_remains_zpkg_only(self):
        for suffix in ("zcfg", "zmdl", "zstr"):
            with self.subTest(suffix=suffix), self.assertRaisesRegex(ZenLangError, r"\$deps is not available"):
                parse("value = $deps.build;", "example." + suffix)

    @unittest.skipUnless(os.environ.get("ZEN_ZPKG_BUILD_TESTS") == "1", "requires live VM builds outside a Nix sandbox")
    def test_deps_provider_execution(self):
        def run(*arguments, success=True):
            result = subprocess.run(arguments, text=True, capture_output=True)
            self.assertEqual(success, result.returncode == 0, result.stdout + result.stderr)
            return result.stdout.strip() if success else result.stderr

        sources = {
            "declared": '''
                _meta.dependencies.build = [ $pkgs.legacy.buildTool ];
                build = if $lib.isDerivation ($lib.head $deps.build) && $deps.general == [] && $deps.runtime == [] then
                  $pkgs.legacy.runCommand "zpkg-deps-declared" {} ''
                    test "${$lib.concatStringsSep "," ($lib.attrNames $deps)}" = build,general,runtime
                    test "${$lib.head $deps.build}" = "${$pkgs.legacy.buildTool}"
                    test "$("${$lib.head $deps.build}/bin/deps-tool")" = built-from-deps
                    mkdir -p "$out/bin"
                    printf '#!${$pkgs.legacy.runtimeShell}\\necho declared-deps\\n' > "$out/bin/app"
                    chmod +x "$out/bin/app"
                  ''
                else $lib.trivial.throw "omitted authored scopes were not empty";
            ''',
            "absent": '''
                build = if $deps == { general = []; build = []; runtime = []; }
                  then $pkgs.legacy.original
                  else $lib.trivial.throw "deps inferred inherited provider inputs";
            ''',
            "imported": "import $pkgs.legacy.original;",
            "runtimeCapture": '''
                _meta.dependencies.runtime = [ $pkgs.legacy.buildTool ];
                build = $pkgs.legacy.runCommand "zpkg-deps-runtime-capture" {} ''
                  "${$lib.head $deps.runtime}/bin/deps-tool" > "$out"
                '';
            ''',
        }
        with tempfile.TemporaryDirectory(prefix="zpkg-provider-deps-") as temporary:
            root = Path(temporary)
            for name, source in sources.items():
                entry = root / (name + ".zpkg")
                entry.write_text(source)
                (root / (name + ".nix")).write_text(compile_zpkg(parse_file(entry)))
            context = root / "context.nix"
            context.write_text('''let
              pkgs = import <nixpkgs> {};
              buildTool = pkgs.writeShellScriptBin "deps-tool" "echo built-from-deps";
              original = pkgs.runCommand "zpkg-deps-original" {
                nativeBuildInputs = [ buildTool ];
              } ''
                test "$(deps-tool)" = built-from-deps
                mkdir -p "$out/bin"
                printf '#!${pkgs.runtimeShell}\\necho inherited-inputs\\n' > "$out/bin/app"
                chmod +x "$out/bin/app"
              '';
              args.pkgs = pkgs // { zenos.legacy = pkgs // { inherit buildTool original; }; };
              declared = import ./declared.nix args;
              absent = import ./absent.nix args;
              imported = import ./imported.nix args;
            in {
              inherit buildTool declared absent imported;
              runtimeCapture = import ./runtimeCapture.nix args;
              identity = absent.drvPath == original.drvPath && imported.drvPath == original.drvPath
                && absent.outPath == original.outPath && imported.outPath == original.outPath
                && absent.nativeBuildInputs == original.nativeBuildInputs
                && !(absent.meta ? dependencies);
            }''')
            identity = run("nix-instantiate", "--eval", "--strict", "--json", str(context), "-A", "identity")
            self.assertTrue(json.loads(identity))
            tool = run("nix-build", str(context), "-A", "buildTool", "--no-out-link")
            for name, expected in (("declared", "declared-deps\n"), ("absent", "inherited-inputs\n"), ("imported", "inherited-inputs\n")):
                path = run("nix-build", str(context), "-A", name, "--no-out-link")
                result = subprocess.run([path + "/bin/app"], env={"PATH": "/no-ambient-commands"}, text=True, capture_output=True)
                self.assertEqual(0, result.returncode, result.stderr)
                self.assertEqual(expected, result.stdout)
                self.assertNotIn(tool, run("nix-store", "--query", "--requisites", path).splitlines())
            error = run("nix-build", str(context), "-A", "runtimeCapture", "--no-out-link", success=False)
            self.assertIn("still captures removed or runtime-only dependencies", error)
            self.assertIn("buildCommand", error)
            self.assertIn("runtimeCapture.zpkg", error)


if __name__ == "__main__":
    unittest.main()
