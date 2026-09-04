from __future__ import annotations

from collections.abc import Iterable

from .lexer import LexInterpolation, LexStringText, Token, TokenKind, lex
from .model import (
    ActionStatement,
    Assignment,
    AttributeSegment,
    AttrSet,
    BinaryExpr,
    CallExpr,
    ConditionalStatement,
    DefaultExpr,
    Diagnostic,
    Document,
    DynamicSegment,
    EnableOption,
    Expression,
    FileKind,
    GRAMMAR_VERSION,
    GroupExpr,
    IdentifierSegment,
    IfExpr,
    ImportStatement,
    InheritStatement,
    Interpolation,
    IR_VERSION,
    LambdaExpr,
    LambdaParameter,
    LetExpr,
    LetStatement,
    ListExpr,
    Literal,
    PathExpr,
    PackageImportStatement,
    Reference,
    SelectionExpr,
    Span,
    Statement,
    StringExpr,
    StringSegment,
    StringText,
    StructuralMarker,
    UnaryExpr,
    Variable,
    WithExpr,
    ZenLangError,
)


_BINARY_PRECEDENCE = {
    TokenKind.OR_OR: 10,
    TokenKind.AND_AND: 20,
    TokenKind.EQUAL_EQUAL: 30,
    TokenKind.BANG_EQUAL: 30,
    TokenKind.GREATER: 40,
    TokenKind.GREATER_EQUAL: 40,
    TokenKind.LESS: 40,
    TokenKind.LESS_EQUAL: 40,
    TokenKind.SLASH_SLASH: 50,
    TokenKind.PLUS_PLUS: 70,
    TokenKind.PLUS: 70,
    TokenKind.MINUS: 70,
    TokenKind.STAR: 80,
    TokenKind.SLASH: 80,
}

_STRUCTURAL_KINDS = frozenset(("freeform", "alias", "packages", "programs"))
_LITERAL_KEYWORDS = {"null": None, "true": True, "false": False}
_EXPRESSION_KEYWORD_STOPS = frozenset(("then", "else", "in"))
_DEFAULT_PRECEDENCE = 95


