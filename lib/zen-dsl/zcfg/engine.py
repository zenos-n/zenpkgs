from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import TypeAlias

from .model import (
    Assignment,
    AttrSet,
    Diagnostic,
    Document,
    Expression,
    ListExpr,
    Literal,
    PkgsRef,
    Span,
    ZcfgError,
)
from .parser import parse


@dataclass(frozen=True)
class ResolvedPkgsRef:
    path: tuple[str, ...]


ResolvedValue: TypeAlias = (
    str | int | bool | None | ResolvedPkgsRef | list["ResolvedValue"] | dict[str, "ResolvedValue"]
)


class Loader:
    def __init__(self):
        self.sources: dict[str, str] = {}
        self._cache: dict[Path, dict[str, ResolvedValue]] = {}

    def load(self, path: str | Path) -> dict[str, ResolvedValue]:
        return self._load(Path(path).resolve(), (), None)

    def read_document(self, path: str | Path) -> Document:
        resolved = Path(path).resolve()
        text = self._read(resolved, None)
        return parse(text, str(resolved))

    def _load(
        self,
        path: Path,
        stack: tuple[Path, ...],
        import_span: Span | None,
    ) -> dict[str, ResolvedValue]:
        if path in stack:
            chain = " -> ".join(str(item) for item in (*stack, path))
            raise ZcfgError(
                Diagnostic(
                    "ZCFG303",
                    f"import cycle detected at {path}",
                    import_span or Span.point(str(path)),
                    notes=(f"import chain: {chain}",),
                )
            )
        if path in self._cache:
            return self._cache[path]

        text = self._read(path, import_span)
        document = parse(text, str(path))
        merged: dict[str, ResolvedValue] = {}
        next_stack = (*stack, path)
        for imported in document.imports:
            self._validate_import_path(imported.path, imported.span)
            imported_path = (path.parent / imported.path).resolve()
            imported_value = self._load(imported_path, next_stack, imported.span)
            merged = _deep_merge(merged, imported_value)

        local = _resolve_assignments(document.assignments)
        merged = _deep_merge(merged, local)
        self._cache[path] = merged
        return merged

    def _read(self, path: Path, import_span: Span | None) -> str:
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError as error:
            raise ZcfgError(
                Diagnostic(
                    "ZCFG301",
                    f"source is not valid UTF-8: {path}",
                    import_span or Span.point(str(path)),
                    notes=(str(error),),
                )
            ) from error
        except OSError as error:
            raise ZcfgError(
                Diagnostic(
                    "ZCFG301",
                    f"cannot read source file: {path}",
                    import_span or Span.point(str(path)),
                    notes=(str(error),),
                )
            ) from error
        self.sources[str(path)] = text
        return text

    @staticmethod
    def _validate_import_path(path: str, span: Span) -> None:
        parts = path.split("/")
        if not (path.startswith("./") or path.startswith("../")):
            raise ZcfgError(
                Diagnostic("ZCFG302", "import path must be relative", span)
            )
        if path.endswith("/") or "" in parts or "." in parts[1:]:
            raise ZcfgError(
                Diagnostic(
                    "ZCFG302",
                    "import path must not contain empty or redundant segments",
                    span,
                )
            )
        if not path.endswith(".zcfg"):
            raise ZcfgError(
                Diagnostic("ZCFG302", "import path must end in .zcfg", span)
            )


def _resolve_assignments(assignments: tuple[Assignment, ...]) -> dict[str, ResolvedValue]:
    result: dict[str, ResolvedValue] = {}
    for assignment in assignments:
        value = _resolve_expression(assignment.value)
        nested: ResolvedValue = value
        for segment in reversed(assignment.path):
            nested = {segment: nested}
        result = _strict_local_merge(result, nested, (), assignment.path_span)
    return result


def _resolve_expression(expression: Expression) -> ResolvedValue:
    if isinstance(expression, Literal):
        return expression.value
    if isinstance(expression, PkgsRef):
        return ResolvedPkgsRef(expression.path)
    if isinstance(expression, ListExpr):
        return [_resolve_expression(item) for item in expression.items]
    if isinstance(expression, AttrSet):
        return _resolve_assignments(expression.assignments)
    raise AssertionError(f"unknown expression type: {type(expression)!r}")


def _strict_local_merge(
    left: dict[str, ResolvedValue],
    right: ResolvedValue,
    path: tuple[str, ...],
    span: Span,
) -> dict[str, ResolvedValue]:
    if not isinstance(right, dict):
        raise AssertionError("assignment root must be an attribute set")
    result = dict(left)
    for key, right_value in right.items():
        current_path = (*path, key)
        if key not in result:
            result[key] = right_value
            continue
        left_value = result[key]
        if isinstance(left_value, dict) and isinstance(right_value, dict):
            result[key] = _strict_local_merge(left_value, right_value, current_path, span)
            continue
        dotted = ".".join(current_path)
        raise ZcfgError(
            Diagnostic(
                "ZCFG201",
                f"conflicting local assignment for '{dotted}'",
                span,
                notes=("each local leaf may be assigned only once",),
            )
        )
    return result


def _deep_merge(
    left: dict[str, ResolvedValue], right: dict[str, ResolvedValue]
) -> dict[str, ResolvedValue]:
    result = dict(left)
    for key, right_value in right.items():
        left_value = result.get(key)
        if isinstance(left_value, dict) and isinstance(right_value, dict):
            result[key] = _deep_merge(left_value, right_value)
        else:
            result[key] = right_value
    return result


def compile_nix(value: dict[str, ResolvedValue]) -> str:
    legacy = value.get("legacy", {})
    if not isinstance(legacy, dict):
        raise ValueError("legacy must be an attribute set")
    if "zenos" in legacy:
        raise ValueError("legacy cannot contain the zenos option tree")

    root = dict(legacy)
    zenos = {key: item for key, item in value.items() if key != "legacy"}
    if zenos:
        root["zenos"] = zenos
    return "{ pkgs }:\n" + _format_attr_set(root, 0) + "\n"


def _format_value(value: ResolvedValue, indent: int) -> str:
    if value is None:
        return "null"
    if value is True:
        return "true"
    if value is False:
        return "false"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, str):
        return _quote_nix_string(value)
    if isinstance(value, ResolvedPkgsRef):
        return "pkgs.zenos." + ".".join(value.path)
    if isinstance(value, list):
        if not value:
            return "[ ]"
        padding = " " * (indent + 2)
        items = [padding + _format_value(item, indent + 2) for item in value]
        return "[\n" + "\n".join(items) + "\n" + " " * indent + "]"
    return _format_attr_set(value, indent)


def _format_attr_set(value: dict[str, ResolvedValue], indent: int) -> str:
    if not value:
        return "{ }"
    padding = " " * (indent + 2)
    lines = [
        f"{padding}{key} = {_format_value(value[key], indent + 2)};"
        for key in sorted(value)
    ]
    return "{\n" + "\n".join(lines) + "\n" + " " * indent + "}"


def _quote_nix_string(value: str) -> str:
    escaped = (
        value.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("${", "\\${")
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t")
    )
    return f'"{escaped}"'
