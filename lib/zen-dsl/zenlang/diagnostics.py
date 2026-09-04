from __future__ import annotations

import json
from collections.abc import Mapping

from .model import Diagnostic


def render_json(diagnostics: list[Diagnostic]) -> str:
    return json.dumps(
        {"diagnostics": [diagnostic.to_dict() for diagnostic in diagnostics]},
        indent=2,
        sort_keys=True,
        ensure_ascii=False,
    )


def render_human(diagnostic: Diagnostic, sources: Mapping[str, str]) -> str:
    span = diagnostic.span
    lines = [
        f"{span.source}:{span.start.line}:{span.start.column}: "
        f"{diagnostic.severity}[{diagnostic.code}]: {diagnostic.message}"
    ]
    source = sources.get(span.source)
    if source is not None:
        source_lines = source.splitlines()
        if 1 <= span.start.line <= len(source_lines):
            raw = source_lines[span.start.line - 1]
            shown = raw.expandtabs(4)
            prefix = len(raw[: span.start.column - 1].expandtabs(4))
            if span.end.line == span.start.line:
                finish = len(raw[: span.end.column - 1].expandtabs(4))
                width = max(1, finish - prefix)
            else:
                width = 1
            lines.extend((f"  {span.start.line:>4} | {shown}", "       | " + " " * prefix + "^" * width))
    lines.extend(f"  note: {note}" for note in diagnostic.notes)
    return "\n".join(lines)
