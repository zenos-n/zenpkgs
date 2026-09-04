from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
import string

from .model import Diagnostic, Position, Span, ZenLangError


class TokenKind(str, Enum):
    EOF = "end of file"
    IDENT = "identifier"
    VARIABLE = "variable"
    INTEGER = "integer"
    FLOAT = "float"
    VERSION = "version"
    STRING = "string"
    MULTILINE_STRING = "multiline string"
    PATH = "path"
    LPAREN = "("
    RPAREN = ")"
    LBRACE = "{"
    RBRACE = "}"
    LBRACKET = "["
    RBRACKET = "]"
    DOT = "."
    COMMA = ","
    COLON = ":"
    SEMICOLON = ";"
    QUESTION = "?"
    EQUAL = "="
    PLUS = "+"
    MINUS = "-"
    STAR = "*"
    SLASH = "/"
    BANG = "!"
    DOUBLE_BANG = "!!"
    PLUS_PLUS = "++"
    MINUS_MINUS = "--"
    SLASH_SLASH = "//"
    OR_OR = "||"
    AND_AND = "&&"
    EQUAL_EQUAL = "=="
    BANG_EQUAL = "!="
    GREATER = ">"
    GREATER_EQUAL = ">="
    LESS = "<"
    LESS_EQUAL = "<="
    ELLIPSIS = "..."


@dataclass(frozen=True, slots=True)
class LexStringText:
    value: str
    span: Span


@dataclass(frozen=True, slots=True)
class LexInterpolation:
    source: str
    span: Span
    content_start: Position


LexStringPart = LexStringText | LexInterpolation


@dataclass(frozen=True, slots=True)
class Token:
    kind: TokenKind
    text: str
    span: Span
    value: object | None = None
    leading_gap: bool = False


_ONE_CHAR = {
    "(": TokenKind.LPAREN,
    ")": TokenKind.RPAREN,
    "{": TokenKind.LBRACE,
    "}": TokenKind.RBRACE,
    "[": TokenKind.LBRACKET,
    "]": TokenKind.RBRACKET,
    ".": TokenKind.DOT,
    ",": TokenKind.COMMA,
    ":": TokenKind.COLON,
    ";": TokenKind.SEMICOLON,
    "?": TokenKind.QUESTION,
    "=": TokenKind.EQUAL,
    "+": TokenKind.PLUS,
    "-": TokenKind.MINUS,
    "*": TokenKind.STAR,
    "/": TokenKind.SLASH,
    "!": TokenKind.BANG,
    ">": TokenKind.GREATER,
    "<": TokenKind.LESS,
}

_MULTI_CHAR = {
    "...": TokenKind.ELLIPSIS,
    "!!": TokenKind.DOUBLE_BANG,
    "++": TokenKind.PLUS_PLUS,
    "--": TokenKind.MINUS_MINUS,
    "//": TokenKind.SLASH_SLASH,
    "||": TokenKind.OR_OR,
    "&&": TokenKind.AND_AND,
    "==": TokenKind.EQUAL_EQUAL,
    "!=": TokenKind.BANG_EQUAL,
    ">=": TokenKind.GREATER_EQUAL,
    "<=": TokenKind.LESS_EQUAL,
}

_IDENT_START = frozenset(string.ascii_letters + "_")
_IDENT_CONTINUE = frozenset(string.ascii_letters + string.digits + "_-'" )
_PATH_CHARS = frozenset(string.ascii_letters + string.digits + "._+-/~")


