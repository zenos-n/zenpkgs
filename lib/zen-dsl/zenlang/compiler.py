from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path, PurePath
from typing import Any

from .api import parse_file
from .emitter import NixEmitter, emit_attr_name, emit_nix_data, semantic_descriptor
from .validation import infer_type
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
    LetExpr,
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
    statements = _resolved_statements(document)
    return {
        "descriptorVersion": DESCRIPTOR_VERSION,
        "grammarVersion": document.grammar_version,
        "irVersion": document.ir_version,
        "kind": document.kind.value,
        "statements": semantic_descriptor(statements),
        **({"nodeMetadata": _node_metadata(statements),
            "aliases": _zmdl_aliases(_coalesce_zmdl_scope_assignments(statements))}
           if document.kind is FileKind.ZMDL else {}),
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
        diagnostics = []
        for diagnostic in document.diagnostics:
            record = diagnostic.to_dict()
            # Bundle diagnostics carry portable locations, not parser AST spans.
            record.pop("span")
            record["source"] = diagnostic.span.source
            record["line"] = diagnostic.span.start.line
            record["column"] = diagnostic.span.start.column
            try:
                record["source"] = Path(diagnostic.span.source).relative_to(resolved_root).as_posix()
            except ValueError:
                pass
            diagnostics.append(record)
        if document.kind is FileKind.ZMDL:
            compiled = compile_zmdl(document, root=resolved_root)
        else:
            compiled = compile_document(document, mode=mode)
        sources.append(
            {
                "compiledNix": compiled,
                **({"mountNix": compile_zmdl_mount(document, root=resolved_root)}
                   if document.kind is FileKind.ZMDL else {}),
                "descriptor": document_descriptor(document),
                "diagnostics": diagnostics,
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
        "diagnostics": [diagnostic for source in sources for diagnostic in source["diagnostics"]],
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
    aliases = _zmdl_aliases(statements)

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
        "nodeMetadata": _node_metadata(statements),
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


def compile_zmdl_mount(document: Document, *, root: str | Path) -> str:
    """Compile a definition independently of its filesystem identity's location."""
    _zmdl_module(document, root)
    statements = _coalesce_zmdl_scope_assignments(_resolved_statements(document))
    _zmdl_aliases(statements, mounting=True)
    emitter = _MountEmitter({}, {"path": "cfg"})
    bindings = [emitter.statement(item) for item in statements
                if isinstance(item, (LetStatement, ResolvedImport))]
    actions = _zmdl_scope_actions(statements, scope_value="cfg", contexts=(), emitter=emitter)
    roots: set[str] = set()

    def visit(items: tuple[Any, ...]) -> None:
        for item in items:
            if isinstance(item, ActionStatement):
                if item.scope in ("user", "shared"):
                    roots.add("home-manager")
                if item.scope != "user":
                    for definition in item.body.statements:
                        if isinstance(definition, Assignment):
                            roots.add(_static_path(definition.target[:1], definition.span)[0])
                        elif isinstance(definition, InheritStatement):
                            roots.update(definition.names)
            elif isinstance(item, Assignment):
                body = _option_body(item.value)
                if body is not None:
                    visit(body.statements)

    visit(statements)
    schema = _emit_zmdl_scope_module(statements, emitter, freeform_depth=0)
    return (
        "{ config, cfg, lib, pkgs, user ? null, freeform ? { }, shareUserActions ? true, "
        "moduleAliasOption ? (_: throw \"ZMDL aliases require the ZSTR runtime\"), "
        "maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:\nlet\n"
        + f"  name = {emit_nix_data(_source_name(document))};\n"
        + "  _zenDefaults = value: if (value._type or \"\") == \"if\" then "
        "lib.mkIf value.condition (_zenDefaults value.content) else "
        "if (value._type or \"\") == \"merge\" then lib.mkMerge (map _zenDefaults value.contents) "
        "else if (value._type or \"\") == \"override\" then value "
        "else if builtins.isAttrs value && !(lib.isDerivation value) && !(value ? _type) "
        "then lib.mapAttrs (_: _zenDefaults) value else lib.mkDefault value;\n"
        + "\n".join(f"  {binding}" for binding in bindings)
        + "\nin {\n"
        + f"  schema = {schema};\n"
        + f"  actionRoots = {emit_nix_data(sorted(roots))};\n"
        + "  actions = [\n" + "\n".join(f"    {action}" for action in actions)
        + "\n  ];\n}\n"
    )


def compile_zpkg(document: Document, *, mode: str = "build") -> str:
    _require_kind(document, FileKind.ZPKG)
    if mode not in ("interface", "build"):
        raise CompilationError("ZPKG mode must be 'interface' or 'build'", document.span)
    emitter = NixEmitter()
    metadata: dict[str, Expression] = {}
    local_bindings: list[ResolvedImport | LetStatement] = []
    package_import: PackageImportStatement | None = None

    for statement in _coalesce_zmdl_scope_assignments(_resolved_statements(document)):
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
    import_data = [
        semantic_descriptor(statement)
        for statement in local_bindings
        if isinstance(statement, ResolvedImport)
    ]
    metadata = _normalized_package_metadata(metadata)
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

    if "dependencies" in metadata:
        scopes: dict[str, Expression] = {}
        _collect_metadata(scopes, (), metadata["dependencies"])
        for scope, value in scopes.items():
            if not isinstance(value, ListExpr) or value.items:
                raise CompilationError(
                    f"{document.span.source}: _meta.dependencies.{scope}: "
                    "ZPKG dependencies are unsupported until backend override "
                    "and runtime-linkage mechanics are specified (D14); "
                    "only empty dependency scopes can be compiled for execution",
                    value.span,
                )

    package = emitter.expression(package_import.package)
    bindings = "\n".join(f"  {emitter.statement(statement)}" for statement in local_bindings)
    supplied = "{ " + " ".join(
        f"{emit_attr_name(key)} = {emitter.expression(value)};"
        for key, value in sorted(metadata.items())
    ) + " }"
    return (
        "{ pkgs, lib ? pkgs.lib, maintainers ? lib.maintainers, licenses ? lib.licenses, ... }:\nlet\n"
        + f"  name = {emit_nix_data(_source_name(document))};\n"
        + (bindings + "\n" if bindings else "")
        + f"  package = {package};\n  suppliedMetadata = {supplied};\n"
        + "in\nassert builtins.isAttrs package && (package.type or null) == \"derivation\";\n"
        + "builtins.deepSeq suppliedMetadata (package // { meta = (package.meta or { }) // suppliedMetadata; })\n"
    )


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


def _zmdl_aliases(
    statements: tuple[Any, ...], *, mounting: bool = False,
) -> list[dict[str, Any]]:
    aliases: list[dict[str, Any]] = []

    def visit(items: tuple[Any, ...], path: list[Any], enabled: bool = False) -> None:
        initial_count = len(aliases)
        metadata, actions, _ = _option_parts(AttrSet(items, False, items[0].span)) if items else ({}, [], False)
        marker = metadata.get("type")
        if isinstance(marker, StructuralMarker) and marker.kind == "alias":
            if path and isinstance(path[-1], dict):
                raise CompilationError(
                    "aliases directly on freeform items are unsupported; declare a named alias child",
                    marker.span,
                )
            children = [item for item in items if isinstance(item, Assignment)
                        and (isinstance(item.target, StructuralMarker)
                             or _assignment_path(item)[0] != "_meta")]
            if children or actions or "default" in metadata or enabled:
                raise CompilationError(
                    "ZMDL alias collisions with local children, actions, or defaults are unsupported; precedence is unresolved",
                    marker.span,
                )
            target: list[Any] = []
            for segment in marker.argument or ():
                if isinstance(segment, DynamicSegment):
                    variable = segment.value
                    if not isinstance(variable, Variable) or variable.name != "f" or len(variable.path) != 1:
                        raise CompilationError("alias targets require lexical $f keys", segment.span)
                    target.append({"freeform": _static_path(variable.path)[0]})
                else:
                    target.append(_static_path((segment,))[0])
            if not target or target[0] != "nixpkgs" or len(target) > 1 and not isinstance(target[1], str):
                raise CompilationError("ZMDL aliases must target nixpkgs options with a static root", marker.span)
            aliases.append({"path": path, "kind": "alias", "target": target})
            return
        for item in items:
            if not isinstance(item, Assignment):
                continue
            if isinstance(item.target, StructuralMarker):
                if item.target.kind == "alias":
                    if mounting:
                        raise CompilationError(
                            "record-form ZMDL alias mounting is unspecified; use _meta.type = (alias nixpkgs.<path>)",
                            item.target.span,
                        )
                    aliases.append({"path": semantic_descriptor(item.target.argument),
                                    "value": semantic_descriptor(item.value)})
                    continue
                if item.target.kind != "freeform":
                    continue
                excluded = [_assignment_path(child)[0] for child in items
                            if isinstance(child, Assignment) and not isinstance(child.target, StructuralMarker)
                            and _assignment_path(child)[0] != "_meta"]
                child_path = [*path, {"freeform": _freeform_id(item.target), "exclude": excluded}]
            else:
                keys = _assignment_path(item)
                if keys[0] == "_meta":
                    continue
                child_path = [*path, *keys]
            body = _option_body(item.value)
            if body is not None:
                visit(body.statements, child_path, isinstance(item.value, EnableOption))
        if "default" in metadata and len(aliases) != initial_count:
            raise CompilationError(
                "ZMDL aliases below local defaults are unsupported; precedence is unresolved",
                metadata["default"].span,
            )

    visit(statements, [])
    return aliases


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
    mounts: list[dict[str, Any]] = []
    nodes: list[dict[str, Any]] = []

    def marker_path(marker: StructuralMarker) -> tuple[str, ...]:
        return _static_path(marker.argument, marker.span)

    def visit(
        statements: tuple[Any, ...],
        prefix: tuple[str, ...],
        binding_scopes: tuple[str, ...] = (),
    ) -> None:
        emitter = _MountEmitter({})
        local_bindings = " ".join(
            emitter.statement(item) for item in statements
            if isinstance(item, LetStatement)
            or isinstance(item, ResolvedImport) and item.binding is not None
        )
        if local_bindings:
            binding_scopes = (*binding_scopes, local_bindings)
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
                    nodes.append({"path": list(nested_prefix)})
                if isinstance(statement.value, AttrSet):
                    visit(statement.value.statements, nested_prefix, binding_scopes)
                continue
            path = (*prefix, *_assignment_path(statement))
            if isinstance(statement.value, StructuralMarker):
                marker = statement.value
                owner = path[:-2] if path[-2:] in (("_meta", "type"), ("_meta", "_type")) else path
                if marker.kind == "programs":
                    raise CompilationError("the (programs) marker has no mounting semantics; use (zmdl programs)", marker.span)
                if marker.kind == "packages" and not (
                    owner == ("system", "packages")
                    or len(owner) == 3 and owner[0] == "users"
                    and owner[1].startswith("{") and owner[2] == "packages"
                ):
                    raise CompilationError("package selectors require system.packages or users.<name>.packages", marker.span)
                if marker.kind == "zmdl":
                    _static_path(marker.argument, marker.span)
                if marker.kind in ("zmdl", "packages", "alias"):
                    target = []
                    for segment in marker.argument or ():
                        if isinstance(segment, DynamicSegment):
                            variable = segment.value
                            if not isinstance(variable, Variable) or variable.name != "f":
                                raise CompilationError("mount targets require lexical $f keys", segment.span)
                            target.append({"freeform": _static_path(variable.path)[0]})
                        else:
                            target.append(_static_path((segment,))[0])
                    mounts.append({"path": list(owner), "kind": marker.kind, "target": target})
                if marker.kind == "alias":
                    aliases.append(
                        {
                            "path": list(owner),
                            "value": {"marker": semantic_descriptor(marker)},
                        }
                    )
            elif isinstance(statement.value, AttrSet):
                if "_meta" not in path:
                    node: dict[str, Any] = {"path": list(path)}
                    metadata, _, _ = _option_parts(statement.value)
                    if ("type" in metadata or "default" in metadata) and not isinstance(metadata.get("type"), StructuralMarker):
                        node["optionNix"] = (
                            "{ lib, pkgs, config, freeform, maintainers ? lib.maintainers, "
                            "licenses ? lib.licenses, ... }: let name = \"structure\"; in "
                            + " ".join(f"let {bindings} in" for bindings in binding_scopes)
                            + " " + _option_declaration(statement.value, emitter, freeform_depth=0)
                        )
                    nodes.append(node)
                visit(statement.value.statements, path, binding_scopes)

    document = documents.get("structure.zstr")
    if document is not None:
        visit(_coalesce_zmdl_scope_assignments(_resolved_statements(document)), ())
    aliases.sort(key=lambda item: item["path"])
    return {"mounts": mounts, "nodes": nodes,
            "present": document is not None}


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
        bindings: tuple[LetStatement | ResolvedImport, ...] = (),
    ) -> None:
        def scoped(value: Expression) -> Expression:
            return LetExpr(bindings, value, value.span) if bindings else value

        for statement in current:
            if isinstance(statement, (LetStatement, ResolvedImport)):
                bindings = (*bindings, statement)
                continue
            if isinstance(statement, ConditionalStatement):
                visit(
                    statement.body.statements,
                    logical_prefix,
                    (*conditions, scoped(statement.condition)),
                    bindings,
                )
                continue
            if not isinstance(statement, Assignment) or statement.operator != "=":
                raise CompilationError(
                    "ZCFG output supports assignments, conditionals, and lexical bindings",
                    statement.span,
                )
            logical_path = (*logical_prefix, *_assignment_path(statement))
            if logical_path[0] == "_meta":
                continue
            if isinstance(statement.value, AttrSet):
                if not any(not isinstance(item, (LetStatement, ResolvedImport))
                           for item in statement.value.statements):
                    path = _route_zcfg_path(logical_path, tree_for(conditions), statement.span)
                    if path:
                        _insert_tree(tree_for(conditions), path, {}, statement.span)
                    continue
                visit(
                    statement.value.statements,
                    logical_path,
                    conditions,
                    bindings,
                )
            else:
                path = _route_zcfg_path(logical_path, tree_for(conditions), statement.span)
                if not path:
                    raise CompilationError("legacy must be an attribute set", statement.span)
                _insert_tree(tree_for(conditions), path, scoped(statement.value), statement.span)

    visit(tuple(statements), (), ())
    return groups


def _route_zcfg_path(
    path: tuple[str, ...], tree: dict[str, Any], span: Any
) -> tuple[str, ...]:
    if path[:2] == ("legacy", "zenos"):
        raise CompilationError("legacy cannot contain the zenos option tree", span)
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
    while isinstance(value, GroupExpr):
        value = value.value
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
        nested = _nest_zmdl_assignment(tuple(IdentifierSegment(part, value.span) for part in path[1:]), value, value.span)
        previous = result.get(path[0])
        if previous is not None and not isinstance(previous, AttrSet):
            raise CompilationError(f"conflicting metadata field: {path[0]}", value.span)
        result[path[0]] = AttrSet(_coalesce_assignments((*previous.statements, nested)) if previous else (nested,), False, value.span)
        return
    field = path[0]
    if field.startswith("_"):
        raise CompilationError("fields inside _meta must be unprefixed", value.span)
    if field in result:
        raise CompilationError(f"duplicate metadata field: {field}", value.span)
    result[field] = value


def _normalized_package_metadata(metadata: dict[str, Expression]) -> dict[str, Expression]:
    result = dict(metadata)
    version = result.get("packageVersion")
    empty = isinstance(version, StringExpr) and all(isinstance(part, StringText) and not part.value for part in version.parts)
    if (version is None or empty) and "zenosVersion" in result:
        result["packageVersion"] = result["zenosVersion"]
    return result


def _node_metadata(statements: tuple[Any, ...]) -> list[dict[str, Any]]:
    """Relative ZMDL node paths; freeform segments are {freeform: identifier}.

    Metadata values use semantic_descriptor. Only zenosVersion is inherited;
    unresolved versions remain absent. Authored statements are never rewritten.
    """
    records: list[dict[str, Any]] = []

    def visit(current: tuple[Any, ...], path: list[Any], inherited: Expression | None) -> None:
        metadata: dict[str, Expression] = {}
        for statement in current:
            if isinstance(statement, Assignment) and not isinstance(statement.target, StructuralMarker):
                names = _assignment_path(statement)
                if names[0] == "_meta":
                    _collect_metadata(metadata, names[1:], statement.value)
        version = metadata.get("zenosVersion", inherited)
        if version is not None:
            metadata["zenosVersion"] = version
        records.append({"path": path, "metadata": {key: semantic_descriptor(value) for key, value in sorted(metadata.items())}})
        for statement in current:
            if not isinstance(statement, Assignment):
                continue
            if isinstance(statement.target, StructuralMarker):
                if statement.target.kind != "freeform":
                    continue
                segments = [{"freeform": _freeform_id(statement.target)}]
            else:
                segments = list(_assignment_path(statement))
                if segments[0] == "_meta":
                    continue
            body = _option_body(statement.value)
            visit(body.statements if body else (), [*path, *segments], version)

    visit(_coalesce_zmdl_scope_assignments(statements), [], None)
    return records


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
    inherited_defaults: tuple[str, ...] = (),
    type_bindings: dict[str, Expression] | None = None,
) -> str:
    metadata, _, enabled = _option_parts(value)
    body = _option_body(value)
    local_bindings = tuple(
        item for item in body.statements if isinstance(item, (LetStatement, ResolvedImport))
    ) if body is not None else ()
    type_bindings = dict(type_bindings or {})
    for item in local_bindings:
        if isinstance(item, LetStatement):
            type_bindings[item.name] = item.annotation
        elif item.annotation is not None:
            type_bindings[item.binding] = item.annotation
    has_scope = body is not None and _zmdl_scope_has_declarations(body.statements)
    if has_scope:
        option_type = _zmdl_submodule_type(
            body.statements,
            emitter,
            freeform_depth=freeform_depth,
            inherited_defaults=inherited_defaults,
            type_bindings=type_bindings,
        )
    else:
        option_type = (
            "lib.types.bool"
            if enabled
            else _option_type(metadata.get("type"), metadata.get("default", value if body is None else None), emitter, bindings=type_bindings, span=value.span)
        )
    default = metadata.get("default")
    if default is None and enabled:
        default_text = "false"
    elif has_scope:
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
    declaration = "lib.mkOption { " + " ".join(fields) + " }"
    if inherited_defaults and not has_scope:
        declaration = (f"({declaration} // lib.foldr (value: rest: rest // value) {{ }} "
                       + "[ " + " ".join(f"({value})" for value in inherited_defaults) + " ])")
    return _with_action_bindings(local_bindings, emitter, declaration)


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
    inherited_defaults: tuple[str, ...] = (),
    type_bindings: dict[str, Expression] | None = None,
) -> str:
    module = _emit_zmdl_scope_module(
        statements,
        emitter,
        freeform_depth=freeform_depth,
        inherited_defaults=inherited_defaults,
        type_bindings=type_bindings,
    )
    return f"(lib.types.submodule ({{ ... }}: {module}))"


