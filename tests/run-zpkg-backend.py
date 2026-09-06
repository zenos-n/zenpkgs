"""Real build acceptance. Run inside the ZenOS VM, outside a Nix build sandbox."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "tests/zpkg-backend.nix"


def run(*args, success=True):
    result = subprocess.run(args, text=True, capture_output=True)
    if (result.returncode == 0) != success:
        raise AssertionError(f"{args}\n{result.stdout}\n{result.stderr}")
    return result.stdout if success else result.stderr


def main():
    assert json.loads(run("nix-instantiate", "--eval", "--strict", "--json", str(FIXTURE), "-A", "inheritanceIdentity"))
    with tempfile.TemporaryDirectory(prefix="zpkg-backend-") as temporary:
        expected = {
            "inheritance": "inherited\n", "clear": "cleared\n", "scopes": "general\nruntime\n",
            "runtime": "runtime\n", "general": "general\n", "build": "native-ok\n",
            "recursive": "recursive\n", "transitiveRuntime": "built\n",
            "sourceSymlinkRuntime": "source-linked\n",
            "sourceExecutionBuild": "source-executed\n",
            "sourceExecutionBuildClosure": "source-executed\n",
            "sourceExecutionGeneralClosure": "source-executed\n",
            "disabledDiscard": "cleared\n",
        }
        paths = {}
        for name, output in expected.items():
            path = run("nix-build", str(FIXTURE), "-A", name, "--no-out-link").strip()
            paths[name] = path
            result = subprocess.run([path + "/bin/app"], env={"PATH": "/no-ambient-commands"}, text=True, capture_output=True)
            assert result.returncode == 0 and result.stdout == output, (name, result.stdout, result.stderr)
            print(f"PASS build and execute: {name}", flush=True)
        build_tool = run("nix-build", str(FIXTURE), "-A", "buildTool", "--no-out-link").strip()
        for name in ("build", "scopes", "recursive", "sourceExecutionBuild", "sourceExecutionBuildClosure"):
            closure = run("nix-store", "--query", "--requisites", paths[name]).splitlines()
            assert build_tool not in closure, (name, "build-only tool leaked into output closure")
        assert build_tool in run("nix-store", "--query", "--requisites", paths["transitiveRuntime"]).splitlines()
        assert build_tool in run("nix-store", "--query", "--requisites", paths["sourceSymlinkRuntime"]).splitlines()
        assert build_tool in run("nix-store", "--query", "--requisites", paths["sourceExecutionGeneralClosure"]).splitlines()
        failures = {
            "captured": "still captures", "finalCapture": "still captures", "auxiliary": "opaque auxiliary input contexts",
            "sourceCapture": "source retains removed or runtime-only dependency references",
            "runtimeCapture": "still captures", "opaque": "opaque provider", "foreign": "cross-compilation",
            "multioutput": "multioutput providers", "multiDependency": "multioutput dependencies",
            "nonDerivation": "must produce a derivation", "customBuilder": "custom/opaque builder",
            "fixedOutput": "fixed-output", "buildLeak": "not allowed to refer",
            "runtimeLibrary": "runtime library/plugin linkage is unsupported",
            "mixedRuntimeLibrary": "runtime library/plugin linkage is unsupported",
            "mixedGeneralLibrary": "runtime library/plugin linkage is unsupported",
            "sourceSymlinkLeak": "not allowed to refer",
            "removedTransitiveSourceLeak": "source retains removed or runtime-only dependency references",
            "removedTransitiveSourceExecution": "source retains removed or runtime-only dependency references",
            "removedTransitiveSourceRuntimeExecution": "source retains removed or runtime-only dependency references",
            "unsafeDiscardBuildLeak": "original drvAttrs enable unsafeDiscardReferences",
            "unsafeDiscardOriginalOnly": "original drvAttrs enable unsafeDiscardReferences",
            "unsafeDiscardFinalBuildLeak": "final drvAttrs enable unsafeDiscardReferences",
            "finalFixedOutput": "final drvAttrs enable fixed-output or content-addressed",
            "finalContentAddressed": "final drvAttrs enable fixed-output or content-addressed",
            "applicationLibrary": "library/plugin output wrapping is unsupported",
        }
        for name, diagnostic in failures.items():
            error = run("nix-build", str(FIXTURE), "-A", name, "--no-out-link", success=False)
            assert diagnostic in error, (name, error)
            print(f"PASS expected rejection: {name}", flush=True)
        test_registry(Path(temporary))
    print("PASS reference closure isolation and legitimate transitive runtime exception", flush=True)


def test_registry(root):
    sys.path.insert(0, str(ROOT / "lib/zen-dsl"))
    from zenlang.compiler import compile_tree

    metadata = '''_meta = {
      name = "Fixture"; summary = "Fixture"; description = ''Fixture'';
      zenosVersion = "1.0.0"; tags = []; maintainers = []; license = $l.mit;
    };
    '''
    sources = {
        "tools/generator": 'build = $pkgs.legacy.writeShellScriptBin "generator" "echo generated";',
        "tools/poison": 'build = $pkgs.legacy.abortProvider "tool sibling evaluated";',
        "runtime/command": 'build = $pkgs.legacy.writeShellScriptBin "runtime-command" "echo registry-runtime";',
        "apps/inherited": 'import $pkgs.legacy."quoted.tool";',
        "apps/poison": 'build = $pkgs.legacy.abortProvider "sibling evaluated";',
        "apps/empty": '_meta.dependencies = {}; build = $pkgs.legacy.runCommand "empty" {} "mkdir $out";',
        "apps/library": 'build = $lib.customPackage;',
        "apps/library-runtime": '_meta.dependencies.runtime = [ $pkgs.runtime.command ]; build = $lib.customPackage;',
        "apps/tool": '''
          _meta.dependencies = {
            build = [ $pkgs.tools.generator ];
            general = [ $pkgs.legacy."quoted.tool" ];
            runtime = [ $pkgs.runtime.command $pkgs.tools.external ];
          };
          build = $pkgs.legacy.runCommand "registry-application" {} ''
            test "$(generator)" = generated
            test "$(quoted-command)" = quoted
            if command -v runtime-command || command -v external-command; then exit 1; fi
            mkdir -p "$out/bin"
            cat > "$out/bin/app" <<'EOF'
#!${$pkgs.legacy.runtimeShell}
if command -v generator; then exit 1; fi
quoted-command
runtime-command
external-command
EOF
            chmod +x "$out/bin/app"
          '';
        ''',
    }
    (root / "structure.zstr").write_text("")
    for name, text in sources.items():
        path = root / "pkgs" / (name + ".zpkg")
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(metadata + text)
    bundle = compile_tree(root, mode="interface")
    (root / "bundle.json").write_text(json.dumps(bundle))
    for source in bundle["sources"]:
        if source["kind"] != "zpkg":
            continue
        for folder, field in (("interfaces", "compiledNix"), ("builds", "buildNix")):
            path = root / folder / (source["path"] + ".nix")
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(source[field])
    expression = f'''let
      pkgs = import <nixpkgs> {{}};
      inherit (pkgs) lib;
      adapter = import {ROOT}/lib/dsl-bundle.nix {{ inherit lib; }};
      interface = import {ROOT}/lib/interface.nix {{ inherit lib; }};
      bundle = builtins.fromJSON (builtins.readFile {root}/bundle.json);
      registry = adapter.registryFromBundle {{ inherit bundle; bundlePath = {root}; }};
      legacyPkgs = pkgs // {{
        "quoted.tool" = pkgs.writeShellScriptBin "quoted-command" "echo quoted";
        abortProvider = builtins.abort;
      }};
      finalPkgs = pkgs // {{ zenos = tree // {{
        tools.external = pkgs.writeShellScriptBin "external-command" "echo registry-external";
        tools.unused = builtins.abort "external sibling evaluated";
        legacy = builtins.abort "nonpinned legacy selected";
      }}; }};
      tree = interface.buildPackageTreeWith {{
        inherit legacyPkgs registry; pkgs = finalPkgs;
        buildPackage = entry: context: import entry.buildFile context;
      }};
      noeval = interface.buildPackageTreeWith {{
        inherit legacyPkgs registry; pkgs = finalPkgs;
        buildPackage = _: _: builtins.abort "interface executed builder";
      }};
      contextPackage = label: pkgs.runCommand "zpkg-lib-${{label}}" {{ }} ''
        mkdir -p "$out/bin"
        printf '#!${{pkgs.runtimeShell}}\\necho ${{label}}\\n' > "$out/bin/app"
        chmod +x "$out/bin/app"
      '';
      defaultLib = lib // {{
        customPackage = contextPackage "default-lib";
        makeBinPath = paths: lib.makeBinPath paths + ":/zpkg-default-lib-context";
        unused = builtins.abort "unused library member evaluated";
      }};
      explicitLib = defaultLib // {{
        customPackage = contextPackage "explicit-lib";
        makeBinPath = paths: lib.makeBinPath paths + ":/zpkg-explicit-lib-context";
      }};
      libraryCase = {{ packagePkgs, packageArgs ? {{ }}, helperLib ? lib }}:
        let
          selectedTree = (import {ROOT}/lib/interface.nix {{ lib = helperLib; }}).buildPackageTreeWith {{
            inherit legacyPkgs registry packageArgs;
            pkgs = packagePkgs;
          }};
          standaloneArgs = {{
            pkgs = packagePkgs // {{ zenos = packagePkgs.zenos // {{ legacy = legacyPkgs; }}; }};
          }} // lib.optionalAttrs (!(packagePkgs ? lib)) {{ lib = helperLib; }} // packageArgs;
        in lib.genAttrs [ "library" "library-runtime" ] (name: {{
          tree = selectedTree.apps.${{name}};
          standalone = import ({root}/builds/pkgs/apps + "/${{name}}.zpkg.nix") standaloneArgs;
        }});
    in {{
      docs = interface.registryDocs registry;
      shape = builtins.attrNames noeval.apps;
      toolShape = builtins.attrNames noeval.tools;
      package = tree.apps.tool;
      standalone = import {root}/builds/pkgs/apps/tool.zpkg.nix {{
        pkgs = finalPkgs // {{ zenos = finalPkgs.zenos // {{
          tools = finalPkgs.zenos.tools // tree.tools;
          legacy = legacyPkgs;
        }}; }};
      }};
      identity = tree.apps.inherited.drvPath == legacyPkgs."quoted.tool".drvPath;
      poison = tree.apps.poison;
      toolPoison = tree.tools.poison;
      libraryCases = {{
        default = libraryCase {{ packagePkgs = finalPkgs // {{ lib = defaultLib; }}; }};
        explicit = libraryCase {{
          packagePkgs = finalPkgs // {{ lib = defaultLib; }};
          packageArgs.lib = explicitLib;
        }};
        fallback = libraryCase {{
          packagePkgs = builtins.removeAttrs finalPkgs [ "lib" ];
          helperLib = defaultLib;
        }};
      }};
    }}'''
    context_file = root / "registry.nix"
    context_file.write_text(expression)
    docs = json.loads(run("nix-instantiate", "--eval", "--strict", "--json", str(context_file), "-A", "docs"))
    entries = {entry["id"]: entry for entry in docs["packages"]}
    imported = entries["pkgs.apps.inherited"]
    assert imported["sourcePath"] == ["quoted.tool"] and not imported["dependenciesDeclared"]
    assert "dependencies" not in imported["meta"]
    empty = entries["pkgs.apps.empty"]
    assert empty["dependenciesDeclared"] and empty["meta"]["dependencies"] == {"general": [], "build": [], "runtime": []}
    assert "sourcePath" not in empty
    assert entries["pkgs.apps.tool"]["meta"]["dependencies"]["general"][0] == {
        "namespace": "pkgs", "path": ["legacy", "quoted.tool"],
    }
    assert json.loads(run("nix-instantiate", "--eval", "--strict", "--json", str(context_file), "-A", "shape")) == ["empty", "inherited", "library", "library-runtime", "poison", "tool"]
    assert json.loads(run("nix-instantiate", "--eval", "--strict", "--json", str(context_file), "-A", "toolShape")) == ["generator", "poison"]
    assert json.loads(run("nix-instantiate", "--eval", "--strict", "--json", str(context_file), "-A", "identity"))
    path = run("nix-build", str(context_file), "-A", "package", "--no-out-link").strip()
    standalone = run("nix-build", str(context_file), "-A", "standalone", "--no-out-link").strip()
    assert path == standalone, "standalone compiler and tree backend differ"
    result = subprocess.run([path + "/bin/app"], env={"PATH": "/no-ambient-commands"}, text=True, capture_output=True)
    assert result.returncode == 0 and result.stdout == "quoted\nregistry-runtime\nregistry-external\n", (result.stdout, result.stderr)
    assert "sibling evaluated" in run("nix-build", str(context_file), "-A", "poison", "--no-out-link", success=False)
    assert "tool sibling evaluated" in run("nix-build", str(context_file), "-A", "toolPoison", "--no-out-link", success=False)
    print("PASS compiled registry: data-only interfaces, presence, quoted paths, pinned legacy, lazy same-branch siblings, existing and registered tools, executable callback", flush=True)
    for case, expected in (("default", "default-lib\n"), ("explicit", "explicit-lib\n"), ("fallback", "default-lib\n")):
        for provider in ("library", "library-runtime"):
            attribute = f"libraryCases.{case}.{provider}"
            standalone = run("nix-build", str(context_file), "-A", attribute + ".standalone", "--no-out-link").strip()
            package = run("nix-build", str(context_file), "-A", attribute + ".tree", "--no-out-link").strip()
            assert standalone == package, (attribute, "standalone/tree library context mismatch")
            result = subprocess.run([package + "/bin/app"], env={"PATH": "/no-ambient-commands"}, text=True, capture_output=True)
            assert result.returncode == 0 and result.stdout == expected, (attribute, result.stdout, result.stderr)
            print(f"PASS library context build/execute and standalone parity: {case}/{provider}", flush=True)


if __name__ == "__main__":
    main()