class Lexer:
    def __init__(
        self,
        text: str,
        source: str,
        *,
        start: Position | None = None,
    ):
        self.text = text
        self.source = source
        origin = start or Position(0, 1, 1)
        self.base_offset = origin.offset
        self.index = 0
        self.line = origin.line
        self.column = origin.column

    def tokenize(self) -> tuple[Token, ...]:
        tokens: list[Token] = []
        while True:
            leading_gap = self._skip_trivia()
            if self._at_end():
                position = self._position()
                tokens.append(Token(TokenKind.EOF, "", Span(self.source, position, position), leading_gap=leading_gap))
                return tuple(tokens)

            start = self._position()
            if self._starts("''"):
                tokens.append(self._with_gap(self._string(start, multiline=True), leading_gap))
            elif self._peek() == '"':
                tokens.append(self._with_gap(self._string(start, multiline=False), leading_gap))
            elif self._starts_path():
                tokens.append(self._with_gap(self._path(start), leading_gap))
            elif self._peek() == "$":
                tokens.append(self._with_gap(self._variable(start), leading_gap))
            elif self._peek() in string.digits:
                tokens.append(self._with_gap(self._number(start), leading_gap))
            elif self._peek() in _IDENT_START:
                tokens.append(self._with_gap(self._identifier(start), leading_gap))
            else:
                matched = False
                for spelling in ("...", "!!", "++", "--", "//", "||", "&&", "==", "!=", ">=", "<="):
                    if self._starts(spelling):
                        self._advance_many(len(spelling))
                        tokens.append(Token(_MULTI_CHAR[spelling], spelling, self._span(start), leading_gap=leading_gap))
                        matched = True
                        break
                if matched:
                    continue
                character = self._peek()
                if character in _ONE_CHAR:
                    self._advance()
                    tokens.append(Token(_ONE_CHAR[character], character, self._span(start), leading_gap=leading_gap))
                    continue
                self._advance()
                self._raise("ZEN001", f"unsupported character {character!r}", start)

    def _skip_trivia(self) -> bool:
        skipped = False
        while not self._at_end():
            if self._peek() in " \t\r\n":
                skipped = True
                self._advance()
            elif self._peek() == "#":
                skipped = True
                while not self._at_end() and self._peek() != "\n":
                    self._advance()
            else:
                return skipped
        return skipped

    @staticmethod
    def _with_gap(token: Token, leading_gap: bool) -> Token:
        return Token(token.kind, token.text, token.span, token.value, leading_gap)

    def _identifier(self, start: Position) -> Token:
        self._advance()
        while not self._at_end() and self._peek() in _IDENT_CONTINUE:
            self._advance()
        text = self._slice(start)
        return Token(TokenKind.IDENT, text, self._span(start), text)

    def _variable(self, start: Position) -> Token:
        self._advance()
        if self._at_end() or self._peek() not in _IDENT_START:
            self._raise("ZEN002", "'$' must be followed by a variable name", start)
        self._advance()
        while not self._at_end() and self._peek() in _IDENT_CONTINUE:
            self._advance()
        text = self._slice(start)
        return Token(TokenKind.VARIABLE, text, self._span(start), text[1:])

    def _number(self, start: Position) -> Token:
        while not self._at_end() and self._peek() in string.digits:
            self._advance()
        components = 1
        while self._peek() == "." and self._peek(1) and self._peek(1) in string.digits:
            components += 1
            self._advance()
            while not self._at_end() and self._peek() in string.digits:
                self._advance()
        if components == 3:
            if self._peek() and self._peek() in string.ascii_uppercase:
                self._advance()
            if self._peek() and self._peek() in "abl":
                self._advance()
            if self._peek() and self._peek() in _IDENT_CONTINUE:
                while not self._at_end() and self._peek() in _IDENT_CONTINUE:
                    self._advance()
                self._raise(
                    "ZEN006",
                    "versions must match X.Y.Z[VARIANT][a|b|l]",
                    start,
                )
            kind = TokenKind.VERSION
        elif components > 3:
            self._raise(
                "ZEN006",
                "versions must contain exactly three numeric components",
                start,
            )
        elif components == 2:
            kind = TokenKind.FLOAT
        else:
            kind = TokenKind.INTEGER
        text = self._slice(start)
        return Token(kind, text, self._span(start), text)

    def _path(self, start: Position) -> Token:
        while not self._at_end() and self._peek() in _PATH_CHARS:
            self._advance()
        text = self._slice(start)
        remainder = text[1:] if text.startswith("/") else text[2:] if text.startswith("./") else text[3:]
        if not remainder or any(not segment for segment in remainder.split("/")):
            self._raise("ZEN007", "paths require non-empty path segments", start)
        return Token(TokenKind.PATH, text, self._span(start), text)

    def _string(self, start: Position, *, multiline: bool) -> Token:
        delimiter = "''" if multiline else '"'
        kind = TokenKind.MULTILINE_STRING if multiline else TokenKind.STRING
        self._advance_many(len(delimiter))
        parts: list[LexStringPart] = []
        text_start = self._position()
        decoded: list[str] = []

        def flush_text() -> None:
            nonlocal text_start
            if decoded:
                parts.append(LexStringText("".join(decoded), Span(self.source, text_start, self._position())))
                decoded.clear()
            text_start = self._position()

        while not self._at_end():
            if multiline and self._starts("''${"):
                decoded.append("${")
                self._advance_many(4)
                continue
            if multiline and self._starts("'''" ):
                decoded.append("''")
                self._advance_many(3)
                continue
            if self._starts(delimiter):
                flush_text()
                self._advance_many(len(delimiter))
                return Token(kind, self._slice(start), self._span(start), tuple(parts))
            if self._starts("${"):
                flush_text()
                interpolation_start = self._position()
                self._advance_many(2)
                content_start = self._position()
                content = self._interpolation_source(interpolation_start)
                parts.append(
                    LexInterpolation(
                        content,
                        Span(self.source, interpolation_start, self._position()),
                        content_start,
                    )
                )
                text_start = self._position()
                continue
            character_start = self._position()
            if multiline:
                character = self._advance()
                if (ord(character) < 0x20 and character not in "\n\r\t") or ord(character) == 0x7F:
                    self._raise("ZEN004", "string contains a control character", character_start)
                decoded.append(character)
                continue

            character = self._advance()
            if character in "\n\r":
                self._raise("ZEN003", "quoted strings cannot contain unescaped newlines", character_start)
            if character != "\\":
                if ord(character) < 0x20 or ord(character) == 0x7F:
                    self._raise("ZEN004", "string contains a control character", character_start)
                decoded.append(character)
                continue
            if self._at_end():
                break
            escaped = self._advance()
            escapes = {'"': '"', "\\": "\\", "n": "\n", "r": "\r", "t": "\t", "$": "$"}
            if escaped not in escapes:
                self._raise("ZEN004", f"unsupported string escape \\{escaped}", start)
            decoded.append(escapes[escaped])
        self._raise("ZEN003", "unterminated string literal", start)

    def _interpolation_source(self, start: Position) -> str:
        content_index = self.index
        depth = 1
        while not self._at_end():
            if self._starts("''"):
                self._skip_nested_string(multiline=True, interpolation_start=start)
                continue
            if self._peek() == '"':
                self._skip_nested_string(multiline=False, interpolation_start=start)
                continue
            if self._peek() == "#":
                while not self._at_end() and self._peek() != "\n":
                    self._advance()
                continue
            character = self._advance()
            if character == "{":
                depth += 1
            elif character == "}":
                depth -= 1
                if depth == 0:
                    return self.text[content_index : self.index - 1]
        self._raise("ZEN005", "unterminated string interpolation", start)

    def _skip_nested_string(self, *, multiline: bool, interpolation_start: Position) -> None:
        delimiter = "''" if multiline else '"'
        self._advance_many(len(delimiter))
        while not self._at_end():
            if multiline and self._starts("''${"):
                self._advance_many(4)
                continue
            if multiline and self._starts("'''"):
                self._advance_many(3)
                continue
            if self._starts(delimiter):
                self._advance_many(len(delimiter))
                return
            character = self._advance()
            if not multiline and character == "\\" and not self._at_end():
                self._advance()
        self._raise("ZEN005", "unterminated string inside interpolation", interpolation_start)

    def _starts_path(self) -> bool:
        if self._starts("./") or self._starts("../"):
            return True
        at_boundary = self.index == 0 or self.text[self.index - 1] in " \t\r\n=([{:;,"
        return (
            at_boundary
            and self._peek() == "/"
            and self._peek(1) not in ("", "/")
            and self._peek(1) not in " \t\r\n"
        )

    def _slice(self, start: Position) -> str:
        local_start = start.offset - self.base_offset
        return self.text[local_start : self.index]

    def _starts(self, text: str) -> bool:
        return self.text.startswith(text, self.index)

    def _peek(self, lookahead: int = 0) -> str:
        index = self.index + lookahead
        return self.text[index] if index < len(self.text) else ""

    def _at_end(self) -> bool:
        return self.index >= len(self.text)

    def _advance(self) -> str:
        character = self.text[self.index]
        self.index += 1
        if character == "\n":
            self.line += 1
            self.column = 1
        else:
            self.column += 1
        return character

    def _advance_many(self, count: int) -> None:
        for _ in range(count):
            self._advance()

    def _position(self) -> Position:
        return Position(self.base_offset + self.index, self.line, self.column)

    def _span(self, start: Position) -> Span:
        return Span(self.source, start, self._position())

    def _raise(self, code: str, message: str, start: Position) -> None:
        raise ZenLangError(Diagnostic(code, message, self._span(start)))


def lex(
    text: str,
    source: str = "<input>",
    *,
    start: Position | None = None,
) -> tuple[Token, ...]:
    return Lexer(text, source, start=start).tokenize()
