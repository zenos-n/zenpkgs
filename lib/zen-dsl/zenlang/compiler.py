from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path, PurePath
from typing import Any

from .api import parse_file
from .emitter import NixEmitter, emit_attr_name, emit_nix_data, semantic_descriptor
from .model import (
    ActionStatement,
    Assignment,
    AttrSet,
    CallExpr,
    ConditionalStatement,
    Document,
    DynamicSegment,
    EnableOption,
    Expression,
    FileKind,
    GRAMMAR_VERSION,
    GroupExpr,
    IdentifierSegment,
    ImportStatement,
    InheritStatement,
    ResolvedImport,
    IR_VERSION,
    LetStatement,
    ListExpr,
    Literal,
    PackageImportStatement,
    StringExpr,
    StringSegment,
    StringText,
    StructuralMarker,
    Variable,
)


DESCRIPTOR_VERSION = "zenlang.semantic/2"
BUNDLE_VERSION = "zenlang.bundle/2"
MAX_TREE_FILES = 4096
_RESERVED_MODULE_LEAF_NAMES = frozenset(("default", "index", "module"))


class CompilationError(ValueError):
    """Raised when a valid AST needs semantics unavailable to a backend."""

    def __init__(self, message: str, span: Any | None = None):
        super().__init__(message)
        self.span = span


def compile_document(
    document: Document,
    *,
    mode: str = "build",
    root: str | Path | None = None,
) -> str:
    if document.kind is FileKind.ZCFG:
        return compile_zcfg(document)
    if document.kind is FileKind.ZMDL:
        return compile_zmdl(document, root=root)
    if document.kind is FileKind.ZPKG:
        return compile_zpkg(document, mode=mode)
    if document.kind is FileKind.ZSTR:
        return compile_zstr(document)
    raise CompilationError(f"unsupported document kind: {document.kind!r}", document.span)


def document_descriptor(document: Document) -> dict[str, Any]:
    return {
        "descriptorVersion": DESCRIPTOR_VERSION,
        "grammarVersion": document.grammar_version,
        "irVersion": document.ir_version,
        "kind": document.kind.value,
        "statements": semantic_descriptor(_resolved_statements(document)),
    }


def check_tree(root: str | Path) -> dict[str, Document]:
    resolved_root = _tree_root(root)
    documents: dict[str, Document] = {}
    folded_paths: dict[str, str] = {}
    for relative, source in _discover_tree(resolved_root):
        folded = relative.casefold()
        previous = folded_paths.get(folded)
        if previous is not None:
            if previous == relative:
                message = f"duplicate source path: {relative}"
            else:
                message = f"case-colliding source paths: {previous} and {relative}"
            raise CompilationError(message)
        folded_paths[folded] = relative
        documents[relative] = parse_file(source, import_root=resolved_root)
    _tree_modules(documents)
    return documents


def compile_tree(root: str | Path, *, mode: str = "build") -> dict[str, Any]:
    if mode not in ("interface", "build"):
        raise CompilationError("ZPKG mode must be 'interface' or 'build'")
    resolved_root = _tree_root(root)
    documents = check_tree(resolved_root)
    modules = _tree_modules(documents)
    sources = []
    structure = _tree_structure(documents)
    for relative, document in documents.items():
        if document.kind is FileKind.ZMDL:
            compiled = compile_zmdl(document, root=resolved_root)
        else:
            compiled = compile_document(document, mode=mode)
        sources.append(
            {
                "compiledNix": compiled,
                "descriptor": document_descriptor(document),
                "kind": document.kind.value,
                "path": relative,
            }
        )
    return {
        "bundleVersion": BUNDLE_VERSION,
        "grammarVersion": GRAMMAR_VERSION,
        "irVersion": IR_VERSION,
        "modules": modules,
        "structure": structure,
        "sources": sources,
    }


def _tree_root(root: str | Path) -> Path:
    source = Path(os.path.abspath(os.fspath(root)))
    try:
        if not source.is_dir():
            raise OSError("path is not a directory")
        return source
    except (OSError, RuntimeError, ValueError) as error:
        raise CompilationError(f"cannot read source root {source}: {error}") from error


def _discover_tree(root: Path) -> list[tuple[str, Path]]:
    discovered: list[tuple[str, Path]] = []
    pending = [root]
    try:
        while pending:
            directory = pending.pop()
            with os.scandir(directory) as entries:
                for entry in entries:
                    if entry.is_dir(follow_symlinks=False):
                        pending.append(Path(entry.path))
                        continue
                    if Path(entry.name).suffix.lower() not in {
                        ".zcfg",
                        ".zmdl",
                        ".zpkg",
                        ".zstr",
                    }:
                        continue
                    relative = Path(entry.path).relative_to(root).as_posix()
                    discovered.append((relative, Path(entry.path)))
                    if len(discovered) > MAX_TREE_FILES:
                        raise CompilationError(
                            f"source file count exceeds the maximum of {MAX_TREE_FILES}"
                        )
    except CompilationError:
        raise
    except OSError as error:
        raise CompilationError(f"cannot scan source root {root}: {error}") from error
    discovered.sort(key=lambda item: item[0])
    return discovered


def compile_zcfg(document: Document) -> str:
    _require_kind(document, FileKind.ZCFG)
    emitter = NixEmitter()
    statements = _resolved_statements(document)
    emitted_statements = [
        statement
        for statement in statements
        if not isinstance(statement, (ResolvedImport, LetStatement))
    ]
    groups = _zcfg_groups(emitted_statements)
    root = next((tree for conditions, tree in groups if not conditions), {})
    conditional_groups = [
        (conditions, tree) for conditions, tree in groups if conditions
    ]
    bindings: list[str] = []
    for statement in statements:
        if isinstance(statement, (ResolvedImport, LetStatement)):
            bindings.append(emitter.statement(statement, 2))

    fragments = [_emit_tree(root, emitter, 2)]
    for conditions, tree in conditional_groups:
        condition = " && ".join(f"({emitter.expression(item)})" for item in conditions)
        if len(conditions) == 1:
            condition = emitter.expression(conditions[0])
        fragments.append(f"(lib.mkIf {condition} {_emit_tree(tree, emitter, 4)})")

    prefix = "{ pkgs, lib ? pkgs.lib, config ? { zenos = { }; }, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:\n"
    bindings.insert(0, f"name = {emit_nix_data(_source_name(document))};")
    if bindings:
        prefix += "let\n" + "\n".join(f"  {binding}" for binding in bindings) + "\nin\n"
    if len(fragments) == 1:
        return prefix + fragments[0] + "\n"
    return (
        prefix
        + "lib.mkMerge [\n"
        + "\n".join(f"  {fragment}" for fragment in fragments)
        + "\n]\n"
    )


