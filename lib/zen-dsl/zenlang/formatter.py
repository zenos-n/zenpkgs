"""Conservative, token-preserving ZenOS editor formatter (stdin to stdout)."""
from __future__ import annotations

from dataclasses import fields, is_dataclass
import re
import sys

from .api import parse
from .lexer import lex, TokenKind
from .model import Position, Span, ZenLangError


def _semantic(value):
    if isinstance(value, (Span, Position)):
        return None
    if is_dataclass(value):
        return (type(value).__name__, tuple(
            (f.name, _semantic(getattr(value, f.name))) for f in fields(value)
            if f.name not in ("span", "diagnostics")
        ))
    if isinstance(value, (tuple, list)):
        return tuple(map(_semantic, value))
    return value


def format_source(text: str, source: str = "stdin.zcfg") -> str:
    before = parse(text, source, validate_semantics=False)
    tokens = lex(text, source)
    output = ""
    depth = 0
    previous = ""
    offset = 0

    def newline():
        nonlocal output
        output = output.rstrip(" \t")
        if output and not output.endswith("\n"):
            output += "\n"

    def emit(raw):
        nonlocal output
        if not output or output.endswith("\n"):
            output += "  " * depth
        output += raw

    for index, token in enumerate(tokens):
        gap = text[offset:token.span.start.offset]
        current = token.text
        offset = token.span.end.offset
        closing = current in ("}", "]", ")")
        if closing:
            depth = max(0, depth - 1)
        comments = list(re.finditer(r"#[^\n]*|/\*[\s\S]*?\*/", gap))
        if comments:
            end = 0
            for comment in comments:
                if "\n" in gap[end:comment.start()]:
                    newline()
                elif output and not output.endswith((" ", "\n")):
                    output += " "
                emit(comment.group())
                if comment.group().startswith("#") or "\n" in gap[comment.end():]:
                    newline()
                end = comment.end()
            if "\n" in gap[end:]:
                newline()
        elif current == "}" and previous != "{":
            newline()
        elif previous == "{" and current != "}":
            newline()
        elif previous == ";":
            newline()
        elif "\n" in gap:
            newline()
        elif output and not output.endswith((" ", "\n")):
            tight = current in (".", ",", ";", ":", ")") or previous in (".", "(")
            if not tight and (gap or current in ("=", "++", "--") or previous in ("=", "++", "--", ":", ",")):
                output += " "
        if token.kind == TokenKind.EOF:
            break
        emit(current)
        if current in ("{", "[", "("):
            depth += 1
        previous = current
    result = output.rstrip() + "\n" if output.strip() else ""
    if [(t.kind, t.text) for t in lex(result, source)] != [(t.kind, t.text) for t in tokens]:
        raise ValueError("formatting changed tokens; leaving the document unchanged")
    if _semantic(parse(result, source, validate_semantics=False)) != _semantic(before):
        raise ValueError("formatting changed the syntax tree; leaving the document unchanged")
    return result


def main():
    source = sys.argv[1] if len(sys.argv) > 1 else "stdin.zcfg"
    try:
        result = format_source(sys.stdin.read(), source)
    except (ZenLangError, ValueError) as error:
        print(f"zenos-fmt: {error}", file=sys.stderr)
        return 1
    sys.stdout.write(result)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
