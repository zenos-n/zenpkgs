from __future__ import annotations

import errno
import os
import stat
from dataclasses import fields, is_dataclass, replace
from pathlib import Path
from typing import Any

from .lexer import Token, lex
from .model import (
    Diagnostic,
    Document,
    FileKind,
    ImportStatement,
    Interpolation,
    MarkdownImport,
    Span,
    ResolvedImport,
    StringExpr,
    StringText,
    ZenLangError,
)
from .parser import parse_tokens
from .validation import (
    validate,
    validate_document_contract,
    validate_import_merges,
    validate_markdown_imports,
)


_MAX_IMPORT_DEPTH = 256
_MAX_SOURCE_BYTES = 4 * 1024 * 1024
_MAX_IMPORTS = 1024
_MAX_TOTAL_SOURCE_BYTES = 32 * 1024 * 1024
_MAX_SYMLINKS = 40

_PhysicalIdentity = tuple[int, int]


def parse(text: str, source: str, *, validate_semantics: bool = True) -> Document:
    """Parse a source fragment; parse_file also enforces the complete file contract."""
    kind = FileKind.from_source(source)
    document = parse_tokens(lex(text, source), kind)
    if validate_semantics:
        document = replace(document, diagnostics=tuple(dict.fromkeys((*document.diagnostics, *validate(document)))))
    else:
        validate_markdown_imports(document)
    return document


def parse_file(
    path: str | Path,
    *,
    validate_semantics: bool = True,
    import_root: str | Path | None = None,
) -> Document:
    entry = _logical_path(path)
    source = str(entry)
    sources: dict[str, str] = {}
    try:
        boundary = _logical_path(import_root) if import_root is not None else entry.parent
        _require_within_root(
            entry,
            boundary,
            Span.point(source),
            subject="source file",
        )
        try:
            root_descriptor = os.open(
                boundary,
                os.O_RDONLY | os.O_CLOEXEC | os.O_DIRECTORY,
            )
        except (OSError, UnicodeError, ValueError) as error:
            raise ZenLangError(
                Diagnostic(
                    "ZEN301",
                    f"cannot read import root: {boundary}",
                    Span.point(source),
                    notes=(str(error),),
                )
            ) from error
        resolver = _ImportResolver(
            boundary,
            root_descriptor,
            validate_semantics=validate_semantics,
            sources=sources,
        )
        try:
            return resolver.load(entry, source, Span.point(source), imported=False)
        finally:
            os.close(root_descriptor)
    except ZenLangError as error:
        error.sources.update(sources)
        raise