def compile_zmdl(
    document: Document,
    *,
    root: str | Path | None = None,
) -> str:
    _require_kind(document, FileKind.ZMDL)
    if root is None:
        raise CompilationError(
            "ZMDL compilation requires an explicit source root",
            document.span,
        )
    module = _zmdl_module(document, root)
    module_path = tuple(module["optionPath"][1:])
    _reject_zmdl_authored_id(document)
    statements = _coalesce_zmdl_scope_assignments(_resolved_statements(document))
    emitter = NixEmitter({"path": "cfg"})
    top_metadata: dict[str, Expression] = {}
    bindings: list[str] = []
    aliases: list[dict[str, Any]] = []

    for statement in statements:
        if isinstance(statement, ResolvedImport):
            bindings.append(emitter.statement(statement, 2))
            continue
        if isinstance(statement, ImportStatement):
            raise CompilationError("filesystem import was not resolved with parse_file", statement.span)
        if isinstance(statement, LetStatement):
            bindings.append(emitter.statement(statement, 2))
            continue
        if not isinstance(statement, Assignment):
            raise CompilationError(
                f"unsupported top-level ZMDL statement: {type(statement).__name__}",
                statement.span,
            )
        path = _assignment_path(statement)
        if path and path[0] == "_meta":
            _collect_metadata(top_metadata, path[1:], statement.value)
            continue
        if isinstance(statement.target, StructuralMarker):
            if statement.target.kind == "freeform":
                continue
            if statement.target.kind == "alias":
                aliases.append(
                    {
                        "path": semantic_descriptor(statement.target.argument),
                        "value": semantic_descriptor(statement.value),
                    }
                )
                continue
            raise CompilationError(
                f"unsupported ZMDL structural marker: {statement.target.kind}",
                statement.target.span,
            )
    actions = _zmdl_scope_actions(
        statements,
        scope_value="cfg",
        contexts=(),
        emitter=emitter,
    )

    descriptor = {
        "descriptorVersion": DESCRIPTOR_VERSION,
        "grammarVersion": document.grammar_version,
        "irVersion": document.ir_version,
        "kind": "zmdl",
        "metadata": {
            key: semantic_descriptor(value)
            for key, value in sorted(top_metadata.items())
        },
        "modulePath": list(module_path),
        "moduleIdentity": module["identity"],
        "aliases": aliases,
        "statements": semantic_descriptor(statements),
    }
    metadata_fragment = (
        "{ _module.args.zenlang.descriptors."
        + _emit_static_path(module_path)
        + " = "
        + emit_nix_data(descriptor, 2)
        + "; }"
    )
    config_fragments = [metadata_fragment, *actions]
    config_value = (
        config_fragments[0]
        if len(config_fragments) == 1
        else "lib.mkMerge [\n"
        + "\n".join(f"    {fragment}" for fragment in config_fragments)
        + "\n  ]"
    )

    module_lines = []
    option_path = _emit_static_path(("zenos", *module_path))
    module_lines.append(
        f"  options.{option_path} = {_zmdl_scope_option(statements, emitter)};"
    )
    module_lines.append(f"  config = {config_value};")

    output = "{ config, lib, pkgs, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:\nlet\n"
    output += f"  cfg = config.{_emit_static_path(('zenos', *module_path))};\n"
    output += f"  name = {emit_nix_data(_source_name(document))};\n"
    if bindings:
        output += "\n".join(f"  {binding}" for binding in bindings) + "\n"
    output += "in\n{\n" + "\n".join(module_lines) + "\n}\n"
    return output


def compile_zpkg(document: Document, *, mode: str = "build") -> str:
    _require_kind(document, FileKind.ZPKG)
    if mode not in ("interface", "build"):
        raise CompilationError("ZPKG mode must be 'interface' or 'build'", document.span)
    emitter = NixEmitter()
    metadata: dict[str, Expression] = {}
    local_bindings: list[ResolvedImport | LetStatement] = []
    package_import: PackageImportStatement | None = None

    for statement in _resolved_statements(document):
        if isinstance(statement, ResolvedImport):
            local_bindings.append(statement)
            continue
        if isinstance(statement, ImportStatement):
            raise CompilationError("filesystem import was not resolved with parse_file", statement.span)
        if isinstance(statement, LetStatement):
            local_bindings.append(statement)
            continue
        if isinstance(statement, PackageImportStatement):
            if package_import is not None:
                raise CompilationError(
                    "a ZPKG requires exactly one package import",
                    statement.span,
                )
            package_import = statement
            continue
        if not isinstance(statement, Assignment):
            raise CompilationError(
                f"unsupported top-level ZPKG statement: {type(statement).__name__}",
                statement.span,
            )
        path = _assignment_path(statement)
        if path and path[0] == "_meta":
            _collect_metadata(metadata, path[1:], statement.value)
        else:
            raise CompilationError(
                "ZPKG top-level assignments are limited to one _meta block",
                statement.span,
            )
    if package_import is None:
        raise CompilationError("a ZPKG requires exactly one package import", document.span)
    imported_path = _static_path(package_import.package.path, package_import.package.span)
    if (
        package_import.package.name != "pkgs"
        or len(imported_path) < 2
        or imported_path[0] != "legacy"
    ):
        raise CompilationError(
            "a ZPKG package import must use $pkgs.legacy.<path>",
            package_import.package.span,
        )
    required_metadata = {
        "name",
        "summary",
        "description",
        "zenosVersion",
        "tags",
        "maintainers",
        "dependencies",
    }
    missing_metadata = sorted(required_metadata - set(metadata))
    if missing_metadata:
        raise CompilationError(
            "missing ZPKG metadata fields: " + ", ".join(missing_metadata),
            document.span,
        )

    import_data = [
        semantic_descriptor(statement)
        for statement in local_bindings
        if isinstance(statement, ResolvedImport)
    ]
    if mode == "interface":
        descriptor = {
            "descriptorVersion": DESCRIPTOR_VERSION,
            "grammarVersion": document.grammar_version,
            "irVersion": document.ir_version,
            "kind": "zpkg",
            "name": _source_name(document),
            "metadata": {
                key: semantic_descriptor(value)
                for key, value in sorted(metadata.items())
            },
            "packageImport": semantic_descriptor(package_import.package),
            "imports": import_data,
            "statements": semantic_descriptor(_resolved_statements(document)),
        }
        return "{ ... }:\n" + emit_nix_data(descriptor) + "\n"

    package = emitter.expression(package_import.package)
    if not local_bindings:
        return "{ pkgs, ... }:\n" + package + "\n"
    bindings = "\n".join(
        f"  {emitter.statement(statement)}" for statement in local_bindings
    )
    return "{ pkgs, ... }:\nlet\n" + bindings + "\nin\n" + package + "\n"


