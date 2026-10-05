"""Lightweight schema/lowering and writable-state checks; no VM or API calls."""

import argparse
from contextlib import contextmanager
import importlib.util
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "lib/zen-dsl"))
from zenlang import parse_file
from zenlang.compiler import compile_zmdl_mount


def assign(tree, name, value):
    keys = name.split(".")
    for key in keys[:-1]:
        tree = tree.setdefault(key, {})
    tree[keys[-1]] = value


def sample(entry):
    kind = entry["type"]
    if "$type.enum" in kind:
        return re.findall(r'"([^"]+)"', kind)[0]
    if "$type.list" in kind:
        return []
    if "$type.set" in kind:
        return {}
    if "$type.boolean" in kind:
        return False
    if "$type.int" in kind:
        return max(10, entry.get("minimum") or 0)
    if entry["name"] in ("instructionFile", "logDirectory", "exportDirectory"):
        return "/tmp/example"
    if "reasoningEffort" in entry["name"] or "ReasoningEffort" in entry["name"]:
        return "high"
    return "example"


NORMALIZE = r'''
  normalize = value:
    if builtins.isList value then map normalize value else
    if !builtins.isAttrs value then value else
    if (value._type or "") == "if" then (if value.condition then normalize value.content else null) else
    if (value._type or "") == "override" then normalize value.content else
    if (value._type or "") == "merge" then merge (map normalize value.contents) else
    lib.filterAttrs (_: item: item != null) (lib.mapAttrs (_: normalize) value);
  merge = values: lib.foldl' lib.recursiveUpdate {} (builtins.filter (v: v != null) values);
'''


