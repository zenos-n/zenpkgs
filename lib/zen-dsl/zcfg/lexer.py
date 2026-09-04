from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
import string

from .model import Diagnostic, Position, Span, ZcfgError


class TokenKind(str, Enum):
    IDENT = "identifier"
    INTEGER = "integer"
    STRING = "string"
    RELPATH = "relative_path"
    PKGS = "$pkgs"
    IMPORT = "import"
    TRUE = "true"
    FALSE = "false"
    NULL = "null"
    DOT = "."
    EQUALS = "="
    SEMICOLON = ";"
    LBRACE = "{"
    RBRACE = "}"
    LBRACKET = "["
    RBRACKET = "]"
    EOF = "end of file"


KEYWORDS = {
    "import": TokenKind.IMPORT,
    "true": TokenKind.TRUE,
    "false": TokenKind.FALSE,
    "null": TokenKind.NULL,
}

SINGLE_CHAR_TOKENS = {
    ".": TokenKind.DOT,
    "=": TokenKind.EQUALS,
    ";": TokenKind.SEMICOLON,
    "{": TokenKind.LBRACE,
    "}": TokenKind.RBRACE,
    "[": TokenKind.LBRACKET,
    "]": TokenKind.RBRACKET,
}

PATH_CHARS = frozenset(string.ascii_letters + string.digits + "._+-/@%")


@dataclass(frozen=True)
class Token:
    kind: TokenKind
    text: str
    span: Span
    value: str | int | None = None


