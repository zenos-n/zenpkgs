"""Private, non-executable per-source compiler cache.

A cache hit still opens and hashes every input using the import resolver's rules.
Neither timestamps nor serialized Python objects are trusted as source identity.
"""
from __future__ import annotations

from dataclasses import fields, is_dataclass
from enum import Enum
import hashlib
import json
import os
from pathlib import Path
import tempfile
from typing import Any

from . import model
from .api import _open_source, _read_source, _require_within_root, _MAX_SOURCE_BYTES
from .model import Document, Span, ZenLangError

CACHE_VERSION = 1
_MAX_CACHE_BYTES = 64 * 1024 * 1024
_TYPES = {
    name: value for name, value in vars(model).items()
    if isinstance(value, type) and is_dataclass(value)
}


def default_cache_dir() -> Path:
    return Path(os.environ.get("XDG_CACHE_HOME") or Path.home() / ".cache") / "zen-dsl"


def compiler_fingerprint() -> str:
    digest = hashlib.sha256()
    directory = Path(__file__).parent
    for path in sorted((*directory.glob("*.py"), *directory.glob("*.nix"))):
        digest.update(path.name.encode())
        digest.update(path.read_bytes())
    digest.update(str(CACHE_VERSION).encode())
    return digest.hexdigest()


def _encode(value: Any) -> Any:
    if isinstance(value, Enum):
        return {"enum": value.value}
    if is_dataclass(value):
        return {"type": type(value).__name__, "fields": [_encode(getattr(value, field.name)) for field in fields(value)]}
    if isinstance(value, tuple):
        return {"tuple": [_encode(item) for item in value]}
    if isinstance(value, list):
        return [_encode(item) for item in value]
    if isinstance(value, dict):
        return {key: _encode(item) for key, item in value.items()}
    if value is None or isinstance(value, (str, bool, int, float)):
        return value
    raise ValueError("unsupported cache value")


def _decode(value: Any) -> Any:
    if isinstance(value, list):
        return [_decode(item) for item in value]
    if isinstance(value, dict):
        if set(value) == {"enum"}:
            return model.FileKind(value["enum"])
        if set(value) == {"tuple"}:
            return tuple(_decode(item) for item in value["tuple"])
        if set(value) == {"type", "fields"}:
            cls = _TYPES[value["type"]]
            if len(value["fields"]) != len(fields(cls)):
                raise ValueError("invalid cached AST")
            return cls(*(_decode(item) for item in value["fields"]))
        return {key: _decode(item) for key, item in value.items()}
    return value


def _json(value: Any) -> bytes:
    return json.dumps(value, sort_keys=True, ensure_ascii=False, separators=(",", ":")).encode("utf-8")


class SourceCache:
    def __init__(self, directory: str | Path, root: Path, mode: str, fingerprint: str):
        self.root = root
        namespace = hashlib.sha256(_json([str(root), mode, fingerprint])).hexdigest()
        self.directory = Path(directory) / namespace

    def _path(self, relative: str) -> Path:
        return self.directory / (hashlib.sha256(relative.encode()).hexdigest() + ".json")

    def load(self, relative: str) -> tuple[Document, dict[str, Any] | None, dict[str, Any]] | None:
        try:
            with self._path(relative).open("rb") as stream:
                data = stream.read(_MAX_CACHE_BYTES + 1)
            if len(data) > _MAX_CACHE_BYTES:
                return None
            envelope = json.loads(data)
            payload = envelope["payload"]
            if envelope["digest"] != hashlib.sha256(_json(payload)).hexdigest():
                return None
            if payload["version"] != CACHE_VERSION or payload["path"] != relative:
                return None
            dependencies = payload["dependencies"]
            if str(self.root / relative) not in dependencies or not dependencies:
                return None
            self._verify_dependencies(dependencies)
            document = _decode(payload["document"])
            source = payload["source"]
            if not isinstance(document, Document) or document.span.source != str(self.root / relative):
                return None
            if source is not None and (source["path"] != relative or source["kind"] != document.kind.value):
                return None
            return document, source, dependencies
        except (OSError, ValueError, KeyError, TypeError, AttributeError, RecursionError, ZenLangError):
            return None

    def _verify_dependencies(self, dependencies: dict[str, Any]) -> None:
        root_fd = os.open(self.root, os.O_RDONLY | os.O_CLOEXEC | os.O_DIRECTORY)
        try:
            for label, expected in dependencies.items():
                path = Path(label)
                span = Span.point(label)
                _require_within_root(path, self.root, span)
                descriptor, metadata = _open_source(
                    path, label, span, imported=True, root=self.root, root_descriptor=root_fd,
                )
                try:
                    if path.suffix == ".md":
                        physical_root = Path(os.readlink(f"/proc/self/fd/{root_fd}"))
                        physical_target = Path(os.readlink(f"/proc/self/fd/{descriptor}"))
                        _require_within_root(physical_target, physical_root, span, subject="Markdown import")
                except BaseException:
                    os.close(descriptor)
                    raise
                text, _ = _read_source(
                    descriptor, metadata, label, span, imported=True,
                    remaining_total_bytes=_MAX_SOURCE_BYTES,
                )
                actual = {
                    "digest": hashlib.sha256(text.encode("utf-8")).hexdigest(),
                    "identity": [metadata.st_dev, metadata.st_ino],
                }
                if actual != expected:
                    raise ValueError("changed compiler input")
        finally:
            os.close(root_fd)

    def store(self, relative: str, document: Document, source: dict[str, Any] | None,
              dependencies: dict[str, Any]) -> None:
        temporary = None
        try:
            payload = {
                "version": CACHE_VERSION, "path": relative, "dependencies": dependencies,
                "document": _encode(document), "source": source,
            }
            data = _json({"payload": payload, "digest": hashlib.sha256(_json(payload)).hexdigest()})
            if len(data) > _MAX_CACHE_BYTES:
                return
            self.directory.mkdir(parents=True, exist_ok=True, mode=0o700)
            with tempfile.NamedTemporaryFile(dir=self.directory, prefix=".entry-", delete=False) as stream:
                temporary = Path(stream.name)
                stream.write(data)
            os.replace(temporary, self._path(relative))
        except (OSError, ValueError, TypeError, RecursionError):
            # A cache is optional, including on read-only or full filesystems.
            pass
        finally:
            if temporary is not None:
                try:
                    temporary.unlink(missing_ok=True)
                except OSError:
                    pass


