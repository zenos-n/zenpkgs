"""Bounded, data-only checks for the compiled catalog's identity contract."""
import copy
import importlib.util
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location("catalog_check", Path(__file__).with_name("package-catalog-check.py"))
catalog = importlib.util.module_from_spec(spec)
spec.loader.exec_module(catalog)


def record(identity="org.example.tool", category=None):
    return {"id": "pkgs." + identity, "target": identity.split("."),
            "categoryTarget": category or ["apps", "tools", "tool"],
            "meta": {"id": identity}}


class PackageIdentityTests(unittest.TestCase):
    def reject(self, records):
        with self.assertRaises((AssertionError, KeyError, TypeError)):
            catalog.validate_records(records)

    def test_canonical_id_independent_of_category(self):
        entry = record()
        catalog.validate_records([entry])
        moved = copy.deepcopy(entry)
        moved["categoryTarget"] = ["dev", "utilities", "tool"]
        catalog.validate_records([moved])
        self.assertEqual(entry["target"], moved["target"])
        self.assertEqual(entry["id"], moved["id"])

    def test_distinct_ids_with_same_leaf(self):
        catalog.validate_records([record(), record("net.example.tool", ["dev", "tool"])])

    def test_missing_or_malformed_id(self):
        for identity in (None, 123, "", "tool", ".org.tool", "org..tool", "org.tool.", "org/tool", "org.tool name"):
            with self.subTest(identity=identity):
                entry = record()
                entry["meta"]["id"] = identity
                self.reject([entry])
        entry = record()
        del entry["meta"]["id"]
        self.reject([entry])

    def test_old_category_id_and_mismatched_target(self):
        for field, value in (("id", "pkgs.apps.tools.tool"), ("target", ["apps", "tools", "tool"])):
            entry = record()
            entry[field] = value
            self.reject([entry])

    def test_duplicate_identity_and_category(self):
        self.reject([record(), record(category=["dev", "tool"])])
        self.reject([record(), record("net.example.other")])

    def test_identity_and_category_prefix_collisions(self):
        self.reject([record(), record("org.example.tool.child", ["dev", "child"])])
        self.reject([record(), record("net.example.other", ["apps", "tools", "tool", "child"])])

    def test_flattened_output_collision_in_either_order(self):
        records = [record("org.example.foo-bar"), record("org.example.foo.bar", ["dev", "bar"])]
        self.reject(records)
        self.reject(list(reversed(records)))

    def test_reserved_roots_and_missing_category(self):
        for identity in ("legacy.example.tool", "byCategories.example.tool"):
            self.reject([record(identity)])
        for category in ([], ["apps.tools"], ["legacy", "tool"], ["apps", "package"]):
            entry = record()
            entry["categoryTarget"] = category
            self.reject([entry])
        entry = record()
        del entry["categoryTarget"]
        self.reject([entry])


if __name__ == "__main__":
    unittest.main()