class Lexer:
    def __init__(self, text: str, source: str):
        self.text = text
        self.source = source
        self.index = 0
        self.line = 1
        self.column = 1

    def tokenize(self) -> tuple[Token, ...]:
        tokens: list[Token] = []
        while True:
            self._skip_trivia()
            if self._at_end():
                position = self._position()
                tokens.append(Token(TokenKind.EOF, "", Span(self.source, position, position)))
                return tuple(tokens)

            start = self._position()
            character = self._peek()
            if character == '"':
                tokens.append(self._string(start))
            elif self._starts_relative_path():
                tokens.append(self._relative_path(start))
            elif character == "$":
                tokens.append(self._pkgs(start))
            elif character in string.digits or (
                character == "-" and self._peek(1) in string.digits
            ):
                tokens.append(self._integer(start))
            elif character in string.ascii_letters or character == "_":
                tokens.append(self._identifier(start))
            elif character in SINGLE_CHAR_TOKENS:
                self._advance()
                tokens.append(
                    Token(
                        SINGLE_CHAR_TOKENS[character],
                        character,
                        Span(self.source, start, self._position()),
                    )
                )
            else:
                raise self._error(
                    "ZCFG001",
                    f"unsupported character {character!r}",
                    start,
                    self._position_after_current(),
                )

    def _skip_trivia(self) -> None:
        while not self._at_end():
            if self._peek().isspace():
                self._advance()
                continue
            if self._peek() == "#":
                while not self._at_end() and self._peek() != "\n":
                    self._advance()
                continue
            return

    def _string(self, start: Position) -> Token:
        self._advance()
        characters: list[str] = []
        while not self._at_end():
            character = self._advance()
            if character == '"':
                text = self.text[start.offset : self.index]
                return Token(
                    TokenKind.STRING,
                    text,
                    Span(self.source, start, self._position()),
                    "".join(characters),
                )
            if character in "\n\r":
                raise self._error(
                    "ZCFG002",
                    "string literals cannot contain unescaped newlines",
                    start,
                    self._position(),
                )
            if character != "\\":
                if ord(character) < 0x20:
                    raise self._error(
                        "ZCFG003",
                        "string literal contains a control character",
                        start,
                        self._position(),
                    )
                characters.append(character)
                continue

            if self._at_end():
                break
            escape_start = self._position()
            escaped = self._advance()
            escapes = {'"': '"', "\\": "\\", "/": "/", "n": "\n", "r": "\r", "t": "\t"}
            if escaped in escapes:
                characters.append(escapes[escaped])
                continue
            if escaped == "u":
                digits = self.text[self.index : self.index + 4]
                if len(digits) != 4 or any(digit not in string.hexdigits for digit in digits):
                    raise self._error(
                        "ZCFG003",
                        "Unicode escapes must contain exactly four hexadecimal digits",
                        escape_start,
                        self._position(),
                    )
                self._advance_many(4)
                codepoint = int(digits, 16)
                if codepoint < 0x20:
                    raise self._error(
                        "ZCFG003",
                        "Unicode escapes cannot encode control characters",
                        escape_start,
                        self._position(),
                    )
                if 0xD800 <= codepoint <= 0xDFFF:
                    raise self._error(
                        "ZCFG003",
                        "surrogate Unicode escapes are not supported; use the UTF-8 character directly",
                        escape_start,
                        self._position(),
                    )
                characters.append(chr(codepoint))
                continue
            raise self._error(
                "ZCFG003",
                f"unsupported string escape \\{escaped}",
                escape_start,
                self._position(),
            )
        raise self._error("ZCFG002", "unterminated string literal", start, self._position())

    def _relative_path(self, start: Position) -> Token:
        while not self._at_end() and self._peek() in PATH_CHARS:
            self._advance()
        text = self.text[start.offset : self.index]
        return Token(
            TokenKind.RELPATH,
            text,
            Span(self.source, start, self._position()),
            text,
        )

    def _pkgs(self, start: Position) -> Token:
        expected = "$pkgs"
        if self.text[self.index : self.index + len(expected)] != expected:
            self._advance()
            raise self._error(
                "ZCFG004",
                "only $pkgs references are allowed",
                start,
                self._position(),
            )
        self._advance_many(len(expected))
        if not self._at_end() and (
            self._peek() in string.ascii_letters + string.digits + "_-'$"
        ):
            while not self._at_end() and (
                self._peek() in string.ascii_letters + string.digits + "_-'$"
            ):
                self._advance()
            raise self._error(
                "ZCFG004",
                "only $pkgs references are allowed",
                start,
                self._position(),
            )
        return Token(TokenKind.PKGS, expected, Span(self.source, start, self._position()))

    def _integer(self, start: Position) -> Token:
        if self._peek() == "-":
            self._advance()
        while not self._at_end() and self._peek() in string.digits:
            self._advance()
        text = self.text[start.offset : self.index]
        return Token(
            TokenKind.INTEGER,
            text,
            Span(self.source, start, self._position()),
            text,
        )

    def _identifier(self, start: Position) -> Token:
        while not self._at_end() and self._peek() in (
            string.ascii_letters + string.digits + "_-'"):
            self._advance()
        text = self.text[start.offset : self.index]
        kind = KEYWORDS.get(text, TokenKind.IDENT)
        return Token(kind, text, Span(self.source, start, self._position()), text)

    def _starts_relative_path(self) -> bool:
        return self.text.startswith("./", self.index) or self.text.startswith("../", self.index)

    def _at_end(self) -> bool:
        return self.index >= len(self.text)

    def _peek(self, lookahead: int = 0) -> str:
        index = self.index + lookahead
        return self.text[index] if index < len(self.text) else ""

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
        return Position(offset=self.index, line=self.line, column=self.column)

    def _position_after_current(self) -> Position:
        if self._at_end():
            return self._position()
        if self._peek() == "\n":
            return Position(offset=self.index + 1, line=self.line + 1, column=1)
        return Position(offset=self.index + 1, line=self.line, column=self.column + 1)

    def _error(self, code: str, message: str, start: Position, end: Position) -> ZcfgError:
        return ZcfgError(Diagnostic(code, message, Span(self.source, start, end)))


def lex(text: str, source: str = "<input>") -> tuple[Token, ...]:
    return Lexer(text, source).tokenize()
