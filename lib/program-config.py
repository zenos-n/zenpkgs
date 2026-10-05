"""Apply selected app preferences without taking ownership of runtime state."""

import json
from collections.abc import MutableMapping
import os
from pathlib import Path
import stat
import sys
import tempfile


def configuration_path(specification):
    home = Path.home()
    app = specification["application"]
    if app == "codex":
        directory = specification.get("stateDirectory") or os.environ.get("CODEX_HOME")
        return Path(directory or home / ".codex") / "config.toml"
    if app == "select-for-figma":
        directory = os.environ.get("XDG_CONFIG_HOME") or home / ".config"
        return Path(directory) / "figma-linux" / "settings.json"
    raise ValueError(f"unknown application: {app}")


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
    path = configuration_path(specification).expanduser().resolve()
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
        target[keys[-1]] = assignment["value"]
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