def compile_zstr(document: Document) -> str:
    _require_kind(document, FileKind.ZSTR)
    descriptor = {
        "descriptorVersion": DESCRIPTOR_VERSION,
        "grammarVersion": document.grammar_version,
        "irVersion": document.ir_version,
        "kind": "zstr",
        "statements": semantic_descriptor(_resolved_statements(document)),
    }
    return emit_nix_data(descriptor) + "\n"


def _require_kind(document: Document, expected: FileKind) -> None:
    if document.kind is not expected:
        raise CompilationError(
            f"expected {expected.value.upper()} document, got {document.kind.value.upper()}",
            document.span,
        )


def _source_name(document: Document) -> str:
    name = PurePath(document.span.source).name
    suffix = "." + document.kind.value
    return name[: -len(suffix)] if name.lower().endswith(suffix) else name


def _assignment_path(statement: Assignment) -> tuple[str, ...]:
    if isinstance(statement.target, StructuralMarker):
        return ()
    return _static_path(statement.target)


def _static_path(segments: Any, span: Any | None = None) -> tuple[str, ...]:
    values: list[str] = []
    for segment in segments or ():
        if isinstance(segment, IdentifierSegment):
            values.append(segment.name)
        elif isinstance(segment, StringSegment):
            values.append(segment.value)
        else:
            raise CompilationError(
                "dynamic attribute paths require a runtime descriptor",
                span or segment.span,
            )
    if not values:
        raise CompilationError("attribute path cannot be empty", span)
    return tuple(values)


def _resolved_statements(document: Document) -> tuple[Any, ...]:
    imported: list[Any] = []
    local: list[Any] = []
    for statement in document.statements:
        if isinstance(statement, ImportStatement):
            raise CompilationError(
                "filesystem import was not resolved with parse_file",
                statement.span,
            )
        if isinstance(statement, ResolvedImport) and statement.binding is None:
            imported.extend(_resolved_statements(statement.document))
        else:
            local.append(statement)
    effective = _coalesce_assignments(tuple((*imported, *local)))
    bindings: dict[str, Any] = {}
    for statement in effective:
        name = None
        if isinstance(statement, LetStatement):
            name = statement.name
        elif isinstance(statement, ResolvedImport):
            name = statement.binding
        if name is None:
            continue
        if name in bindings:
            raise CompilationError(
                f"imported lexical binding {name!r} collides with another declaration",
                statement.span,
            )
        bindings[name] = statement
    return effective


def _coalesce_assignments(statements: tuple[Any, ...]) -> tuple[Any, ...]:
    if any(
        isinstance(statement, Assignment) and statement.operator != "="
        for statement in statements
    ):
        return statements
    result: list[Any] = []
    positions: dict[str, int] = {}
    for statement in statements:
        if not isinstance(statement, Assignment) or statement.operator != "=":
            result.append(statement)
            continue
        key = repr(semantic_descriptor(statement.target))
        previous_index = positions.get(key)
        if previous_index is None:
            positions[key] = len(result)
            result.append(statement)
            continue
        previous = result[previous_index]
        if isinstance(previous.value, AttrSet) and isinstance(statement.value, AttrSet):
            merged_value = AttrSet(
                _coalesce_assignments((*previous.value.statements, *statement.value.statements)),
                previous.value.recursive or statement.value.recursive,
                statement.value.span,
            )
            result[previous_index] = Assignment(
                statement.target,
                statement.operator,
                merged_value,
                statement.span,
            )
        elif _compatible_assignment_values(previous.value, statement.value):
            result[previous_index] = statement
        else:
            raise CompilationError(
                "incompatible duplicate assignment",
                statement.span,
            )
    return tuple(result)


def _coalesce_zmdl_scope_assignments(
    statements: tuple[Any, ...],
) -> tuple[Any, ...]:
    normalized: list[Any] = []
    for statement in statements:
        if not isinstance(statement, Assignment) or statement.operator != "=":
            normalized.append(statement)
            continue
        value = _canonicalize_zmdl_option_value(statement.value)
        if isinstance(statement.target, StructuralMarker):
            normalized.append(
                Assignment(statement.target, statement.operator, value, statement.span)
            )
            continue
        normalized.append(
            _nest_zmdl_assignment(statement.target, value, statement.span)
        )
    return _coalesce_assignments(tuple(normalized))


def _canonicalize_zmdl_option_value(value: Expression) -> Expression:
    if isinstance(value, AttrSet):
        return AttrSet(
            _coalesce_zmdl_scope_assignments(value.statements),
            value.recursive,
            value.span,
        )
    if isinstance(value, EnableOption):
        body = AttrSet(
            _coalesce_zmdl_scope_assignments(value.body.statements),
            value.body.recursive,
            value.body.span,
        )
        return EnableOption(body, value.span)
    return value


def _nest_zmdl_assignment(
    target: tuple[Any, ...],
    value: Expression,
    span: Any,
) -> Assignment:
    if len(target) == 1:
        return Assignment(target, "=", value, span)
    nested = _nest_zmdl_assignment(target[1:], value, span)
    body = AttrSet((nested,), False, span)
    return Assignment((target[0],), "=", body, span)


