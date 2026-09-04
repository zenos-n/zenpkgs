from __future__ import annotations

from .lexer import Token, TokenKind, lex
from .model import (
    Assignment,
    AttrSet,
    Diagnostic,
    Document,
    Expression,
    Import,
    ListExpr,
    Literal,
    PkgsRef,
    Span,
    ZcfgError,
)


class Parser:
    def __init__(self, tokens: tuple[Token, ...]):
        self.tokens = tokens
        self.index = 0

    def parse_document(self) -> Document:
        imports: list[Import] = []
        assignments: list[Assignment] = []
        saw_assignment = False
        while not self._at(TokenKind.EOF):
            if self._at(TokenKind.IMPORT):
                if saw_assignment:
                    self._raise(
                        self._current(),
                        "ZCFG102",
                        "imports must appear before all assignments",
                    )
                imports.append(self._parse_import())
            else:
                saw_assignment = True
                assignments.append(self._parse_assignment())
        eof = self._current()
        start = self.tokens[0].span.start
        return Document(
            imports=tuple(imports),
            assignments=tuple(assignments),
            span=Span(eof.span.source, start, eof.span.end),
        )

    def _parse_import(self) -> Import:
        start = self._consume(TokenKind.IMPORT, "expected 'import'")
        path = self._consume(
            TokenKind.RELPATH,
            "imports require a bare relative path such as ./base.zcfg",
        )
        end = self._consume(TokenKind.SEMICOLON, "expected ';' after import")
        return Import(
            path=str(path.value),
            span=Span(start.span.source, start.span.start, end.span.end),
        )

    def _parse_assignment(self) -> Assignment:
        path, path_span = self._parse_attr_path("expected an assignment or import")
        self._consume(TokenKind.EQUALS, "expected '=' after attribute path")
        value = self._parse_value()
        end = self._consume(TokenKind.SEMICOLON, "expected ';' after assignment")
        return Assignment(
            path=path,
            value=value,
            span=Span(path_span.source, path_span.start, end.span.end),
            path_span=path_span,
        )

    def _parse_attr_path(self, message: str) -> tuple[tuple[str, ...], Span]:
        first = self._consume(TokenKind.IDENT, message)
        path = [first.text]
        end = first.span.end
        while self._at(TokenKind.DOT):
            self._advance()
            segment = self._consume(
                TokenKind.IDENT,
                "expected an identifier after '.'",
            )
            path.append(segment.text)
            end = segment.span.end
        return tuple(path), Span(first.span.source, first.span.start, end)

    def _parse_value(self) -> Expression:
        token = self._current()
        if token.kind is TokenKind.STRING:
            self._advance()
            return Literal(str(token.value), token.span)
        if token.kind is TokenKind.INTEGER:
            self._advance()
            try:
                value = int(token.value)
            except ValueError:
                self._raise(token, "ZCFG103", "integer is outside the signed 64-bit range")
            if value < -(2**63) or value > 2**63 - 1:
                self._raise(token, "ZCFG103", "integer is outside the signed 64-bit range")
            return Literal(value, token.span)
        if token.kind is TokenKind.TRUE:
            self._advance()
            return Literal(True, token.span)
        if token.kind is TokenKind.FALSE:
            self._advance()
            return Literal(False, token.span)
        if token.kind is TokenKind.NULL:
            self._advance()
            return Literal(None, token.span)
        if token.kind is TokenKind.PKGS:
            return self._parse_pkgs_ref()
        if token.kind is TokenKind.LBRACKET:
            return self._parse_list()
        if token.kind is TokenKind.LBRACE:
            return self._parse_attr_set()
        self._raise(
            token,
            "ZCFG101",
            "expected a literal, list, attribute set, or $pkgs reference",
        )

    def _parse_pkgs_ref(self) -> PkgsRef:
        start = self._consume(TokenKind.PKGS, "expected '$pkgs'")
        self._consume(TokenKind.DOT, "$pkgs must reference at least one attribute")
        path, path_span = self._parse_attr_path(
            "expected an attribute name after '$pkgs.'"
        )
        return PkgsRef(path, Span(start.span.source, start.span.start, path_span.end))

    def _parse_list(self) -> ListExpr:
        start = self._consume(TokenKind.LBRACKET, "expected '['")
        items: list[Expression] = []
        while not self._at(TokenKind.RBRACKET):
            if self._at(TokenKind.EOF):
                self._raise(self._current(), "ZCFG101", "unterminated list")
            items.append(self._parse_value())
        end = self._consume(TokenKind.RBRACKET, "expected ']'")
        return ListExpr(
            tuple(items),
            Span(start.span.source, start.span.start, end.span.end),
        )

    def _parse_attr_set(self) -> AttrSet:
        start = self._consume(TokenKind.LBRACE, "expected '{'")
        assignments: list[Assignment] = []
        while not self._at(TokenKind.RBRACE):
            if self._at(TokenKind.EOF):
                self._raise(self._current(), "ZCFG101", "unterminated attribute set")
            if self._at(TokenKind.IMPORT):
                self._raise(
                    self._current(),
                    "ZCFG104",
                    "imports are only allowed at the top level",
                )
            assignments.append(self._parse_assignment())
        end = self._consume(TokenKind.RBRACE, "expected '}'")
        return AttrSet(
            tuple(assignments),
            Span(start.span.source, start.span.start, end.span.end),
        )

    def _consume(self, kind: TokenKind, message: str) -> Token:
        token = self._current()
        if token.kind is not kind:
            self._raise(token, "ZCFG101", message)
        self._advance()
        return token

    def _at(self, kind: TokenKind) -> bool:
        return self._current().kind is kind

    def _current(self) -> Token:
        return self.tokens[self.index]

    def _advance(self) -> None:
        if not self._at(TokenKind.EOF):
            self.index += 1

    @staticmethod
    def _raise(token: Token, code: str, message: str) -> None:
        raise ZcfgError(Diagnostic(code, message, token.span))


def parse(text: str, source: str = "<input>") -> Document:
    return Parser(lex(text, source)).parse_document()
