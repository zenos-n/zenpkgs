from __future__ import annotations

from dataclasses import dataclass, fields, is_dataclass
from enum import Enum
from typing import Any, TypeAlias


GRAMMAR_VERSION = "1.0.0Na"
IR_VERSION = "1.0.0Na"


class FileKind(str, Enum):
    ZCFG = "zcfg"
    ZMDL = "zmdl"
    ZPKG = "zpkg"
    ZSTR = "zstr"

    @classmethod
    def from_source(cls, source: str) -> "FileKind":
        suffix = source.rsplit("/", 1)[-1].rsplit(".", 1)
        if len(suffix) == 2:
            try:
                return cls(suffix[1].lower())
            except ValueError:
                pass
        raise ZenLangError(
            Diagnostic(
                "ZEN201",
                "source must have a .zcfg, .zmdl, .zpkg, or .zstr extension",
                Span.point(source),
            )
        )


@dataclass(frozen=True, slots=True)
class Position:
    offset: int
    line: int
    column: int


@dataclass(frozen=True, slots=True)
class Span:
    source: str
    start: Position
    end: Position

    @classmethod
    def point(cls, source: str) -> "Span":
        position = Position(0, 1, 1)
        return cls(source, position, position)


@dataclass(frozen=True, slots=True)
class Diagnostic:
    code: str
    message: str
    span: Span
    severity: str = "error"
    notes: tuple[str, ...] = ()

    def to_dict(self) -> dict[str, Any]:
        return _to_data(self)


class ZenLangError(Exception):
    def __init__(self, diagnostic: Diagnostic):
        super().__init__(diagnostic.message)
        self.diagnostic = diagnostic
        self.sources: dict[str, str] = {}


@dataclass(frozen=True, slots=True)
class IdentifierSegment:
    name: str
    span: Span


@dataclass(frozen=True, slots=True)
class StringSegment:
    value: str
    span: Span


@dataclass(frozen=True, slots=True)
class DynamicSegment:
    value: "Expression"
    span: Span


AttributeSegment: TypeAlias = IdentifierSegment | StringSegment | DynamicSegment


@dataclass(frozen=True, slots=True)
class Literal:
    value: None | bool | int | float | str
    kind: str
    span: Span


@dataclass(frozen=True, slots=True)
class StringText:
    value: str
    span: Span


@dataclass(frozen=True, slots=True)
class Interpolation:
    expression: "Expression"
    span: Span


StringPart: TypeAlias = StringText | Interpolation


@dataclass(frozen=True, slots=True)
class StringExpr:
    parts: tuple[StringPart, ...]
    multiline: bool
    span: Span


@dataclass(frozen=True, slots=True)
class GroupExpr:
    value: "Expression"
    span: Span


@dataclass(frozen=True, slots=True)
class PathExpr:
    value: str
    span: Span


@dataclass(frozen=True, slots=True)
class Reference:
    path: tuple[AttributeSegment, ...]
    span: Span


@dataclass(frozen=True, slots=True)
class Variable:
    name: str
    path: tuple[AttributeSegment, ...]
    span: Span


@dataclass(frozen=True, slots=True)
class ListExpr:
    items: tuple["Expression", ...]
    span: Span


@dataclass(frozen=True, slots=True)
class AttrSet:
    statements: tuple["Statement", ...]
    recursive: bool
    span: Span


@dataclass(frozen=True, slots=True)
class StructuralMarker:
    kind: str
    argument: tuple[AttributeSegment, ...] | None
    span: Span


@dataclass(frozen=True, slots=True)
class EnableOption:
    body: AttrSet
    span: Span


@dataclass(frozen=True, slots=True)
class UnaryExpr:
    operator: str
    operand: "Expression"
    span: Span


@dataclass(frozen=True, slots=True)
class BinaryExpr:
    left: "Expression"
    operator: str
    right: "Expression"
    span: Span


@dataclass(frozen=True, slots=True)
class SelectionExpr:
    value: "Expression"
    segment: AttributeSegment
    span: Span


