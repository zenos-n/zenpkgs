import unittest

from zenlang.formatter import format_source
from zenlang.model import ZenLangError


class FormatterTests(unittest.TestCase):
    def test_expands_bindings_and_is_idempotent(self):
        source = 'a={b=1;c=[ 1 2 ];};\n'
        expected = 'a = {\n  b = 1;\n  c = [ 1 2 ];\n};\n'
        self.assertEqual(format_source(source), expected)
        self.assertEqual(format_source(expected), expected)

    def test_preserves_comments_strings_and_actions(self):
        source = '''# heading
_import "base.zcfg";
u!! { # action
  text = ''literal
    indentation ${$f.user}
  ''; # comment
  users.($f.user).enable=true;
}; # end
'''
        result = format_source(source)
        self.assertEqual(format_source(result), result)
        for literal in ['# heading', '# action', '# comment', '# end', "''literal\n    indentation ${$f.user}\n  ''"]:
            self.assertIn(literal, result)

    def test_rejects_invalid_source(self):
        with self.assertRaises(ZenLangError):
            format_source('a = {')


if __name__ == '__main__':
    unittest.main()