class _ImportResolver:
    def __init__(
        self,
        root: Path,
        root_descriptor: int,
        *,
        validate_semantics: bool,
        sources: dict[str, str],
    ):
        self.root = root
        self.root_descriptor = root_descriptor
        self.validate_semantics = validate_semantics
        self.sources = sources
        self.cache: dict[tuple[Path, _PhysicalIdentity], Document] = {}
        self.expanded_import_counts: dict[int, int] = {}
        self.expanded_source_bytes: dict[int, int] = {}
        self.stack: list[tuple[_PhysicalIdentity, Path]] = []
        self.import_count = 0
        self.total_source_bytes = 0

    def load(
        self,
        path: Path,
        label: str,
        span: Span,
        *,
        imported: bool,
    ) -> Document:
        if len(self.stack) > _MAX_IMPORT_DEPTH:
            raise ZenLangError(
                Diagnostic(
                    "ZEN307",
                    f"import depth exceeds the maximum of {_MAX_IMPORT_DEPTH}",
                    span,
                    notes=(
                        "import trace: "
                        + " -> ".join(str(item[1]) for item in self.stack),
                    ),
                )
            )
        descriptor, metadata = _open_source(
            path,
            label,
            span,
            imported=imported,
            root=self.root,
            root_descriptor=self.root_descriptor,
        )
        identity = _physical_identity(metadata)
        stack_identities = tuple(item[0] for item in self.stack)
        if identity in stack_identities:
            os.close(descriptor)
            cycle_start = stack_identities.index(identity)
            cycle = (*self.stack[cycle_start:], (identity, path))
            raise ZenLangError(
                Diagnostic(
                    "ZEN305",
                    "import cycle detected",
                    span,
                    notes=(
                        "import trace: "
                        + " -> ".join(str(item[1]) for item in cycle),
                    ),
                )
            )
        cache_key = (path, identity)
        cached = self.cache.get(cache_key)
        if cached is not None:
            os.close(descriptor)
            return cached
        text, source_bytes = _read_source(
            descriptor,
            metadata,
            label,
            span,
            imported=imported,
            remaining_total_bytes=_MAX_TOTAL_SOURCE_BYTES - self.total_source_bytes,
        )
        self.total_source_bytes += source_bytes
        self.sources[label] = text
        document = parse(text, label, validate_semantics=False)
        before_markdown = self.total_source_bytes
        document = self._resolve_markdown(document, path)
        source_bytes += self.total_source_bytes - before_markdown
        self.stack.append((identity, path))
        try:
            bare: list[ResolvedImport] = []
            local: list[Any] = []
            diagnostics = list(document.diagnostics)
            expanded_import_count = 0
            expanded_source_bytes = source_bytes
            for statement in document.statements:
                if not isinstance(statement, ImportStatement):
                    local.append(statement)
                    continue
                child = self._load_import(path, document.kind, statement)
                expanded_import_count += 1 + self.expanded_import_counts[id(child)]
                if expanded_import_count > _MAX_IMPORTS:
                    raise ZenLangError(
                        Diagnostic(
                            "ZEN309",
                            f"import count exceeds the maximum of {_MAX_IMPORTS}",
                            statement.path.span,
                        )
                    )
                expanded_source_bytes += self.expanded_source_bytes[id(child)]
                if expanded_source_bytes > _MAX_TOTAL_SOURCE_BYTES:
                    raise ZenLangError(
                        Diagnostic(
                            "ZEN310",
                            "aggregate source size exceeds the maximum of "
                            f"{_MAX_TOTAL_SOURCE_BYTES} bytes",
                            statement.path.span,
                        )
                    )
                resolved = ResolvedImport(
                    child,
                    statement.binding,
                    statement.annotation,
                    statement.span,
                )
                if statement.binding is None:
                    bare.append(resolved)
                else:
                    local.append(resolved)
                diagnostics.extend(child.diagnostics)
            result = Document(
                document.kind,
                document.grammar_version,
                document.ir_version,
                tuple((*bare, *local)),
                document.span,
                tuple(dict.fromkeys(diagnostics)),
            )
            if self.validate_semantics:
                warnings = validate(result, metadata_warnings=not imported)
                if not imported:
                    validate_document_contract(result)
                validate_import_merges(result)
                result = replace(result, diagnostics=tuple(dict.fromkeys((*result.diagnostics, *warnings))))
            self.expanded_import_counts[id(result)] = expanded_import_count
            self.expanded_source_bytes[id(result)] = expanded_source_bytes
            self.cache[cache_key] = result
            return result
        finally:
            self.stack.pop()

    def _load_import(
        self,
        current_path: Path,
        kind: FileKind,
        statement: ImportStatement,
    ) -> Document:
        relative = _import_path(statement)
        if not relative:
            raise ZenLangError(Diagnostic("ZEN302", "import paths must not be empty", statement.path.span))
        if "\0" in relative:
            raise ZenLangError(Diagnostic("ZEN302", "import paths cannot contain NUL bytes", statement.path.span))
        candidate = Path(relative)
        if candidate.is_absolute() or "://" in relative:
            raise ZenLangError(
                Diagnostic("ZEN302", "imports must use relative filesystem paths", statement.path.span)
            )
        self.import_count += 1
        if self.import_count > _MAX_IMPORTS:
            raise ZenLangError(
                Diagnostic("ZEN309", f"import count exceeds the maximum of {_MAX_IMPORTS}", statement.path.span)
            )
        target = _logical_path(current_path.parent / candidate)
        _require_within_root(target, self.root, statement.path.span)
        try:
            target_kind = FileKind.from_source(str(target))
        except ZenLangError as error:
            raise ZenLangError(
                Diagnostic("ZEN303", f"import must use the same .{kind.value} file extension", statement.path.span)
            ) from error
        if target_kind is not kind:
            raise ZenLangError(
                Diagnostic("ZEN303", f"import must use the same .{kind.value} file extension", statement.path.span)
            )
        return self.load(target, str(target), statement.path.span, imported=True)

    def _resolve_markdown(self, value: Any, current_path: Path) -> Any:
        if isinstance(value, MarkdownImport):
            relative = _import_path(value)
            span = value.path.span
            if not relative or "\0" in relative or Path(relative).is_absolute() or "://" in relative:
                raise ZenLangError(Diagnostic("ZEN302", "Markdown imports require a nonempty relative filesystem path without NUL bytes", span))
            target = _logical_path(current_path.parent / relative)
            _require_within_root(target, self.root, span)
            if target.suffix != ".md":
                raise ZenLangError(Diagnostic("ZEN303", "Markdown imports require a .md file extension", span))
            descriptor, metadata = _open_source(
                target, str(target), span, imported=True,
                root=self.root, root_descriptor=self.root_descriptor,
            )
            try:
                # Check the opened target, not a pre-open realpath. DSL symlinks
                # retain their existing rules; only Markdown is physically confined.
                physical_root = Path(os.readlink(f"/proc/self/fd/{self.root_descriptor}"))
                physical_target = Path(os.readlink(f"/proc/self/fd/{descriptor}"))
                _require_within_root(physical_target, physical_root, span, subject="Markdown import")
            except (OSError, ValueError) as error:
                os.close(descriptor)
                raise ZenLangError(Diagnostic("ZEN304", f"cannot verify Markdown import target: {target}", span, notes=(str(error),))) from error
            except ZenLangError:
                os.close(descriptor)
                raise
            text, size = _read_source(
                descriptor, metadata, str(target), span, imported=True,
                remaining_total_bytes=_MAX_TOTAL_SOURCE_BYTES - self.total_source_bytes,
            )
            self.total_source_bytes += size
            return StringExpr((StringText(text, value.span),), True, value.span)
        if isinstance(value, tuple):
            return tuple(self._resolve_markdown(item, current_path) for item in value)
        if is_dataclass(value):
            return replace(value, **{
                field.name: self._resolve_markdown(getattr(value, field.name), current_path)
                for field in fields(value) if field.name != "span"
            })
        return value


