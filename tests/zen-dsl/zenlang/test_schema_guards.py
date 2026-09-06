"""Schema-pending frontend and exact-query checks; run only in the ZenOS VM."""
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from zenlang import parse, parse_file
from zenlang.model import GRAMMAR_VERSION, IR_VERSION, ZenLangError
from zenlang.schema_validation import (
    SCHEMA_ENCODING, SCHEMA_VERSION, SchemaContext, load_schema, schema_requests,
    validate_file, validate_zcfg,
)


def context(queries=None, root=None):
    data = {
        "encoding": SCHEMA_ENCODING, "schemaVersion": SCHEMA_VERSION,
        "zenosVersion": SCHEMA_VERSION, "grammarVersion": GRAMMAR_VERSION,
        "irVersion": IR_VERSION, "bundleDigest": "a" * 64,
        "root": root or {"kind": "unsupported", "reason": "unqueried schema coverage"},
    }
    if queries is not None:
        data["queries"] = queries
    return data


def found(path, annotation="$type.bool", values=()):
    checks = [
        {"value": schema_requests(parse(f"x = {value};", "host.zcfg"))[0]["value"], "status": status}
        for value, status in values
    ]
    return {"path": path.split("."), "status": "found", "node": {
        "kind": "option", "annotation": annotation, "checks": checks,
    }}


