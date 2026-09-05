"""Offline ZCFG checks against a trusted, mounted runtime schema export.

Schema construction belongs to lib/schema-validation.nix, not source discovery.
This module never emits or evaluates Nix, resolves package values, or calls DSL
functions. Literal request data is checked separately by the trusted exporter's
Nix module API. A type name alone cannot certify values: addCheck can retain it.
Missing literal checks and unknown expressions remain explicitly incomplete.
"""
from __future__ import annotations

from dataclasses import dataclass, fields, is_dataclass, replace
import json
from pathlib import Path
from typing import Any

from .api import parse, parse_file
from .emitter import semantic_descriptor
from .model import (
    Assignment, AttrSet, ConditionalStatement, Diagnostic, Document, FileKind,
    GRAMMAR_VERSION, IR_VERSION, GroupExpr, IdentifierSegment, ImportStatement, LetStatement, ListExpr,
    Literal, ResolvedImport, Span, StringExpr, StringSegment,
    StringText, StructuralMarker, UnaryExpr, Variable, ZenLangError,
)
from .validation import _annotation_type


SCHEMA_VERSION = "1.0.0Na"
SCHEMA_ENCODING = "zenlang.schema-validation/1"


def _names(segments: Any) -> tuple[str, ...] | None:
    if isinstance(segments, StructuralMarker):
        return None
    if any(not isinstance(part, (IdentifierSegment, StringSegment)) for part in segments):
        return None
    return tuple(part.name if isinstance(part, IdentifierSegment) else part.value for part in segments)


def _known(value: Any) -> bool:
    if isinstance(value, GroupExpr):
        return _known(value.value)
    if isinstance(value, Literal):
        return True
    if isinstance(value, StringExpr):
        return all(isinstance(part, StringText) for part in value.parts)
    if isinstance(value, UnaryExpr):
        return value.operator == "-" and isinstance(value.operand, Literal) and value.operand.kind in ("integer", "float")
    if isinstance(value, ListExpr):
        return all(_known(item) for item in value.items)
    if isinstance(value, AttrSet):
        return not value.recursive and all(
            isinstance(item, Assignment) and item.operator == "="
            and _names(item.target) is not None and _known(item.value)
            for item in value.statements
        )
    return False


def _literal_data(value: Any) -> Any:
    # Numeric signs are part of literal serialization, not expression evaluation.
    if isinstance(value, UnaryExpr):
        return Literal(-value.operand.value, value.operand.kind, value.span)
    if isinstance(value, tuple):
        return tuple(_literal_data(item) for item in value)
    if is_dataclass(value):
        return replace(value, **{
            field.name: _literal_data(getattr(value, field.name))
            for field in fields(value) if field.name != "span"
        })
    return value


def schema_requests(document: Document) -> list[dict[str, Any]]:
    """Literal data requests for the trusted exporter, never executable source.

    Request booleans both as assignments and possible generated enable leaves.
    Only nodes actually mounted by the runtime answer these requests.
    """
    if document.kind is not FileKind.ZCFG:
        raise ZenLangError(Diagnostic("ZEN500", "schema requests require ZCFG", document.span))
    requests: list[dict[str, Any]] = []

    def visit(statements: Any, prefix: tuple[str, ...]) -> None:
        for statement in statements:
            if isinstance(statement, ResolvedImport) and statement.binding is None:
                visit(statement.document.statements, prefix)
            elif isinstance(statement, ConditionalStatement):
                visit(statement.body.statements, prefix)
            elif isinstance(statement, Assignment):
                suffix = _names(statement.target)
                if suffix is None:
                    continue
                path = (*prefix, *suffix)
                if path[:1] == ("_meta",):
                    continue
                value = statement.value
                while isinstance(value, GroupExpr):
                    value = value.value
                if _known(value):
                    descriptor = semantic_descriptor(_literal_data(value))
                    requests.append({"path": list(path), "value": descriptor})
                    if isinstance(value, Literal) and value.kind in ("true", "false"):
                        requests.append({"path": [*path, "enable"], "value": descriptor})
                if isinstance(value, AttrSet) and not value.recursive:
                    visit(value.statements, path)

    visit(document.statements, ())
    return requests