def _tree_modules(documents: dict[str, Document]) -> list[dict[str, Any]]:
    modules: list[dict[str, Any]] = []
    identities: dict[str, dict[str, Any]] = {}
    folded_identities: dict[str, dict[str, Any]] = {}

    for relative, document in documents.items():
        if document.kind is not FileKind.ZMDL:
            continue
        module = _module_record(relative, document)
        identity = module["identity"]
        previous = identities.get(identity)
        if previous is not None:
            raise CompilationError(
                f"duplicate ZMDL module identity {identity!r}: "
                f"{previous['path']} and {relative}",
                document.span,
            )
        folded = identity.casefold()
        previous = folded_identities.get(folded)
        if previous is not None:
            raise CompilationError(
                f"case-colliding ZMDL module identities: "
                f"{previous['identity']} and {identity}",
                document.span,
            )
        _reject_zmdl_authored_id(document)
        identities[identity] = module
        folded_identities[folded] = module
        modules.append(module)

    modules.sort(key=lambda module: module["path"])
    return modules


def _zmdl_module(document: Document, root: str | Path) -> dict[str, Any]:
    resolved_root = _tree_root(root)
    source = Path(document.span.source)
    try:
        logical_source = Path(os.path.abspath(os.fspath(source)))
        relative = logical_source.relative_to(resolved_root).as_posix()
    except (OSError, RuntimeError, ValueError) as error:
        raise CompilationError(
            f"ZMDL source must be below explicit root {resolved_root}: {source}",
            document.span,
        ) from error
    return _module_record(relative, document)


def _module_record(relative: str, document: Document) -> dict[str, Any]:
    parts = PurePath(relative).parts
    if len(parts) < 2 or parts[0] != "modules":
        raise CompilationError(
            f"ZMDL source must be below modules/: {relative}",
            document.span,
        )
    if not relative.endswith(".zmdl"):
        raise CompilationError(
            f"ZMDL source must use the lowercase .zmdl extension: {relative}",
            document.span,
        )
    module_path = (*parts[1:-1], parts[-1][: -len(".zmdl")])
    leaf = module_path[-1]
    if leaf.casefold() in _RESERVED_MODULE_LEAF_NAMES:
        raise CompilationError(
            f"reserved generic ZMDL leaf name {leaf!r}: {relative}",
            document.span,
        )
    canonical_path = ("zenos", *module_path)
    return {
        "identity": ".".join(canonical_path),
        "optionPath": list(canonical_path),
        "path": relative,
    }


def _reject_zmdl_authored_id(document: Document) -> None:
    metadata: dict[str, Expression] = {}
    for statement in _resolved_statements(document):
        if not isinstance(statement, Assignment):
            continue
        path = _assignment_path(statement)
        if path and path[0] == "_meta":
            _collect_metadata(metadata, path[1:], statement.value)
    value = metadata.get("id")
    if value is not None:
        raise CompilationError(
            "ZMDL _meta.id must not be authored; module identity is derived "
            "from its modules/<path>.zmdl source path",
            value.span,
        )


def _freeform_id(marker: StructuralMarker) -> str:
    if (
        marker.argument is None
        or len(marker.argument) != 1
        or not isinstance(marker.argument[0], IdentifierSegment)
    ):
        raise CompilationError(
            "a ZMDL freeform marker requires exactly one identifier",
            marker.span,
        )
    return marker.argument[0].name


def _tree_structure(documents: dict[str, Document]) -> dict[str, Any]:
    aliases: list[dict[str, Any]] = []

    def marker_path(marker: StructuralMarker) -> tuple[str, ...]:
        return _static_path(marker.argument, marker.span)

    def visit(statements: tuple[Any, ...], prefix: tuple[str, ...]) -> None:
        for statement in statements:
            if isinstance(statement, ResolvedImport) and statement.binding is None:
                continue
            if not isinstance(statement, Assignment):
                continue
            if isinstance(statement.target, StructuralMarker):
                nested_prefix = prefix
                if statement.target.kind == "alias":
                    aliases.append(
                        {
                            "path": list((*prefix, *marker_path(statement.target))),
                            "value": semantic_descriptor(statement.value),
                        }
                    )
                elif statement.target.kind == "freeform":
                    freeform = marker_path(statement.target)
                    nested_prefix = (*prefix, "{" + freeform[-1] + "}")
                if isinstance(statement.value, AttrSet):
                    visit(statement.value.statements, nested_prefix)
                continue
            path = (*prefix, *_assignment_path(statement))
            if isinstance(statement.value, StructuralMarker):
                marker = statement.value
                owner = path[:-2] if path[-2:] in (("_meta", "type"), ("_meta", "_type")) else path
                if marker.kind == "alias":
                    aliases.append(
                        {
                            "path": list(owner),
                            "value": {"marker": semantic_descriptor(marker)},
                        }
                    )
            elif isinstance(statement.value, AttrSet):
                visit(statement.value.statements, path)

    for _relative, document in documents.items():
        if document.kind is FileKind.ZSTR:
            visit(document.statements, ())
    aliases.sort(key=lambda item: item["path"])
    return {"aliases": aliases}


def _emit_static_path(path: tuple[str, ...]) -> str:
    return ".".join(emit_attr_name(part) for part in path)


def _zcfg_groups(
    statements: list[Any],
) -> list[tuple[tuple[Expression, ...], dict[str, Any]]]:
    groups: list[tuple[tuple[Expression, ...], dict[str, Any]]] = []

    def tree_for(conditions: tuple[Expression, ...]) -> dict[str, Any]:
        for existing_conditions, tree in groups:
            if existing_conditions == conditions:
                return tree
        tree: dict[str, Any] = {}
        groups.append((conditions, tree))
        return tree

    def visit(
        current: tuple[Any, ...],
        logical_prefix: tuple[str, ...],
        conditions: tuple[Expression, ...],
    ) -> None:
        for statement in current:
            if isinstance(statement, ConditionalStatement):
                visit(
                    statement.body.statements,
                    logical_prefix,
                    (*conditions, statement.condition),
                )
                continue
            if not isinstance(statement, Assignment) or statement.operator != "=":
                raise CompilationError(
                    "ZCFG output supports assignments, conditionals, and top-level bindings",
                    statement.span,
                )
            logical_path = (*logical_prefix, *_assignment_path(statement))
            if isinstance(statement.value, AttrSet):
                if not statement.value.statements:
                    path = _route_zcfg_path(logical_path, tree_for(conditions), statement.span)
                    if path:
                        _insert_tree(tree_for(conditions), path, {}, statement.span)
                    continue
                visit(
                    statement.value.statements,
                    logical_path,
                    conditions,
                )
            else:
                path = _route_zcfg_path(logical_path, tree_for(conditions), statement.span)
                if not path:
                    raise CompilationError("legacy must be an attribute set", statement.span)
                _insert_tree(tree_for(conditions), path, statement.value, statement.span)

    visit(tuple(statements), (), ())
    return groups


