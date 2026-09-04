from __future__ import annotations

import json
from typing import Mapping

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
    heading = (
        f"{span.source}:{span.start.line}:{span.start.column}: "
        f"{diagnostic.severity}[{diagnostic.code}]: {diagnostic.message}"
    )
    lines = [heading]
    source = sources.get(span.source)
    if source is not None:
        source_lines = source.splitlines()
        if 1 <= span.start.line <= len(source_lines):
            raw_line = source_lines[span.start.line - 1]
            source_line = raw_line.expandtabs(4)
            prefix_width = len(raw_line[: span.start.column - 1].expandtabs(4))
            if span.end.line == span.start.line:
                end_width = len(raw_line[: span.end.column - 1].expandtabs(4))
                width = max(1, end_width - prefix_width)
            else:
                width = 1
            lines.append(f"  {span.start.line:>4} | {source_line}")
            lines.append("       | " + " " * prefix_width + "^" * width)
    lines.extend(f"  note: {note}" for note in diagnostic.notes)
    return "\n".join(lines)