def _emit_zmdl_scope_module(
    statements: tuple[Any, ...],
    emitter: NixEmitter,
    *,
    freeform_depth: int,
    inherited_defaults: tuple[str, ...] = (),
    type_bindings: dict[str, Expression] | None = None,
) -> str:
    effective = _coalesce_zmdl_scope_assignments(statements)
    type_bindings = dict(type_bindings or {})
    for statement in effective:
        if isinstance(statement, LetStatement):
            type_bindings[statement.name] = statement.annotation
        elif isinstance(statement, ResolvedImport) and statement.binding is not None and statement.annotation is not None:
            type_bindings[statement.binding] = statement.annotation
    metadata: dict[str, Expression] = {}
    for statement in effective:
        if isinstance(statement, Assignment) and not isinstance(statement.target, StructuralMarker):
            path = _assignment_path(statement)
            if path[0] == "_meta":
                _collect_metadata(metadata, path[1:], statement.value)
    default_records = inherited_defaults
    if "default" in metadata:
        default_records = (*default_records, "{ default = " + emitter.expression(metadata["default"]) + "; }")

    def child_defaults(key: str) -> tuple[str, ...]:
        # Parent defaults become ordinary child option defaults. This retains
        # priority 1500 while allowing partial submodule definitions to merge.
        return tuple(
            f"(if ({record}) ? default && builtins.hasAttr ({key}) ({record}).default "
            f"then {{ default = builtins.getAttr ({key}) ({record}).default; }} else {{ }})"
            for record in default_records
        )

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
        alias_metadata, _, _ = _option_parts(statement.value)
        alias_marker = alias_metadata.get("type")
        if isinstance(alias_marker, StructuralMarker) and alias_marker.kind == "alias":
            if isinstance(emitter, _MountEmitter):
                target = "[ " + " ".join(
                    f"({emitter.expression(segment.value)})" if isinstance(segment, DynamicSegment)
                    else emit_nix_data(_static_path((segment,))[0])
                    for segment in alias_marker.argument
                ) + " ]"
                option_lines.append((path, f"moduleAliasOption {target}"))
            continue
        option_lines.append(
            (
                path,
                _option_declaration(
                    statement.value,
                    emitter,
                    freeform_depth=freeform_depth,
                    inherited_defaults=child_defaults(emit_nix_data(path[0])),
                    type_bindings=type_bindings,
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
                inherited_defaults=child_defaults(binding),
                type_bindings=type_bindings,
            )
            child_type = (
                "(lib.types.submodule ({ name, ... }: let "
                f"{binding} = name; in {child_module}))"
            )
        else:
            metadata, _, _ = _option_parts(freeform.value)
            annotation = metadata.get("type")
            child_type = _option_type(annotation, metadata.get("default"), child_emitter, bindings=type_bindings, span=freeform.span)
        fields.append(f"freeformType = lib.types.attrsOf {child_type};")
    if default_records:
        records = "[ " + " ".join(f"({record})" for record in default_records) + " ]"
        names = emit_nix_data([path[0] for path, _ in option_lines])
        # Freeform defaults still instantiate their keys; unknown defaults must
        # remain definitions so the module system diagnoses them, not drops them.
        fields.append(
            "config = lib.mkOptionDefault (builtins.removeAttrs "
            f"(lib.foldr (record: rest: lib.recursiveUpdate rest (record.default or {{ }})) {{ }} {records}) {names});"
        )
    bindings = tuple(item for item in effective if isinstance(item, (LetStatement, ResolvedImport)))
    return _with_action_bindings(bindings, emitter, "{ " + " ".join(fields) + " }")


def _option_type(
    annotation: Expression | None, value: Expression | None, emitter: NixEmitter,
    *, bindings: dict[str, Expression] | None = None, span: Any | None = None,
) -> str:
    if annotation is None and value is not None:
        annotation = infer_type(value, bindings)
    if annotation is None:
        raise CompilationError("cannot infer option type; supply _meta.type (use $type.set for an open record)", span or (value.span if value is not None else None))
    return emitter.type_expression(annotation)


def _emit_type(annotation: Expression, emitter: NixEmitter) -> str:
    if isinstance(annotation, GroupExpr):
        return _emit_type(annotation.value, emitter)
    aliases = {
        "string": "str",
        "boolean": "bool",
        "set": "attrs",
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


class _MountEmitter(_FreeformEmitter):
    def _variable(self, expression: Variable) -> str:
        if expression.name == "f" and len(expression.path) == 1:
            identifier = _static_path(expression.path)[0]
            if identifier not in self.freeform_bindings:
                return "freeform." + emit_attr_name(identifier)
        return super()._variable(expression)

    def child_emitter(self) -> NixEmitter:
        return _MountEmitter(self.freeform_bindings, self.variable_roots)


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
    cls = _MountEmitter if isinstance(emitter, _MountEmitter) else _FreeformEmitter
    return cls(bindings, emitter.variable_roots)


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
    inherited_weight: Expression | None = None,
    binding_scopes: tuple[tuple[int, str], ...] = (),
) -> list[str]:
    effective = _coalesce_zmdl_scope_assignments(statements)
    bindings = " ".join(
        emitter.statement(item) for item in effective
        if isinstance(item, (LetStatement, ResolvedImport))
    )
    if bindings:
        binding_scopes = (*binding_scopes, (len(contexts), bindings))
    metadata: dict[str, Expression] = {}
    for statement in effective:
        if isinstance(statement, Assignment) and not isinstance(statement.target, StructuralMarker):
            path = _assignment_path(statement)
            if path[0] == "_meta":
                _collect_metadata(metadata, path[1:], statement.value)
    weight = metadata.get("weight", inherited_weight)
    declared_names = sorted(
        {
            _assignment_path(statement)[0]
            for statement in effective
            if isinstance(statement, Assignment)
            and not isinstance(statement.target, StructuralMarker)
            and _assignment_path(statement)[0] != "_meta"
        }
    )
    if isinstance(emitter, _MountEmitter) and scope_value == "cfg" and "enable" not in declared_names:
        declared_names.append("enable")
    actions: list[str] = []
    for statement in effective:
        if isinstance(statement, ActionStatement):
            actions.extend(_emit_transposed_action(
                statement, contexts, emitter, conditional_base=scope_value,
                weight=weight, binding_scopes=binding_scopes,
            ))
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
        actions.extend(
            _zmdl_scope_actions(
                body.statements,
                scope_value=child_scope,
                contexts=contexts,
                emitter=emitter,
                inherited_weight=weight,
                binding_scopes=binding_scopes,
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
        actions.extend(
            _zmdl_scope_actions(
                body.statements,
                scope_value=value_binding,
                contexts=child_contexts,
                emitter=child_emitter,
                inherited_weight=weight,
                binding_scopes=binding_scopes,
            )
        )
    return actions


def _emit_transposed_action(
    action: ActionStatement,
    contexts: tuple[_FreeformContext, ...],
    emitter: NixEmitter,
    *,
    conditional_base: str,
    weight: Expression | None = None,
    binding_scopes: tuple[tuple[int, str], ...] = (),
) -> list[str]:
    if not contexts:
        value = _emit_action(action, emitter, conditional_base=conditional_base, weight=weight)
        return [_map_freeform_contexts((), value, binding_scopes)]
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
        if weight is not None:
            rendered_value = f"(lib.mkOverride ({emitter.expression(weight)}) ({rendered_value}))"
        indexes = [
            index
            for index, segment in enumerate(target)
            if isinstance(segment, DynamicSegment)
        ]
        if action.scope == "user" or (isinstance(emitter, _MountEmitter) and action.scope == "shared"):
            module = "{ " + emitter.path(target) + f" = {rendered_value}; }}"
            module = _with_action_bindings(bindings, emitter, module)
            if condition is not None:
                module = f"(lib.mkIf ({condition}) {module})"
            if isinstance(emitter, _MountEmitter):
                mapped = _map_freeform_contexts(contexts, module, binding_scopes)
                system_value = (
                    f"(if shareUserActions then {{ home-manager.sharedModules = [ {{ config = _zenDefaults ({mapped}); }} ]; }} else {{ }})"
                    if action.scope == "user" else mapped
                )
                fragments.append(
                    f"(if user == null then {system_value} "
                    f"else {{ home-manager.users.${{user}} = {mapped}; }})"
                )
            else:
                mapped = _map_freeform_contexts(contexts, f"[ {module} ]", binding_scopes)
                fragments.append(f"{{ home-manager.sharedModules = {mapped}; }}")
            return
        if not indexes:
            path = _static_path(target, span)
            value = _with_action_bindings(bindings, emitter, rendered_value)
            if condition is not None:
                value = f"(lib.mkIf ({condition}) {value})"
            mapped = _map_freeform_contexts(contexts, value, binding_scopes)
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
        mapped = _map_freeform_contexts(contexts, value, binding_scopes)
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
    if isinstance(emitter, _MountEmitter) and action.scope == "system":
        fragments = [f"(if user == null then {fragment} else {{ }})" for fragment in fragments]
    return fragments


def _with_action_bindings(
    bindings: list[LetStatement] | tuple[Any, ...],
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
    binding_scopes: tuple[tuple[int, str], ...] = (),
) -> str:
    result = value
    for depth in range(len(contexts), -1, -1):
        for scope_depth, bindings in reversed(binding_scopes):
            if scope_depth == depth:
                result = f"(let {bindings} in {result})"
        if depth == 0:
            break
        context = contexts[depth - 1]
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
    weight: Expression | None = None,
) -> str:
    body = emitter.attr_set(action.body, 4)
    weight_text = emitter.expression(weight) if weight is not None else None
    if weight_text is not None:
        body = _guarded_mount_body(action.body, emitter, None, weight_text)
    if isinstance(emitter, _MountEmitter):
        if not action.unconditional:
            condition = emitter.guard_condition(action.guards, conditional_base)
            zen_statements = tuple(
                item for item in action.body.statements if isinstance(item, Assignment)
                and not isinstance(item.target, StructuralMarker)
                and _static_path(item.target[:1]) == ("zenos",)
            )
            if zen_statements:
                bindings = tuple(item for item in action.body.statements if isinstance(item, LetStatement))
                zen_body = AttrSet((*bindings, *zen_statements), action.body.recursive, action.body.span)
                other_body = AttrSet(tuple(item for item in action.body.statements if item not in zen_statements),
                                     action.body.recursive, action.body.span)
                ordinary = (_guarded_mount_body(other_body, emitter, None, weight_text)
                            if weight_text is not None else emitter.attr_set(other_body))
                body = (f"(lib.mkMerge [ (lib.mkIf ({condition}) {ordinary}) "
                        f"({_guarded_mount_body(zen_body, emitter, condition, weight_text)}) ])")
            else:
                body = f"(lib.mkIf ({condition}) {body})"
        if action.scope == "system":
            return f"(if user == null then {body} else {{ }})"
        user_body = f"{{ home-manager.users.${{user}} = {body}; }}"
        if action.scope == "user":
            return f"(if user == null then (if shareUserActions then {{ home-manager.sharedModules = [ {{ config = _zenDefaults {body}; }} ]; }} else {{ }}) else {user_body})"
        return f"(if user == null then {body} else {user_body})"
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


def _guarded_mount_body(
    body: AttrSet, emitter: NixEmitter, condition: str | None, weight: str | None = None,
) -> str:
    # Keep submodule definition shapes independent of their own option values.
    # Guard the authored leaves, without inspecting unevaluated RHS expressions.
    bindings = []
    fields = []

    def wrap(value: str) -> str:
        if weight is not None:
            value = f"(lib.mkOverride ({weight}) ({value}))"
        if condition is not None:
            value = f"(lib.mkIf ({condition}) ({value}))"
        return value

    for statement in body.statements:
        if isinstance(statement, LetStatement):
            bindings.append(statement)
        elif isinstance(statement, Assignment):
            value = (
                _guarded_mount_body(statement.value, emitter, condition, weight)
                if isinstance(statement.value, AttrSet) and statement.value.statements
                else wrap(emitter.expression(statement.value))
            )
            fields.append(f"{emitter.path(statement.target)} = {value};")
        elif isinstance(statement, InheritStatement):
            for name in statement.names:
                value = emitter.binding_name(name) if statement.source is None else (
                    f"({emitter.expression(statement.source)}).{emit_attr_name(name)}"
                )
                fields.append(f"{emit_attr_name(name)} = {wrap(value)};")
        else:
            raise CompilationError("unsupported mounted action statement", statement.span)
    value = ("rec " if body.recursive else "") + "{ " + " ".join(fields) + " }"
    return _with_action_bindings(bindings, emitter, value)


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
