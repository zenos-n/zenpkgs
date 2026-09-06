"""Integration tests: run only in the ZenOS VM with the pinned schema inputs."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

from zenlang import parse
from zenlang.compiler import compile_tree
from zenlang.schema_validation import SchemaContext, schema_requests, validate_zcfg


ROOT = Path(__file__).resolve().parents[3]


def request(path, *values):
    return [{"path": path}] + [
        {"path": path, "value": {"type": "literal", "value": value}}
        for value in values
    ]


@unittest.skipUnless(
    os.environ.get("ZEN_SCHEMA_NIXPKGS") and os.environ.get("ZEN_SCHEMA_HOME_MANAGER"),
    "set ZEN_SCHEMA_NIXPKGS and ZEN_SCHEMA_HOME_MANAGER inside the ZenOS VM",
)
class ConcreteSchemaQueryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temporary = tempfile.TemporaryDirectory(prefix="zen-schema-queries-")
        cls.addClassCleanup(cls.temporary.cleanup)
        cls.root = Path(cls.temporary.name)
        source = cls.root / "source"
        module = source / "modules/programs/demo.zmdl"
        module.parent.mkdir(parents=True)
        module.write_text('''
            port = {
                _meta = { type = $type.int; default = 8080; };
                s!! { warnings = [ ($lib.trivial.throwIf true "action forced") ]; };
            };
            instances = { (freeform instance) = {
                label._meta.type = (alias nixpkgs.networking.queryNames.($f.instance).label);
            }; };
        ''')
        (source / "structure.zstr").write_text('''
            system.programs._meta.type = (zmdl programs);
            system.packages._meta.type = (packages);
            users = { (freeform user) = {
                programs._meta.type = (zmdl programs);
                packages._meta.type = (packages);
                identity._meta.type = (alias nixpkgs.networking.queryNames.($f.user));
                legacy._meta.type = (alias nixpkgs.users.users.($f.user));
                legacy.homeManager._meta.type = (alias nixpkgs.home-manager.users.($f.user));
            }; };
            legacy._meta.type = (alias nixpkgs.networking);
        ''')
        bundle = cls.root / "bundle.json"
        bundle.write_text(json.dumps(compile_tree(source)))
        nixpkgs = os.environ["ZEN_SCHEMA_NIXPKGS"]
        home_manager = os.environ["ZEN_SCHEMA_HOME_MANAGER"]
        cls.prelude = f'''
            pkgs = import {nixpkgs} {{ system = "x86_64-linux"; }};
            inherit (pkgs) lib;
            bundle = import {ROOT}/lib/read-dsl-bundle.nix {bundle};
            runtime = import {ROOT}/lib/zstr-runtime.nix {{ inherit lib; }};
            export = import {ROOT}/lib/schema-validation.nix {{ inherit lib; }};
            packageTree = {{
              tools.demo = pkgs.hello;
              "a.b" = pkgs.hello;
              legacy = pkgs;
              unavailable = throw "selected package unavailable";
              unqueried = builtins.abort "unqueried package forced";
              notPackage = 42;
              absent = null;
              recursive = packageTree;
              deep.a.b.c.d = pkgs.hello;
            }};
            evaluate = mountedBundle: import ({nixpkgs} + "/nixos/lib/eval-config.nix") {{
              system = "x86_64-linux";
              modules = [ ({home_manager} + "/nixos")
                (runtime.moduleFromBundle {{ bundle = mountedBundle; inherit packageTree; }})
                ({{ lib, ... }}: {{ options.networking = {{
                  queryNames = lib.genAttrs [ "alice" "bob" "a.b" "one" "two" ] (name: {{
                    label = lib.mkOption {{ type = lib.types.enum [ name ]; }};
                  }});
                  queryRequired = lib.mkOption {{ type = lib.types.str; }};
                  queryPoison = lib.mkOption {{ type = lib.types.str; default = builtins.abort "default forced"; }};
                  queryUnavailable = lib.mkOption {{ type = throw "selected type unavailable"; }};
                  queryUnqueried = lib.mkOption {{ type = builtins.abort "unqueried option type forced"; }};
                  queryPositive = lib.mkOption {{ type = lib.types.addCheck lib.types.int (x: x > 0); }};
                  queryNested = lib.mkOption {{ type = lib.types.listOf (lib.types.addCheck lib.types.int (x: x > 0)); }};
                  queryFunction = lib.mkOption {{ type = lib.types.functionTo lib.types.str; }};
                  queryRecord = lib.mkOption {{ type = lib.types.attrs; }};
                  queryUnion = lib.mkOption {{ type = lib.types.either lib.types.attrs lib.types.str; }};
                  queryInts = lib.mkOption {{ type = lib.types.attrsOf lib.types.int; }};
                  guarded = lib.mkOption {{
                    type = lib.types.addCheck (lib.types.attrsOf lib.types.int) (value: !(value ? forbidden));
                  }};
                  guardedLazy = lib.mkOption {{
                    type = lib.types.addCheck (lib.types.lazyAttrsOf lib.types.int) (value: !(value ? forbidden));
                  }};
                  mergeGuarded = lib.mkOption {{
                    type = let collection = lib.types.attrsOf lib.types.int; in collection // {{
                      merge = loc: defs: let value = collection.merge loc defs; in
                        assert !(value ? left && value ? right); value;
                    }};
                  }};
                  queryCollection = lib.mkOption {{
                    type = lib.types.attrsOf (lib.types.submodule {{
                      options.port = lib.mkOption {{ type = lib.types.int; }};
                    }});
                  }};
                  queryInstances = lib.genAttrs [ "alice" "bob" "a.b" ] (_: lib.mkOption {{
                    type = lib.types.submoduleWith {{
                      specialArgs = {{ allowed = {{ alice = 3; bob = 7; "a.b" = 11; }}; }};
                      modules = [ ({{ name, allowed, ... }}: {{
                        options.limit = lib.mkOption {{
                          type = lib.types.addCheck lib.types.int (x: x == allowed.${{name}});
                        }};
                        options.required = lib.mkOption {{ type = lib.types.str; }};
                        options.poison = lib.mkOption {{ type = lib.types.str; default = builtins.abort "instance default forced"; }};
                        freeformType = lib.types.attrsOf (lib.types.enum [ name ]);
                      }}) ];
                    }};
                  }});
                }}; }})
              ];
            }};
            evaluated = evaluate bundle;
        '''

    def export(self, requests, *, arguments="", prelude="", expression=None, succeeds=True):
        requests_path = self.root / "requests.json"
        requests_path.write_text(json.dumps(requests))
        expression = expression or f"export {{ inherit evaluated bundle packageTree requests; {arguments} }}"
        result = subprocess.run(
            ["nix", "eval", "--impure", "--json", "--expr", f'''
                let {self.prelude}
                    requests = builtins.fromJSON (builtins.readFile {requests_path});
                    {prelude}
                in {expression}
            '''], capture_output=True, text=True, timeout=120,
        )
        if not succeeds:
            self.assertNotEqual(result.returncode, 0, result.stdout)
            return
        self.assertEqual(result.returncode, 0, result.stderr)
        return json.loads(result.stdout)

    def queries(self, requests, **kwargs):
        exported = self.export(requests, **kwargs)
        return {tuple(item["path"]): item for item in exported["queries"]}

    def assertChecks(self, query, statuses):
        self.assertEqual(query["status"], "found", query)
        self.assertEqual(query["node"]["kind"], "option", query)
        self.assertEqual([check["status"] for check in query["node"]["checks"]], statuses)

    def test_concrete_users_and_literal_dotted_keys(self):
        requests = []
        for name in ("alice", "bob", "a.b"):
            requests += request(["users", name, "identity", "label"], name, "wrong")
            requests += request(["users", name, "programs", "demo", "port"], 12, "wrong")
        queries = self.queries(requests)
        for query in queries.values():
            self.assertChecks(query, ["accepted", "rejected"])
        self.assertNotEqual(
            queries[("users", "alice", "identity", "label")]["node"]["annotation"],
            queries[("users", "bob", "identity", "label")]["node"]["annotation"],
        )

    def test_module_freeform_uses_each_actual_name(self):
        requests = []
        for name in ("one", "two", "a.b"):
            requests += request(["system", "programs", "demo", "instances", name, "label"], name, "wrong")
        for query in self.queries(requests).values():
            self.assertChecks(query, ["accepted", "rejected"])

    def test_upstream_submodule_special_args_and_name_dependent_freeform(self):
        requests = []
        for name, value in (("alice", 3), ("bob", 7), ("a.b", 11)):
            requests += request(["legacy", "queryInstances", name, "limit"], value, 7 if name == "alice" else 3)
            requests += request(["legacy", "queryInstances", name, "extra"], name, "wrong")
        for query in self.queries(requests).values():
            self.assertChecks(query, ["accepted", "rejected"])

    def test_direct_legacy_packages_and_derivation_leaf_boundaries(self):
        paths = [
            ["system", "packages", "legacy", "hello"],
            ["users", "a.b", "packages", "legacy", "hello"],
            ["system", "packages", "a.b"],
            ["system", "packages", "tools", "demo"],
        ]
        requests = [item for path in paths for item in request(path, True, False, "wrong", 1)]
        requests += request(paths[0] + ["outPath"])
        queries = self.queries(requests)
        for path in paths:
            self.assertChecks(queries[tuple(path)], ["accepted", "accepted", "rejected", "rejected"])
        self.assertEqual(queries[tuple(paths[0] + ["outPath"])]["status"], "missing")

    def test_missing_versus_unavailable_and_no_sibling_forcing(self):
        expected = {
            ("system", "packages", "legacy", "zenSchemaNoSuchPackage"): "missing",
            ("system", "packages", "unavailable"): "unsupported",
            ("system", "packages", "notPackage"): "unsupported",
            ("system", "packages", "absent"): "missing",
            ("legacy", "queryUnavailable"): "unsupported",
            ("legacy", "queryUnavailable", "child"): "unsupported",
            ("legacy", "queryFunction"): "unsupported",
            ("legacy", "queryRecord", "child"): "unsupported",
            ("legacy", "queryUnion", "child"): "unsupported",
            ("legacy", "zenSchemaNoSuchOption"): "missing",
            ("legacy", "queryRequired", "child"): "missing",
            ("legacy", "queryRequired"): "found",
            ("legacy", "queryPoison"): "found",
        }
        queries = self.queries([{"path": list(path)} for path in expected])
        self.assertEqual({path: query["status"] for path, query in queries.items()}, expected)
        for path, query in queries.items():
            if query["status"] == "unsupported":
                self.assertTrue(query.get("reason"), path)

    def test_real_user_nixos_and_home_manager_aliases(self):
        requests = request(["users", "a.b", "legacy", "isNormalUser"], True, "wrong")
        requests += request(["users", "a.b", "legacy", "homeManager", "programs", "git", "enable"], True, "wrong")
        for query in self.queries(requests).values():
            self.assertChecks(query, ["accepted", "rejected"])

    def test_literal_checks_keep_actual_upstream_constraints(self):
        path = ["legacy", "queryPositive"]
        nested = ["legacy", "queryNested"]
        requests = request(path, 3, -1)
        requests += [{"path": nested, "value": {"type": "list", "items": [
            {"type": "literal", "value": value},
        ]}} for value in (3, -1)]
        for query in self.queries(requests).values():
            self.assertChecks(query, ["accepted", "rejected"])

    def test_collection_checks_are_not_bypassed_by_dotted_requests(self):
        documents = [parse(text, "host.zcfg") for name in ("guarded", "guardedLazy") for text in (
            f"legacy.{name} = {{ forbidden = 1; }};",
            f"legacy.{name} = {{ allowed = 1; }};",
            f"legacy.{name}.forbidden = 1;",
            f"legacy.{name}.allowed = 1;",
        )]
        exported = self.export([item for document in documents for item in schema_requests(document)])
        queries = {tuple(query["path"]): query for query in exported["queries"]}
        for name in ("guarded", "guardedLazy"):
            self.assertChecks(queries[("legacy", name)], ["rejected", "accepted"])
            for key in ("forbidden", "allowed"):
                query = queries[("legacy", name, key)]
                self.assertEqual(query["status"], "unsupported", query)
                self.assertIn("record value", query["reason"])
        schema = SchemaContext.from_dict(exported)
        self.assertEqual(
            [validate_zcfg(document, schema).exit_code for document in documents],
            [1, 0, 2, 2] * 2,
        )

    def test_partial_collection_merge_cannot_be_certified_per_assignment(self):
        documents = [parse(text, "host.zcfg") for text in (
            "legacy.mergeGuarded = { left = 1; right = 2; };",
            "legacy.mergeGuarded = { left = 1; };",
            "legacy.mergeGuarded = { right = 2; };",
            "legacy.mergeGuarded.left = 1; legacy.mergeGuarded.right = 2;",
            "legacy.queryInts.allowed = 1;",
            "legacy.queryCollection.alice.port = 1;",
        )]
        exported = self.export([item for document in documents for item in schema_requests(document)])
        queries = {tuple(query["path"]): query for query in exported["queries"]}
        self.assertChecks(queries[("legacy", "mergeGuarded")], ["rejected", "accepted", "accepted"])
        for path in (
            ("legacy", "mergeGuarded", "left"), ("legacy", "mergeGuarded", "right"),
            ("legacy", "queryInts", "allowed"), ("legacy", "queryCollection", "alice", "port"),
        ):
            self.assertEqual(queries[path]["status"], "unsupported", queries[path])
        schema = SchemaContext.from_dict(exported)
        self.assertEqual(
            [validate_zcfg(document, schema).exit_code for document in documents],
            [1, 0, 0, 2, 2, 2],
        )

    def test_unique_exact_paths_keep_all_literals_and_path_only_checks_empty(self):
        path = ["system", "programs", "demo", "port"]
        requests = request(path, 3, "wrong", 3) + request(path)
        requests += request(["system", "programs", "demo", "enable"])
        exported = self.export(requests)
        self.assertEqual([query["path"] for query in exported["queries"]], [path, requests[-1]["path"]])
        self.assertChecks(exported["queries"][0], ["accepted", "rejected", "accepted"])
        self.assertChecks(exported["queries"][1], [])
        self.assertEqual(exported["root"]["kind"], "unsupported")

    def test_branch_queries_are_shallow_and_do_not_claim_unqueried_children(self):
        paths = [[], ["system"], ["system", "programs", "demo"], ["system", "packages", "legacy"]]
        queries = self.queries([{"path": path} for path in paths])
        for query in queries.values():
            self.assertEqual(query["status"], "found", query)
            self.assertEqual(query["node"]["kind"], "branch")
            self.assertEqual(query["node"]["children"], {})
            self.assertEqual(query["node"]["freeform"]["kind"], "unsupported")
        self.assertTrue(queries[("system", "programs", "demo")]["node"]["shorthand"])

    def test_mount_relocation_and_no_structure_exposure(self):
        original = ["system", "programs", "demo", "port"]
        moved = ["relocated", "demo", "port"]
        exported = self.export(request(original, 3) + request(moved, 3), prelude='''
            movedBundle = bundle // { structure = bundle.structure // {
              mounts = map (mount: if mount.path == [ "system" "programs" ]
                then mount // { path = [ "relocated" ]; } else mount) bundle.structure.mounts;
            }; };
        ''', expression='''export {
            evaluated = evaluate movedBundle; bundle = movedBundle;
            inherit packageTree requests;
        }''')
        self.assertEqual(exported["queries"][0]["status"], "missing")
        self.assertChecks(exported["queries"][1], ["accepted"])
        absent = self.export(request(original), expression='''export {
            bundle = { bundleVersion = "zenlang.bundle/2"; structure.present = false; };
            evaluated = throw "unmounted options forced";
            packageTree = throw "unmounted packages forced";
            inherit requests;
        }''')
        self.assertEqual(absent["root"], {"kind": "branch", "children": {}, "freeform": None})
        self.assertEqual(absent["queries"][0]["status"], "missing")

    def test_depth_limits_are_reported_and_can_be_raised(self):
        path = ["system", "packages", "deep", "a", "b", "c", "d"]
        self.assertEqual(self.queries(request(path))[tuple(path)]["status"], "unsupported")
        self.assertChecks(self.queries(request(path, True), arguments="packageDepth = 6;")[tuple(path)], ["accepted"])
        for arguments in ("maxDepth = 2;", "packageDepth = 0;", "maxDepth = 4; packageDepth = 64;"):
            query = self.queries(request(path), arguments=arguments)[tuple(path)]
            self.assertEqual(query["status"], "unsupported", arguments)
            self.assertIn("depth limit", query["reason"])

    def test_request_bounds_reject_instead_of_truncating(self):
        queries = self.export([{"path": [f"missing-{index}"]} for index in range(4096)])["queries"]
        self.assertEqual(len(queries), 4096)
        self.assertTrue(all(query["status"] == "missing" for query in queries))
        self.export([{"path": []}] * 4097, succeeds=False)
        self.assertEqual(self.export([{"path": ["x"] * 64}])["queries"][0]["status"], "missing")
        for requests in ([{"path": ["x"] * 65}], [{"path": [1]}], [{"path": "system"}], [{"path": [], "value": None}]):
            self.export(requests, succeeds=False)

    def test_no_request_export_remains_compatible_and_bounded(self):
        exported = self.export([], arguments="maxDepth = 2;")
        self.assertEqual(exported["queries"], [])
        self.assertEqual(exported["root"]["kind"], "branch")
        self.assertEqual(exported["root"]["children"]["system"]["kind"], "branch")
        self.assertEqual(exported["root"]["children"]["system"]["children"]["programs"]["kind"], "unsupported")


if __name__ == "__main__":
    unittest.main()