@dataclass(frozen=True, slots=True)
class DefaultExpr:
    value: "Expression"
    default: "Expression"
    span: Span


@dataclass(frozen=True, slots=True)
class CallExpr:
    callee: "Expression"
    arguments: tuple["Expression", ...]
    span: Span


@dataclass(frozen=True, slots=True)
class IfExpr:
    condition: "Expression"
    then_value: "Expression"
    else_value: "Expression"
    span: Span


@dataclass(frozen=True, slots=True)
class LetExpr:
    statements: tuple["Statement", ...]
    body: "Expression"
    span: Span


@dataclass(frozen=True, slots=True)
class WithExpr:
    scope: "Expression"
    body: "Expression"
    span: Span


@dataclass(frozen=True, slots=True)
class LambdaParameter:
    name: str | None
    default: "Expression | None"
    variadic: bool
    span: Span


@dataclass(frozen=True, slots=True)
class LambdaExpr:
    parameters: tuple[LambdaParameter, ...]
    body: "Expression"
    form: str
    span: Span


@dataclass(frozen=True, slots=True)
class Assignment:
    target: tuple[AttributeSegment, ...] | StructuralMarker
    operator: str
    value: "Expression"
    span: Span


@dataclass(frozen=True, slots=True)
class ImportStatement:
    path: StringExpr | PathExpr
    binding: str | None
    annotation: "Expression | None"
    span: Span


@dataclass(frozen=True, slots=True)
class PackageImportStatement:
    package: Variable
    span: Span


@dataclass(frozen=True, slots=True)
class ResolvedImport:
    document: "Document"
    binding: str | None
    annotation: "Expression | None"
    span: Span


@dataclass(frozen=True, slots=True)
class LetStatement:
    name: str
    annotation: "Expression"
    value: "Expression"
    span: Span


@dataclass(frozen=True, slots=True)
class ConditionalStatement:
    condition: "Expression"
    body: AttrSet
    span: Span


@dataclass(frozen=True, slots=True)
class ActionStatement:
    scope: str
    unconditional: bool
    guards: tuple["Expression", ...]
    body: AttrSet
    span: Span


@dataclass(frozen=True, slots=True)
class InheritStatement:
    source: "Expression | None"
    names: tuple[str, ...]
    span: Span


Statement: TypeAlias = (
    Assignment
    | ImportStatement
    | PackageImportStatement
    | ResolvedImport
    | LetStatement
    | ConditionalStatement
    | ActionStatement
    | InheritStatement
)

Expression: TypeAlias = (
    Literal
    | StringExpr
    | GroupExpr
    | PathExpr
    | Reference
    | Variable
    | ListExpr
    | AttrSet
    | StructuralMarker
    | EnableOption
    | UnaryExpr
    | BinaryExpr
    | SelectionExpr
    | DefaultExpr
    | CallExpr
    | IfExpr
    | LetExpr
    | WithExpr
    | LambdaExpr
)


@dataclass(frozen=True, slots=True)
class Document:
    kind: FileKind
    grammar_version: str
    ir_version: str
    statements: tuple[Statement, ...]
    span: Span
    diagnostics: tuple[Diagnostic, ...] = ()

    def to_dict(self) -> dict[str, Any]:
        return _to_data(self)


def _node_name(value: object) -> str:
    name = type(value).__name__
    result = []
    for index, character in enumerate(name):
        if index and character.isupper():
            result.append("_")
        result.append(character.lower())
    return "".join(result)


def _to_data(value: Any) -> Any:
    if isinstance(value, Enum):
        return value.value
    if isinstance(value, tuple):
        return [_to_data(item) for item in value]
    if is_dataclass(value):
        result = {field.name: _to_data(getattr(value, field.name)) for field in fields(value)}
        if not isinstance(value, (Position, Span, Diagnostic)):
            result = {"type": _node_name(value), **result}
        return result
    return value


def ast_to_dict(document: Document) -> dict[str, Any]:
    return document.to_dict()