def _route_zcfg_path(
    path: tuple[str, ...], tree: dict[str, Any], span: Any
) -> tuple[str, ...]:
    if path[0] == "legacy":
        routed = path[1:]
        if routed and routed[0] == "zenos":
            raise CompilationError("legacy cannot contain the zenos option tree", span)
        return routed
    if len(path) >= 3 and path[0] == "users" and path[2] == "legacy":
        user = path[1]
        _insert_tree(tree, ("zenos", "users", user), {}, span)
        legacy_path = path[3:]
        if legacy_path and legacy_path[0] == "homeManager":
            return ("home-manager", "users", user, *legacy_path[1:])
        return ("users", "users", user, *legacy_path)
    return ("zenos", *path)


def _insert_tree(
    tree: dict[str, Any], path: tuple[str, ...], value: Any, span: Any | None = None
) -> None:
    if not path:
        raise CompilationError("cannot assign an empty path")
    current = tree
    for segment in path[:-1]:
        existing = current.get(segment)
        if existing is None:
            child: dict[str, Any] = {}
            current[segment] = child
            current = child
        elif isinstance(existing, dict):
            current = existing
        else:
            raise CompilationError(f"conflicting assignment at {'.'.join(path)}", span)
    leaf = path[-1]
    if leaf in current:
        existing = current[leaf]
        if isinstance(existing, dict) and isinstance(value, dict):
            _merge_tree(existing, value)
            return
        if _compatible_assignment_values(existing, value):
            current[leaf] = value
            return
        raise CompilationError(f"incompatible assignment at {'.'.join(path)}", span)
    current[leaf] = value


def _merge_tree(left: dict[str, Any], right: dict[str, Any]) -> None:
    for key, value in right.items():
        if key in left and isinstance(left[key], dict) and isinstance(value, dict):
            _merge_tree(left[key], value)
        elif key in left:
            raise CompilationError(f"conflicting assignment at {key}")
        else:
            left[key] = value


def _compatible_assignment_values(left: Any, right: Any) -> bool:
    if type(left) is not type(right):
        return False
    if isinstance(left, Literal):
        return left.kind == right.kind or {
            left.kind,
            right.kind,
        } <= {"true", "false"}
    return True


def _emit_tree(tree: dict[str, Any], emitter: NixEmitter, indent: int) -> str:
    if not tree:
        return "{ }"
    padding = " " * (indent + 2)
    lines: list[str] = []
    for key in sorted(tree):
        value = tree[key]
        if isinstance(value, dict):
            emitted = _emit_tree(value, emitter, indent + 2)
        else:
            emitted = emitter.expression(value, indent + 2)
        lines.append(f"{padding}{emit_attr_name(key)} = {emitted};")
    return "{\n" + "\n".join(lines) + "\n" + " " * indent + "}"


def _collect_metadata(
    result: dict[str, Expression], path: tuple[str, ...], value: Expression
) -> None:
    if not path:
        if not isinstance(value, AttrSet):
            raise CompilationError("_meta must be an attribute set", value.span)
        for statement in value.statements:
            if not isinstance(statement, Assignment):
                raise CompilationError("metadata may contain only assignments", statement.span)
            child_path = _assignment_path(statement)
            _collect_metadata(result, child_path, statement.value)
        return
    if len(path) != 1:
        raise CompilationError(
            "nested metadata values are not supported by this backend",
            value.span,
        )
    field = path[0]
    if field.startswith("_"):
        field = field[1:]
    if field in result:
        raise CompilationError(f"duplicate metadata field: _{field}", value.span)
    result[field] = value


def _option_parts(
    value: Expression,
) -> tuple[dict[str, Expression], list[ActionStatement], bool]:
    enabled = isinstance(value, EnableOption)
    body = (
        value.body
        if isinstance(value, EnableOption)
        else value
        if isinstance(value, AttrSet)
        else None
    )
    metadata: dict[str, Expression] = {}
    actions: list[ActionStatement] = []
    if body is not None:
        for statement in body.statements:
            if isinstance(statement, ActionStatement):
                actions.append(statement)
            elif isinstance(statement, Assignment):
                path = _assignment_path(statement)
                if path and path[0] == "_meta":
                    _collect_metadata(metadata, path[1:], statement.value)
    return metadata, actions, enabled


def _option_declaration(
    value: Expression,
    emitter: NixEmitter,
    *,
    freeform_depth: int,
) -> str:
    metadata, _, enabled = _option_parts(value)
    body = _option_body(value)
    has_scope = body is not None and _zmdl_scope_has_declarations(body.statements)
    if has_scope:
        option_type = _zmdl_submodule_type(
            body.statements,
            emitter,
            freeform_depth=freeform_depth,
        )
    else:
        option_type = (
            "lib.types.bool"
            if enabled
            else _option_type(metadata.get("type"), value, emitter)
        )
    default = metadata.get("default")
    if default is None and enabled:
        default_text = "false"
    elif default is None and has_scope:
        default_text = "{ }"
    elif default is None and not isinstance(value, (AttrSet, EnableOption)):
        default_text = emitter.expression(value)
    else:
        default_text = emitter.expression(default) if default is not None else None
    fields = [f"type = {option_type};"]
    if default_text is not None:
        fields.append(f"default = {default_text};")
    description = metadata.get("description") or metadata.get("brief")
    if description is not None:
        fields.append(f"description = {emitter.expression(description)};")
    if "example" in metadata:
        fields.append(f"example = {emitter.expression(metadata['example'])};")
    return "lib.mkOption { " + " ".join(fields) + " }"


def _option_body(value: Expression) -> AttrSet | None:
    if isinstance(value, EnableOption):
        return value.body
    if isinstance(value, AttrSet):
        return value
    return None


def _zmdl_scope_has_declarations(statements: tuple[Any, ...]) -> bool:
    for statement in statements:
        if not isinstance(statement, Assignment):
            continue
        if isinstance(statement.target, StructuralMarker):
            if statement.target.kind == "freeform":
                return True
            continue
        path = _assignment_path(statement)
        if path[0] != "_meta":
            return True
    return False


