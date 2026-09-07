import unittest

from zenlang import ZenLangError, parse


class VersionSchemeTests(unittest.TestCase):
    def test_three_part_versions_with_alpha_beta_or_stable(self):
        for version in ("1.0.0", "1.0.0N", "1.0.0Na", "1.0.0Nb", "2.3.4a", "2.3.4b", "2.3.4L"):
            for value in (version, f'"{version}"'):
                with self.subTest(value=value):
                    parse(f"_meta.zenosVersion = {value};", "version.zmdl")

    def test_invalid_version_components_and_lifecycle(self):
        for version in ("1.0", "1.0N", "1.0.0.1", "1.0.0Nl", "1.0.0l", "1.0.0Ns", "1.0.0Nstable"):
            for value in (version, f'"{version}"'):
                with self.subTest(value=value), self.assertRaises(ZenLangError):
                    parse(f"_meta.zenosVersion = {value};", "version.zmdl")

    def test_upstream_package_versions_are_not_zenos_versions(self):
        parse('_meta.zenosVersion = 1.0.0N; _meta.packageVersion = "1.0";', "package.zpkg")