class BundleCache(SourceCache):
    """The exact serialized output of a fully checked, unchanged source tree."""
    def load_output(self, inventory: list[str]) -> tuple[str, list[model.Diagnostic]] | None:
        try:
            with (self.directory / "bundle-manifest.json").open("rb") as stream:
                raw_manifest = stream.read(_MAX_CACHE_BYTES + 1)
            if len(raw_manifest) > _MAX_CACHE_BYTES:
                return None
            envelope = json.loads(raw_manifest)
            manifest = envelope["payload"]
            if envelope["digest"] != hashlib.sha256(_json(manifest)).hexdigest():
                return None
            if manifest["version"] != CACHE_VERSION or manifest["inventory"] != inventory:
                return None
            dependencies = manifest["dependencies"]
            if any(str(self.root / relative) not in dependencies for relative in inventory):
                return None
            self._verify_dependencies(dependencies)
            with (self.directory / "bundle-output.json").open("rb") as stream:
                output = stream.read(512 * 1024 * 1024 + 1)
            if len(output) > 512 * 1024 * 1024:
                return None
            if hashlib.sha256(output).hexdigest() != manifest["outputDigest"]:
                return None
            warnings = _decode(manifest["diagnostics"])
            if not isinstance(warnings, list) or not all(isinstance(item, model.Diagnostic) for item in warnings):
                return None
            return output.decode("utf-8"), warnings
        except (OSError, ValueError, KeyError, TypeError, AttributeError, RecursionError, ZenLangError):
            return None

    def store_output(self, output: str, diagnostics: list[model.Diagnostic],
                     dependencies: dict[str, Any], inventory: list[str]) -> None:
        temporary: list[Path] = []
        try:
            data = output.encode("utf-8")
            if len(data) > 512 * 1024 * 1024:
                return
            payload = {
                "version": CACHE_VERSION, "inventory": inventory, "dependencies": dependencies,
                "outputDigest": hashlib.sha256(data).hexdigest(), "diagnostics": _encode(diagnostics),
            }
            manifest = _json({"payload": payload, "digest": hashlib.sha256(_json(payload)).hexdigest()})
            if len(manifest) > _MAX_CACHE_BYTES:
                return
            self.directory.mkdir(parents=True, exist_ok=True, mode=0o700)
            # Publish the manifest last. Readers verify the output digest, so
            # concurrent writers or interrupted writes can only cause a miss.
            for name, content in (("bundle-output.json", data), ("bundle-manifest.json", manifest)):
                with tempfile.NamedTemporaryFile(dir=self.directory, prefix=".bundle-", delete=False) as stream:
                    path = Path(stream.name)
                    temporary.append(path)
                    stream.write(content)
                os.replace(path, self.directory / name)
        except (OSError, ValueError, TypeError, RecursionError):
            pass
        finally:
            for path in temporary:
                try:
                    path.unlink(missing_ok=True)
                except OSError:
                    pass
