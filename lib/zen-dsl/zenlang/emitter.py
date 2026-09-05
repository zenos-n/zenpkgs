from __future__ import annotations

import math
from collections.abc import Mapping, Sequence
from typing import Any

from .model import (
    ActionStatement,
    Assignment,
    AttrSet,
    BinaryExpr,
    CallExpr,
    ConditionalStatement,
    DefaultExpr,
    DynamicSegment,
    EnableOption,
    Expression,
    GroupExpr,
    IdentifierSegment,
    IfExpr,
    ImportStatement,
    MarkdownImport,
    InheritStatement,
    Interpolation,
    LambdaExpr,
    LetExpr,
    LetStatement,
    ListExpr,
    Literal,
    PathExpr,
    PackageImportStatement,
    Reference,
    ResolvedImport,
    SelectionExpr,
    Statement,
    StringExpr,
    StringSegment,
    StringText,
    StructuralMarker,
    UnaryExpr,
    Variable,
    WithExpr,
)


class NixEmissionError(ValueError):
    """Raised when an AST value cannot be represented safely as Nix source."""

    def __init__(self, message: str, span: object | None = None):
        super().__init__(message)
        self.span = span


_NIX_KEYWORDS = frozenset(
    ("assert", "else", "false", "if", "in", "inherit", "let", "null", "or", "rec", "then", "true", "with")
)
_DEFAULT_VARIABLE_ROOTS: Mapping[str, str | None] = {
    "c": "config",
    "cfg": "config.zenos",
    "deps": "deps",
    "f": None,
    "l": "licenses",
    "lib": "lib",
    "m": "maintainers",
    "name": "name",
    "path": "cfg",
    "pkgs": "pkgs",
    "src": "zenRuntime.src",
    "type": "lib.types",
    "v": None,
}


def quote_nix_string(value: str) -> str:
    pieces: list[str] = ['"']
    for character in value:
        if character == "\\":
            pieces.append("\\\\")
        elif character == '"':
            pieces.append('\\"')
        elif character == "\n":
            pieces.append("\\n")
        elif character == "\r":
            pieces.append("\\r")
        elif character == "\t":
            pieces.append("\\t")
        elif ord(character) < 32 or ord(character) == 127:
            raise NixEmissionError(
                f"Nix strings cannot safely encode control character U+{ord(character):04X}"
            )
        else:
            pieces.append(character)
    return "".join(pieces).replace("${", "\\${") + '"'


def is_nix_identifier(value: str) -> bool:
    if not value or value in _NIX_KEYWORDS:
        return False
    if not (value[0].isascii() and (value[0].isalpha() or value[0] == "_")):
        return False
    return all(
        character.isascii() and (character.isalnum() or character in "_'-")
        for character in value[1:]
    )


def emit_attr_name(value: str) -> str:
    return value if is_nix_identifier(value) else quote_nix_string(value)


def emit_nix_data(value: Any, indent: int = 0) -> str:
    """Emit deterministic Nix for JSON-like Python data."""
    if value is None:
        return "null"
    if value is True:
        return "true"
    if value is False:
        return "false"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, float):
        if not math.isfinite(value):
            raise NixEmissionError("non-finite floats are not valid Nix literals")
        return repr(value)
    if isinstance(value, str):
        return quote_nix_string(value)
    if isinstance(value, Mapping):
        if not value:
            return "{ }"
        padding = " " * (indent + 2)
        lines = [
            f"{padding}{emit_attr_name(str(key))} = {emit_nix_data(value[key], indent + 2)};"
            for key in sorted(value, key=lambda item: str(item))
        ]
        return "{\n" + "\n".join(lines) + "\n" + " " * indent + "}"
    if isinstance(value, Sequence) and not isinstance(value, (str, bytes, bytearray)):
        if not value:
            return "[ ]"
        padding = " " * (indent + 2)
        lines = [f"{padding}{emit_nix_data(item, indent + 2)}" for item in value]
        return "[\n" + "\n".join(lines) + "\n" + " " * indent + "]"
    raise NixEmissionError(f"unsupported Nix data value: {type(value).__name__}")