class Parser:
    def __init__(self, tokens: tuple[Token, ...], kind: FileKind):
        self.tokens = tokens
        self.kind = kind
        self.index = 0
        self.diagnostics: list[Diagnostic] = []

    def parse_document(self) -> Document:
        statements: list[Statement] = []
        while not self._at(TokenKind.EOF):
            statements.append(self._parse_statement())
        eof = self._current()
        start = self.tokens[0].span.start
        return Document(
            self.kind,
            GRAMMAR_VERSION,
            IR_VERSION,
            tuple(statements),
            Span(eof.span.source, start, eof.span.end),
            tuple(self.diagnostics),
        )

    def parse_interpolation(self) -> Expression:
        expression = self._parse_expression()
        if not self._at(TokenKind.EOF):
            self._raise(self._current(), "ZEN102", "expected the end of the interpolation")
        return expression

    def _parse_statement(self) -> Statement:
        if self._is_ident("_import"):
            return self._parse_import()
        if self._is_ident("import") and self._peek().kind is TokenKind.PATH:
            return self._parse_import(legacy=True)
        if self.kind is FileKind.ZPKG and self._is_ident("import"):
            return self._parse_package_import()
        if self._is_ident("_let"):
            return self._parse_let_statement()
        if self._is_ident("inherit"):
            return self._parse_inherit()
        if self._is_action_start():
            return self._parse_action()
        if self._is_ident("if"):
            return self._parse_conditional_statement()
        return self._parse_assignment()

    def _parse_package_import(self) -> PackageImportStatement:
        start = self._advance()
        if not self._at(TokenKind.VARIABLE):
            self._raise(
                self._current(),
                "ZEN122",
                "a ZPKG package import requires $pkgs.legacy.<path>",
            )
        package = self._parse_variable()
        end = self._consume(TokenKind.SEMICOLON, "expected ';' after package import")
        return PackageImportStatement(
            package,
            Span(start.span.source, start.span.start, end.span.end),
        )

    def _parse_import(self, *, legacy: bool = False) -> ImportStatement:
        start = self._advance()
        if legacy:
            self.diagnostics.append(
                Diagnostic(
                    "ZEN214",
                    "legacy 'import' syntax is deprecated; use '_import'",
                    start.span,
                    severity="warning",
                )
            )
        if self._at(TokenKind.STRING, TokenKind.MULTILINE_STRING, TokenKind.PATH):
            path = self._parse_import_path()
            end = self._consume(TokenKind.SEMICOLON, "expected ';' after import")
            return ImportStatement(path, None, None, self._joined(start.span, end.span))

        binding = self._consume(TokenKind.IDENT, "expected an import path or binding name")
        annotation: Expression | None = None
        if self._match(TokenKind.COLON):
            annotation = self._parse_expression(stop=(TokenKind.EQUAL,))
        self._consume(TokenKind.EQUAL, "expected '=' before a bound import path")
        path = self._parse_import_path()
        end = self._consume(TokenKind.SEMICOLON, "expected ';' after import")
        return ImportStatement(
            path,
            binding.text,
            annotation,
            Span(start.span.source, start.span.start, end.span.end),
        )

    def _parse_import_path(self) -> StringExpr | PathExpr:
        if self._at(TokenKind.STRING, TokenKind.MULTILINE_STRING):
            return self._parse_string(self._advance())
        token = self._consume(TokenKind.PATH, "imports require a string or filesystem path")
        return PathExpr(str(token.value), token.span)

    def _parse_let_statement(self) -> LetStatement:
        start = self._advance()
        name = self._consume(TokenKind.IDENT, "expected a local binding name")
        self._consume(TokenKind.COLON, "_let bindings require a type annotation")
        annotation = self._parse_expression(stop=(TokenKind.EQUAL,))
        self._consume(TokenKind.EQUAL, "expected '=' after _let type annotation")
        value = self._parse_expression(stop=(TokenKind.SEMICOLON,))
        end = self._consume(TokenKind.SEMICOLON, "expected ';' after _let binding")
        return LetStatement(
            name.text,
            annotation,
            value,
            Span(start.span.source, start.span.start, end.span.end),
        )

    def _parse_inherit(self) -> InheritStatement:
        start = self._advance()
        source: Expression | None = None
        if self._match(TokenKind.LPAREN):
            source = self._parse_expression(stop=(TokenKind.RPAREN,))
            self._consume(TokenKind.RPAREN, "expected ')' after inherit source")
        names: list[str] = []
        while self._at(TokenKind.IDENT):
            names.append(self._advance().text)
        if not names:
            self._raise(self._current(), "ZEN103", "inherit requires at least one identifier")
        end = self._consume(TokenKind.SEMICOLON, "expected ';' after inherit statement")
        return InheritStatement(
            source,
            tuple(names),
            Span(start.span.source, start.span.start, end.span.end),
        )

    def _parse_conditional_statement(self) -> ConditionalStatement:
        start = self._advance()
        condition = self._parse_expression(stop=(TokenKind.LBRACE,))
        body = self._parse_attr_set()
        end = self._consume(TokenKind.SEMICOLON, "expected ';' after conditional statement")
        return ConditionalStatement(
            condition,
            body,
            Span(start.span.source, start.span.start, end.span.end),
        )

    def _parse_action(self) -> ActionStatement:
        start = self._current()
        scope = "shared"
        if self._at(TokenKind.IDENT):
            scope_token = self._advance()
            scope = "system" if scope_token.text == "s" else "user"
        operator = self._current()
        if not self._match(TokenKind.BANG, TokenKind.DOUBLE_BANG):
            self._raise(operator, "ZEN104", "expected '!' or '!!' in action")
        unconditional = operator.kind is TokenKind.DOUBLE_BANG
        guards: tuple[Expression, ...] = ()
        if self._at(TokenKind.LBRACKET):
            if unconditional:
                self._raise(self._current(), "ZEN105", "unconditional actions cannot have guards")
            guard_list = self._parse_list()
            guards = guard_list.items
        body = self._parse_attr_set()
        end = self._consume(TokenKind.SEMICOLON, "expected ';' after action")
        return ActionStatement(
            scope,
            unconditional,
            guards,
            body,
            Span(start.span.source, start.span.start, end.span.end),
        )

    def _parse_assignment(self) -> Assignment:
        if self._looks_like_structural_marker():
            target: tuple[AttributeSegment, ...] | StructuralMarker = self._parse_structural_marker()
            start = target.span
        else:
            target = self._parse_attribute_path()
            start = target[0].span
        operator = self._current()
        if not self._match(TokenKind.EQUAL, TokenKind.PLUS_PLUS, TokenKind.MINUS_MINUS):
            self._raise(operator, "ZEN106", "expected '=', '++', or '--' after assignment target")
        value = self._parse_expression(stop=(TokenKind.SEMICOLON,))
        end = self._consume(TokenKind.SEMICOLON, "expected ';' after assignment")
        return Assignment(
            target,
            operator.text,
            value,
            Span(start.source, start.start, end.span.end),
        )

    def _parse_expression(
        self,
        minimum_precedence: int = 0,
        *,
        stop: Iterable[TokenKind] = (),
        allow_juxtaposition: bool = True,
    ) -> Expression:
        stops = frozenset(stop)
        expression = self._parse_prefix(stops, allow_juxtaposition)

        while self._current().kind not in stops and not self._at(TokenKind.EOF):
            if self._at(TokenKind.DOT):
                dot = self._advance()
                segment = self._parse_attribute_segment()
                expression = SelectionExpr(
                    expression,
                    segment,
                    Span(dot.span.source, expression.span.start, segment.span.end),
                )
                continue
            if self._is_ident("or") and minimum_precedence <= _DEFAULT_PRECEDENCE:
                if not self._supports_default(expression):
                    self._raise(
                        self._current(),
                        "ZEN119",
                        "'or' defaults require an attribute selection",
                    )
                self._advance()
                default = self._parse_expression(
                    _DEFAULT_PRECEDENCE + 1,
                    stop=stops,
                    allow_juxtaposition=allow_juxtaposition,
                )
                expression = DefaultExpr(
                    expression,
                    default,
                    Span(expression.span.source, expression.span.start, default.span.end),
                )
                continue
            precedence = _BINARY_PRECEDENCE.get(self._current().kind)
            if precedence is not None and precedence >= minimum_precedence:
                operator = self._advance()
                right = self._parse_expression(
                    precedence + 1,
                    stop=stops,
                    allow_juxtaposition=allow_juxtaposition,
                )
                expression = BinaryExpr(
                    expression,
                    operator.text,
                    right,
                    Span(expression.span.source, expression.span.start, right.span.end),
                )
                continue
            if (
                allow_juxtaposition
                and minimum_precedence <= 90
                and self._starts_expression()
                and self._current().leading_gap
                and not self._at_expression_keyword_stop()
            ):
                argument = self._parse_expression(91, stop=stops, allow_juxtaposition=False)
                if not self._is_selection_expression(argument):
                    self._raise(
                        self._current(),
                        "ZEN120",
                        "application arguments containing operators or control expressions must be parenthesized",
                    )
                expression = CallExpr(
                    expression,
                    (argument,),
                    Span(expression.span.source, expression.span.start, argument.span.end),
                )
                continue
            break
        return expression

    def _parse_prefix(
        self,
        stops: frozenset[TokenKind],
        allow_juxtaposition: bool,
    ) -> Expression:
        token = self._current()
        if token.kind in stops:
            self._raise(token, "ZEN107", "expected an expression")
        if self._looks_like_lambda():
            return self._parse_lambda(stops)
        if token.kind in (TokenKind.BANG, TokenKind.MINUS):
            operator = self._advance()
            operand = self._parse_expression(
                85,
                stop=stops,
                allow_juxtaposition=allow_juxtaposition,
            )
            return UnaryExpr(
                operator.text,
                operand,
                Span(operator.span.source, operator.span.start, operand.span.end),
            )
        if self._is_ident("if"):
            return self._parse_if_expression(stops)
        if self._is_ident("let"):
            return self._parse_let_expression(stops)
        if self._is_ident("with"):
            return self._parse_with_expression(stops)
        if token.kind is TokenKind.IDENT and token.text in _LITERAL_KEYWORDS:
            self._advance()
            return Literal(_LITERAL_KEYWORDS[token.text], token.text, token.span)
        if token.kind is TokenKind.INTEGER:
            self._advance()
            try:
                value = int(token.text)
            except ValueError:
                self._raise(token, "ZEN108", "invalid integer literal")
            return Literal(value, "integer", token.span)
        if token.kind is TokenKind.FLOAT:
            self._advance()
            return Literal(float(token.text), "float", token.span)
        if token.kind is TokenKind.VERSION:
            self._advance()
            return Literal(token.text, "version", token.span)
        if token.kind in (TokenKind.STRING, TokenKind.MULTILINE_STRING):
            self._advance()
            return self._parse_string(token)
        if token.kind is TokenKind.PATH:
            self._advance()
            return PathExpr(str(token.value), token.span)
        if token.kind is TokenKind.VARIABLE:
            return self._parse_variable()
        if token.kind is TokenKind.IDENT:
            if (
                token.text == "enableOption"
                and self._peek().kind is TokenKind.LBRACE
                and self._peek().leading_gap
            ):
                self._advance()
                body = self._parse_attr_set()
                return EnableOption(body, Span(token.span.source, token.span.start, body.span.end))
            path = self._parse_attribute_path()
            return Reference(path, Span(path[0].span.source, path[0].span.start, path[-1].span.end))
        if token.kind is TokenKind.LBRACKET:
            return self._parse_list()
        if token.kind is TokenKind.LBRACE or self._is_ident("rec"):
            return self._parse_attr_set()
        if self._looks_like_structural_marker():
            return self._parse_structural_marker()
        if self._match(TokenKind.LPAREN):
            start = self.tokens[self.index - 1]
            expression = self._parse_expression(stop=(TokenKind.RPAREN,))
            end = self._consume(TokenKind.RPAREN, "expected ')' after expression")
            return GroupExpr(
                expression,
                Span(start.span.source, start.span.start, end.span.end),
            )
        self._raise(token, "ZEN107", f"expected an expression, found {token.kind.value}")

    def _parse_if_expression(self, stops: frozenset[TokenKind]) -> IfExpr:
        start = self._advance()
        condition = self._parse_expression(stop=(), allow_juxtaposition=True)
        if not self._is_ident("then"):
            self._raise(self._current(), "ZEN109", "expected 'then' in conditional expression")
        self._advance()
        then_value = self._parse_expression(stop=(), allow_juxtaposition=True)
        if not self._is_ident("else"):
            self._raise(self._current(), "ZEN109", "expected 'else' in conditional expression")
        self._advance()
        else_value = self._parse_expression(stop=stops)
        return IfExpr(
            condition,
            then_value,
            else_value,
            Span(start.span.source, start.span.start, else_value.span.end),
        )

    def _parse_let_expression(self, stops: frozenset[TokenKind]) -> LetExpr:
        start = self._advance()
        statements: list[Statement] = []
        while not self._is_ident("in"):
            if self._at(TokenKind.EOF):
                self._raise(self._current(), "ZEN110", "unterminated let expression; expected 'in'")
            if self._is_ident("_let"):
                statements.append(self._parse_let_statement())
                continue
            if (
                self._at(TokenKind.IDENT)
                and self._current().text in ("_import", "import", "inherit", "if")
            ) or self._is_action_start():
                self._raise(
                    self._current(),
                    "ZEN121",
                    "let expressions contain only assignments and _let bindings",
                )
            statement = self._parse_assignment()
            if isinstance(statement.target, StructuralMarker):
                self._raise(
                    self._current(),
                    "ZEN121",
                    "let expressions do not allow structural assignments",
                )
            statements.append(statement)
        self._advance()
        body = self._parse_expression(stop=stops)
        return LetExpr(
            tuple(statements),
            body,
            Span(start.span.source, start.span.start, body.span.end),
        )

    def _parse_with_expression(self, stops: frozenset[TokenKind]) -> WithExpr:
        start = self._advance()
        scope = self._parse_expression(stop=(TokenKind.SEMICOLON,))
        self._consume(TokenKind.SEMICOLON, "expected ';' after with scope")
        body = self._parse_expression(stop=stops)
        return WithExpr(scope, body, Span(start.span.source, start.span.start, body.span.end))

    def _parse_lambda(self, stops: frozenset[TokenKind]) -> LambdaExpr:
        start = self._current().span.start
        source = self._current().span.source
        parameters: list[LambdaParameter] = []
        if self._at(TokenKind.LBRACE):
            self._advance()
            while not self._at(TokenKind.RBRACE):
                if self._match(TokenKind.ELLIPSIS):
                    token = self.tokens[self.index - 1]
                    parameters.append(LambdaParameter(None, None, True, token.span))
                else:
                    name = self._consume(TokenKind.IDENT, "expected a lambda parameter")
                    default: Expression | None = None
                    if self._match(TokenKind.QUESTION):
                        default = self._parse_expression(stop=(TokenKind.COMMA, TokenKind.RBRACE))
                    end = default.span.end if default is not None else name.span.end
                    parameters.append(
                        LambdaParameter(name.text, default, False, Span(source, name.span.start, end))
                    )
                if not self._match(TokenKind.COMMA):
                    break
            self._consume(TokenKind.RBRACE, "expected '}' after lambda parameters")
            form = "set"
        else:
            token = self._advance()
            name = str(token.value) if token.kind is TokenKind.VARIABLE else token.text
            parameters.append(LambdaParameter(name, None, False, token.span))
            form = "variable" if token.kind is TokenKind.VARIABLE else "identifier"
        self._consume(TokenKind.COLON, "expected ':' after lambda parameters")
        body = self._parse_expression(stop=stops)
        return LambdaExpr(tuple(parameters), body, form, Span(source, start, body.span.end))

    def _parse_list(self) -> ListExpr:
        start = self._consume(TokenKind.LBRACKET, "expected '['")
        items: list[Expression] = []
        while not self._at(TokenKind.RBRACKET):
            if self._at(TokenKind.EOF):
                self._raise(self._current(), "ZEN111", "unterminated list")
            if self._at(TokenKind.SEMICOLON):
                self._raise(self._current(), "ZEN111", "expected ']' before ';'")
            if self._at(TokenKind.COMMA):
                self._raise(
                    self._current(),
                    "ZEN117",
                    "list items must be separated by whitespace, not commas",
                )
            if items and not self._current().leading_gap:
                self._raise(
                    self._current(),
                    "ZEN117",
                    "list items must be separated by whitespace",
                )
            items.append(
                self._parse_expression(
                    91,
                    stop=(TokenKind.RBRACKET, TokenKind.COMMA),
                    allow_juxtaposition=False,
                )
            )
            if not self._is_selection_expression(items[-1]):
                self._raise(
                    self._current(),
                    "ZEN120",
                    "list expressions containing operators or control expressions must be parenthesized",
                )
            if self._at(TokenKind.COMMA):
                self._raise(
                    self._current(),
                    "ZEN117",
                    "list items must be separated by whitespace, not commas",
                )
        end = self._consume(TokenKind.RBRACKET, "expected ']'")
        return ListExpr(tuple(items), Span(start.span.source, start.span.start, end.span.end))

    def _parse_attr_set(self) -> AttrSet:
        recursive = False
        if self._is_ident("rec"):
            start = self._advance()
            recursive = True
        else:
            start = self._current()
        self._consume(TokenKind.LBRACE, "expected '{'")
        statements: list[Statement] = []
        while not self._at(TokenKind.RBRACE):
            if self._at(TokenKind.EOF):
                self._raise(self._current(), "ZEN112", "unterminated attribute set")
            statements.append(self._parse_statement())
        end = self._consume(TokenKind.RBRACE, "expected '}'")
        return AttrSet(
            tuple(statements),
            recursive,
            Span(start.span.source, start.span.start, end.span.end),
        )

    def _parse_structural_marker(self) -> StructuralMarker:
        start = self._consume(TokenKind.LPAREN, "expected '('")
        kind = self._consume(TokenKind.IDENT, "expected a structural marker name")
        if kind.text not in _STRUCTURAL_KINDS:
            self._raise(kind, "ZEN113", f"unknown structural marker {kind.text!r}")
        argument: tuple[AttributeSegment, ...] | None = None
        if not self._at(TokenKind.RPAREN):
            argument = self._parse_attribute_path()
        end = self._consume(TokenKind.RPAREN, "expected ')' after structural marker")
        if kind.text in ("packages", "programs") and argument is not None:
            self._raise(kind, "ZEN114", f"({kind.text}) does not accept an argument")
        if kind.text in ("freeform", "alias") and argument is None:
            self._raise(kind, "ZEN114", f"({kind.text}) requires an argument")
        return StructuralMarker(
            kind.text,
            argument,
            Span(start.span.source, start.span.start, end.span.end),
        )

    def _parse_variable(self) -> Variable:
        start = self._advance()
        path: list[AttributeSegment] = []
        while self._match(TokenKind.DOT):
            path.append(self._parse_attribute_segment())
        end = path[-1].span.end if path else start.span.end
        return Variable(
            str(start.value),
            tuple(path),
            Span(start.span.source, start.span.start, end),
        )

    def _parse_attribute_path(self) -> tuple[AttributeSegment, ...]:
        path = [self._parse_attribute_segment(allow_dynamic=False)]
        while self._match(TokenKind.DOT):
            path.append(self._parse_attribute_segment())
        return tuple(path)

    def _parse_attribute_segment(self, *, allow_dynamic: bool = True) -> AttributeSegment:
        token = self._current()
        if token.kind is TokenKind.IDENT:
            self._advance()
            return IdentifierSegment(token.text, token.span)
        if token.kind in (TokenKind.STRING, TokenKind.MULTILINE_STRING):
            self._advance()
            string_value = self._parse_string(token)
            if any(isinstance(part, Interpolation) for part in string_value.parts):
                self._raise(token, "ZEN115", "quoted attribute segments cannot contain interpolation")
            value = "".join(part.value for part in string_value.parts if isinstance(part, StringText))
            return StringSegment(value, token.span)
        if allow_dynamic and self._match(TokenKind.LPAREN):
            start = self.tokens[self.index - 1]
            if not self._at(TokenKind.VARIABLE):
                self._raise(
                    self._current(),
                    "ZEN118",
                    "dynamic attribute segments require a variable",
                )
            value = self._parse_variable()
            if not self._at(TokenKind.RPAREN):
                self._raise(
                    self._current(),
                    "ZEN118",
                    "dynamic attribute segments contain exactly one variable",
                )
            end = self._consume(TokenKind.RPAREN, "expected ')' after dynamic attribute segment")
            return DynamicSegment(value, Span(start.span.source, start.span.start, end.span.end))
        self._raise(token, "ZEN116", "expected an identifier, quoted name, or dynamic attribute segment")

    def _parse_string(self, token: Token) -> StringExpr:
        parts: list[StringText | Interpolation] = []
        for part in token.value or ():
            if isinstance(part, LexStringText):
                parts.append(StringText(part.value, part.span))
            elif isinstance(part, LexInterpolation):
                nested = Parser(lex(part.source, token.span.source, start=part.content_start), self.kind)
                parts.append(Interpolation(nested.parse_interpolation(), part.span))
        return StringExpr(tuple(parts), token.kind is TokenKind.MULTILINE_STRING, token.span)

    def _looks_like_structural_marker(self) -> bool:
        return (
            self._at(TokenKind.LPAREN)
            and self._peek().kind is TokenKind.IDENT
            and self._peek().text in _STRUCTURAL_KINDS
        )

    def _is_action_start(self) -> bool:
        if self._at(TokenKind.BANG, TokenKind.DOUBLE_BANG):
            return True
        return (
            self._at(TokenKind.IDENT)
            and self._current().text in ("s", "u")
            and self._peek().kind in (TokenKind.BANG, TokenKind.DOUBLE_BANG)
        )

    def _looks_like_lambda(self) -> bool:
        if self._at(TokenKind.IDENT, TokenKind.VARIABLE) and self._peek().kind is TokenKind.COLON:
            return True
        if not self._at(TokenKind.LBRACE):
            return False
        index = self.index + 1
        expect_parameter = True
        while index < len(self.tokens):
            kind = self.tokens[index].kind
            if kind is TokenKind.RBRACE:
                return index + 1 < len(self.tokens) and self.tokens[index + 1].kind is TokenKind.COLON
            if expect_parameter and kind not in (TokenKind.IDENT, TokenKind.ELLIPSIS):
                return False
            if kind is TokenKind.QUESTION:
                # Defaults may contain arbitrary syntax; find the next top-level comma/brace.
                depth = 0
                index += 1
                while index < len(self.tokens):
                    current = self.tokens[index].kind
                    if current in (TokenKind.LPAREN, TokenKind.LBRACKET, TokenKind.LBRACE):
                        depth += 1
                    elif current in (TokenKind.RPAREN, TokenKind.RBRACKET, TokenKind.RBRACE):
                        if depth == 0 and current is TokenKind.RBRACE:
                            break
                        depth -= 1
                    elif current is TokenKind.COMMA and depth == 0:
                        break
                    index += 1
                continue
            expect_parameter = kind is TokenKind.COMMA
            if kind not in (TokenKind.IDENT, TokenKind.ELLIPSIS, TokenKind.COMMA):
                return False
            index += 1
        return False

    def _starts_expression(self) -> bool:
        token = self._current()
        if token.kind in (
            TokenKind.IDENT,
            TokenKind.VARIABLE,
            TokenKind.INTEGER,
            TokenKind.FLOAT,
            TokenKind.VERSION,
            TokenKind.STRING,
            TokenKind.MULTILINE_STRING,
            TokenKind.PATH,
            TokenKind.LPAREN,
            TokenKind.LBRACE,
            TokenKind.LBRACKET,
            TokenKind.BANG,
            TokenKind.MINUS,
        ):
            return True
        return False

    def _at_expression_keyword_stop(self) -> bool:
        return self._at(TokenKind.IDENT) and self._current().text in _EXPRESSION_KEYWORD_STOPS | {"or"}

    @staticmethod
    def _is_selection_expression(expression: Expression) -> bool:
        return not isinstance(
            expression,
            (BinaryExpr, CallExpr, IfExpr, LambdaExpr, LetExpr, UnaryExpr, WithExpr),
        )

    @staticmethod
    def _supports_default(expression: Expression) -> bool:
        if isinstance(expression, GroupExpr):
            return Parser._supports_default(expression.value)
        if isinstance(expression, Variable):
            return bool(expression.path)
        if isinstance(expression, Reference):
            return len(expression.path) > 1
        return isinstance(expression, SelectionExpr)

    def _is_ident(self, text: str) -> bool:
        return self._at(TokenKind.IDENT) and self._current().text == text

    def _consume(self, kind: TokenKind, message: str) -> Token:
        if not self._at(kind):
            self._raise(self._current(), "ZEN101", message)
        return self._advance()

    def _match(self, *kinds: TokenKind) -> bool:
        if self._at(*kinds):
            self._advance()
            return True
        return False

    def _at(self, *kinds: TokenKind) -> bool:
        return self._current().kind in kinds

    def _current(self) -> Token:
        return self.tokens[self.index]

    def _peek(self, distance: int = 1) -> Token:
        return self.tokens[min(self.index + distance, len(self.tokens) - 1)]

    def _advance(self) -> Token:
        token = self._current()
        if token.kind is not TokenKind.EOF:
            self.index += 1
        return token

    @staticmethod
    def _joined(start: Span, end: Span) -> Span:
        return Span(start.source, start.start, end.end)

    @staticmethod
    def _raise(token: Token, code: str, message: str) -> None:
        raise ZenLangError(Diagnostic(code, message, token.span))


def parse_tokens(tokens: tuple[Token, ...], kind: FileKind) -> Document:
    return Parser(tokens, kind).parse_document()
