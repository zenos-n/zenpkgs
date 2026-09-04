from __future__ import annotations

import argparse
from collections.abc import Sequence
import json
from pathlib import Path
import sys
from typing import TextIO

from .api import parse_file
from .compiler import CompilationError, check_tree, compile_document, compile_tree
from .diagnostics import render_human, render_json
from .emitter import NixEmissionError
from .model import Diagnostic, FileKind, Span, ZenLangError, ast_to_dict
from zcfg.cli import write_output_atomic
from zcfg.model import ZcfgError


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="zen-dsl",
        description="Parse and validate ZenOS ZCFG, ZMDL, ZPKG, and ZSTR sources.",
    )
    commands = parser.add_subparsers(dest="command", required=True)
    for name, help_text in (
        ("check", "validate a ZenOS DSL source file"),
        ("ast", "print the immutable source AST as JSON"),
        ("compile", "compile a ZenOS DSL source file to Nix"),
    ):
        command = commands.add_parser(name, help=help_text)
        command.add_argument("file", help=".zcfg, .zmdl, .zpkg, or .zstr source file")
        command.add_argument(
            "--import-root",
            help="allowed source-tree root for relative imports (default: entry directory)",
        )
        command.add_argument(
            "--diagnostic-format",
            choices=("human", "json"),
            default="human",
            help="error output format (default: human)",
        )
        if name == "compile":
            command.add_argument(
                "-o",
                "--output",
                default="-",
                help="output file, or - for stdout (default: -)",
            )
            command.add_argument(
                "--mode",
                choices=("interface", "build"),
                help="ZPKG compilation mode (default: build)",
            )
            command.add_argument(
                "--root",
                help="source tree root used to derive a standalone ZMDL identity",
            )
    check_tree_command = commands.add_parser(
        "check-tree", help="validate every ZenOS DSL source below a root"
    )
    check_tree_command.add_argument("--root", required=True, help="source tree root")
    _add_diagnostic_argument(check_tree_command)
    compile_tree_command = commands.add_parser(
        "compile-tree", help="compile a deterministic ZenOS DSL JSON bundle"
    )
    compile_tree_command.add_argument("--root", required=True, help="source tree root")
    compile_tree_command.add_argument("--output", required=True, help="bundle output file")
    compile_tree_command.add_argument(
        "--mode",
        choices=("interface", "build"),
        default="build",
        help="ZPKG compilation mode (default: build)",
    )
    _add_diagnostic_argument(compile_tree_command)
    return parser


def _add_diagnostic_argument(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--diagnostic-format",
        choices=("human", "json"),
        default="human",
        help="error output format (default: human)",
    )


def main(
    argv: Sequence[str] | None = None,
    stdout: TextIO | None = None,
    stderr: TextIO | None = None,
) -> int:
    stdout = stdout or sys.stdout
    stderr = stderr or sys.stderr
    arguments = build_parser().parse_args(argv)
    if arguments.command == "compile":
        return _compile(arguments, stdout, stderr)
    if arguments.command in ("check-tree", "compile-tree"):
        return _tree(arguments, stdout, stderr)

    try:
        document = parse_file(arguments.file, import_root=arguments.import_root)
        if arguments.command == "ast":
            json.dump(ast_to_dict(document), stdout, indent=2, sort_keys=True, ensure_ascii=False)
            stdout.write("\n")
        elif arguments.diagnostic_format == "json":
            stdout.write(render_json(list(document.diagnostics)) + "\n")
        else:
            _write_warnings(document, stderr, "human")
        return 0
    except ZenLangError as error:
        if arguments.diagnostic_format == "json":
            stderr.write(render_json([error.diagnostic]) + "\n")
        else:
            stderr.write(render_human(error.diagnostic, error.sources) + "\n")
        return 1