class NixEmitter:
    def __init__(self, variable_roots: Mapping[str, str | None] | None = None):
        self.variable_roots = dict(_DEFAULT_VARIABLE_ROOTS)
        if variable_roots is not None:
            self.variable_roots.update(variable_roots)

    def expression(self, expression: Expression, indent: int = 0) -> str:
        try:
            return self._expression(expression, indent)
        except NixEmissionError as error:
            if error.span is None:
                error.span = expression.span
            raise

    def _expression(self, expression: Expression, indent: int = 0) -> str:
        if isinstance(expression, Literal):
            if expression.value is None:
                return "null"
            if expression.value is True:
                return "true"
            if expression.value is False:
                return "false"
            if expression.kind == "version":
                return quote_nix_string(str(expression.value))
            if isinstance(expression.value, int):
                return str(expression.value)
            if isinstance(expression.value, float):
                if not math.isfinite(expression.value):
                    raise NixEmissionError(
                        "non-finite floats are not valid Nix literals"
                    )
                return repr(expression.value)
            if isinstance(expression.value, str):
                return quote_nix_string(expression.value)
            raise NixEmissionError(f"unsupported literal kind: {expression.kind!r}")
        if isinstance(expression, StringExpr):
            return self._string(expression)
        if isinstance(expression, MarkdownImport):
            raise NixEmissionError("unresolved Markdown import; use parse_file with an import root")
        if isinstance(expression, GroupExpr):
            return f"({self.expression(expression.value, indent)})"
        if isinstance(expression, PathExpr):
            return emit_nix_data(
                {
                    "__zenlangType": "path",
                    "kind": "absolute" if expression.value.startswith("/") else "relative",
                    "value": expression.value,
                },
                indent,
            )
        if isinstance(expression, Reference):
            return self._reference(expression)
        if isinstance(expression, Variable):
            return self._variable(expression)
        if isinstance(expression, ListExpr):
            return self._list(expression, indent)
        if isinstance(expression, AttrSet):
            return self.attr_set(expression, indent)
        if isinstance(expression, StructuralMarker):
            argument = [
                self.segment_value(segment) for segment in expression.argument or ()
            ]
            return emit_nix_data(
                {
                    "argument": argument,
                    "kind": expression.kind,
                    "type": "structural-marker",
                },
                indent,
            )
        if isinstance(expression, EnableOption):
            return (
                '{ __zenlangType = "enable-option"; body = '
                + self.attr_set(expression.body, indent + 2)
                + "; }"
            )
        if isinstance(expression, UnaryExpr):
            return (
                f"({expression.operator}{self.expression(expression.operand, indent)})"
            )
        if isinstance(expression, BinaryExpr):
            return (
                f"({self.expression(expression.left, indent)} {expression.operator} "
                f"{self.expression(expression.right, indent)})"
            )
        if isinstance(expression, SelectionExpr):
            return f"({self.expression(expression.value, indent)}).{self.segment(expression.segment)}"
        if isinstance(expression, DefaultExpr):
            return (
                f"({self.expression(expression.value, indent)} or "
                f"{self.expression(expression.default, indent)})"
            )
        if isinstance(expression, CallExpr):
            parts = [self.expression(expression.callee, indent)]
            parts.extend(
                self.expression(argument, indent) for argument in expression.arguments
            )
            return "(" + " ".join(parts) + ")"
        if isinstance(expression, IfExpr):
            return (
                f"(if {self.expression(expression.condition, indent)} then "
                f"{self.expression(expression.then_value, indent)} else "
                f"{self.expression(expression.else_value, indent)})"
            )
        if isinstance(expression, LetExpr):
            bindings, fragments = self._partition_statements(
                expression.statements, indent + 2
            )
            if fragments:
                raise NixEmissionError(
                    "conditional and action statements are not bindings in let expressions"
                )
            padding = " " * (indent + 2)
            body = "\n".join(f"{padding}{binding}" for binding in bindings)
            return f"(let\n{body}\n{' ' * indent}in {self.expression(expression.body, indent)})"
        if isinstance(expression, WithExpr):
            scope = self.expression(expression.scope, indent)
            return (
                f"(with {scope}; "
                f"{self.expression(expression.body, indent)})"
            )
        if isinstance(expression, LambdaExpr):
            parameters = self._lambda_parameters(expression)
            child = self.child_emitter()
            if expression.form == "variable":
                parameter = expression.parameters[0]
                if parameter.name is not None:
                    child.variable_roots[parameter.name] = parameter.name
            return f"({parameters}: {child.expression(expression.body, indent)})"
        raise NixEmissionError(f"unsupported expression: {type(expression).__name__}")

    def statement(self, statement: Statement, indent: int = 0) -> str:
        try:
            return self._statement(statement, indent)
        except NixEmissionError as error:
            if error.span is None:
                error.span = statement.span
            raise

    def _statement(self, statement: Statement, indent: int = 0) -> str:
        if isinstance(statement, Assignment):
            value = self.expression(statement.value, indent)
            if isinstance(statement.target, StructuralMarker):
                marker = self.expression(statement.target, indent + 2)
                return f"__zenStructural = {{ marker = {marker}; value = {value}; }};"
            target = self.path(statement.target)
            if statement.operator == "=":
                return f"{target} = {value};"
            raise NixEmissionError(
                f"dependency assignment operator {statement.operator!r} requires the ZPKG compiler"
            )
        if isinstance(statement, ImportStatement):
            raise NixEmissionError("filesystem imports must be resolved with parse_file before emission")
        if isinstance(statement, ResolvedImport):
            if statement.binding is None:
                raise NixEmissionError("bare imports must be merged before emission")
            return (
                f"{self.binding_name(statement.binding)} = "
                f"{self.document_value(statement.document, indent, annotation=statement.annotation)};"
            )
        if isinstance(statement, LetStatement):
            return f"{self.binding_name(statement.name)} = {self.expression(statement.value, indent)};"
        if isinstance(statement, ConditionalStatement):
            return (
                f"config = lib.mkIf {self.expression(statement.condition, indent)} "
                f"{self.attr_set(statement.body, indent)};"
            )
        if isinstance(statement, ActionStatement):
            condition = self.guard_condition(statement.guards)
            body = self.attr_set(statement.body, indent)
            value = body if statement.unconditional else f"lib.mkIf {condition} {body}"
            return f"config = {value};"
        if isinstance(statement, InheritStatement):
            names = " ".join(self.binding_name(name) for name in statement.names)
            if statement.source is None:
                return f"inherit {names};"
            return f"inherit ({self.expression(statement.source, indent)}) {names};"
        raise NixEmissionError(f"unsupported statement: {type(statement).__name__}")

    def attr_set(self, attr_set: AttrSet, indent: int = 0) -> str:
        bindings, fragments = self._partition_statements(
            attr_set.statements, indent + 2
        )
        prefix = "rec " if attr_set.recursive else ""
        padding = " " * (indent + 2)
        plain = prefix + "{ }"
        if bindings:
            plain = (
                prefix
                + "{\n"
                + "\n".join(f"{padding}{item}" for item in bindings)
                + "\n"
                + " " * indent
                + "}"
            )
        if not fragments:
            return plain
        items = [plain, *fragments] if bindings else fragments
        item_padding = " " * (indent + 2)
        return (
            "lib.mkMerge [\n"
            + "\n".join(f"{item_padding}{item}" for item in items)
            + "\n"
            + " " * indent
            + "]"
        )

    def document_value(
        self,
        document: object,
        indent: int = 0,
        *,
        annotation: Expression | None = None,
    ) -> str:
        statements = _flatten_resolved_imports(getattr(document, "statements"))
        descriptor = {
            "grammarVersion": getattr(document, "grammar_version"),
            "irVersion": getattr(document, "ir_version"),
            "kind": getattr(document, "kind").value,
            "statements": semantic_descriptor(statements),
            "typeAnnotation": semantic_descriptor(annotation),
        }
        return emit_nix_data(descriptor, indent)

    def path(
        self,
        segments: Sequence[IdentifierSegment | StringSegment | DynamicSegment]
        | StructuralMarker,
    ) -> str:
        if isinstance(segments, StructuralMarker):
            raise NixEmissionError("structural markers are not Nix assignment paths")
        if not segments:
            raise NixEmissionError("attribute paths cannot be empty")
        return ".".join(self.segment(segment) for segment in segments)

    def segment(
        self, segment: IdentifierSegment | StringSegment | DynamicSegment
    ) -> str:
        if isinstance(segment, IdentifierSegment):
            return emit_attr_name(segment.name)
        if isinstance(segment, StringSegment):
            return quote_nix_string(segment.value)
        if isinstance(segment, DynamicSegment):
            return "${" + self.expression(segment.value) + "}"
        raise NixEmissionError(
            f"unsupported attribute segment: {type(segment).__name__}"
        )

    def segment_value(
        self, segment: IdentifierSegment | StringSegment | DynamicSegment
    ) -> Any:
        if isinstance(segment, IdentifierSegment):
            return segment.name
        if isinstance(segment, StringSegment):
            return segment.value
        if isinstance(segment, DynamicSegment):
            return {"type": "dynamic", "value": semantic_descriptor(segment.value)}
        raise NixEmissionError(
            f"unsupported attribute segment: {type(segment).__name__}"
        )

    def guard_condition(
        self, guards: Sequence[Expression], extra: str | None = None
    ) -> str:
        parts = [extra] if extra is not None else []
        parts.extend(self.expression(guard) for guard in guards)
        return " && ".join(f"({part})" for part in parts) if parts else "true"

    def binding_name(self, value: str) -> str:
        if not is_nix_identifier(value):
            raise NixEmissionError(f"{value!r} is not a safe Nix binding name")
        return value

    def child_emitter(self) -> "NixEmitter":
        return NixEmitter(self.variable_roots)

    def _string(self, expression: StringExpr) -> str:
        pieces: list[str] = []
        for part in expression.parts:
            if isinstance(part, StringText):
                quoted = quote_nix_string(part.value)
                pieces.append(quoted[1:-1])
            elif isinstance(part, Interpolation):
                pieces.append("${" + self.expression(part.expression) + "}")
        return '"' + "".join(pieces) + '"'

    def _reference(self, expression: Reference) -> str:
        if not expression.path or not isinstance(expression.path[0], IdentifierSegment):
            raise NixEmissionError("Nix references must start with an identifier")
        root = self.binding_name(expression.path[0].name)
        suffix = "".join(f".{self.segment(segment)}" for segment in expression.path[1:])
        return root + suffix

    def _variable(self, expression: Variable) -> str:
        if expression.name == "name" and not expression.path:
            source_name = expression.span.source.rsplit("/", 1)[-1]
            source_name = source_name.rsplit(".", 1)[0]
            return quote_nix_string(source_name)
        if expression.name == "pkgs":
            remaining = expression.path
            if (
                remaining
                and isinstance(remaining[0], IdentifierSegment)
                and remaining[0].name == "zenos"
            ):
                remaining = remaining[1:]
            return "pkgs.zenos" + "".join(
                f".{self.segment(segment)}" for segment in remaining
            )
        if expression.name not in self.variable_roots:
            raise NixEmissionError(f"no Nix mapping for variable ${expression.name}")
        root = self.variable_roots[expression.name]
        if root is None:
            if not expression.path or not isinstance(
                expression.path[0], IdentifierSegment
            ):
                raise NixEmissionError(
                    f"${expression.name} requires an identifier path"
                )
            root = self.binding_name(expression.path[0].name)
            remaining = expression.path[1:]
        else:
            remaining = expression.path
        return root + "".join(f".{self.segment(segment)}" for segment in remaining)

    def _list(self, expression: ListExpr, indent: int) -> str:
        if not expression.items:
            return "[ ]"
        padding = " " * (indent + 2)
        items = [
            f"{padding}{self.expression(item, indent + 2)}" for item in expression.items
        ]
        return "[\n" + "\n".join(items) + "\n" + " " * indent + "]"

    def _lambda_parameters(self, expression: LambdaExpr) -> str:
        if expression.form in ("identifier", "variable"):
            parameter = expression.parameters[0]
            if parameter.name is None:
                raise NixEmissionError("lambda parameter is missing a name")
            return self.binding_name(parameter.name)
        values: list[str] = []
        for parameter in expression.parameters:
            if parameter.variadic:
                values.append("...")
            elif parameter.name is not None:
                value = self.binding_name(parameter.name)
                if parameter.default is not None:
                    value += " ? " + self.expression(parameter.default)
                values.append(value)
        return "{ " + ", ".join(values) + " }"

    def _partition_statements(
        self, statements: Sequence[Statement], indent: int
    ) -> tuple[list[str], list[str]]:
        bindings: list[str] = []
        fragments: list[str] = []
        for statement in statements:
            if isinstance(statement, ConditionalStatement):
                fragments.append(
                    f"(lib.mkIf {self.expression(statement.condition, indent)} {self.attr_set(statement.body, indent)})"
                )
            elif isinstance(statement, ActionStatement):
                body = self.attr_set(statement.body, indent)
                fragments.append(
                    body
                    if statement.unconditional
                    else f"(lib.mkIf {self.guard_condition(statement.guards)} {body})"
                )
            elif isinstance(statement, (ImportStatement, ResolvedImport)) and statement.binding is None:
                raise NixEmissionError("bare imports must be merged before emission")
            else:
                bindings.append(self.statement(statement, indent))
        return bindings, fragments