@dataclass(frozen=True)
class SchemaContext:
    root: dict[str, Any]
    source: str
    bundle_digest: str

    @classmethod
    def from_dict(cls, data: Any, *, source: str = "<schema>") -> SchemaContext:
        def invalid(message: str) -> None:
            raise ZenLangError(Diagnostic("ZEN500", message, Span.point(source)))

        if not isinstance(data, dict):
            invalid("schema context must be an object")
        if data.get("encoding") != SCHEMA_ENCODING or data.get("schemaVersion") != SCHEMA_VERSION:
            invalid("unsupported mounted schema encoding/version; regenerate the schema context")
        if data.get("zenosVersion") != SCHEMA_VERSION:
            invalid("unsupported schema zenosVersion; an explicit migration is required")
        if data.get("grammarVersion") != GRAMMAR_VERSION or data.get("irVersion") != IR_VERSION:
            invalid("unsupported schema grammar/IR version; regenerate with a compatible compiler")
        digest = data.get("bundleDigest")
        if not isinstance(digest, str) or len(digest) != 64 or any(c not in "0123456789abcdef" for c in digest):
            invalid("schema context requires a SHA-256 bundleDigest")
        annotations: dict[str, Any] = {}

        def node(value: Any, depth: int = 0) -> dict[str, Any]:
            if depth > 64 or not isinstance(value, dict):
                invalid("invalid or excessively nested schema node")
            kind = value.get("kind")
            if kind == "unsupported":
                if not isinstance(value.get("reason"), str):
                    invalid("unsupported schema nodes require a reason")
                return dict(value)
            if kind == "option":
                annotation = value.get("annotation")
                if not isinstance(annotation, str):
                    invalid("option schema requires a DSL type annotation")
                if annotation not in annotations:
                    try:
                        declaration = parse(f"value._meta.type = {annotation};", source + ".zstr")
                    except ZenLangError as error:
                        invalid(f"invalid schema type annotation: {error.diagnostic.message}")
                    if len(declaration.statements) != 1:
                        invalid("schema type annotation must contain exactly one type")
                    assignment = declaration.statements[0]
                    if not isinstance(assignment, Assignment) or isinstance(assignment.value, StructuralMarker):
                        invalid("schema option annotation must be a value type")
                    annotations[annotation] = assignment.value
                checks = value.get("checks", [])
                if not isinstance(checks, list) or any(
                    not isinstance(check, dict) or not isinstance(check.get("value"), dict)
                    or check.get("status") not in ("accepted", "rejected", "unsupported")
                    for check in checks
                ):
                    invalid("invalid literal check records")
                type_name = value.get("typeName", annotation)
                if not isinstance(type_name, str):
                    invalid("runtime typeName must be a string")
                return {"kind": kind, "annotation": annotations[annotation], "label": type_name, "checks": checks}
            if kind != "branch" or not isinstance(value.get("children"), dict):
                invalid("schema branches require a children object")
            if type(value.get("shorthand", False)) is not bool:
                invalid("schema shorthand must be boolean")
            if any(not isinstance(key, str) for key in value["children"]):
                invalid("schema child names must be strings")
            return {
                "kind": kind,
                "children": {key: node(child, depth + 1) for key, child in value["children"].items()},
                "freeform": node(value["freeform"], depth + 1) if value.get("freeform") is not None else None,
                "shorthand": value.get("shorthand", False),
            }

        return cls(node(data.get("root")), source, digest)


def load_schema(path: str | Path) -> SchemaContext:
    try:
        with Path(path).open(encoding="utf-8") as stream:
            data = json.load(stream)
        return SchemaContext.from_dict(data, source=str(path))
    except (OSError, ValueError, RecursionError) as error:
        raise ZenLangError(Diagnostic("ZEN500", f"cannot read mounted schema: {error}", Span.point(str(path)))) from error


@dataclass(frozen=True)
class SchemaValidationResult:
    diagnostics: tuple[Diagnostic, ...]

    @property
    def valid(self) -> bool:
        return not any(item.severity == "error" for item in self.diagnostics)

    @property
    def complete(self) -> bool:
        return not any(item.code == "ZEN503" for item in self.diagnostics)

    @property
    def exit_code(self) -> int:
        return 1 if not self.valid else 0 if self.complete else 2


def validate_file(
    path: str | Path, schema: SchemaContext, *, import_root: str | Path | None = None,
) -> SchemaValidationResult:
    return validate_zcfg(parse_file(path, import_root=import_root), schema)