def _logical_path(path: str | Path) -> Path:
    try:
        return Path(os.path.abspath(os.fspath(path)))
    except (OSError, TypeError, ValueError) as error:
        raise ZenLangError(
            Diagnostic(
                "ZEN301",
                f"cannot normalize filesystem path: {path}",
                Span.point(str(path)),
                notes=(str(error),),
            )
        ) from error


def _require_within_root(
    path: Path,
    import_root: Path,
    span: Span,
    *,
    subject: str = "import",
) -> None:
    try:
        path.relative_to(import_root)
    except ValueError as error:
        raise ZenLangError(
            Diagnostic(
                "ZEN306",
                f"{subject} resolves outside the allowed root: {path}",
                span,
                notes=(f"import root: {import_root}",),
            )
        ) from error


def _open_source(
    path: Path,
    label: str,
    span: Span,
    *,
    imported: bool,
    root: Path,
    root_descriptor: int,
) -> tuple[int, os.stat_result]:
    description = "imported file" if imported else "source file"
    code = "ZEN304" if imported else "ZEN301"
    try:
        descriptor = _open_beneath(root_descriptor, root, path)
    except (OSError, UnicodeError, ValueError) as error:
        raise ZenLangError(
            Diagnostic(
                code,
                f"cannot read {description}: {label}",
                span,
                notes=(str(error),),
            )
        ) from error
    try:
        metadata = os.fstat(descriptor)
        if not stat.S_ISREG(metadata.st_mode):
            raise OSError("path is not a regular file")
        return descriptor, metadata
    except (OSError, UnicodeError, ValueError) as error:
        os.close(descriptor)
        raise ZenLangError(
            Diagnostic(
                code,
                f"cannot read {description}: {label}",
                span,
                notes=(str(error),),
            )
        ) from error


