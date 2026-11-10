"""Follow GNOME's accent only for a matching packaged Destination wallpaper."""
import os
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit

COLORS = {color: color for color in (
    'blue', 'green', 'yellow', 'orange', 'red', 'pink', 'purple', 'slate')}
COLORS.update(teal='cyan', grey='slate')


def replacement(uri, previous, current, root):
    old, new = COLORS.get(previous), COLORS.get(current)
    if not old or not new or old == new:
        return None
    try:
        parsed = urlsplit(uri)
        if parsed.scheme != 'file' or parsed.netloc not in ('', 'localhost') or parsed.query or parsed.fragment:
            return None
        source = Path(unquote(parsed.path, errors='strict')).resolve()
        root = Path(root).resolve()
    except (ValueError, OSError, RuntimeError):
        return None
    # Preferences can still refer to an older, retained Nix wallpaper output.
    historical = (len(source.parents) >= 5
                  and source.parent.parts[-3:] == ('share', 'backgrounds', 'destination-2')
                  and source.parents[3].parent == Path('/nix/store')
                  and re.fullmatch(r'[a-z0-9]{32}-destination-2-wallpapers-.+', source.parents[3].name))
    if source.parent != root and not historical:
        return None
    match = re.fullmatch(re.escape(old) + r' (light|dark)\.png', source.name)
    if not match:
        return None
    target = root / f'{new} {match[1]}.png'
    return target.as_uri() if target.is_file() else None


def watch(root):
    from gi.repository import Gio, GLib
    interface = Gio.Settings.new('org.gnome.desktop.interface')
    background = Gio.Settings.new('org.gnome.desktop.background')
    previous = interface.get_string('accent-color')

    def changed(settings, _key):
        nonlocal previous
        current = settings.get_string('accent-color')
        old, previous = previous, current
        for key in ('picture-uri', 'picture-uri-dark'):
            before = background.get_string(key)
            after = replacement(before, old, current, root)
            if after and background.is_writable(key) and background.get_string(key) == before:
                background.set_string(key, after)

    interface.connect('changed::accent-color', changed)
    print('Watching matching Destination wallpaper accents', flush=True)
    GLib.MainLoop().run()


if __name__ == '__main__':
    if os.environ.get('XDG_SESSION_CLASS') != 'greeter':
        watch(sys.argv[1])
