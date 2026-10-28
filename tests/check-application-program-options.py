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
    if entry["name"] in ("instructionFile", "logDirectory", "downloadDirectory"):
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
    from zenlang import parse_file
    from zenlang.compiler import compile_zmdl_mount
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
                explicit_null = {"enable": True}
                for entry in catalog[application]:
                    assign(explicit_null, entry["name"], None)
                cases["explicitNull"] = explicit_null
                cases["recentTabs"] = values | {"tabSwitchingOrder": "recent"}
                empty = json.loads(json.dumps(values))
                for entry in catalog[application]:
                    if entry.get("maximumLength") is not None:
                        assign(empty, entry["name"], "")
                        for label, text in (("ascii", "x"), ("utf8", "é")):
                            limit = entry["maximumLength"]
                            valid = json.loads(json.dumps(values))
                            assign(valid, entry["name"], text * (limit // len(text.encode("utf-8"))))
                            cases[f"boundary_{label}_" + entry["name"]] = valid
                            invalid = json.loads(json.dumps(values))
                            assign(invalid, entry["name"], text * (limit // len(text.encode("utf-8")) + 1))
                            cases[f"invalid_{label}_" + entry["name"]] = invalid
                cases["emptyPreferences"] = empty
                for label, path in (("relative", "Downloads"), ("empty", ""), ("tilde", "~/Downloads")):
                    cases["invalid_download_" + label] = values | {"downloadDirectory": path}
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
  pkgs.zenos = {{ legacy = {{}}; byCategories.apps.ai.codex = "/codex";
    com.neg-zero.select-for-figma = "/figma"; }};
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
                def configured(tree, name):
                    for key in name.split("."):
                        tree = tree[key]
                    return tree

                null_assignments = next(iter(payload("explicitNull")["home"]["activation"].values()))["assignments"]
                assert null_assignments == []
                for entry in catalog[application]:
                    assert configured(results["explicitNull"]["cfg"], entry["name"]) is None
                    assert configured(results["enabledNull"]["cfg"], entry["name"]) is None
                    expected = configured(values, entry["name"])
                    if isinstance(entry["transform"], dict):
                        expected = entry["transform"][expected]
                    assert emitted[tuple(entry["key"])] == expected, entry["name"]
                assert emitted[("tab-switcher-mru",)] is False
                recent = next(iter(payload("recentTabs")["home"]["activation"].values()))["assignments"]
                assert next(item["value"] for item in recent if item["path"] == ["tab-switcher-mru"]) is True
                for name in cases:
                    if name.startswith("boundary_") or name == "emptyPreferences":
                        assert all(item["assertion"] for item in payload(name)["assertions"]), name
                        selected = next(iter(payload(name)["home"]["activation"].values()))["assignments"]
                        lowered = {tuple(item["path"]): item["value"] for item in selected}
                        for entry in catalog[application]:
                            if entry.get("maximumLength") is not None:
                                assert lowered[tuple(entry["key"])] == configured(cases[name], entry["name"])
            print(f"{application}: schema, defaults, bounds, disabled and shared actions passed", flush=True)


spec = importlib.util.spec_from_file_location("program_config", ROOT / "lib/program-config.py")
backend = importlib.util.module_from_spec(spec)
spec.loader.exec_module(backend)


class WritablePreferences(unittest.TestCase):
    @contextmanager
    def environment(self):
        with tempfile.TemporaryDirectory(prefix="zen-program-files-") as directory:
            with patch.dict(os.environ, {"HOME": directory, "XDG_CONFIG_HOME": directory + "/config",
                                         "XDG_DATA_HOME": directory + "/data"}):
                os.environ.pop("CODEX_HOME", None)
                yield Path(directory)

    @unittest.skipUnless(importlib.util.find_spec("tomlkit"), "tomlkit is supplied by the remote Nix check")
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

    def test_native_state_preserves_sessions_chromium_and_unselected_preferences(self):
        with self.environment() as home:
            target = home / "data/select-for-figma/state.json"
            target.parent.mkdir(parents=True)
            original = {"window-width": 1440, "open-files": [{"url": "https://figma.com/design/fixture"}],
                        "appearance": "dark", "restore-session": True, "zane-work-model": "keep-model"}
            target.write_text(json.dumps(original))
            chromium = target.parent / "chromium/Default/Cookies"
            chromium.parent.mkdir(parents=True)
            chromium.write_bytes(b"private-cookie-sentinel")
            electron = home / "config/figma-linux/settings.json"
            electron.parent.mkdir(parents=True)
            electron.write_text('{"old-electron-state":"untouched"}')
            preferences = {"application": "select-for-figma", "assignments": [
                {"path": ["restore-session"], "value": False},
                {"path": ["tab-switcher-mru"], "value": False},
                {"path": ["zane-chat-model"], "value": ""},
                {"path": ["zane-chat-effort"], "value": ""},
            ]}
            previous = target.read_text()
            backend.apply(preferences)
            actual = json.loads(target.read_text())
            self.assertEqual(actual["open-files"], original["open-files"])
            self.assertEqual(actual["window-width"], 1440)
            self.assertEqual(actual["appearance"], "dark")
            self.assertEqual(actual["zane-work-model"], "keep-model")
            self.assertIs(actual["restore-session"], False)
            self.assertIs(actual["tab-switcher-mru"], False)
            self.assertEqual(actual["zane-chat-model"], "")
            self.assertEqual(actual["zane-chat-effort"], "")
            self.assertEqual(chromium.read_bytes(), b"private-cookie-sentinel")
            self.assertEqual(electron.read_text(), '{"old-electron-state":"untouched"}')
            self.assertEqual(target.with_name("state.json.zenos-backup").read_text(), previous)
            self.assertEqual(target.stat().st_mode & 0o777, 0o600)
            before = target.stat().st_mtime_ns
            backup = target.with_name("state.json.zenos-backup").read_bytes()
            backend.apply(preferences)
            self.assertEqual(target.stat().st_mtime_ns, before)
            self.assertEqual(target.with_name("state.json.zenos-backup").read_bytes(), backup)

    def test_native_first_write_migrates_legacy_state_and_chromium_directory(self):
        with self.environment() as home:
            legacy = home / "data/figma-gtk"
            legacy.mkdir(parents=True)
            original = '{"restore-session":true,"open-files":["kept"],"window-width":1200}'
            (legacy / "state.json").write_text(original)
            chromium = legacy / "chromium/Default/Cookies"
            chromium.parent.mkdir(parents=True)
            chromium.write_bytes(b"legacy-cookies")
            (legacy / "unrelated.cache").write_text("cache-sentinel")
            backend.apply({"application": "select-for-figma", "assignments": [
                {"path": ["restore-session"], "value": False}]})
            current = home / "data/select-for-figma"
            actual = json.loads((current / "state.json").read_text())
            self.assertIs(actual["restore-session"], False)
            self.assertEqual(actual["open-files"], ["kept"])
            self.assertEqual(actual["window-width"], 1200)
            self.assertEqual((current / "chromium/Default/Cookies").read_bytes(), b"legacy-cookies")
            self.assertEqual((current / "unrelated.cache").read_text(), "cache-sentinel")
            self.assertEqual((current / "state.json.zenos-backup").read_text(), original)

    def test_existing_native_directory_takes_priority_over_legacy(self):
        with self.environment() as home:
            legacy = home / "data/figma-gtk"
            current = home / "data/select-for-figma"
            for directory, marker in ((legacy, "legacy"), (current, "current")):
                directory.mkdir(parents=True)
                (directory / "state.json").write_text(json.dumps({"session": marker}))
            original = (legacy / "state.json").read_bytes()
            backend.apply({"application": "select-for-figma", "assignments": [
                {"path": ["notifications"], "value": False}]})
            self.assertEqual(json.loads((current / "state.json").read_text())["session"], "current")
            self.assertEqual((legacy / "state.json").read_bytes(), original)

    def test_empty_assignments_do_not_create_or_migrate_state(self):
        with self.environment() as home:
            specification = {"application": "select-for-figma", "assignments": []}
            backend.apply(specification)
            self.assertFalse((home / "data").exists())
            legacy = home / "data/figma-gtk"
            legacy.mkdir(parents=True)
            (legacy / "state.json").write_text("not json")
            backend.apply(specification)
            self.assertEqual((legacy / "state.json").read_text(), "not json")
            self.assertFalse((home / "data/select-for-figma").exists())

    def test_invalid_native_state_is_not_overwritten(self):
        with self.environment() as home:
            target = home / "data/select-for-figma/state.json"
            target.parent.mkdir(parents=True)
            specification = {"application": "select-for-figma", "assignments": [
                {"path": ["restore-session"], "value": False}]}
            for contents in ("not json", "null", "[]", '"scalar"'):
                with self.subTest(contents=contents):
                    target.write_text(contents)
                    with self.assertRaises(ValueError):
                        backend.apply(specification)
                    self.assertEqual(target.read_text(), contents)
                    self.assertFalse(target.with_name("state.json.zenos-backup").exists())
            target.unlink()
            target.symlink_to("/nix/store/immutable-example/state.json")
            with self.assertRaisesRegex(ValueError, "immutable"):
                backend.apply(specification)
            backend.apply(specification | {"assignments": []})
            self.assertTrue(target.is_symlink())

    def test_native_state_uses_home_data_fallback_without_state_directory_override(self):
        with self.environment() as home:
            with patch.dict(os.environ, {"XDG_DATA_HOME": ""}):
                backend.apply({"application": "select-for-figma", "stateDirectory": str(home / "ignored"),
                               "assignments": [{"path": ["appearance"], "value": "system"}]})
            target = home / ".local/share/select-for-figma/state.json"
            self.assertEqual(json.loads(target.read_text()), {"appearance": "system"})
            self.assertFalse((home / "ignored").exists())
            self.assertFalse((home / "config").exists())

    def test_immutable_native_directory_does_not_consume_legacy_data(self):
        with self.environment() as home:
            legacy = home / "data/figma-gtk"
            legacy.mkdir(parents=True)
            (legacy / "state.json").write_text('{"session":"preserved"}')
            destination = home / "data/select-for-figma"
            destination.symlink_to("/nix/store/immutable-example", target_is_directory=True)
            with self.assertRaisesRegex(ValueError, "immutable"):
                backend.apply({"application": "select-for-figma", "assignments": [
                    {"path": ["notifications"], "value": False}]})
            self.assertEqual((legacy / "state.json").read_text(), '{"session":"preserved"}')
            self.assertTrue(destination.is_symlink())

    def test_running_native_or_legacy_app_blocks_writes_and_migration(self):
        names = ("io.github.doromiert.FigmaGtk", "io.github.doromiert.SelectForFigma")
        for owner in names:
            for existing_native in (False, True):
                with self.subTest(owner=owner, existing_native=existing_native), self.environment() as home:
                    legacy = home / "data/figma-gtk"
                    legacy.mkdir(parents=True)
                    (legacy / "state.json").write_text('{"session":"legacy"}')
                    (legacy / "Cookies").write_bytes(b"legacy-cookie-sentinel")
                    current = home / "data/select-for-figma"
                    if existing_native:
                        current.mkdir()
                        (current / "state.json").write_text('{"session":"native"}')
                    before = {path.relative_to(home): path.read_bytes()
                              for path in home.rglob("*") if path.is_file()}

                    def response(command, **kwargs):
                        self.assertEqual(command[0], "/test/gdbus")
                        self.assertIn("org.freedesktop.DBus.NameHasOwner", command)
                        self.assertIn(command[-1], names)
                        return subprocess.CompletedProcess(command, 0,
                            "(true,)" if command[-1] == owner else "(false,)", "")

                    with patch.object(backend.subprocess, "run", side_effect=response) as query:
                        with self.assertRaisesRegex(ValueError, "close Select"):
                            backend.apply({"application": "select-for-figma", "sessionBusCommand": "/test/gdbus",
                                           "assignments": [{"path": ["notifications"], "value": False}]})
                    self.assertIn(owner, [call.args[0][-1] for call in query.call_args_list])
                    self.assertEqual(before, {path.relative_to(home): path.read_bytes()
                                             for path in home.rglob("*") if path.is_file()})
                    self.assertEqual(current.exists(), existing_native)
                    self.assertTrue(legacy.is_dir())

    def test_closed_native_and_legacy_apps_allow_migration_and_write(self):
        with self.environment() as home:
            legacy = home / "data/figma-gtk"
            legacy.mkdir(parents=True)
            (legacy / "state.json").write_text('{"session":"preserved"}')
            with patch.object(backend.subprocess, "run", return_value=
                              subprocess.CompletedProcess([], 0, "(false,)\n", "")) as query:
                backend.apply({"application": "select-for-figma", "sessionBusCommand": "/test/gdbus",
                               "assignments": [{"path": ["notifications"], "value": False}]})
            self.assertEqual([call.args[0][-1] for call in query.call_args_list],
                             ["io.github.doromiert.FigmaGtk", "io.github.doromiert.SelectForFigma"])
            self.assertTrue(all(call.args[0][0] == "/test/gdbus" for call in query.call_args_list))
            self.assertEqual(json.loads((home / "data/select-for-figma/state.json").read_text()),
                             {"session": "preserved", "notifications": False})
            self.assertFalse(legacy.exists())

    def test_session_bus_failure_requires_offline_session_and_valid_response(self):
        for state in ("offline", "address", "runtime", "unexpected"):
            with self.subTest(state=state), self.environment() as home:
                runtime = home / "runtime"
                runtime.mkdir()
                environment = {"DBUS_SESSION_BUS_ADDRESS": "", "XDG_RUNTIME_DIR": str(runtime)}
                if state == "address":
                    environment["DBUS_SESSION_BUS_ADDRESS"] = "unix:path=/test/bus"
                if state == "runtime":
                    (runtime / "bus").touch()
                result = subprocess.CompletedProcess([], 0 if state == "unexpected" else 1,
                                                     "invalid response", "cannot connect")
                legacy = home / "data/figma-gtk"
                legacy.mkdir(parents=True)
                (legacy / "state.json").write_text('{"session":"preserved"}')
                specification = {"application": "select-for-figma", "sessionBusCommand": "/test/gdbus",
                                 "assignments": [{"path": ["notifications"], "value": False}]}
                with patch.dict(os.environ, environment), patch.object(backend.subprocess, "run", return_value=result):
                    if state == "offline":
                        backend.apply(specification)
                        self.assertFalse(legacy.exists())
                        self.assertIs(json.loads((home / "data/select-for-figma/state.json").read_text())["notifications"], False)
                    else:
                        with self.assertRaisesRegex(ValueError, "unexpected" if state == "unexpected" else "cannot check"):
                            backend.apply(specification)
                        self.assertEqual((legacy / "state.json").read_text(), '{"session":"preserved"}')
                        self.assertFalse((home / "data/select-for-figma").exists())

    def test_empty_preferences_do_not_query_session_bus(self):
        with self.environment() as home:
            with patch.object(backend.subprocess, "run") as query:
                backend.apply({"application": "select-for-figma", "sessionBusCommand": "/test/gdbus",
                               "assignments": []})
            query.assert_not_called()
            self.assertFalse((home / "data").exists())

    def test_missing_native_state_is_created_as_private_object(self):
        with self.environment() as home:
            backend.apply({"application": "select-for-figma", "assignments": [
                {"path": ["notifications"], "value": False}]})
            target = home / "data/select-for-figma/state.json"
            self.assertEqual(json.loads(target.read_text()), {"notifications": False})
            self.assertEqual(target.stat().st_mode & 0o777, 0o600)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--nixpkgs", type=Path)
    parser.add_argument("--writable-only", action="store_true")
    parser.add_argument("--codex-schema", type=Path)
    arguments = parser.parse_args()
    if not arguments.writable_only:
        if arguments.nixpkgs is None:
            parser.error("--nixpkgs is required unless --writable-only is selected")
        schema_checks(arguments.nixpkgs.resolve(), arguments.codex_schema)
    unittest.main(argv=[sys.argv[0]])