def validate_zcfg(document: Document, schema: SchemaContext) -> SchemaValidationResult:
    """Check a frontend-validated AST. Both conditional bodies are inspected.

    Bare imports retain their assignment locations. Bound imports are values,
    not mounts. This is not merged-config inference or a defaults/action check.
    """
    if document.kind is not FileKind.ZCFG:
        raise ZenLangError(Diagnostic("ZEN500", "mounted schema validation requires ZCFG", document.span))
    if document.grammar_version != GRAMMAR_VERSION or document.ir_version != IR_VERSION:
        raise ZenLangError(Diagnostic("ZEN500", "unsupported ZCFG grammar/IR version", document.span))
    diagnostics = list(document.diagnostics)

    def report(code: str, message: str, span: Span) -> None:
        diagnostics.append(Diagnostic(code, message, span, "warning" if code == "ZEN503" else "error"))

    def lookup(path: tuple[str, ...], span: Span) -> dict[str, Any] | None:
        current = schema.root
        for index, part in enumerate(path):
            if current["kind"] == "unsupported":
                report("ZEN503", f"{'.'.join(path)}: schema unavailable: {current['reason']}", span)
                return None
            if current["kind"] == "option":
                if _annotation_type(current["annotation"]) in ("set", "either"):
                    report("ZEN503", f"{'.'.join(path)}: traversal inside a value-typed option is unsupported; assign its record as a value", span)
                else:
                    report("ZEN501", f"{'.'.join(path)}: cannot traverse a scalar or list option", span)
                return None
            current = current["children"].get(part, current["freeform"])
            if current is None:
                report("ZEN501", f"unknown mounted option or selector: {'.'.join(path[:index + 1])}", span)
                return None
        if current["kind"] == "unsupported":
            report("ZEN503", f"{'.'.join(path)}: schema unavailable: {current['reason']}", span)
            return None
        return current

    def references(value: Any) -> None:
        if isinstance(value, Variable) and value.name == "cfg":
            path = _names(value.path)
            if path is None:
                report("ZEN503", "dynamic $cfg path cannot be checked statically", value.span)
            elif path:
                lookup(path, value.span)
        if isinstance(value, tuple):
            for item in value:
                references(item)
        elif is_dataclass(value):
            for field in fields(value):
                if field.name not in ("span", "diagnostics"):
                    references(getattr(value, field.name))

    def check_value(value: Any, current: dict[str, Any], path: tuple[str, ...]) -> None:
        while isinstance(value, GroupExpr):
            value = value.value
        label = ".".join(path)
        if current["kind"] == "branch":
            if isinstance(value, AttrSet) and not value.recursive:
                visit(value.statements, path)
            elif isinstance(value, Literal) and value.kind in ("true", "false") and current["shorthand"]:
                enable = lookup((*path, "enable"), value.span)
                if enable is not None:
                    check_value(value, enable, (*path, "enable"))
            elif _known(value):
                report("ZEN502", f"{label}: mounted branch requires an attribute set" + (" or module boolean shorthand" if current["shorthand"] else ""), value.span)
            else:
                report("ZEN503", f"{label}: expression contents cannot be validated without evaluation", value.span)
        elif _known(value):
            descriptor = semantic_descriptor(_literal_data(value))
            statuses = {check["status"] for check in current["checks"] if check["value"] == descriptor}
            if statuses == {"rejected"}:
                report("ZEN502", f"{label}: value rejected by mounted runtime type {current['label']}", value.span)
            elif statuses != {"accepted"}:
                report("ZEN503", f"{label}: literal has no conclusive runtime type check; regenerate requests and schema", value.span)
        else:
            report("ZEN503", f"{label}: value is not statically known; expected {current['label']}", value.span)

    def visit(statements: Any, prefix: tuple[str, ...]) -> None:
        for statement in statements:
            if isinstance(statement, ResolvedImport):
                if statement.binding is None:
                    visit(statement.document.statements, prefix)
                continue
            if isinstance(statement, ImportStatement):
                report("ZEN503", "unresolved import; use parse_file or validate_file", statement.span)
            elif isinstance(statement, LetStatement):
                continue
            elif isinstance(statement, ConditionalStatement):
                if not _known(statement.condition):
                    report("ZEN503", "configuration condition is not statically known", statement.condition.span)
                visit(statement.body.statements, prefix)
            elif isinstance(statement, Assignment):
                suffix = _names(statement.target)
                if suffix is None:
                    report("ZEN503", "dynamic assignment path cannot be checked statically", statement.span)
                    continue
                path = (*prefix, *suffix)
                if path[:1] == ("_meta",):
                    continue
                current = lookup(path, statement.span)
                if current is not None:
                    check_value(statement.value, current, path)
            else:
                report("ZEN503", "statement contents cannot be validated statically", statement.span)

    references(document.statements)
    visit(document.statements, ())
    return SchemaValidationResult(tuple(dict.fromkeys(diagnostics)))