def _read_source(
    descriptor: int,
    metadata: os.stat_result,
    label: str,
    span: Span,
    *,
    imported: bool,
    remaining_total_bytes: int,
) -> tuple[str, int]:
    description = "imported file" if imported else "source file"
    code = "ZEN304" if imported else "ZEN301"
    try:
        if metadata.st_size > _MAX_SOURCE_BYTES:
            _raise_source_too_large(label, span, imported=imported)
        if metadata.st_size > remaining_total_bytes:
            _raise_total_source_too_large(span)

        chunks: list[bytes] = []
        remaining = min(_MAX_SOURCE_BYTES, remaining_total_bytes) + 1
        while remaining:
            chunk = os.read(descriptor, min(64 * 1024, remaining))
            if not chunk:
                break
            chunks.append(chunk)
            remaining -= len(chunk)
        data = b"".join(chunks)
        if len(data) > _MAX_SOURCE_BYTES:
            _raise_source_too_large(label, span, imported=imported)
        if len(data) > remaining_total_bytes:
            _raise_total_source_too_large(span)
        return data.decode("utf-8"), len(data)
    except ZenLangError:
        raise
    except (OSError, UnicodeError, ValueError) as error:
        raise ZenLangError(
            Diagnostic(
                code,
                f"cannot read {description}: {label}",
                span,
                notes=(str(error),),
            )
        ) from error
    finally:
        os.close(descriptor)


def _open_beneath(root_descriptor: int, root: Path, path: Path) -> int:
    relative = path.relative_to(root)
    directory_flags = os.O_RDONLY | os.O_CLOEXEC | os.O_NOFOLLOW | os.O_DIRECTORY
    descriptor = os.dup(root_descriptor)
    try:
        parts = relative.parts
        if not parts:
            raise OSError("source path resolves to the import root directory")
        for part in parts[:-1]:
            next_descriptor = os.open(part, directory_flags, dir_fd=descriptor)
            os.close(descriptor)
            descriptor = next_descriptor
        return _open_final_file(descriptor, parts[-1], frozenset())
    finally:
        os.close(descriptor)


def _open_final_file(
    parent_descriptor: int,
    name: str,
    followed_symlinks: frozenset[_PhysicalIdentity],
) -> int:
    path_flags = os.O_PATH | os.O_CLOEXEC | os.O_NOFOLLOW
    path_descriptor = os.open(name, path_flags, dir_fd=parent_descriptor)
    try:
        metadata = os.fstat(path_descriptor)
        identity = _physical_identity(metadata)
        if stat.S_ISREG(metadata.st_mode):
            descriptor = os.open(
                name,
                os.O_RDONLY | os.O_CLOEXEC | os.O_NOFOLLOW,
                dir_fd=parent_descriptor,
            )
            opened_metadata = os.fstat(descriptor)
            if (
                not stat.S_ISREG(opened_metadata.st_mode)
                or _physical_identity(opened_metadata) != identity
            ):
                os.close(descriptor)
                raise OSError(errno.ESTALE, "final file changed while opening")
            return descriptor
        if not stat.S_ISLNK(metadata.st_mode):
            raise OSError("path is not a regular file")
        if identity in followed_symlinks or len(followed_symlinks) >= _MAX_SYMLINKS:
            raise OSError(errno.ELOOP, "too many levels of symbolic links")
        target = os.readlink("", dir_fd=path_descriptor)
        if not target:
            raise OSError(errno.ENOENT, "symbolic link has an empty target")
        return _open_symlink_target(
            parent_descriptor,
            target,
            followed_symlinks | {identity},
        )
    finally:
        os.close(path_descriptor)


