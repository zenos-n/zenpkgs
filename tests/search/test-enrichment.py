import importlib.util
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import Mock
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("enrichment", Path(__file__).parents[2] / "scripts/enrich-search.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
pop_spec = importlib.util.spec_from_file_location("popularity", Path(__file__).parents[2] / "scripts/search-popularity.py")
popularity = importlib.util.module_from_spec(pop_spec)
pop_spec.loader.exec_module(popularity)


class EnrichmentTests(unittest.TestCase):
    def test_dependency_counts_deduplicate_aliases_and_label_the_catalog_population(self):
        manifest = {"packages": {"one": {"drvPath": "/nix/store/one.drv"}, "alias": {"drvPath": "/nix/store/one.drv"}, "two": {"drvPath": "/nix/store/two.drv"}, "unknown": {}}}
        result = popularity.dependency_metrics(manifest, lambda _: {"derivations": {"one.drv": {"inputs": {"drvs": {"external.drv": {}}}}, "two.drv": {"inputs": {"drvs": {"one.drv": {}}}}}})
        self.assertEqual(result["one"]["catalogDependents"], 1)
        self.assertEqual(result["alias"]["catalogDependents"], 1)
        self.assertEqual(result["one"]["directBuildInputs"], 1)
        self.assertEqual(result["two"]["catalogDependencies"], ["alias", "one"])
        self.assertNotIn("unknown", result)

    def test_repology_counts_distinct_repositories_and_matches_native_attributes(self):
        counts = {}
        popularity.merge_repology(counts, {"project-name": [{"repo": "nix_unstable", "srcname": "native-attribute"}, {"repo": "nix_unstable", "srcname": "native-attribute"}, {"repo": "debian", "srcname": "unrelated-name"}]})
        self.assertEqual(counts, {"native-attribute": 2})

    def test_repology_resumes_a_checkpoint_and_retries_connection_resets(self):
        import json, time
        with tempfile.TemporaryDirectory() as directory:
            cache = Path(directory) / "counts.json"
            cache.with_suffix(".partial.json").write_text(json.dumps({"counts": {"previous": 4}, "cursor": "last/", "pages": 20, "startedEpoch": time.time()}))
            response = Mock(status_code=200)
            response.json.return_value = {"last": [{"repo": "nix_unstable", "srcname": "native"}]}
            session = Mock()
            session.get.side_effect = [OSError("connection reset"), response]
            with patch.object(popularity.time, "sleep"):
                result = popularity.repology_counts(session, cache)
            self.assertEqual(result["counts"], {"previous": 4, "native": 1})
            self.assertEqual(session.get.call_count, 2)
            self.assertIn("/last/?inrepo=", session.get.call_args.args[0])
            self.assertTrue(cache.is_file())
            self.assertFalse(cache.with_suffix(".partial.json").exists())
    def test_definition_links_are_revision_specific_and_do_not_leak_store_paths(self):
        self.assertEqual(module.source_url("pkgs/apps/tool.zpkg", "abc", "def"), "https://github.com/zenos-n/zenpkgs/blob/abc/pkgs/apps/tool.zpkg")
        self.assertEqual(module.source_url("/nix/store/hash-source/nixos/modules/foo.nix:42", "abc", "def", [{"root": "/nix/store/hash-source", "repository": "NixOS/nixpkgs", "revision": "def"}]), "https://github.com/NixOS/nixpkgs/blob/def/nixos/modules/foo.nix#L42")
        self.assertIsNone(module.source_url("/nix/store/unknown-repo/lib/package.nix", "abc", "def"))
        self.assertIsNone(module.source_url("/etc/private.nix", "abc", "def"))
        self.assertIsNone(module.source_url("pkgs/../secret", "abc", "def"))
        self.assertEqual(module.source_url("/nix/store/hm-source/modules/home.nix:5", "abc", "def", [{"root": "/nix/store/hm-source", "repository": "nix-community/home-manager", "revision": "hm"}]), "https://github.com/nix-community/home-manager/blob/hm/modules/home.nix#L5")

    def test_cached_bin_directory_follows_wrapper_symlink(self):
        scanner = Mock()
        scanner.listing.side_effect = [
            {"root": {"entries": {"bin": {"type": "symlink", "target": "/nix/store/target-app/bin"}}}},
            {"root": {"entries": {"bin": {"type": "directory", "entries": {"tool": {"type": "regular", "executable": True}}}}}},
        ]
        self.assertIn("tool", module.cached_directory(scanner, "/nix/store/wrapper-app/bin"))
        scanner.listing.side_effect = None
        scanner.listing.return_value = None
        self.assertIsNone(module.cached_directory(scanner, "/nix/store/missing-app/bin"))

    def test_local_executables_artwork_and_unknown_outputs(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "bin").mkdir()
            (root / "sbin").mkdir()
            admin = root / "sbin/admin-tool"
            admin.touch(); admin.chmod(0o755)
            for name in ("editor", "not-executable", ".editor-wrapped"):
                file = root / "bin" / name
                file.touch()
                file.chmod(0o644 if name == "not-executable" else 0o755)
            reader, scanner = Mock(), Mock()
            scanner.listing.return_value = None
            result = module.inventory({"outputPaths": [str(root)]}, reader, scanner, root, "https://example.org/artwork")
            self.assertEqual(result["programs"], ["admin-tool", "editor"])
            self.assertEqual(result["binaryStatus"], "complete")
            self.assertEqual(result["artworkStatus"], "no-entries")
            unknown = module.inventory({"outputPaths": ["/nix/store/missing-package"]}, reader, scanner, root, "https://example.org")
            self.assertNotIn("programs", unknown)
            self.assertEqual(unknown["binaryStatus"], "partial")

    def test_enrichment_preserves_authored_identity_and_isolates_failed_providers(self):
        catalog = {"metadata": {"zenpkgsVersion": "abc"}, "pkgs": {
            "good": {"meta": {"id": "pkgs.good", "kind": "package", "version": "1", "maintainers": ["zen-maintainer"], "sourcePath": "pkgs/good.zpkg"}},
            "bad": {"meta": {"id": "pkgs.bad", "kind": "package", "programs": ["obsolete"], "indexedOutputPaths": ["/nix/store/obsolete"], "resolvedVersion": "obsolete"}},
        }, "options": {"flag": {"meta": {"default": False, "declarations": ["modules/flag.zmdl"]}}}}
        manifest = {"system": "x86_64-linux", "nixpkgsRevision": "def", "packages": {"pkgs.good": {"status": "evaluated", "version": "2", "outputs": ["out"], "outputPaths": []}}}
        with tempfile.TemporaryDirectory() as directory:
            result = module.enrich(catalog, manifest, Mock(), Mock(), Path(directory), "https://example.org")
        good = result["pkgs"]["good"]["meta"]
        self.assertEqual(good["version"], "1")
        self.assertEqual(good["resolvedVersion"], "2")
        self.assertEqual(good["maintainers"], ["zen-maintainer"])
        self.assertEqual(result["pkgs"]["bad"]["meta"]["binaryStatus"], "unavailable")
        self.assertNotIn("programs", result["pkgs"]["bad"]["meta"])
        self.assertNotIn("resolvedVersion", result["pkgs"]["bad"]["meta"])
        self.assertFalse(result["options"]["flag"]["meta"]["default"])
        self.assertIn("/abc/modules/flag.zmdl", result["options"]["flag"]["meta"]["declarations"][0])

    def test_screenshot_mirrors_keep_captions_and_original_attribution(self):
        shot = {"url": "https://upstream.org/editor.png", "source": "https://upstream.org/editor.png", "caption": "Editor"}
        catalog = {"pkgs": {"editor": {"meta": {"screenshots": [shot]}}}}
        scanner = Mock()
        scanner.fetch_screenshot.return_value = ("small.webp", "large.webp")
        module.mirror_screenshots(catalog, scanner, "https://archive.org/artwork")
        self.assertEqual(shot["url"], "https://archive.org/artwork/screenshots/large.webp")
        self.assertEqual(shot["thumbnail"], "https://archive.org/artwork/screenshots/small.webp")
        self.assertEqual(shot["source"], "https://upstream.org/editor.png")
        self.assertEqual(shot["caption"], "Editor")

    def test_previous_inventory_requires_exact_output_identity(self):
        import copy
        previous = {"pkgs": {"app": {"meta": {"id": "pkgs.app", "indexedOutputPaths": ["/nix/store/same-app"], "binaryStatus": "complete", "programs": ["app"], "artworkStatus": "indexed", "icon": "https://archive.org/icon.png"}}}}
        catalog = {"pkgs": {"app": {"meta": {"id": "pkgs.app", "kind": "package", "indexedOutputPaths": ["/nix/store/obsolete-version"], "programs": ["obsolete-command"], "icon": "https://archive.org/obsolete.png"}}}}
        manifest = {"system": "x86_64-linux", "packages": {"pkgs.app": {"status": "evaluated", "outputPaths": ["/nix/store/same-app"]}}}
        with patch.object(module, "inventory", return_value={"binaryStatus": "partial", "artworkStatus": "unavailable"}):
            result = module.enrich(copy.deepcopy(catalog), manifest, Mock(), Mock(), Path("/tmp"), "https://archive.org", previous)
            self.assertEqual(result["pkgs"]["app"]["meta"]["programs"], ["app"])
            self.assertEqual(result["pkgs"]["app"]["meta"]["icon"], "https://archive.org/icon.png")
            manifest["packages"]["pkgs.app"]["outputPaths"] = ["/nix/store/new-version"]
            result = module.enrich(copy.deepcopy(catalog), manifest, Mock(), Mock(), Path("/tmp"), "https://archive.org", previous)
            self.assertNotIn("programs", result["pkgs"]["app"]["meta"])
            self.assertNotIn("icon", result["pkgs"]["app"]["meta"])

    def test_reference_artwork_is_exact_identity_and_does_not_replace_binary_inventory(self):
        reader, scanner = Mock(), Mock()
        reader.parse_metainfo.return_value = {"screenshots": [{"url": "https://upstream.org/shot.png"}]}
        refs = module.reference_catalog('<components><component><id>org.example.Editor</id><icon type="remote" width="128">https://upstream.org/icon.png</icon><releases><release version="2.0"/></releases></component></components>', reader)
        self.assertNotIn("Editor", refs)
        self.assertEqual(refs["org.example.Editor"]["reference"]["version"], "2.0")
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            scanner.cache_dir = root
            scanner.indexed_files.return_value = []
            scanner.session.get.side_effect = RuntimeError("offline icon")
            scanner.listing.return_value = {"root": {"entries": {"bin": {"type": "directory", "entries": {"actual-nix-command": {"type": "regular", "executable": True}}}}}}
            result = module.inventory({"outputPaths": ["/nix/store/hash-editor"]}, reader, scanner, root, "https://archive.org", refs, "org.example.Editor")
        self.assertEqual(result["programs"], ["actual-nix-command"])
        self.assertEqual(result["artworkReference"]["version"], "2.0")
        self.assertEqual(result["screenshots"][0]["url"], "https://upstream.org/shot.png")
        scanner.fetch_entries.assert_not_called()

    def test_reference_graphics_do_not_discard_actual_desktop_file_details(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            scanner = Mock()
            scanner.cache_dir = root
            scanner.listing.return_value = {"root": {"entries": {}}}
            scanner.indexed_files.return_value = ["share/applications/org.example.Editor.desktop"]
            scanner.resolve.return_value = ("hash", "/share/applications/org.example.Editor.desktop")
            scanner.fetch_entries.return_value = {"/share/applications/org.example.Editor.desktop": {"desktopName": "Actual Nix launcher", "noDisplay": False}}
            reference = {"screenshots": [{"url": "https://upstream.org/shot.png"}], "reference": {"version": "2.0"}}
            result = module.inventory({"outputPaths": ["/nix/store/hash-editor"]}, Mock(), scanner, root, "https://archive.org", {"org.example.Editor": reference}, "org.example.Editor")
        self.assertEqual(result["desktopEntries"][0]["desktopName"], "Actual Nix launcher")
        scanner.fetch_entries.assert_called_once()


if __name__ == "__main__":
    unittest.main()
