"""Exercise real GSettings notifications and desktop MIME precedence in isolation."""
import importlib.util
import os
from pathlib import Path
import select
import shutil
import subprocess
import sys
import tempfile
import time
import unittest

from gi.repository import Gio

HELPER, MIME, ASSETS = map(Path, sys.argv[1:4])
sys.argv[1:] = []
spec = importlib.util.spec_from_file_location('wallpaper', HELPER)
wallpaper = importlib.util.module_from_spec(spec)
spec.loader.exec_module(wallpaper)


class DesktopDefaults(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.assets = self.root / 'destination-2'
        self.assets.mkdir()
        for color in wallpaper.COLORS.values():
            for mode in ('light', 'dark'):
                (self.assets / f'{color} {mode}.png').touch()

    def test_uri_recognition(self):
        original = self.assets / 'purple dark.png'
        expected = (self.assets / 'blue dark.png').as_uri()
        for uri in (original.as_uri(), 'file://' + str(original), 'file://localhost' + str(original)):
            self.assertEqual(wallpaper.replacement(uri, 'purple', 'blue', self.assets), expected)
        for uri in ((self.root / original.name).as_uri(), 'https://example.test/purple dark.png',
                    'file://remote' + str(original), original.as_uri() + '#fragment',
                    original.as_uri() + '?query', 'file://[invalid',
                    (self.assets / 'red dark.png').as_uri()):
            self.assertIsNone(wallpaper.replacement(uri, 'purple', 'blue', self.assets), uri)
        old = 'file:///nix/store/' + 'a' * 32 + '-destination-2-wallpapers-0.9/share/backgrounds/destination-2/purple%20light.png'
        self.assertEqual(wallpaper.replacement(old, 'purple', 'blue', self.assets),
                         (self.assets / 'blue light.png').as_uri())
        symlink = self.root / 'wallpaper.png'
        symlink.symlink_to(original)
        self.assertEqual(wallpaper.replacement(symlink.as_uri(), 'purple', 'blue', self.assets), expected)
        (self.assets / 'blue dark.png').unlink()
        self.assertIsNone(wallpaper.replacement(original.as_uri(), 'purple', 'blue', self.assets))

    def test_installed_palette(self):
        schema = Gio.SettingsSchemaSource.get_default().lookup('org.gnome.desktop.interface', True)
        _, variants = schema.get_key('accent-color').get_range().unpack()
        for previous in variants:
            for current in variants:
                if previous == current:
                    continue
                for mode in ('light', 'dark'):
                    original = ASSETS / f'{wallpaper.COLORS[previous]} {mode}.png'
                    self.assertTrue(original.is_file(), original)
                    after = wallpaper.replacement(original.as_uri(), previous, current, ASSETS)
                    self.assertIsNotNone(after, (previous, current, mode))
                    self.assertTrue(after.endswith(f'%20{mode}.png'), after)

    def test_real_settings_observer(self):
        interface = Gio.Settings.new('org.gnome.desktop.interface')
        background = Gio.Settings.new('org.gnome.desktop.background')
        uri = lambda color, mode: (self.assets / f'{color} {mode}.png').as_uri()
        interface.set_string('accent-color', 'purple')
        background.set_string('picture-uri', uri('purple', 'light'))
        background.set_string('picture-uri-dark', uri('purple', 'dark'))
        Gio.Settings.sync()
        process = subprocess.Popen([sys.executable, str(HELPER), str(self.assets)], stdout=subprocess.PIPE)
        def stop():
            process.terminate()
            process.wait(timeout=5)
            process.stdout.close()
        self.addCleanup(stop)
        self.assertTrue(select.select([process.stdout], [], [], 10)[0], 'observer never became ready')
        self.assertEqual(process.stdout.readline().strip(), b'Watching matching Destination wallpaper accents')
        self.assertEqual(background.get_string('picture-uri'), uri('purple', 'light'))

        def accent(color):
            interface.set_string('accent-color', color)
            Gio.Settings.sync()

        def wait(light, dark):
            deadline = time.monotonic() + 5
            while time.monotonic() < deadline:
                from gi.repository import GLib
                while GLib.MainContext.default().iteration(False):
                    pass
                if [background.get_string(k) for k in ('picture-uri', 'picture-uri-dark')] == [light, dark]:
                    return
                time.sleep(.01)
            self.fail(f'wallpapers did not become {(light, dark)}')

        accent('blue')
        wait(uri('blue', 'light'), uri('blue', 'dark'))
        # A deliberate mismatching dark variant stays; matching light still follows.
        background.set_string('picture-uri-dark', uri('red', 'dark'))
        accent('green')
        wait(uri('green', 'light'), uri('red', 'dark'))
        # Selecting a matching variant resumes following, including teal/cyan.
        background.set_string('picture-uri-dark', uri('green', 'dark'))
        accent('teal')
        wait(uri('cyan', 'light'), uri('cyan', 'dark'))
        accent('slate')
        wait(uri('slate', 'light'), uri('slate', 'dark'))
        # Foreign wallpapers and mismatched Destination variants never follow.
        custom = (self.root / 'purple light.png').as_uri()
        background.set_string('picture-uri', custom)
        background.set_string('picture-uri-dark', uri('pink', 'dark'))
        accent('purple')
        accent('yellow')
        Gio.Settings.sync()
        time.sleep(.15)
        wait(custom, uri('pink', 'dark'))
        self.assertIsNone(process.poll())

    def test_mime_defaults_and_overrides(self):
        system, user, data = [self.root / name for name in ('system', 'user', 'data')]
        for directory in (system, user, data / 'applications'):
            directory.mkdir(parents=True)
        shutil.copyfile(MIME, system / 'gnome-mimeapps.list')
        (data / 'applications/org.example.Custom.desktop').write_text(
            '[Desktop Entry]\nType=Application\nName=Custom editor\nExec=true %f\nMimeType=text/plain;application/json;\n')
        env = os.environ | {'XDG_CONFIG_HOME': str(user), 'XDG_CONFIG_DIRS': str(system),
                           'XDG_DATA_HOME': str(data), 'XDG_CURRENT_DESKTOP': 'GNOME'}
        def query(content, desktop='GNOME'):
            result = subprocess.check_output([sys.executable, '-c',
                'from gi.repository import Gio; import sys; a=Gio.AppInfo.get_default_for_type(sys.argv[1],False); print(a.get_id() if a else "none")', content],
                env=env | {'XDG_CURRENT_DESKTOP': desktop}, text=True)
            return result.strip()
        for content in ('text/plain', 'application/json', 'application/xml', 'text/markdown',
                        'text/x-python', 'text/x-c', 'application/x-shellscript', 'application/x-zerosize'):
            self.assertEqual(query(content), 'org.gnome.TextEditor.desktop', content)
        (user / 'mimeapps.list').write_text('[Default Applications]\napplication/json=org.example.Custom.desktop;\n')
        self.assertEqual(query('application/json'), 'org.example.Custom.desktop')
        (user / 'mimeapps.list').unlink()
        (system / 'kde-mimeapps.list').write_text('[Default Applications]\napplication/json=org.example.Custom.desktop;\n')
        self.assertEqual(query('application/json', 'KDE'), 'org.example.Custom.desktop')


if __name__ == '__main__':
    unittest.main(verbosity=2)
