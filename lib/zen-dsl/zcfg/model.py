from __future__ import annotations

from dataclasses import dataclass
from typing import Any


@dataclass(frozen=True)
class Position:
    offset: int
    line: int
    column: int

    def to_dict(self) -> dict[str, int]:
        return {
            "offset": self.offset,
            "line": self.line,
            "column": self.column,
        }


@dataclass(frozen=True)
class Span:
    source: str
    start: Position
    end: Position

    def to_dict(self) -> dict[str, Any]:
        return {
            "source": self.source,
            "start": self.start.to_dict(),
            "end": self.end.to_dict(),
        }

    @classmethod
    def point(cls, source: str) -> "Span":
        position = Position(offset=0, line=1, column=1)
        return cls(source=source, start=position, end=position)


@dataclass(frozen=True)
class Diagnostic:
    code: str
    message: str
    span: Span
    severity: str = "error"
    notes: tuple[str, ...] = ()

    def to_dict(self) -> dict[str, Any]:
        result: dict[str, Any] = {
            "severity": self.severity,
            "code": self.code,
            "message": self.message,
            "span": self.span.to_dict(),
        }
        if self.notes:
            result["notes"] = list(self.notes)
        return result


class ZcfgError(Exception):
    def __init__(self, diagnostic: Diagnostic):
        super().__init__(diagnostic.message)
        self.diagnostic = diagnostic


@dataclass(frozen=True)
class Literal:
    value: str | int | bool | None
    span: Span


@dataclass(frozen=True)
class PkgsRef:
    path: tuple[str, ...]
    span: Span


@dataclass(frozen=True)
class ListExpr:
    items: tuple["Expression", ...]
    span: Span


@dataclass(frozen=True)
class Assignment:
    path: tuple[str, ...]
    value: "Expression"
    span: Span
    path_span: Span


@dataclass(frozen=True)
class AttrSet:
    assignments: tuple[Assignment, ...]
    span: Span


Expression = Literal | PkgsRef | ListExpr | AttrSet


@dataclass(frozen=True)
class Import:
    path: str
    span: Span


@dataclass(frozen=True)
class Document:
    imports: tuple[Import, ...]
    assignments: tuple[Assignment, ...]
    span: Span


def expression_to_dict(expression: Expression) -> dict[str, Any]:
    if isinstance(expression, Literal):
        return {
            "type": "literal",
            "value": expression.value,
            "span": expression.span.to_dict(),
        }
    if isinstance(expression, PkgsRef):
        return {
            "type": "pkgs_ref",
            "path": list(expression.path),
            "span": expression.span.to_dict(),
        }
    if isinstance(expression, ListExpr):
        return {
            "type": "list",
            "items": [expression_to_dict(item) for item in expression.items],
            "span": expression.span.to_dict(),
        }
    return {
        "type": "attr_set",
        "assignments": [assignment_to_dict(item) for item in expression.assignments],
        "span": expression.span.to_dict(),
    }


def assignment_to_dict(assignment: Assignment) -> dict[str, Any]:
    return {
        "type": "assignment",
        "path": list(assignment.path),
        "value": expression_to_dict(assignment.value),
        "span": assignment.span.to_dict(),
        "path_span": assignment.path_span.to_dict(),
    }


def document_to_dict(document: Document) -> dict[str, Any]:
    return {
        "type": "document",
        "imports": [
            {"type": "import", "path": item.path, "span": item.span.to_dict()}
            for item in document.imports
        ],
        "assignments": [assignment_to_dict(item) for item in document.assignments],
        "span": document.span.to_dict(),
    }
