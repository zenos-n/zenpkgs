"""Run in the ZenOS VM with ZEN_SCHEMA_NIXPKGS and ZEN_SCHEMA_HOME_MANAGER."""
import io
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from zenlang import parse
from zenlang.cli import main
from zenlang.compiler import compile_tree
from zenlang.model import GRAMMAR_VERSION, IR_VERSION, ZenLangError
from zenlang.schema_validation import (
    SCHEMA_ENCODING, SCHEMA_VERSION, SchemaContext, load_schema, validate_file,
    schema_requests, validate_zcfg,
)


ROOT = Path(__file__).resolve().parents[3]


def option(annotation, *, accepted=(), rejected=()):
    checks = []
    for status, values in (("accepted", accepted), ("rejected", rejected)):
        for value in values:
            request = schema_requests(parse(f"x = {value};", "host.zcfg"))[0]
            checks.append({"value": request["value"], "status": status})
    return {"kind": "option", "annotation": annotation, "checks": checks}


def branch(children=None, **kwargs):
    return {"kind": "branch", "children": children or {}, **kwargs}


def context(root):
    return {
        "encoding": SCHEMA_ENCODING, "schemaVersion": SCHEMA_VERSION,
        "grammarVersion": GRAMMAR_VERSION, "irVersion": IR_VERSION,
        "zenosVersion": SCHEMA_VERSION, "bundleDigest": "a" * 64, "root": root,
    }


