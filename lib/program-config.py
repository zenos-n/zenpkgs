"""Apply selected app preferences without taking ownership of runtime state."""

import json
from collections.abc import MutableMapping
import os
from pathlib import Path
import stat
import subprocess
import sys
import tempfile


def configuration_path(specification):
    home = Path.home()
    app = specification["application"]
    if app == "codex":
        directory = specification.get("stateDirectory") or os.environ.get("CODEX_HOME")
        return Path(directory or home / ".codex") / "config.toml"
    if app == "select-for-figma":
        directory = os.environ.get("XDG_DATA_HOME") or home / ".local/share"
        return Path(directory) / "select-for-figma" / "state.json"
    if app == "gpu-screen-recorder-ui":
        directory = os.environ.get("XDG_CONFIG_HOME") or home / ".config"
        return Path(directory) / "gpu-screen-recorder" / "config_ui"
    raise ValueError(f"unknown application: {app}")


def require_select_closed(specification):
    command = specification.get("sessionBusCommand")
    if not command:
        return
    for name in ("io.github.doromiert.FigmaGtk", "io.github.doromiert.SelectForFigma"):
        result = subprocess.run([
            command, "call", "--session", "--dest", "org.freedesktop.DBus",
            "--object-path", "/org/freedesktop/DBus", "--method",
            "org.freedesktop.DBus.NameHasOwner", name,
        ], capture_output=True, text=True, timeout=10)
        if result.returncode:
            runtime = os.environ.get("XDG_RUNTIME_DIR")
            if os.environ.get("DBUS_SESSION_BUS_ADDRESS") or (runtime and (Path(runtime) / "bus").exists()):
                raise ValueError("cannot check Select for Figma's session bus; close the app and retry from the user session")
            # Initial/offline activation has no running user session to inspect.
            return
        if result.stdout.strip() == "(true,)":
            raise ValueError("close Select for Figma before applying preferences or migrating its data")
        if result.stdout.strip() != "(false,)":
            raise ValueError("unexpected session bus response while checking Select for Figma")


def atomic_write(path, content):
    path.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    descriptor, temporary = tempfile.mkstemp(prefix=f".{path.name}.zenos-", dir=path.parent)
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8") as output:
            output.write(content)
            output.flush()
            os.fsync(output.fileno())
        os.replace(temporary, path)
    finally:
        Path(temporary).unlink(missing_ok=True)


def apply(specification):
    assignments = specification["assignments"]
    if not assignments:
        return
    path = configuration_path(specification).expanduser()
    if specification["application"] == "select-for-figma":
        require_select_closed(specification)
        # Match the app's first-launch migration before creating its new directory.
        # Moving the whole directory preserves Chromium cookies and saved sessions.
        destination = path.parent
        legacy = destination.with_name("figma-gtk")
        if not destination.exists() and not destination.is_symlink() and legacy.is_dir():
            legacy.rename(destination)
    path = path.resolve()
    if str(path).startswith("/nix/store/"):
        raise ValueError(f"{path} is immutable; migrate this config to a writable file")
    if path.exists():
        info = path.stat()
        if not stat.S_ISREG(info.st_mode) or info.st_uid != os.geteuid():
            raise ValueError(f"{path} must be a regular file owned by the current user")
    original = path.read_text(encoding="utf-8") if path.exists() else ""
    toml = specification["application"] == "codex"
    if toml:
        import tomlkit
        document = tomlkit.parse(original)
    else:
        document = json.loads(original) if original else {}
    if not isinstance(document, MutableMapping):
        raise ValueError(f"{path} must contain a configuration object")
    for assignment in assignments:
        keys = assignment["path"]
        if not keys or not all(isinstance(key, str) and key for key in keys):
            raise ValueError("preference paths must contain nonempty string keys")
        target = document
        for key in keys[:-1]:
            if key not in target:
                target[key] = tomlkit.table() if toml else {}
            if not isinstance(target[key], MutableMapping):
                raise ValueError(f"cannot assign {'.'.join(keys)}: {key} is not a table")
            target = target[key]
        value = assignment["value"]
        if specification["application"] == "gpu-screen-recorder-ui" and keys[-1] == "save_directory":
            value = value.replace("%h", str(Path.home()))
        target[keys[-1]] = value
    content = tomlkit.dumps(document) if toml else json.dumps(document, indent=2) + "\n"
    if content == original:
        return
    if original:
        atomic_write(path.with_name(path.name + ".zenos-backup"), original)
    atomic_write(path, content)


if __name__ == "__main__":
    try:
        apply(json.loads(Path(sys.argv[1]).read_text(encoding="utf-8")))
    except Exception as error:
        print(f"ZenOS program preferences: {error}", file=sys.stderr)
        sys.exit(1)