def _open_symlink_target(
    parent_descriptor: int,
    target: str,
    followed_symlinks: frozenset[_PhysicalIdentity],
    remaining_parts: tuple[str, ...] = (),
) -> int:
    if os.path.isabs(target):
        descriptor = os.open(
            "/", os.O_RDONLY | os.O_CLOEXEC | os.O_DIRECTORY
        )
        parts = (*Path(target).parts[1:], *remaining_parts)
    else:
        descriptor = os.dup(parent_descriptor)
        parts = (*Path(target).parts, *remaining_parts)
    try:
        if not parts or (not remaining_parts and target.endswith(os.sep)):
            raise OSError("symbolic link target is not a regular file")
        return _open_followed_path(descriptor, parts, followed_symlinks)
    finally:
        os.close(descriptor)


def _open_followed_path(
    parent_descriptor: int,
    parts: tuple[str, ...],
    followed_symlinks: frozenset[_PhysicalIdentity],
) -> int:
    path_flags = os.O_PATH | os.O_CLOEXEC | os.O_NOFOLLOW
    descriptor = os.dup(parent_descriptor)
    try:
        for index, part in enumerate(parts):
            if index == len(parts) - 1:
                return _open_final_file(descriptor, part, followed_symlinks)
            path_descriptor = os.open(part, path_flags, dir_fd=descriptor)
            try:
                metadata = os.fstat(path_descriptor)
                if stat.S_ISDIR(metadata.st_mode):
                    os.close(descriptor)
                    descriptor = os.dup(path_descriptor)
                    continue
                if not stat.S_ISLNK(metadata.st_mode):
                    raise OSError("symbolic link target traverses a non-directory")
                identity = _physical_identity(metadata)
                if (
                    identity in followed_symlinks
                    or len(followed_symlinks) >= _MAX_SYMLINKS
                ):
                    raise OSError(errno.ELOOP, "too many levels of symbolic links")
                target = os.readlink("", dir_fd=path_descriptor)
                if not target:
                    raise OSError(errno.ENOENT, "symbolic link has an empty target")
                return _open_symlink_target(
                    descriptor,
                    target,
                    followed_symlinks | {identity},
                    parts[index + 1 :],
                )
            finally:
                os.close(path_descriptor)
        raise OSError("symbolic link target is not a regular file")
    finally:
        os.close(descriptor)


def _physical_identity(metadata: os.stat_result) -> _PhysicalIdentity:
    return metadata.st_dev, metadata.st_ino


def _raise_source_too_large(
    label: str, span: Span, *, imported: bool
) -> None:
    description = "imported file" if imported else "source file"
    raise ZenLangError(
        Diagnostic(
            "ZEN308",
            f"{description} exceeds the maximum size of {_MAX_SOURCE_BYTES} bytes: {label}",
            span,
        )
    )


def _raise_total_source_too_large(span: Span) -> None:
    raise ZenLangError(
        Diagnostic(
            "ZEN310",
            "aggregate source size exceeds the maximum of "
            f"{_MAX_TOTAL_SOURCE_BYTES} bytes",
            span,
        )
    )


def _import_path(statement: ImportStatement | MarkdownImport) -> str:
    if not isinstance(statement.path, StringExpr):
        return statement.path.value
    if any(isinstance(part, Interpolation) for part in statement.path.parts):
        raise ZenLangError(
            Diagnostic("ZEN302", "import paths cannot contain interpolation", statement.path.span)
        )
    return "".join(part.value for part in statement.path.parts if isinstance(part, StringText))


def tokenize(text: str, source: str) -> tuple[Token, ...]:
    FileKind.from_source(source)
    return lex(text, source)