def schema_checks(nixpkgs, codex_schema):
    catalog = json.loads((ROOT / "tests/fixtures/application-program-options.json").read_text())
    with tempfile.TemporaryDirectory(prefix="zen-program-schema-") as temporary:
        directory = Path(temporary)
        for application in ("codex", "select-for-figma"):
            compiled = directory / "module.nix"
            compiled.write_text(compile_zmdl_mount(
                parse_file(ROOT / "modules/programs" / f"{application}.zmdl"), root=ROOT
            ))
            subprocess.run(["nix-instantiate", "--parse", str(compiled)], check=True,
                           stdout=subprocess.DEVNULL)
            values = {"enable": True}
            for entry in catalog[application]:
                assign(values, entry["name"], sample(entry))
            if application == "codex":
                values.update({
                    "providers": {"example": {"displayName": "Example", "apiUrl": "http://localhost:11434/v1",
                        "apiKeyVariable": "EXAMPLE_API_KEY", "useOpenAiLogin": False}},
                    "toolServers": {"docs": {"serverUrl": "https://developers.openai.com/mcp", "enable": False,
                        "allowedTools": [], "startupTimeoutSeconds": 10}},
                    "profiles": {"example": {"model": "example", "answerDetail": "low"}},
                    "agentRoles": {"reviewer": {"purpose": "Review changes", "configurationFile": "/tmp/reviewer.toml"}},
                })
            cases = {"defaults": {}, "enabledNull": {"enable": True}, "sample": values,
                     "disabled": values | {"enable": False}}
            for entry in catalog[application]:
                if entry.get("minimum") is not None:
                    invalid = json.loads(json.dumps(values))
                    assign(invalid, entry["name"], entry["minimum"] - 1)
                    cases["invalid_" + entry["name"]] = invalid
            if application == "codex":
                cases["conflictingServer"] = values | {"toolServers": {"bad": {"command": "server", "serverUrl": "https://example.com"}}}
                cases["reservedRole"] = values | {"agentRoles": {"enabled": {"purpose": "invalid"}}}
            else:
                cases["browserSwitches"] = values | {"browserArguments": ["--enable-gpu-rasterization", "--custom-value=a=b"]}
            wrong_enums = []
            for entry in catalog[application]:
                if "$type.enum" in entry["type"]:
                    invalid = {}
                    assign(invalid, entry["name"], "INVALID_ENUM")
                    wrong_enums.append(invalid)
            (directory / "wrong-enums.json").write_text(json.dumps(wrong_enums))
            (directory / "cases.json").write_text(json.dumps(cases))
            expression = f'''let
  lib = import {nixpkgs}/lib;
  cases = builtins.fromJSON (builtins.readFile {directory}/cases.json);
  runtimeLib = lib // {{ mkWritableProgramConfig = arguments: arguments; }};
  pkgs.zenos = {{ legacy = {{}}; apps.ai.codex = "/codex";
    apps.graphics.select-for-figma = "/figma"; }};
  make = cfg: user: import {compiled} {{ lib = runtimeLib; inherit cfg user pkgs; config = {{}}; }};
  schema = (make {{}} null).schema;
{NORMALIZE}
  run = values: let
    cfg = (lib.evalModules {{ modules = [ schema {{ config = values; }} ]; }}).config;
    mounted = make cfg "tester";
  in {{ inherit cfg; actions = normalize (merge mounted.actions);
    shared = normalize (merge (make cfg null).actions); }};
  rejected = values: !(builtins.tryEval (builtins.deepSeq
    (lib.evalModules {{ modules = [ schema {{ config = values; }} ]; }}).config true)).success;
in assert builtins.all rejected (builtins.fromJSON (builtins.readFile {directory}/wrong-enums.json));
  lib.mapAttrs (_: run) cases
'''
            check = directory / "check.nix"
            check.write_text(expression)
            result = subprocess.run(["nix-instantiate", "--eval", "--strict", "--json", str(check)],
                                    check=True, capture_output=True, text=True, timeout=60)
            results = json.loads(result.stdout)

            def payload(case):
                return results[case]["actions"].get("home-manager", {}).get("users", {}).get("tester", {})

            assert payload("defaults") == {} and payload("disabled") == {}
            assert payload("enabledNull")["home"]["packages"] == ["/codex" if application == "codex" else "/figma"]
            activation = next(iter(payload("sample")["home"]["activation"].values()))
            assignments = activation["assignments"]
            empty = next(iter(payload("enabledNull")["home"]["activation"].values()))
            assert empty["assignments"] == []
            assert results["sample"]["shared"]["home-manager"]["sharedModules"][0]["config"] == payload("sample")
            assert all(item["assertion"] for item in payload("sample")["assertions"])
            assert len({tuple(item["path"]) for item in assignments}) == len(assignments)
            emitted = {tuple(item["path"]): item["value"] for item in assignments}
            for entry in catalog[application]:
                assert tuple(entry["key"]) in emitted, entry["name"]
            for name in cases:
                if name.startswith("invalid_") or name in ("conflictingServer", "reservedRole"):
                    assert not all(item["assertion"] for item in payload(name)["assertions"]), name
            if application == "codex":
                assert emitted[("approval_policy",)] == "on-request"
                assert emitted[("sandbox_mode",)] == "read-only"
                assert emitted[("history", "persistence")] == "none"
                assert emitted[("shell_environment_policy", "set")] == {}
                assert emitted[("tui", "status_line")] == []
                assert emitted[("tui", "disable_paste_burst")] is True
                assert emitted[("model_providers", "example", "env_key")] == "EXAMPLE_API_KEY"
                assert emitted[("mcp_servers", "docs", "enabled_tools")] == []
                document = {}
                for assignment in assignments:
                    target = document
                    for key in assignment["path"][:-1]:
                        target = target.setdefault(key, {})
                    target[assignment["path"][-1]] = assignment["value"]
                if codex_schema:
                    import jsonschema
                    jsonschema.validate(document, json.loads(codex_schema.read_text()))
            else:
                assert emitted[("app", "disableThemes")] is True
                assert emitted[("app", "logLevel")] == 0
                assert emitted[("app", "commandSwitches")] == []
                switches = next(iter(payload("browserSwitches")["home"]["activation"].values()))["assignments"]
                assert next(item["value"] for item in switches if item["path"] == ["app", "commandSwitches"]) == [
                    {"switch": "enable-gpu-rasterization"}, {"switch": "custom-value", "value": "a=b"}]
            print(f"{application}: schema, defaults, bounds, disabled and shared actions passed", flush=True)


spec = importlib.util.spec_from_file_location("program_config", ROOT / "lib/program-config.py")
backend = importlib.util.module_from_spec(spec)
spec.loader.exec_module(backend)