def _zmdl_scope_option(
    statements: tuple[Any, ...],
    emitter: NixEmitter,
) -> str:
    option_type = _zmdl_submodule_type(statements, emitter, freeform_depth=0)
    return f"lib.mkOption {{ type = {option_type}; default = {{ }}; }}"


def _zmdl_submodule_type(
    statements: tuple[Any, ...],
    emitter: NixEmitter,
    *,
    freeform_depth: int,
) -> str:
    module = _emit_zmdl_scope_module(
        statements,
        emitter,
        freeform_depth=freeform_depth,
    )
    return f"(lib.types.submodule ({{ ... }}: {module}))"


def _emit_zmdl_scope_module(
    statements: tuple[Any, ...],
    emitter: NixEmitter,
    *,
    freeform_depth: int,
) -> str:
    effective = _coalesce_zmdl_scope_assignments(statements)
    option_lines: list[tuple[tuple[str, ...], str]] = []
    freeforms: list[Assignment] = []
    for statement in effective:
        if not isinstance(statement, Assignment):
            continue
        if isinstance(statement.target, StructuralMarker):
            if statement.target.kind == "freeform":
                freeforms.append(statement)
            continue
        path = _assignment_path(statement)
        if path[0] == "_meta":
            continue
        option_lines.append(
            (
                path,
                _option_declaration(
                    statement.value,
                    emitter,
                    freeform_depth=freeform_depth,
                ),
            )
        )

    if len(freeforms) > 1:
        raise CompilationError(
            "a scope cannot declare incompatible freeform identifiers",
            freeforms[1].target.span,
        )

    option_lines.sort(key=lambda item: item[0])
    options = "{ }"
    if option_lines:
        options = (
            "{ "
            + " ".join(
                f"{_emit_static_path(path)} = {declaration};"
                for path, declaration in option_lines
            )
            + " }"
        )
    fields = [f"options = {options};"]
    if freeforms:
        freeform = freeforms[0]
        body = _option_body(freeform.value)
        if body is None:
            raise CompilationError(
                "a ZMDL freeform value must be an attribute set",
                freeform.value.span,
            )
        identifier = _freeform_id(freeform.target)
        binding = f"_zenFreeformKey{freeform_depth}"
        child_emitter = _extend_freeform_emitter(emitter, identifier, binding)
        if _zmdl_scope_has_declarations(body.statements):
            child_module = _emit_zmdl_scope_module(
                body.statements,
                child_emitter,
                freeform_depth=freeform_depth + 1,
            )
            child_type = (
                "(lib.types.submodule ({ name, ... }: let "
                f"{binding} = name; in {child_module}))"
            )
        else:
            metadata, _, _ = _option_parts(freeform.value)
            annotation = metadata.get("type")
            child_type = (
                _emit_type(annotation, child_emitter)
                if annotation is not None
                else "lib.types.anything"
            )
        fields.append(f"freeformType = lib.types.attrsOf {child_type};")
    return "{ " + " ".join(fields) + " }"


def _option_type(
    annotation: Expression | None, value: Expression, emitter: NixEmitter
) -> str:
    if annotation is not None:
        return _emit_type(annotation, emitter)
    if isinstance(value, Literal):
        return {
            "true": "lib.types.bool",
            "false": "lib.types.bool",
            "integer": "lib.types.int",
            "float": "lib.types.float",
        }.get(
            value.kind,
            "lib.types.str" if isinstance(value.value, str) else "lib.types.anything",
        )
    if isinstance(value, StringExpr):
        return "lib.types.str"
    if isinstance(value, ListExpr):
        return "lib.types.listOf lib.types.anything"
    if isinstance(value, AttrSet):
        return "lib.types.attrs"
    return "lib.types.anything"


def _emit_type(annotation: Expression, emitter: NixEmitter) -> str:
    if isinstance(annotation, GroupExpr):
        return _emit_type(annotation.value, emitter)
    aliases = {
        "string": "str",
        "boolean": "bool",
        "set": "attrsOf",
        "list": "listOf",
    }
    if (
        isinstance(annotation, Variable)
        and annotation.name == "type"
        and len(annotation.path) == 1
    ):
        name = _static_path(annotation.path)[0]
        if name == "null":
            return "(lib.types.enum [ null ])"
        return "lib.types." + aliases.get(name, name)
    if isinstance(annotation, CallExpr) and isinstance(annotation.callee, Variable):
        callee = annotation.callee
        if callee.name == "type" and len(callee.path) == 1:
            name = _static_path(callee.path)[0]
            argument = annotation.arguments[0] if annotation.arguments else None
            if (
                name in ("list", "set", "functionTo")
                and isinstance(argument, ListExpr)
                and len(argument.items) == 1
            ):
                function = {
                    "list": "listOf",
                    "set": "attrsOf",
                    "functionTo": "functionTo",
                }[name]
                return (
                    f"(lib.types.{function} {_emit_type(argument.items[0], emitter)})"
                )
            if name == "enum" and isinstance(argument, ListExpr):
                return f"(lib.types.enum {emitter.expression(argument)})"
            if name == "either" and isinstance(argument, ListExpr):
                types = [_emit_type(item, emitter) for item in argument.items]
                result = types[-1]
                for item in reversed(types[:-1]):
                    result = f"(lib.types.either {item} {result})"
                return result
    return emitter.expression(annotation)


class _FreeformEmitter(NixEmitter):
    def __init__(
        self,
        freeform_bindings: dict[str, str],
        variable_roots: dict[str, str | None] | None = None,
    ):
        super().__init__(variable_roots or {"path": "cfg"})
        self.freeform_bindings = dict(freeform_bindings)

    def _variable(self, expression: Variable) -> str:
        if expression.name == "f":
            if (
                len(expression.path) == 1
                and isinstance(expression.path[0], IdentifierSegment)
                and expression.path[0].name in self.freeform_bindings
            ):
                return self.freeform_bindings[expression.path[0].name]
            raise CompilationError(
                "freeform identifiers are scalar keys",
                expression.span,
            )
        return super()._variable(expression)

    def child_emitter(self) -> NixEmitter:
        return _FreeformEmitter(self.freeform_bindings, self.variable_roots)


def _extend_freeform_emitter(
    emitter: NixEmitter,
    identifier: str,
    binding: str,
) -> _FreeformEmitter:
    bindings = (
        dict(emitter.freeform_bindings)
        if isinstance(emitter, _FreeformEmitter)
        else {}
    )
    bindings[identifier] = binding
    return _FreeformEmitter(bindings, emitter.variable_roots)


