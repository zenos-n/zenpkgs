"""Keep GNOME's cursor available to Xcursor clients and Flatpak."""
import argparse
import configparser
import os
from pathlib import Path
import shlex
import shutil
import subprocess
import tempfile


SANDBOX_PATH = ":".join([
    "/run/host/user-share/icons/zenos-cursors", "/run/host/user-share/icons",
    "/run/host/share/icons", "/app/share/icons", "/usr/share/icons",
])


def theme_name(name):
    if not name or name in (".", "..") or any(c in name for c in "/\\\n\r\x00,;"):
        raise ValueError("invalid cursor theme name")
    return name


def icon_roots(home, data_home, data_dirs):
    return [data_home / "icons", home / ".icons"] + [
        Path(p) / "icons" for p in data_dirs.split(":") if p
    ]


def remove_export(path):
    # Store copies retain read-only directory modes; owned exports must be replaceable.
    for base, _, _ in os.walk(path):
        Path(base).chmod(0o700)
    shutil.rmtree(path)


def export_theme(name, roots, destination):
    """Dereference store links: Flatpak cannot follow them outside its icon mount."""
    theme_name(name)
    fallback = destination.parent / "default"
    if os.path.lexists(fallback) and (fallback.is_symlink() or not (fallback / ".zenos-cursor-owned").is_file()):
        raise FileExistsError(f"unmanaged default cursor theme: {fallback}")
    pending, found = [name], {}
    while pending:
        current = theme_name(pending.pop())
        if current in found:
            continue
        source = next((root / current for root in roots if (root / current).is_dir()), None)
        if source is None:
            if current == name:
                raise FileNotFoundError(f"cursor theme not installed: {name}")
            continue
        found[current] = source
        index = source / "index.theme"
        if index.is_file():
            parser = configparser.ConfigParser(interpolation=None, strict=False)
            parser.read(index)
            inherits = parser.get("Icon Theme", "Inherits", fallback="")
            pending.extend(value.strip() for value in inherits.replace(";", ",").split(",") if value.strip())
    # Build before changing the live export; a missing/broken source keeps the old theme.
    destination.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=".zenos-cursor-", dir=destination.parent) as temporary:
        staging = Path(temporary)
        for current, source in found.items():
            target = staging / current
            target.mkdir()
            if (source / "cursors").is_dir():
                shutil.copytree(source / "cursors", target / "cursors", symlinks=False)
            if (source / "index.theme").is_file():
                shutil.copyfile(source / "index.theme", target / "index.theme")
        default = staging / "default"
        default.mkdir(exist_ok=True)
        (default / "index.theme").write_text(f"[Icon Theme]\nName=Default\nInherits={name}\n")
        if name != "default" and (staging / name / "cursors").is_dir():
            # Steam's web runtime can ignore inheritance; give default real cursors.
            shutil.copytree(staging / name / "cursors", default / "cursors", copy_function=os.link)
        (default / ".zenos-cursor-owned").touch()
        if fallback.exists():
            remove_export(fallback)
        # Steam exports the user icon root, not a custom nested XCURSOR_PATH.
        shutil.copytree(default, fallback, copy_function=os.link)
        destination.mkdir(exist_ok=True)
        for item in staging.iterdir():
            target = destination / item.name
            if target.is_symlink() or target.is_file():
                target.unlink()
            elif target.exists():
                remove_export(target)
            item.rename(target)


def environment(name, size, home, data_home):
    theme_name(name)
    if size <= 0:
        raise ValueError("cursor size must be positive")
    roots = [str(data_home / "icons/zenos-cursors"), str(data_home / "icons")]
    roots.extend(p for p in os.environ.get("XCURSOR_PATH", "").split(":") if p)
    roots.extend(str(Path(p) / "icons") for p in os.environ.get("XDG_DATA_DIRS", "").split(":") if p)
    return {"XCURSOR_THEME": name, "XCURSOR_SIZE": str(size),
            "XCURSOR_PATH": ":".join(dict.fromkeys(roots))}


def main():
    from gi.repository import Gio, GLib
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--environment", action="store_true")
    parser.add_argument("--shell", action="store_true")
    parser.add_argument("--watch", action="store_true")
    args = parser.parse_args()
    settings = Gio.Settings.new("org.gnome.desktop.interface")
    home = Path.home()
    fallback = home / (".private/Packages" if (home / ".private").is_dir() else ".local/share")
    data_home = Path(os.environ.get("XDG_DATA_HOME", str(fallback)))

    def values():
        return environment(settings.get_string("cursor-theme"), settings.get_int("cursor-size"), home, data_home)

    if args.environment:
        for key, value in values().items():
            print(f"export {key}={shlex.quote(value)}" if args.shell else f"{key}={value}")
        return

    def apply(*_):
        try:
            env = values()
            roots = icon_roots(home, data_home, os.environ.get("XDG_DATA_DIRS", ""))
            # The bridge's own export must not hide an updated installed theme.
            export_theme(env["XCURSOR_THEME"], roots, data_home / "icons/zenos-cursors")
            if os.environ.get("DISPLAY"):
                subprocess.run(["xrdb", "-nocpp", "-merge"], input=f'Xcursor.theme: {env["XCURSOR_THEME"]}\nXcursor.size: {env["XCURSOR_SIZE"]}\n', text=True, check=True)
            subprocess.run(["dbus-update-activation-environment", "--systemd", *[f"{key}={value}" for key, value in env.items()]], check=True)
            if shutil.which("flatpak"):
                subprocess.run(["flatpak", "override", "--user",
                    f'--env=XCURSOR_THEME={env["XCURSOR_THEME"]}', f'--env=XCURSOR_SIZE={env["XCURSOR_SIZE"]}',
                    f"--env=XCURSOR_PATH={SANDBOX_PATH}"], check=True)
            print(f'Cursor ready: {env["XCURSOR_THEME"]} ({env["XCURSOR_SIZE"]})', flush=True)
        except (OSError, ValueError, configparser.Error, subprocess.CalledProcessError) as error:
            if not args.watch:
                raise
            print(f"zenos-gnome-cursor: {error}", flush=True)

    apply()
    if args.watch:
        settings.connect("changed::cursor-theme", apply)
        settings.connect("changed::cursor-size", apply)
        GLib.MainLoop().run()


if __name__ == "__main__":
    main()