class SchemaGuardTests(unittest.TestCase):
    def setUp(self):
        self.data = context([
            found("system.enabled"), found("system.count", "$type.int"),
            found("system.result", values=(("true", "accepted"),)),
        ])
        self.schema = SchemaContext.from_dict(self.data)

    def check(self, guard, schema=None):
        document = parse(f"if {guard} {{ system.result = true; }};", "host.zcfg", defer_schema_guards=True)
        return validate_zcfg(document, schema or self.schema)

    def test_source_only_default_remains_strict(self):
        for guard in ("$cfg.system.enabled", "!$cfg.system.enabled", "($cfg.system).enabled"):
            with self.subTest(guard=guard), self.assertRaises(ZenLangError) as caught:
                parse(f"if {guard} {{ system.result = true; }};", "host.zcfg")
            self.assertEqual(caught.exception.diagnostic.code, "ZEN220")
        parse("if $cfg.system.count or false { system.result = true; };", "host.zcfg")

    def test_resolved_boolean_guards_remain_runtime_incomplete(self):
        for guard in (
            "$cfg.system.enabled", "!$cfg.system.enabled", "($cfg.system).enabled",
            "(($cfg).system).enabled", "($cfg.system.enabled)",
            "$cfg.system.enabled && true", "false || !$cfg.system.enabled",
            "$cfg.system.enabled or false", "!(($cfg.system).enabled or false)",
            "($cfg.system.count or 0) > 1", "$cfg.system.count == 1",
        ):
            with self.subTest(guard=guard):
                result = self.check(guard)
                self.assertEqual(result.exit_code, 2, result.diagnostics)
                self.assertTrue(result.valid)
                self.assertTrue(any(item.code == "ZEN503" for item in result.diagnostics))

    def test_resolved_integer_guards_fail_through_boolean_shapes(self):
        for guard in (
            "$cfg.system.count", "!$cfg.system.count", "($cfg.system).count",
            "$cfg.system.count && true", "false || $cfg.system.count",
            "$cfg.system.count or false", "!($cfg.system.count or false)",
            "($cfg.system.count && true) == false",
            "($cfg.system.count or false) == false",
        ):
            with self.subTest(guard=guard):
                result = self.check(guard)
                self.assertEqual(result.exit_code, 1, result.diagnostics)
                self.assertTrue(any(item.code == "ZEN502" for item in result.diagnostics))

    def test_scalar_comparison_defaults_in_source_only_and_pending_modes(self):
        for annotation, fallback, comparison in (
            ("string", '"localhost"', '== "localhost"'),
            ("string", '("localhost")', '!= "remote"'),
            ("string", '"${$name}"', '== "localhost"'),
            ("string", "$name", '== "localhost"'),
            ("int", "0", "> 1"),
            ("int", "(-1)", "<= 1"),
            ("float", "1.5", "> 1.0"),
            ("null", "null", "== null"),
            ("path", "./fallback", "== ./fallback"),
        ):
            schema = SchemaContext.from_dict(context([
                found("legacy.hostName", f"$type.{annotation}"),
                found("system.count", "$type.int", (("1", "accepted"),)),
            ]))
            source = f"if ($cfg.legacy.hostName or {fallback}) {comparison} {{ system.count = 1; }};"
            for pending in (False, True):
                with self.subTest(annotation=annotation, fallback=fallback, pending=pending):
                    document = parse(source, "host.zcfg", defer_schema_guards=pending)
                    result = validate_zcfg(document, schema)
                    self.assertEqual(result.exit_code, 2, result.diagnostics)

    def test_scalar_defaults_do_not_become_boolean_guards(self):
        for fallback in ('"localhost"', "$name", "0", "1.5", "null", "./fallback"):
            for guard in (
                f"$cfg.legacy.hostName or {fallback}",
                f"!($cfg.legacy.hostName or {fallback})",
                f"($cfg.legacy.hostName or {fallback}) && true",
                f"false || ($cfg.legacy.hostName or {fallback})",
            ):
                for pending in (False, True):
                    with self.subTest(guard=guard, pending=pending), self.assertRaises(ZenLangError) as caught:
                        parse(f"if {guard} {{ system.count = 1; }};", "host.zcfg", defer_schema_guards=pending)
                    self.assertEqual(caught.exception.diagnostic.code, "ZEN220")

    def test_string_enum_fallback_uses_scalar_kind_without_becoming_boolean(self):
        schema = SchemaContext.from_dict(context([
            found("system.mode", '$type.enum [ "dark" "light" ]'), self.data["queries"][2],
        ]))
        for guard in ('($cfg.system.mode or "dark") == "dark"', '$cfg.system.mode == "light"'):
            with self.subTest(guard=guard):
                result = self.check(guard, schema)
                self.assertEqual(result.exit_code, 2, result.diagnostics)
        for guard in ("$cfg.system.mode", "$cfg.system.mode or false"):
            with self.subTest(guard=guard):
                result = self.check(guard, schema)
                self.assertEqual(result.exit_code, 1, result.diagnostics)

    def test_scalar_default_type_mismatches_still_fail_schema_guards(self):
        for annotation, fallback, comparison in (
            ("int", '"localhost"', '== "localhost"'),
            ("string", "0", "> 1"),
            ("bool", '"localhost"', '== "localhost"'),
            ("string", "false", "== false"),
            ("bool", "0", "== 0"),
        ):
            with self.subTest(annotation=annotation, fallback=fallback):
                schema = SchemaContext.from_dict(context([
                    found("legacy.hostName", f"$type.{annotation}"), self.data["queries"][2],
                ]))
                result = self.check(f"($cfg.legacy.hostName or {fallback}) {comparison}", schema)
                self.assertEqual(result.exit_code, 1, result.diagnostics)
                self.assertTrue(any(item.code == "ZEN502" for item in result.diagnostics))

    def test_unknown_scalar_defaults_are_not_assumed_compatible(self):
        for fallback in ("$lib.unknown", "$cfg.legacy.($name)"):
            source = f'if ($cfg.legacy.hostName or {fallback}) == "localhost" {{ system.count = 1; }};'
            parse(source, "host.zcfg")
            with self.subTest(fallback=fallback), self.assertRaises(ZenLangError) as caught:
                parse(source, "host.zcfg", defer_schema_guards=True)
            self.assertEqual(caught.exception.diagnostic.code, "ZEN220")

    def test_pending_never_loosens_invalid_source_shapes(self):
        for guard in (
            "!1", "$cfg.system.enabled && 1", "1 || $cfg.system.enabled",
            "$cfg.system.enabled or 1", "$cfg.system.enabled && $name",
            "$cfg.system.enabled || $v.count", "$lib.anyFunction $cfg.system.enabled",
            "$cfg.system.($name)", "($cfg.system.enabled && $v.count) == true",
        ):
            with self.subTest(guard=guard), self.assertRaises(ZenLangError):
                parse(f'_let count: $type.int = 1; if {guard} {{ system.result = true; }};', "host.zcfg", defer_schema_guards=True)

    def test_pending_keeps_non_guard_semantic_validation(self):
        for source in (
            "_let count: $type.int = true; if $cfg.system.enabled { x = 1; };",
            "if $cfg.system.enabled { x = $v.missing; };",
            "if $cfg.system.enabled { x = 1 + 2; };",
            "if $cfg.system.enabled { x = $lib.anyFunction 1; };",
        ):
            with self.subTest(source=source), self.assertRaises(ZenLangError):
                parse(source, "host.zcfg", defer_schema_guards=True)
        with self.assertRaises(ZenLangError):
            parse("value = enableOption { s![ $cfg.system.enabled ] { x = true; }; };", "module.zmdl", defer_schema_guards=True)

    def test_recursive_imports_use_pending_mode_and_keep_locations(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            host, child, leaf = (root / name for name in ("host.zcfg", "child.zcfg", "leaf.zcfg"))
            host.write_text('_import "child.zcfg";')
            child.write_text('_import "leaf.zcfg";')
            leaf.write_text("if $cfg.system.enabled { system.result = true; };")
            with self.assertRaises(ZenLangError):
                parse_file(host)
            self.assertEqual(validate_file(host, self.schema).exit_code, 2)
            requests = schema_requests(parse_file(host, defer_schema_guards=True))
            self.assertIn({"path": ["system", "enabled"]}, requests)
            leaf.write_text("if $cfg.system.count { system.result = true; };")
            result = validate_file(host, self.schema)
            self.assertEqual(result.exit_code, 1)
            self.assertTrue(any(item.code == "ZEN502" and item.span.source == str(leaf) for item in result.diagnostics))
            leaf.write_text("if $cfg.system.enabled && 1 { system.result = true; };")
            with self.assertRaises(ZenLangError):
                parse_file(host, defer_schema_guards=True)

    def test_bound_import_guards_are_checked_without_mounting_values(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            child, host = root / "child.zcfg", root / "host.zcfg"
            child.write_text("if $cfg.system.count { unmounted = true; };")
            host.write_text('_import data = "child.zcfg"; system.result = true;')
            document = parse_file(host, defer_schema_guards=True)
            self.assertFalse(any(item["path"] == ["unmounted"] for item in schema_requests(document)))
            self.assertEqual(validate_zcfg(document, self.schema).exit_code, 1)

    def test_grouped_assignment_guard_is_checked(self):
        document = parse("system = ({ if $cfg.system.count { result = true; }; });", "host.zcfg", defer_schema_guards=True)
        self.assertTrue(any(item.code == "ZEN502" for item in validate_zcfg(document, self.schema).diagnostics))

    def test_exact_queries_override_legacy_root(self):
        root = {"kind": "branch", "children": {"system": {"kind": "unsupported", "reason": "poisonous sibling"}}}
        schema = SchemaContext.from_dict(self.data | {"root": root})
        self.assertEqual(self.check("$cfg.system.enabled", schema).exit_code, 2)
        missing = SchemaContext.from_dict(context([
            {"path": ["system", "enabled"], "status": "missing"}, self.data["queries"][2],
        ], root={"kind": "branch", "children": {"system": {"kind": "branch", "children": {"enabled": found("enabled")["node"]}}}}))
        result = self.check("$cfg.system.enabled", missing)
        self.assertEqual(result.exit_code, 1)
        self.assertTrue(any(item.code == "ZEN501" for item in result.diagnostics))

    def test_unsupported_and_unqueried_never_claim_success(self):
        for extra in (
            [], [{"path": ["system", "enabled"], "status": "unsupported", "reason": "unavailable"}],
            [{"path": ["system", "enabled"], "status": "found", "node": {"kind": "unsupported", "reason": "unavailable"}}],
        ):
            with self.subTest(extra=extra):
                schema = SchemaContext.from_dict(context([self.data["queries"][2], *extra]))
                self.assertEqual(self.check("$cfg.system.enabled", schema).exit_code, 2)

    def test_unavailable_default_type_remains_incomplete(self):
        self.assertEqual(self.check("$cfg.system.enabled or $cfg.system.unknown").exit_code, 2)

    def test_branch_and_unknown_union_guard_types(self):
        for node, expected in (
            ({"kind": "branch", "children": {}}, 1),
            (found("x", "$type.either [ $type.bool $type.int ]")["node"], 2),
        ):
            schema = SchemaContext.from_dict(context([
                {"path": ["system", "enabled"], "status": "found", "node": node},
                self.data["queries"][2],
            ]))
            self.assertEqual(self.check("$cfg.system.enabled", schema).exit_code, expected)

    def test_legacy_schema1_context_without_queries_still_works(self):
        root = {"kind": "branch", "children": {"system": {"kind": "branch", "children": {
            item["path"][-1]: item["node"] for item in self.data["queries"]
        }}}}
        legacy = SchemaContext.from_dict(context(root=root))
        self.assertEqual(self.check("$cfg.system.enabled", legacy).exit_code, 2)
        self.assertEqual(self.check("$cfg.system.count or false", legacy).exit_code, 1)

    def test_requests_include_nonliteral_targets_and_full_grouped_references(self):
        document = parse('''
            system = { result = $cfg.system.enabled; tags = [ $name ]; };
            if (($cfg).users)."a.b".enabled { system.count = 3; };
            _let flag: $type.bool = ($cfg.system).enabled;
        ''', "host.zcfg", defer_schema_guards=True)
        requests = schema_requests(document)
        for path in (
            ["system"], ["system", "result"], ["system", "tags"],
            ["system", "count"], ["system", "enabled"], ["users", "a.b", "enabled"],
        ):
            self.assertIn({"path": path}, requests)
        self.assertNotIn({"path": ["users"]}, requests)
        self.assertNotIn({"path": []}, requests)

    def test_literal_order_multiple_values_and_checks_are_preserved(self):
        document = parse("system.count = 1; if false { system.count = 2; };", "host.zcfg")
        requests = schema_requests(document)
        self.assertEqual(requests[0]["value"]["value"], 1)
        self.assertEqual([item["value"]["value"] for item in requests if "value" in item], [1, 2])
        self.assertEqual(requests.count({"path": ["system", "count"]}), 1)
        schema = SchemaContext.from_dict(context([found("system.count", "$type.int", (("1", "accepted"), ("2", "rejected")))]))
        self.assertEqual(validate_zcfg(document, schema).exit_code, 1)

    def test_requests_are_bounded_by_count_path_depth_and_bytes(self):
        document = parse("x = $name; y = $name;", "host.zcfg")
        with self.assertRaises(ZenLangError):
            schema_requests(document, max_requests=1)
        for count in (0, -1, 4097, True):
            with self.subTest(count=count), self.assertRaises(ZenLangError):
                schema_requests(document, max_requests=count)
        with patch("zenlang.schema_validation.MAX_SCHEMA_BYTES", 16), self.assertRaises(ZenLangError):
            schema_requests(document)
        for depth in (64, 65):
            deep = parse(".".join(["x"] * depth) + " = true;", "host.zcfg")
            if depth == 64:
                self.assertTrue(schema_requests(deep))
            else:
                with self.assertRaises(ZenLangError):
                    schema_requests(deep)

    def test_invalid_query_shapes_fail_closed(self):
        for queries in (
            None, {}, [None], [{"path": "x", "status": "missing"}],
            [{"path": [1], "status": "missing"}], [{"path": ["x"] * 65, "status": "missing"}],
            [{"path": ["x"], "status": "accepted"}], [{"path": ["x"], "status": "found"}],
            [{"path": ["x"], "status": "unsupported", "reason": 1}],
            [found("x"), found("x")], [found("x", "$type.int; injected = true")],
            [{"path": [str(i)], "status": "missing"} for i in range(4097)],
        ):
            with self.subTest(queries=str(queries)[:100]), self.assertRaises(ZenLangError) as caught:
                SchemaContext.from_dict(self.data | {"queries": queries})
            self.assertEqual(caught.exception.diagnostic.code, "ZEN500")

    def test_schema_json_size_limit_applies_to_file_and_dict(self):
        with patch("zenlang.schema_validation.MAX_SCHEMA_BYTES", 16):
            with self.assertRaises(ZenLangError):
                SchemaContext.from_dict(self.data)
            with tempfile.TemporaryDirectory() as temporary:
                path = Path(temporary) / "schema.json"
                path.write_text(json.dumps(self.data))
                with self.assertRaises(ZenLangError) as caught:
                    load_schema(path)
                self.assertEqual(caught.exception.diagnostic.code, "ZEN500")

    def test_static_checks_never_execute_expressions(self):
        with patch("subprocess.run", side_effect=AssertionError("executed source")):
            self.assertEqual(self.check("$cfg.system.enabled").exit_code, 2)
            schema_requests(parse("x = $cfg.system.count;", "host.zcfg"))


if __name__ == "__main__":
    unittest.main()