def _compile(arguments: argparse.Namespace, stdout: TextIO, stderr: TextIO) -> int:
    try:
        kind = FileKind.from_source(arguments.file)
        if kind is not FileKind.ZPKG and arguments.mode is not None:
            raise ZenLangError(
                Diagnostic(
                    "ZEN201",
                    "--mode is only valid for .zpkg source files",
                    Span.point(arguments.file),
                )
            )
        if kind is FileKind.ZMDL and arguments.root is None:
            raise ZenLangError(
                Diagnostic(
                    "ZEN201",
                    "--root is required for .zmdl source files",
                    Span.point(arguments.file),
                )
            )
        if kind is not FileKind.ZMDL and arguments.root is not None:
            raise ZenLangError(
                Diagnostic(
                    "ZEN201",
                    "--root is only valid for .zmdl source files",
                    Span.point(arguments.file),
                )
            )
    except ZenLangError as error:
        if arguments.diagnostic_format == "json":
            stderr.write(render_json([error.diagnostic]) + "\n")
        else:
            stderr.write(render_human(error.diagnostic, {}) + "\n")
        return 1

    try:
        import_root = arguments.import_root or arguments.root
        document = parse_file(arguments.file, import_root=import_root)
        output = compile_document(
            document,
            mode=arguments.mode or "build",
            root=arguments.root,
        )
        _write_warnings(document, stderr, arguments.diagnostic_format)
    except ZenLangError as error:
        _write_zenlang_error(error, arguments.diagnostic_format, stderr)
        return 1
    except (CompilationError, NixEmissionError) as error:
        diagnostic = Diagnostic(
            "ZEN401",
            str(error),
            getattr(error, "span", None) or Span.point(arguments.file),
        )
        _write_zenlang_diagnostic(diagnostic, arguments.diagnostic_format, {}, stderr)
        return 1

    try:
        if arguments.output == "-":
            stdout.write(output)
        else:
            write_output_atomic(Path(arguments.output), output)
        return 0
    except ZcfgError as error:
        diagnostic = Diagnostic("ZEN402", str(error), Span.point(arguments.output))
        _write_zenlang_diagnostic(diagnostic, arguments.diagnostic_format, {}, stderr)
        return 1


def _tree(arguments: argparse.Namespace, stdout: TextIO, stderr: TextIO) -> int:
    try:
        if arguments.command == "check-tree":
            documents = check_tree(arguments.root)
            warnings = [
                diagnostic
                for document in documents.values()
                for diagnostic in document.diagnostics
            ]
            if arguments.diagnostic_format == "json":
                stdout.write(render_json(warnings) + "\n")
            else:
                for document in documents.values():
                    _write_warnings(document, stderr, "human")
            return 0
        checked = check_tree(arguments.root)
        warnings = tuple(
            dict.fromkeys(
                diagnostic
                for document in checked.values()
                for diagnostic in document.diagnostics
            )
        )
        if warnings:
            if arguments.diagnostic_format == "json":
                stderr.write(render_json(list(warnings)) + "\n")
            else:
                for diagnostic in warnings:
                    stderr.write(render_human(diagnostic, {}) + "\n")
        bundle = compile_tree(arguments.root, mode=arguments.mode)
        output = json.dumps(
            bundle, indent=2, sort_keys=True, ensure_ascii=False
        ) + "\n"
        write_output_atomic(Path(arguments.output), output)
        return 0
    except ZenLangError as error:
        _write_zenlang_error(error, arguments.diagnostic_format, stderr)
    except (CompilationError, NixEmissionError) as error:
        diagnostic = Diagnostic(
            "ZEN401",
            str(error),
            getattr(error, "span", None) or Span.point(arguments.root),
        )
        _write_zenlang_diagnostic(diagnostic, arguments.diagnostic_format, {}, stderr)
    except ZcfgError as error:
        diagnostic = Diagnostic("ZEN402", str(error), Span.point(arguments.output))
        _write_zenlang_diagnostic(diagnostic, arguments.diagnostic_format, {}, stderr)
    return 1


def _write_zenlang_error(
    error: ZenLangError, output_format: str, stderr: TextIO
) -> None:
    _write_zenlang_diagnostic(error.diagnostic, output_format, error.sources, stderr)


def _write_zenlang_diagnostic(
    diagnostic: Diagnostic,
    output_format: str,
    sources: dict[str, str],
    stderr: TextIO,
) -> None:
    if output_format == "json":
        stderr.write(render_json([diagnostic]) + "\n")
    else:
        stderr.write(render_human(diagnostic, sources) + "\n")


def _write_warnings(document: object, stderr: TextIO, output_format: str) -> None:
    diagnostics = list(getattr(document, "diagnostics", ()))
    if not diagnostics:
        return
    if output_format == "json":
        stderr.write(render_json(diagnostics) + "\n")
    else:
        for diagnostic in diagnostics:
            stderr.write(render_human(diagnostic, {}) + "\n")