def emit_expression(
    expression: Expression, *, variable_roots: Mapping[str, str | None] | None = None
) -> str:
    return NixEmitter(variable_roots).expression(expression)


def emit_statement(
    statement: Statement, *, variable_roots: Mapping[str, str | None] | None = None
) -> str:
    return NixEmitter(variable_roots).statement(statement)


def semantic_descriptor(value: Any) -> Any:
    """Convert AST nodes to a stable, span-free descriptor made only of data."""
    if isinstance(value, MarkdownImport):
        raise NixEmissionError("unresolved Markdown import; use parse_file with an import root")
    if isinstance(value, Literal):
        return {"kind": value.kind, "type": "literal", "value": value.value}
    if isinstance(value, StringText):
        return {"type": "text", "value": value.value}
    if isinstance(value, Interpolation):
        return {
            "expression": semantic_descriptor(value.expression),
            "type": "interpolation",
        }
    if isinstance(value, StringExpr):
        return {
            "multiline": value.multiline,
            "parts": semantic_descriptor(value.parts),
            "type": "string",
        }
    if isinstance(value, GroupExpr):
        return {"type": "group", "value": semantic_descriptor(value.value)}
    if isinstance(value, PathExpr):
        return {"type": "path", "value": value.value}
    if isinstance(value, Reference):
        return {"path": semantic_descriptor(value.path), "type": "reference"}
    if isinstance(value, Variable):
        return {
            "name": value.name,
            "path": semantic_descriptor(value.path),
            "type": "variable",
        }
    if isinstance(value, ListExpr):
        return {"items": semantic_descriptor(value.items), "type": "list"}
    if isinstance(value, AttrSet):
        return {
            "recursive": value.recursive,
            "statements": semantic_descriptor(value.statements),
            "type": "attr-set",
        }
    if isinstance(value, StructuralMarker):
        return {
            "argument": semantic_descriptor(value.argument),
            "kind": value.kind,
            "type": "structural-marker",
        }
    if isinstance(value, EnableOption):
        return {"body": semantic_descriptor(value.body), "type": "enable-option"}
    if isinstance(value, UnaryExpr):
        return {
            "operand": semantic_descriptor(value.operand),
            "operator": value.operator,
            "type": "unary",
        }
    if isinstance(value, BinaryExpr):
        return {
            "left": semantic_descriptor(value.left),
            "operator": value.operator,
            "right": semantic_descriptor(value.right),
            "type": "binary",
        }
    if isinstance(value, SelectionExpr):
        return {
            "segment": semantic_descriptor(value.segment),
            "type": "selection",
            "value": semantic_descriptor(value.value),
        }
    if isinstance(value, DefaultExpr):
        return {
            "default": semantic_descriptor(value.default),
            "type": "default",
            "value": semantic_descriptor(value.value),
        }
    if isinstance(value, CallExpr):
        return {
            "arguments": semantic_descriptor(value.arguments),
            "callee": semantic_descriptor(value.callee),
            "type": "call",
        }
    if isinstance(value, IfExpr):
        return {
            "condition": semantic_descriptor(value.condition),
            "else": semantic_descriptor(value.else_value),
            "then": semantic_descriptor(value.then_value),
            "type": "if",
        }
    if isinstance(value, LetExpr):
        return {
            "body": semantic_descriptor(value.body),
            "statements": semantic_descriptor(value.statements),
            "type": "let",
        }
    if isinstance(value, WithExpr):
        return {
            "body": semantic_descriptor(value.body),
            "scope": semantic_descriptor(value.scope),
            "type": "with",
        }
    if isinstance(value, LambdaExpr):
        return {
            "form": value.form,
            "parameters": [
                {
                    "default": semantic_descriptor(parameter.default),
                    "name": parameter.name,
                    "variadic": parameter.variadic,
                }
                for parameter in value.parameters
            ],
            "body": semantic_descriptor(value.body),
            "type": "lambda",
        }
    if isinstance(value, Assignment):
        return {
            "operator": value.operator,
            "target": semantic_descriptor(value.target),
            "type": "assignment",
            "value": semantic_descriptor(value.value),
        }
    if isinstance(value, ImportStatement):
        return {
            "annotation": semantic_descriptor(value.annotation),
            "binding": value.binding,
            "path": semantic_descriptor(value.path),
            "type": "import",
        }
    if isinstance(value, PackageImportStatement):
        return {
            "package": semantic_descriptor(value.package),
            "type": "package-import",
        }
    if isinstance(value, ResolvedImport):
        return {
            "annotation": semantic_descriptor(value.annotation),
            "binding": value.binding,
            "document": {
                "grammarVersion": value.document.grammar_version,
                "irVersion": value.document.ir_version,
                "kind": value.document.kind.value,
                "statements": semantic_descriptor(value.document.statements),
            },
            "type": "resolved-import",
        }
    if isinstance(value, LetStatement):
        return {
            "annotation": semantic_descriptor(value.annotation),
            "name": value.name,
            "type": "let-binding",
            "value": semantic_descriptor(value.value),
        }
    if isinstance(value, ConditionalStatement):
        return {
            "body": semantic_descriptor(value.body),
            "condition": semantic_descriptor(value.condition),
            "type": "conditional",
        }
    if isinstance(value, ActionStatement):
        return {
            "body": semantic_descriptor(value.body),
            "guards": semantic_descriptor(value.guards),
            "scope": value.scope,
            "type": "action",
            "unconditional": value.unconditional,
        }
    if isinstance(value, InheritStatement):
        return {
            "names": list(value.names),
            "source": semantic_descriptor(value.source),
            "type": "inherit",
        }
    if isinstance(value, IdentifierSegment):
        return {"kind": "identifier", "value": value.name}
    if isinstance(value, StringSegment):
        return {"kind": "string", "value": value.value}
    if isinstance(value, DynamicSegment):
        return {"kind": "dynamic", "value": semantic_descriptor(value.value)}
    if isinstance(value, tuple):
        return [semantic_descriptor(item) for item in value]
    if value is None or isinstance(value, (str, int, float, bool)):
        return value
    raise NixEmissionError(f"unsupported descriptor node: {type(value).__name__}")


def _flatten_resolved_imports(statements: Sequence[Statement]) -> tuple[Statement, ...]:
    imported: list[Statement] = []
    local: list[Statement] = []
    for statement in statements:
        if isinstance(statement, ResolvedImport) and statement.binding is None:
            imported.extend(_flatten_resolved_imports(statement.document.statements))
        else:
            local.append(statement)
    return tuple((*imported, *local))