@dataclass(frozen=True)
class _FreeformContext:
    key_binding: str
    value_binding: str
    source: str


def _zmdl_scope_actions(
    statements: tuple[Any, ...],
    *,
    scope_value: str,
    contexts: tuple[_FreeformContext, ...],
    emitter: NixEmitter,
) -> list[str]:
    effective = _coalesce_zmdl_scope_assignments(statements)
    declared_names = sorted(
        {
            _assignment_path(statement)[0]
            for statement in effective
            if isinstance(statement, Assignment)
            and not isinstance(statement.target, StructuralMarker)
            and _assignment_path(statement)[0] != "_meta"
        }
    )
    actions: list[str] = []
    freeforms: list[Assignment] = []
    for statement in effective:
        if not isinstance(statement, Assignment):
            continue
        if isinstance(statement.target, StructuralMarker):
            if statement.target.kind == "freeform":
                freeforms.append(statement)
            continue
        path = _assignment_path(statement)
        if path[0] == "_meta":
            continue
        body = _option_body(statement.value)
        if body is None:
            continue
        child_scope = scope_value + "." + _emit_static_path(path)
        _, direct_actions, _ = _option_parts(statement.value)
        for action in direct_actions:
            actions.extend(
                _emit_transposed_action(
                    action,
                    contexts,
                    emitter,
                    conditional_base=child_scope,
                )
            )
        actions.extend(
            _zmdl_scope_actions(
                body.statements,
                scope_value=child_scope,
                contexts=contexts,
                emitter=emitter,
            )
        )

    if len(freeforms) > 1:
        raise CompilationError(
            "a scope cannot declare incompatible freeform identifiers",
            freeforms[1].target.span,
        )
    if freeforms:
        freeform = freeforms[0]
        body = _option_body(freeform.value)
        if body is None:
            raise CompilationError(
                "a ZMDL freeform value must be an attribute set",
                freeform.value.span,
            )
        identifier = _freeform_id(freeform.target)
        depth = len(contexts)
        key_binding = f"_zenFreeformKey{depth}"
        value_binding = f"_zenFreeformValue{depth}"
        source = scope_value
        if declared_names:
            source = (
                f"(builtins.removeAttrs {scope_value} "
                + emit_nix_data(declared_names)
                + ")"
            )
        context = _FreeformContext(
            key_binding,
            value_binding,
            source,
        )
        child_contexts = (*contexts, context)
        child_emitter = _extend_freeform_emitter(
            emitter,
            identifier,
            key_binding,
        )
        _, direct_actions, _ = _option_parts(freeform.value)
        for action in direct_actions:
            actions.extend(
                _emit_transposed_action(
                    action,
                    child_contexts,
                    child_emitter,
                    conditional_base=value_binding,
                )
            )
        actions.extend(
            _zmdl_scope_actions(
                body.statements,
                scope_value=value_binding,
                contexts=child_contexts,
                emitter=child_emitter,
            )
        )
    return actions


def _emit_transposed_action(
    action: ActionStatement,
    contexts: tuple[_FreeformContext, ...],
    emitter: NixEmitter,
    *,
    conditional_base: str,
) -> list[str]:
    if not contexts:
        return [_emit_action(action, emitter, conditional_base=conditional_base)]
    condition = None
    if not action.unconditional:
        condition = emitter.guard_condition(action.guards, conditional_base)
    fragments: list[str] = []
    bindings: list[LetStatement] = []

    def emit_definition(
        target: tuple[Any, ...],
        rendered_value: str,
        span: Any,
    ) -> None:
        indexes = [
            index
            for index, segment in enumerate(target)
            if isinstance(segment, DynamicSegment)
        ]
        if action.scope == "user":
            module = "{ " + emitter.path(target) + f" = {rendered_value}; }}"
            module = _with_action_bindings(bindings, emitter, module)
            if condition is not None:
                module = f"(lib.mkIf ({condition}) {module})"
            mapped = _map_freeform_contexts(contexts, f"[ {module} ]")
            fragments.append(f"{{ home-manager.sharedModules = {mapped}; }}")
            return
        if not indexes:
            path = _static_path(target, span)
            value = _with_action_bindings(bindings, emitter, rendered_value)
            if condition is not None:
                value = f"(lib.mkIf ({condition}) {value})"
            mapped = _map_freeform_contexts(contexts, value)
            fragments.append(f"{{ {_emit_static_path(path)} = {mapped}; }}")
            return

        # Keep the module definition path static; only its option value may
        # depend on the evaluated freeform keys.
        first_dynamic = indexes[0]
        if first_dynamic == 0:
            raise CompilationError(
                "freeform action targets require a static top-level path",
                target[0].span,
            )
        prefix = _static_path(target[:first_dynamic], span)
        suffix = target[first_dynamic:]
        value = "{ " + emitter.path(suffix) + f" = {rendered_value}; }}"
        value = _with_action_bindings(bindings, emitter, value)
        if condition is not None:
            value = f"(lib.mkIf ({condition}) {value})"
        mapped = _map_freeform_contexts(contexts, value)
        fragments.append(f"{{ {_emit_static_path(prefix)} = {mapped}; }}")

    for statement in action.body.statements:
        if isinstance(statement, LetStatement):
            bindings.append(statement)
            continue
        if isinstance(statement, InheritStatement):
            for name in statement.names:
                if statement.source is None:
                    rendered_value = emitter.binding_name(name)
                else:
                    rendered_value = (
                        f"({emitter.expression(statement.source, 6)})."
                        + emit_attr_name(name)
                    )
                target = (IdentifierSegment(name, statement.span),)
                emit_definition(target, rendered_value, statement.span)
            continue
        if not isinstance(statement, Assignment) or statement.operator != "=":
            raise CompilationError(
                "unsupported statement in a freeform action",
                statement.span,
            )
        if isinstance(statement.target, StructuralMarker):
            raise CompilationError(
                "structural markers are not action assignment targets",
                statement.target.span,
            )
        rendered_value = emitter.expression(statement.value, 6)
        emit_definition(statement.target, rendered_value, statement.span)
    if action.scope not in ("system", "shared", "user"):
        raise CompilationError(f"unknown action scope: {action.scope!r}", action.span)
    return fragments