class WritablePreferences(unittest.TestCase):
    @contextmanager
    def environment(self):
        with tempfile.TemporaryDirectory(prefix="zen-program-files-") as directory:
            with patch.dict(os.environ, {"HOME": directory, "XDG_CONFIG_HOME": directory + "/config"}):
                os.environ.pop("CODEX_HOME", None)
                yield Path(directory)

    def test_toml_preserves_comments_state_and_explicit_empty_values(self):
        with self.environment() as home:
            directory = home / ".codex"
            directory.mkdir()
            target = directory / "config.toml"
            target.write_text('# user comment\nmodel = "old"\n[projects."/work"]\ntrust_level = "trusted"\n'
                              '[shell_environment_policy]\nset = { LANG = "C" }\n')
            auth = directory / "auth.json"
            auth.write_text('{"sentinel":"private-runtime-state"}')
            original = target.read_text()
            preferences = {"application": "codex", "assignments": [
                {"path": ["model"], "value": "new"},
                {"path": ["model_post_turn_compact_threshold_percent"], "value": 0},
                {"path": ["analytics", "enabled"], "value": False},
                {"path": ["shell_environment_policy", "set"], "value": {}},
                {"path": ["tui", "status_line"], "value": []},
            ]}
            backend.apply(preferences)
            import tomllib
            actual = tomllib.loads(target.read_text())
            self.assertIn('# user comment', target.read_text())
            self.assertEqual(actual["projects"]["/work"]["trust_level"], "trusted")
            self.assertEqual(actual["model_post_turn_compact_threshold_percent"], 0)
            self.assertIs(actual["analytics"]["enabled"], False)
            self.assertEqual(actual["shell_environment_policy"]["set"], {})
            self.assertEqual(actual["tui"]["status_line"], [])
            self.assertEqual(auth.read_text(), '{"sentinel":"private-runtime-state"}')
            backup = target.with_name(target.name + ".zenos-backup")
            self.assertEqual(backup.read_text(), original)
            self.assertEqual(target.stat().st_mode & 0o777, 0o600)
            self.assertEqual(backup.stat().st_mode & 0o777, 0o600)
            before = target.stat().st_mtime_ns
            backend.apply(preferences)
            self.assertEqual(target.stat().st_mtime_ns, before)

    def test_json_preserves_session_and_sibling_preferences(self):
        with self.environment() as home:
            target = home / "config/figma-linux/settings.json"
            target.parent.mkdir(parents=True)
            original = {"clientId": "sentinel", "authedUserIDs": ["kept"],
                        "app": {"windowsState": {"1": {"x": 12}}, "saveLastOpenedTabs": True},
                        "ui": {"scalePanel": 1}}
            target.write_text(json.dumps(original))
            backend.apply({"application": "select-for-figma", "assignments": [
                {"path": ["app", "saveLastOpenedTabs"], "value": False},
                {"path": ["app", "fontDirs"], "value": []},
                {"path": ["ui", "scaleFigmaUI"], "value": 1.5},
            ]})
            actual = json.loads(target.read_text())
            self.assertEqual(actual["clientId"], original["clientId"])
            self.assertEqual(actual["authedUserIDs"], original["authedUserIDs"])
            self.assertEqual(actual["app"]["windowsState"], original["app"]["windowsState"])
            self.assertIs(actual["app"]["saveLastOpenedTabs"], False)
            self.assertEqual(actual["app"]["fontDirs"], [])
            self.assertEqual(actual["ui"], {"scalePanel": 1, "scaleFigmaUI": 1.5})

    def test_invalid_file_immutable_symlink_and_null_are_not_overwritten(self):
        with self.environment() as home:
            target = home / "config/figma-linux/settings.json"
            target.parent.mkdir(parents=True)
            target.write_text("not json")
            specification = {"application": "select-for-figma", "assignments": [
                {"path": ["app", "saveLastOpenedTabs"], "value": False}]}
            with self.assertRaises(ValueError):
                backend.apply(specification)
            self.assertEqual(target.read_text(), "not json")
            target.unlink()
            target.symlink_to("/nix/store/immutable-example/settings.json")
            with self.assertRaisesRegex(ValueError, "immutable"):
                backend.apply(specification)
            backend.apply(specification | {"assignments": []})
            self.assertTrue(target.is_symlink())


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--nixpkgs", type=Path, required=True)
    parser.add_argument("--codex-schema", type=Path)
    arguments = parser.parse_args()
    schema_checks(arguments.nixpkgs.resolve(), arguments.codex_schema)
    unittest.main(argv=[sys.argv[0]])
