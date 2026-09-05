from __future__ import annotations

import math
import os
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
    "c": None,
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


def color_names() -> dict[str, str]:
    """CSS Color 4 named colors, plus the transparent keyword."""
    entries = """
aliceblue f0f8ff antiquewhite faebd7 aqua 00ffff aquamarine 7fffd4 azure f0ffff
beige f5f5dc bisque ffe4c4 black 000000 blanchedalmond ffebcd blue 0000ff
blueviolet 8a2be2 brown a52a2a burlywood deb887 cadetblue 5f9ea0 chartreuse 7fff00
chocolate d2691e coral ff7f50 cornflowerblue 6495ed cornsilk fff8dc crimson dc143c
cyan 00ffff darkblue 00008b darkcyan 008b8b darkgoldenrod b8860b darkgray a9a9a9
darkgreen 006400 darkgrey a9a9a9 darkkhaki bdb76b darkmagenta 8b008b darkolivegreen 556b2f
darkorange ff8c00 darkorchid 9932cc darkred 8b0000 darksalmon e9967a darkseagreen 8fbc8f
darkslateblue 483d8b darkslategray 2f4f4f darkslategrey 2f4f4f darkturquoise 00ced1 darkviolet 9400d3
deeppink ff1493 deepskyblue 00bfff dimgray 696969 dimgrey 696969 dodgerblue 1e90ff
firebrick b22222 floralwhite fffaf0 forestgreen 228b22 fuchsia ff00ff gainsboro dcdcdc
ghostwhite f8f8ff gold ffd700 goldenrod daa520 gray 808080 green 008000
greenyellow adff2f grey 808080 honeydew f0fff0 hotpink ff69b4 indianred cd5c5c
indigo 4b0082 ivory fffff0 khaki f0e68c lavender e6e6fa lavenderblush fff0f5
lawngreen 7cfc00 lemonchiffon fffacd lightblue add8e6 lightcoral f08080 lightcyan e0ffff
lightgoldenrodyellow fafad2 lightgray d3d3d3 lightgreen 90ee90 lightgrey d3d3d3 lightpink ffb6c1
lightsalmon ffa07a lightseagreen 20b2aa lightskyblue 87cefa lightslategray 778899 lightslategrey 778899
lightsteelblue b0c4de lightyellow ffffe0 lime 00ff00 limegreen 32cd32 linen faf0e6
magenta ff00ff maroon 800000 mediumaquamarine 66cdaa mediumblue 0000cd mediumorchid ba55d3
mediumpurple 9370db mediumseagreen 3cb371 mediumslateblue 7b68ee mediumspringgreen 00fa9a mediumturquoise 48d1cc
mediumvioletred c71585 midnightblue 191970 mintcream f5fffa mistyrose ffe4e1 moccasin ffe4b5
navajowhite ffdead navy 000080 oldlace fdf5e6 olive 808000 olivedrab 6b8e23
orange ffa500 orangered ff4500 orchid da70d6 palegoldenrod eee8aa palegreen 98fb98
paleturquoise afeeee palevioletred db7093 papayawhip ffefd5 peachpuff ffdab9 peru cd853f
pink ffc0cb plum dda0dd powderblue b0e0e6 purple 800080 rebeccapurple 663399
red ff0000 rosybrown bc8f8f royalblue 4169e1 saddlebrown 8b4513 salmon fa8072
sandybrown f4a460 seagreen 2e8b57 seashell fff5ee sienna a0522d silver c0c0c0
skyblue 87ceeb slateblue 6a5acd slategray 708090 slategrey 708090 snow fffafa
springgreen 00ff7f steelblue 4682b4 tan d2b48c teal 008080 thistle d8bfd8
tomato ff6347 turquoise 40e0d0 violet ee82ee wheat f5deb3 white ffffff
whitesmoke f5f5f5 yellow ffff00 yellowgreen 9acd32 transparent 00000000
""".split()
    return dict(zip(entries[::2], entries[1::2]))


def normalize_color(value: str) -> str:
    text = value.removeprefix("#")
    if len(text) not in (6, 8) or any(char not in "0123456789abcdefABCDEF" for char in text):
        raise ValueError("colors require six or eight hexadecimal digits, optionally prefixed by #")
    return text.lower()