def _with_action_bindings(
    bindings: list[LetStatement],
    emitter: NixEmitter,
    value: str,
) -> str:
    if not bindings:
        return value
    rendered = " ".join(emitter.statement(binding, 6) for binding in bindings)
    return f"(let {rendered} in {value})"


def _map_freeform_contexts(
    contexts: tuple[_FreeformContext, ...],
    value: str,
) -> str:
    result = value
    for context in reversed(contexts):
        result = (
            "lib.mkMerge (lib.mapAttrsToList "
            f"({context.key_binding}: {context.value_binding}: {result}) "
            f"{context.source})"
        )
    return result


def _emit_action(
    action: ActionStatement,
    emitter: NixEmitter,
    *,
    conditional_base: str,
) -> str:
    body = emitter.attr_set(action.body, 4)
    if action.scope == "system":
        routed = body
    elif action.scope == "user":
        routed = "{ home-manager.sharedModules = [ " + body + " ]; }"
    elif action.scope == "shared":
        routed = body
    else:
        raise CompilationError(f"unknown action scope: {action.scope!r}", action.span)
    if action.unconditional:
        return routed
    condition = emitter.guard_condition(action.guards, conditional_base)
    return f"(lib.mkIf ({condition}) {routed})"


def _collect_dependency_ops(
    result: dict[str, list[tuple[str, Expression]]], body: AttrSet
) -> None:
    for statement in body.statements:
        if not isinstance(statement, Assignment):
            raise CompilationError("dependency sets may contain only assignments", statement.span)
        path = _assignment_path(statement)
        if len(path) != 1 or path[0] not in result:
            raise CompilationError(
                "dependency scopes must be global, build, run, or export",
                statement.span,
            )
        result[path[0]].append((statement.operator, statement.value))


@dataclass(frozen=True)
class _Dependency:
    identity: tuple[str, ...]
    min_version: str | None
    span: Any


def _apply_dependency_ops(
    initial: tuple[_Dependency, ...],
    operations: list[tuple[str, Expression]],
) -> tuple[_Dependency, ...]:
    result = list(initial)
    for operator, value in operations:
        if not isinstance(value, ListExpr):
            raise CompilationError("dependency cascade operations require list values", value.span)
        dependencies = [_dependency(item) for item in value.items]
        if operator == "=":
            result = []
            for dependency in dependencies:
                _append_dependency(result, dependency)
        elif operator == "++":
            for dependency in dependencies:
                _append_dependency(result, dependency)
        elif operator == "--":
            for dependency in dependencies:
                index = next(
                    (index for index, existing in enumerate(result) if existing.identity == dependency.identity),
                    None,
                )
                if index is None:
                    raise CompilationError(
                        "cannot remove absent dependency " + ".".join(("$pkgs", *dependency.identity)),
                        dependency.span,
                    )
                result.pop(index)
        else:
            raise CompilationError(f"unknown dependency cascade operator: {operator!r}", value.span)
    return tuple(result)


def _append_dependency(result: list[_Dependency], dependency: _Dependency) -> None:
    existing = next((item for item in result if item.identity == dependency.identity), None)
    if existing is None:
        result.append(dependency)
        return
    if existing.min_version != dependency.min_version:
        raise CompilationError(
            "conflicting duplicate dependency " + ".".join(("$pkgs", *dependency.identity)),
            dependency.span,
        )


def _dependency(expression: Expression) -> _Dependency:
    candidate = expression.value if isinstance(expression, GroupExpr) else expression
    if isinstance(candidate, Variable):
        identity = _canonical_package_identity(candidate)
        return _Dependency(identity, None, expression.span)
    if isinstance(candidate, AttrSet):
        fields: dict[str, Expression] = {}
        for statement in candidate.statements:
            if not isinstance(statement, Assignment) or statement.operator != "=":
                raise CompilationError("dependency records contain only assignments", statement.span)
            path = _assignment_path(statement)
            if len(path) != 1 or path[0] in fields or path[0] not in ("id", "minVersion"):
                raise CompilationError("dependency records support only id and minVersion", statement.span)
            fields[path[0]] = statement.value
        if "id" not in fields or not isinstance(fields["id"], Variable):
            raise CompilationError("dependency records require a canonical id", candidate.span)
        identity = _canonical_package_identity(fields["id"])
        minimum = fields.get("minVersion")
        min_version = None
        if minimum is not None:
            if not isinstance(minimum, StringExpr) or any(not isinstance(part, StringText) for part in minimum.parts):
                raise CompilationError("dependency minVersion must be a plain string", minimum.span)
            min_version = "".join(part.value for part in minimum.parts)
        return _Dependency(identity, min_version, expression.span)
    raise CompilationError("invalid dependency record", expression.span)


def _canonical_package_identity(variable: Variable) -> tuple[str, ...]:
    if variable.name != "pkgs" or len(variable.path) < 2:
        raise CompilationError("dependency IDs must use $pkgs.zenos.<path>", variable.span)
    identity = _static_path(variable.path, variable.span)
    if identity[0] != "zenos":
        raise CompilationError("dependency IDs must use $pkgs.zenos.<path>", variable.span)
    return identity


def _check_dependency_short_names(dependencies: tuple[_Dependency, ...]) -> None:
    names: dict[str, tuple[str, ...]] = {}
    for dependency in dependencies:
        short = dependency.identity[-1]
        previous = names.get(short)
        if previous is not None and previous != dependency.identity:
            raise CompilationError(
                f"dependency short name {short!r} collides between "
                f"{'.'.join(previous)} and {'.'.join(dependency.identity)}",
                dependency.span,
            )
        names[short] = dependency.identity


def _emit_dependencies(dependencies: tuple[_Dependency, ...]) -> str:
    if not dependencies:
        return "[ ]"
    records = []
    for dependency in dependencies:
        identity = "pkgs." + ".".join(emit_attr_name(part) for part in dependency.identity)
        minimum = "null" if dependency.min_version is None else emit_nix_data(dependency.min_version)
        records.append(f"{{ id = {identity}; minVersion = {minimum}; }}")
    return "[ " + " ".join(records) + " ]"


def _dependency_descriptors(dependencies: tuple[_Dependency, ...]) -> list[dict[str, Any]]:
    return [
        {
            "id": "$pkgs." + ".".join(dependency.identity),
            "minVersion": dependency.min_version,
        }
        for dependency in dependencies
    ]