class SchemaValidationTests(unittest.TestCase):
    def setUp(self):
        demo = branch({
            "enable": option("$type.bool", accepted=("true", "false")),
            "port": option("$type.int", accepted=("-3", "42"), rejected=('"wrong"', '"bad"')),
            "theme": option('$type.enum [ "dark" "light" ]', accepted=('"dark"',), rejected=('"pink"', "1.0.0")),
            "tags": option("$type.list [ $type.string ]", accepted=('[ "a" ]',), rejected=("[ 1 ]",)),
            "settings": option("$type.set [ $type.int ]", rejected=('{ count = "wrong"; }',)),
            "future": {"kind": "unsupported", "reason": "custom runtime type"},
        }, shorthand=True)
        scope = branch({
            "programs": branch({"demo": demo}),
            "packages": branch({"tools": branch({"demo": option("$type.bool", accepted=("true", "false"), rejected=("{ enable = true; }",))})}),
        })
        self.data = context(branch({"system": scope, "users": branch(freeform=scope)}))
        self.schema = SchemaContext.from_dict(self.data)

    def check(self, text):
        return validate_zcfg(parse(text, "host.zcfg"), self.schema)

    def test_mounted_paths_literals_and_module_shorthand(self):
        result = self.check('''
            _meta.zenosVersion = 1.0.0Na;
            system.programs.demo = { port = -3; theme = "dark"; tags = [ "a" ]; };
            users."a.b".programs.demo = false;
            system.packages.tools.demo = true;
        ''')
        self.assertEqual(result.exit_code, 0, result.diagnostics)

    def test_invalid_types_and_selectors(self):
        for text in (
            'system.programs.demo.port = "wrong";',
            'system.programs.demo.theme = "pink";',
            'system.programs.demo.theme = 1.0.0;',
            'system.programs.demo.tags = [ 1 ];',
            'system.programs.demo.settings = { count = "wrong"; };',
            'system.packages.tools.demo = { enable = true; };',
            'system.packages.tools = true;',
            'system.programs = true;',
        ):
            with self.subTest(text=text):
                self.assertEqual(self.check(text).diagnostics[-1].code, "ZEN502")

    def test_unknown_empty_branches_and_scalar_descendants(self):
        for text in (
            'programs.demo = true;', 'system.programs.missing = {};',
            'system.packages.tools.missing = false;',
            'system.programs.demo.port.child = 1;',
            'system.packages.tools.demo.enable = true;',
        ):
            with self.subTest(text=text):
                self.assertEqual(self.check(text).diagnostics[-1].code, "ZEN501")

    def test_condition_bodies_are_checked_without_executing_conditions(self):
        result = self.check('if false { system.programs.missing = true; };')
        self.assertEqual(result.exit_code, 1)
        result = self.check('if $cfg.system.programs.demo.enable or false { system.programs.demo.port = 1; };')
        self.assertEqual(result.exit_code, 2)
        result = self.check('if $cfg.system.programs.typo.enable or false { system.programs.demo.port = 1; };')
        self.assertFalse(result.valid)

    def test_unknown_values_dynamic_paths_and_unsupported_schema_are_incomplete(self):
        for text in (
            'system.programs.demo.port = $cfg.system.programs.demo.port;',
            'system.programs.demo.theme = "${$name}";',
            'system.programs.demo.future = 1;',
            'system.programs.demo.future.child = {};',
            '_let user: $type.string = "alex"; users.($v.user).programs.demo = true;',
        ):
            with self.subTest(text=text):
                self.assertEqual(self.check(text).exit_code, 2)

    def test_library_calls_are_never_executed_by_schema_checks(self):
        # The expression-policy owner can independently expand frontend forms.
        document = parse('system.programs.demo.port = $lib.anyFunction 1;', "host.zcfg", validate_semantics=False)
        with patch("subprocess.run", side_effect=AssertionError("validation executed a process")):
            self.assertEqual(validate_zcfg(document, self.schema).exit_code, 2)

    def test_partial_collection_does_not_claim_complete_inference(self):
        result = self.check('system.programs.demo.tags = [ "ok" $name ];')
        self.assertTrue(result.valid)
        self.assertFalse(result.complete)

    def test_new_literal_requires_fresh_runtime_checks(self):
        self.assertEqual(self.check('system.programs.demo.port = 99;').exit_code, 2)

    def test_requests_are_data_only_and_preserve_import_and_literal_shapes(self):
        document = parse('''
            system.programs.demo = { port = -3; theme = "dark"; };
            system.packages.tools.demo = true;
            system.programs.demo.tags = [ $name ];
        ''', "host.zcfg")
        with patch("subprocess.run", side_effect=AssertionError("request generation executed a process")):
            requests = schema_requests(document)
        self.assertTrue(any(item["path"] == ["system", "programs", "demo", "port"] and item["value"]["value"] == -3 for item in requests))
        self.assertFalse(any(item["path"][-1] == "tags" for item in requests))

    def test_schema_read_errors_are_diagnostics(self):
        with tempfile.TemporaryDirectory() as temporary:
            source = Path(temporary) / "schema.json"
            with self.assertRaises(ZenLangError) as caught:
                load_schema(source)
            self.assertEqual(caught.exception.diagnostic.code, "ZEN500")
            source.write_text("not JSON")
            with self.assertRaises(ZenLangError):
                load_schema(source)

    def test_import_locations_and_bound_import_not_mounted(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "child.zcfg").write_text('system.programs.nope = true;')
            host = root / "host.zcfg"
            host.write_text('_import "child.zcfg";')
            result = validate_file(host, self.schema)
            self.assertEqual(result.diagnostics[-1].span.source, str(root / "child.zcfg"))
            host.write_text('_import data = "child.zcfg"; system.programs.demo = true;')
            self.assertEqual(validate_file(host, self.schema).exit_code, 0)

    def test_versions_shapes_and_annotation_injection_fail_closed(self):
        for data in (
            [], {}, self.data | {"schemaVersion": "2.0.0"},
            self.data | {"zenosVersion": "2.0.0"},
            self.data | {"grammarVersion": "2.0.0"},
            self.data | {"irVersion": "2.0.0"},
            self.data | {"root": branch({"x": option("$type.int; extra = true")})},
            self.data | {"root": branch({"x": option("(packages)")})},
        ):
            with self.subTest(data=data), self.assertRaises(ZenLangError):
                SchemaContext.from_dict(data)

    def test_cli_checks_and_compile_does_not_write_invalid_output(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            schema = root / "schema.json"
            schema.write_text(json.dumps(self.data))
            host = root / "host.zcfg"
            output = root / "host.nix"
            output.write_text("existing output")
            host.write_text('system.programs.demo.port = "bad";')
            stdout, stderr = io.StringIO(), io.StringIO()
            self.assertEqual(main(["validate", str(host), "--schema", str(schema), "--diagnostic-format", "json"], stdout, stderr), 1)
            self.assertEqual(json.loads(stdout.getvalue())["diagnostics"][-1]["code"], "ZEN502")
            self.assertEqual(main(["compile", str(host), "--schema", str(schema), "-o", str(output)], io.StringIO(), io.StringIO()), 1)
            self.assertEqual(output.read_text(), "existing output")
            host.write_text('system.programs.demo.port = $cfg.system.programs.demo.port;')
            self.assertEqual(main(["check", str(host), "--schema", str(schema)], io.StringIO(), io.StringIO()), 2)
            host.write_text('system.programs.demo.port = 42;')
            self.assertEqual(main(["validate", str(host), "--schema", str(schema)], io.StringIO(), io.StringIO()), 0)
            self.assertEqual(load_schema(schema).bundle_digest, "a" * 64)
            requests = io.StringIO()
            self.assertEqual(main(["schema-requests", str(host)], requests, io.StringIO()), 0)
            self.assertEqual(json.loads(requests.getvalue())[0]["value"]["value"], 42)


@unittest.skipUnless(os.environ.get("ZEN_SCHEMA_NIXPKGS") and os.environ.get("ZEN_SCHEMA_HOME_MANAGER"), "set ZEN_SCHEMA_NIXPKGS and ZEN_SCHEMA_HOME_MANAGER inside the ZenOS VM")
class RuntimeSchemaExportTests(unittest.TestCase):
    def test_real_bundle_runtime_schema_delivery(self):
        with tempfile.TemporaryDirectory(prefix="zen-schema-export-") as temporary:
            root = Path(temporary)
            source = root / "source"
            module = source / "modules/programs/demo.zmdl"
            module.parent.mkdir(parents=True)
            module.write_text('''
                port = {
                    _meta = { type = $type.int; default = 8080; };
                    s!! { warnings = [ ($lib.trivial.throwIf true "action was evaluated") ]; };
                };
                theme._meta.type = $type.enum [ "dark" "light" ];
                tags._meta.type = $type.list [ $type.string ];
                settings._meta.type = $type.set [ $type.int ];
                instances = { (freeform instance) = { label._meta.type = $type.string; }; };
            ''')
            structure = source / "structure.zstr"
            structure.write_text('''
                system.programs._meta.type = (zmdl programs);
                system.packages._meta.type = (packages);
                system.count._meta.type = $type.int;
                users = { (freeform user) = {
                    programs._meta.type = (zmdl programs);
                    packages._meta.type = (packages);
                }; };
                legacy._meta.type = (alias nixpkgs.networking);
            ''')
            bundle = root / "bundle.json"
            bundle.write_text(json.dumps(compile_tree(source)))
            nixpkgs = os.environ["ZEN_SCHEMA_NIXPKGS"]
            home_manager = os.environ["ZEN_SCHEMA_HOME_MANAGER"]
            valid = (
                'system.programs.demo = true;',
                'system.programs.demo.port = 12;',
                'system.packages.tools.demo = false;',
                'users.alex.packages.tools.demo = true;',
                'system.count = 5;',
                'legacy.useDHCP = true;',
                'legacy.requiredForSchemaTest = "value";',
                'legacy.poisonousDefault = "overridden";',
                'legacy.unionForSchemaTest = 42;',
                'legacy.positiveForSchemaTest = 3;',
                'legacy.pathForSchemaTest = "/test";',
                'legacy.customConstraint = "abc";',
            )
            invalid = (
                'system.programs.demo.port = "bad";',
                'system.programs.demo.theme = "pink";',
                'system.programs.demo.theme = 1.0.0;',
                'system.programs.demo.tags = [ 1 ];',
                'system.programs.demo.settings = { count = "wrong"; };',
                'system.packages.tools.missing = true;',
                'users.alex.packages.tools.demo = "wrong";',
                'system.packages.tools.demo = { _type = "override"; priority = 1; content = true; };',
                'legacy.unknownOption = true;',
                'legacy.positiveForSchemaTest = -1;',
                'legacy.nestedConstraint = [ (-1) ];',
                'legacy.pathForSchemaTest = "./relative";',
                'legacy.customConstraint = "123";',
            )
            deferred = (
                'users.alex.programs.demo.theme = "dark";',
                'system.programs.demo.instances.one.label = "one";',
                'legacy.pathForSchemaTest = ./relative;',
                'legacy.brokenForSchemaTest = true;',
                'system.packages.legacy.hello = true;',
            )
            requests_file = root / "requests.json"
            requests_file.write_text(json.dumps([
                request for text in (*valid, *invalid, *deferred, 'relocated.demo.port = 42;')
                for request in schema_requests(parse(text, "host.zcfg"))
            ]))
            expression = f'''
                let
                  pkgs = import {nixpkgs} {{ system = "x86_64-linux"; }};
                  inherit (pkgs) lib;
                  bundle = builtins.fromJSON (builtins.readFile {bundle});
                  requests = builtins.fromJSON (builtins.readFile {requests_file});
                  packageTree = {{ tools.demo = pkgs.hello; legacy = throw "recursive legacy universe was forced"; }};
                  runtime = import {ROOT}/lib/zstr-runtime.nix {{ inherit lib; }};
                  evaluate = mountedBundle: import ({nixpkgs} + "/nixos/lib/eval-config.nix") {{
                    system = "x86_64-linux";
                    modules = [ ({home_manager} + "/nixos") (runtime.moduleFromBundle {{ bundle = mountedBundle; inherit packageTree; }})
                      ({{ lib, ... }}: {{ options.networking = {{
                        requiredForSchemaTest = lib.mkOption {{ type = lib.types.str; }};
                        poisonousDefault = lib.mkOption {{ type = lib.types.str; default = throw "default was evaluated"; }};
                        customConstraint = lib.mkOption {{ type = lib.types.strMatching "[a-z]+"; }};
                        pathForSchemaTest = lib.mkOption {{ type = lib.types.path; }};
                        unionForSchemaTest = lib.mkOption {{ type = lib.types.either lib.types.int lib.types.str; }};
                        positiveForSchemaTest = lib.mkOption {{ type = lib.types.addCheck lib.types.int (x: x > 0); }};
                        nestedConstraint = lib.mkOption {{ type = lib.types.listOf (lib.types.addCheck lib.types.int (x: x > 0)); }};
                        brokenForSchemaTest = lib.mkOption {{ type = throw "schema unavailable"; }};
                      }}; }})
                    ];
                  }};
                  evaluated = evaluate bundle;
                  movedBundle = bundle // {{ structure = bundle.structure // {{
                    mounts = map (mount: if mount.path == [ "system" "programs" ]
                      then mount // {{ path = [ "relocated" ]; }} else mount) bundle.structure.mounts;
                  }}; }};
                  export = import {ROOT}/lib/schema-validation.nix {{ inherit lib; }};
                in {{
                  mounted = export {{ inherit evaluated bundle packageTree requests; }};
                  absent = export {{
                    evaluated = throw "unmounted options forced";
                    bundle = {{ bundleVersion = "zenlang.bundle/2"; structure.present = false; sources = [ ]; modules = [ ]; }};
                    packageTree = throw "unmounted packages forced";
                  }};
                  bounded = export {{ inherit evaluated bundle packageTree; maxDepth = 2; }};
                  moved = export {{ evaluated = evaluate movedBundle; bundle = movedBundle; inherit packageTree requests; }};
                }}
            '''
            result = subprocess.run(["nix", "eval", "--impure", "--json", "--expr", expression], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            exported = json.loads(result.stdout)
            schema = SchemaContext.from_dict(exported["mounted"])
            schema_path = root / "schema.json"
            schema_path.write_text(json.dumps(exported["mounted"]))
            host = root / "host.zcfg"
            host.write_text('system.programs.demo.port = 12;')
            self.assertEqual(main(["validate", str(host), "--schema", str(schema_path)], io.StringIO(), io.StringIO()), 0)
            compiled = io.StringIO()
            self.assertEqual(main(["compile", str(host), "--schema", str(schema_path)], compiled, io.StringIO()), 0)
            self.assertIn("zenos", compiled.getvalue())
            host.write_text('legacy.positiveForSchemaTest = -1;')
            self.assertEqual(main(["validate", str(host), "--schema", str(schema_path)], io.StringIO(), io.StringIO()), 1)
            for text in valid:
                with self.subTest(text=text):
                    checked = validate_zcfg(parse(text, "host.zcfg"), schema)
                    self.assertEqual(checked.exit_code, 0, checked.diagnostics)
            for text in invalid:
                with self.subTest(text=text):
                    checked = validate_zcfg(parse(text, "host.zcfg"), schema)
                    self.assertEqual(checked.exit_code, 1, checked.diagnostics)
            absent = SchemaContext.from_dict(exported["absent"])
            self.assertEqual(validate_zcfg(parse('system.programs.demo = true;', "host.zcfg"), absent).diagnostics[-1].code, "ZEN501")
            for text in deferred:
                with self.subTest(text=text):
                    self.assertEqual(validate_zcfg(parse(text, "host.zcfg"), schema).exit_code, 2)
            bounded = SchemaContext.from_dict(exported["bounded"])
            self.assertEqual(validate_zcfg(parse('system.programs.demo = true;', "host.zcfg"), bounded).exit_code, 2)
            moved = SchemaContext.from_dict(exported["moved"])
            self.assertEqual(validate_zcfg(parse('system.programs.demo = true;', "host.zcfg"), moved).exit_code, 1)
            self.assertEqual(validate_zcfg(parse('relocated.demo.port = 42;', "host.zcfg"), moved).exit_code, 0)


if __name__ == "__main__":
    unittest.main()