def color_runtime() -> str:
    """Trusted color operations; interpolation uses premultiplied sRGB channels."""
    return r'''(let
      normalize = value:
        if builtins.isString value && builtins.match "#?([0-9a-fA-F]{6}|[0-9a-fA-F]{8})" value != null
        then builtins.replaceStrings [ "A" "B" "C" "D" "E" "F" ] [ "a" "b" "c" "d" "e" "f" ]
          (if builtins.substring 0 1 value == "#" then builtins.substring 1 (-1) value else value)
        else throw "Zen color requires six or eight hexadecimal digits";
      digits = "0123456789abcdef";
      indices = builtins.listToAttrs (builtins.genList (n: { name = builtins.substring n 1 digits; value = n; }) 16);
      decode = value: let text = normalize value; in
        builtins.genList (n: if n == 3 && builtins.stringLength text == 6 then 255 else
          indices.${builtins.substring (n * 2) 1 text} * 16 + indices.${builtins.substring (n * 2 + 1) 1 text}) 4;
      byte = value: let n = builtins.floor (value + 0.5); in
        builtins.substring (builtins.div n 16) 1 digits + builtins.substring (n - builtins.div n 16 * 16) 1 digits;
      encode = values: builtins.concatStringsSep "" (builtins.map byte values);
      amount = value: if builtins.isFloat value && value >= 0.0 && value <= 1.0 then value
        else throw "Zen color amount must be a float between 0.0 and 1.0";
      mix = first: second: weight: let
        a = decode first; b = decode second; t = amount weight;
        alphaA = builtins.elemAt a 3 / 255.0; alphaB = builtins.elemAt b 3 / 255.0;
        alpha = (1.0 - t) * alphaA + t * alphaB;
      in encode (builtins.genList (n: if n == 3 then alpha * 255.0 else
        if alpha == 0.0 then 0.0 else
        ((1.0 - t) * builtins.elemAt a n * alphaA + t * builtins.elemAt b n * alphaB) / alpha) 4);
    in {
      inherit normalize mix;
      alpha = value: weight: let channels = decode value; in encode
        (builtins.genList (n: if n == 3 then amount weight * 255.0 else builtins.elemAt channels n) 4);
      lighten = value: weight: mix value "ffffff" weight;
      darken = value: weight: mix value "000000" weight;
    })'''


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
            path = os.path.abspath(os.path.join(os.path.dirname(expression.span.source), expression.value))
            return f"(/. + {quote_nix_string(path)})"
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
            if isinstance(expression.callee, Variable) and expression.callee.name == "type":
                return self.type_expression(expression)
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
            name = self.binding_name(statement.name)
            annotation = self.type_expression(statement.annotation)
            value = self.expression(statement.value, indent)
            checked = (
                "(lib.evalModules { modules = [ { "
                f"options.value = lib.mkOption {{ type = {annotation}; }}; "
                f"config.value = {value}; }} ]; }}).config.value"
            )
            span = statement.span
            message = quote_nix_string(
                f"_let {statement.name} annotation mismatch: "
                f"{span.source}:{span.start.line}:{span.start.column}"
            )
            return (
                f"{name} = (builtins.addErrorContext {message} "
                f"((_zenCheckedValue: builtins.deepSeq _zenCheckedValue _zenCheckedValue) ({checked})));"
            )
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
        locals_ = [
            self.statement(statement, indent + 2)
            for statement in attr_set.statements
            if isinstance(statement, (LetStatement, ResolvedImport))
        ]
        bindings, fragments = self._partition_statements(
            tuple(statement for statement in attr_set.statements
                  if not isinstance(statement, (LetStatement, ResolvedImport))), indent + 2
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
        if fragments:
            items = [plain, *fragments] if bindings else fragments
            item_padding = " " * (indent + 2)
            plain = (
                "(lib.mkMerge [\n"
                + "\n".join(f"{item_padding}{item}" for item in items)
                + "\n"
                + " " * indent
                + "])"
            )
        if locals_:
            return "(let " + " ".join(locals_) + " in " + plain + ")"
        return plain

    def document_value(
        self,
        document: object,
        indent: int = 0,
        *,
        annotation: Expression | None = None,
    ) -> str:
        # Import resolution and merge precedence are shared with document lowering.
        from .compiler import _coalesce_zmdl_scope_assignments, _resolved_statements

        statements = _coalesce_zmdl_scope_assignments(_resolved_statements(document))
        value = self.attr_set(AttrSet(statements, False, document.span), indent)
        check = self.type_expression(annotation) if annotation is not None else "(lib.types.attrsOf lib.types.anything)"
        checked = (
            "(lib.evalModules { modules = [ { "
            f"options.value = lib.mkOption {{ type = {check}; }}; "
            f"config.value = {value}; }} ]; }}).config.value"
        )
        if annotation is None:
            return "(" + checked + ")"
        message = quote_nix_string(f"bound-import annotation mismatch: {document.span.source}")
        return (
            f"(let _zenCheckedValue = {checked}; "
            f"in builtins.addErrorContext {message} "
            "(builtins.deepSeq _zenCheckedValue _zenCheckedValue))"
        )

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
                value = self.expression(part.expression)
                message = quote_nix_string(
                    f"{part.span.source}:{part.span.start.line}: string interpolation requires a scalar, path, or package"
                )
                pieces.append("${((value: let kind = builtins.typeOf value; in "
                    'if kind == "string" then value '
                    'else if kind == "bool" || kind == "int" || kind == "float" then builtins.toJSON value '
                    'else if kind == "path" then "${value}" '
                    'else if kind == "set" && (value.type or null) == "derivation" '
                    '&& builtins.isString (value.outPath or null) then value.outPath '
                    'else throw ' + message + ") (" + value + "))}")
        return '"' + "".join(pieces) + '"'

    def _reference(self, expression: Reference) -> str:
        if not expression.path or not isinstance(expression.path[0], IdentifierSegment):
            raise NixEmissionError("Nix references must start with an identifier")
        root = self.binding_name(expression.path[0].name)
        suffix = "".join(f".{self.segment(segment)}" for segment in expression.path[1:])
        return root + suffix

    def _variable(self, expression: Variable) -> str:
        if expression.name == "type":
            return self.type_expression(expression)
        if expression.name == "c":
            names = color_names()
            if not expression.path:
                return f"({emit_nix_data(names)} // (builtins.removeAttrs {color_runtime()} [ \"normalize\" ]))"
            if len(expression.path) != 1 or not isinstance(expression.path[0], (IdentifierSegment, StringSegment)):
                raise NixEmissionError("$c requires a named color or color operation")
            name = self.segment_value(expression.path[0])
            if name in names:
                return quote_nix_string(names[name])
            if name in ("alpha", "mix", "lighten", "darken"):
                return f"{color_runtime()}.{name}"
            raise NixEmissionError(f"unknown CSS color primitive $c.{name}")
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

    def type_expression(self, annotation: Expression) -> str:
        if isinstance(annotation, GroupExpr):
            return self.type_expression(annotation.value)
        root = annotation.callee if isinstance(annotation, CallExpr) else annotation
        if not isinstance(root, Variable) or root.name != "type" or len(root.path) != 1:
            raise NixEmissionError("type expressions require a $type primitive", annotation.span)
        name = self.segment_value(root.path[0])
        if isinstance(annotation, CallExpr):
            if len(annotation.arguments) != 1 or not isinstance(annotation.arguments[0], ListExpr):
                raise NixEmissionError("type parameters must be enclosed in brackets", annotation.span)
            items = annotation.arguments[0].items
            if name in ("list", "set", "functionTo") and len(items) == 1:
                function = {"list": "listOf", "set": "attrsOf", "functionTo": "functionTo"}[name]
                return f"(lib.types.{function} {self.type_expression(items[0])})"
            if name == "enum":
                return f"(lib.types.enum {self.expression(annotation.arguments[0])})"
            if name == "either" and len(items) >= 2:
                result = self.type_expression(items[-1])
                for item in reversed(items[:-1]):
                    result = f"(lib.types.either {self.type_expression(item)} {result})"
                return result
            raise NixEmissionError(f"unsupported type application $type.{name}", annotation.span)
        if name == "color":
            return ('(let color = lib.types.mkOptionType { name = "zenColor"; '
                'functor = (lib.types.defaultFunctor "zenColor") // { type = color; }; '
                'description = "six- or eight-digit hexadecimal color"; '
                'check = value: builtins.isString value && builtins.match "#?([0-9a-fA-F]{6}|[0-9a-fA-F]{8})" value != null; '
                'merge = loc: defs: lib.types.str.merge loc (builtins.map (def: def // { value = '
                + color_runtime() + '.normalize def.value; }) defs); }; in color)')
        if name == "packages":
            return "(lib.types.attrsOf lib.types.anything)"
        if name == "null":
            return "(lib.types.enum [ null ])"
        aliases = {"string": "str", "boolean": "bool", "set": "attrs"}
        if name in ("string", "boolean", "bool", "int", "float", "path", "package", "set"):
            return "lib.types." + aliases.get(name, name)
        raise NixEmissionError(f"unsupported type primitive $type.{name}", annotation.span)

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
