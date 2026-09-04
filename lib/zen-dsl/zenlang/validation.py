from __future__ import annotations

import re

from .model import (
    ActionStatement,
    Assignment,
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
    GroupExpr,
    IdentifierSegment,
    IfExpr,
    ImportStatement,
    InheritStatement,
    Interpolation,
    LambdaExpr,
    LetExpr,
    LetStatement,
    ListExpr,
    Literal,
    PathExpr,
    PackageImportStatement,
    Reference,
    ResolvedImport,
    SelectionExpr,
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


_ALLOWED_TOP_LEVEL = {
    FileKind.ZCFG: (Assignment, ImportStatement, ResolvedImport, LetStatement, ConditionalStatement),
    FileKind.ZMDL: (Assignment, ImportStatement, ResolvedImport, LetStatement, ActionStatement),
    FileKind.ZPKG: (
        Assignment,
        ImportStatement,
        PackageImportStatement,
        ResolvedImport,
        LetStatement,
    ),
    FileKind.ZSTR: (Assignment, ImportStatement, ResolvedImport, LetStatement),
}

_COMMON_VARIABLES = frozenset(("pkgs", "lib", "name", "type", "m", "l", "v"))
_BUILTIN_VARIABLES = {
    FileKind.ZCFG: _COMMON_VARIABLES | {"cfg"},
    FileKind.ZMDL: _COMMON_VARIABLES | {"cfg", "path", "c", "f"},
    FileKind.ZPKG: _COMMON_VARIABLES | {"deps", "src"},
    FileKind.ZSTR: _COMMON_VARIABLES | {"f"},
}
_PARAMETERIZED_TYPES = frozenset(("list", "set", "either", "function", "functionTo", "enum"))
_ZENOS_VERSION = re.compile(r"^[0-9]+\.[0-9]+\.[0-9]+(?:[A-Z](?:[abl])?|[abl])?$")
_BOOLEAN_BINARY = frozenset(("||", "&&", "==", "!=", ">", ">=", "<", "<="))
_ZCFG_BINARY = _BOOLEAN_BINARY
_RESERVED_BINDINGS = frozenset(
    (
        "abort",
        "assert",
        "baseNameOf",
        "builtins",
        "cfg",
        "config",
        "derivationStrict",
        "deps",
        "derivation",
        "dirOf",
        "else",
        "false",
        "fetchTarball",
        "fetchTree",
        "fetchGit",
        "import",
        "in",
        "inherit",
        "let",
        "lib",
        "licenses",
        "isNull",
        "maintainers",
        "map",
        "name",
        "null",
        "or",
        "pathExists",
        "placeholder",
        "pkgs",
        "readFile",
        "removeAttrs",
        "rec",
        "scopedImport",
        "sourceRoot",
        "src",
        "storePath",
        "then",
        "throw",
        "toString",
        "trace",
        "true",
        "types",
        "with",
        "zenRuntime",
    )
)


def validate(document: Document) -> None:
    _validate_statements(
        document.statements,
        document.kind,
        variables=frozenset(),
        freeforms=frozenset(),
        direct_variables=frozenset(),
        action_context=False,
        top_level=True,
        in_meta=False,
        in_deps=False,
    )
    _validate_executable_names(document.statements, lexical=frozenset(), package_scope=False)
    _validate_boolean_contexts(document)
    if document.kind is FileKind.ZMDL:
        _validate_zmdl_freeform_declarations(tuple(_effective_statements(document)))


def validate_document_contract(document: Document) -> None:
    if document.kind is FileKind.ZPKG:
        _validate_zpkg_declaration(tuple(_effective_statements(document)), document.span)


def _validate_zpkg_declaration(
    statements: tuple[Statement, ...], document_span: object
) -> None:
    package_imports = [
        statement
        for statement in statements
        if isinstance(statement, PackageImportStatement)
    ]
    if len(package_imports) != 1:
        span = statements[-1].span if statements else document_span
        raise ZenLangError(
            Diagnostic(
                "ZEN222",
                "a ZPKG requires exactly one import $pkgs.legacy.<path> statement",
                span,
            )
        )
    metadata_blocks: list[AttrSet] = []
    for statement in statements:
        if isinstance(statement, (PackageImportStatement, LetStatement, ResolvedImport)):
            continue
        if not isinstance(statement, Assignment) or _target_names(statement) != ("_meta",):
            raise ZenLangError(
                Diagnostic(
                    "ZEN222",
                    "ZPKG top-level assignments are limited to one _meta block",
                    statement.span,
                )
            )
        if not isinstance(statement.value, AttrSet):
            raise ZenLangError(
                Diagnostic("ZEN222", "ZPKG _meta must be an attribute set", statement.value.span)
            )
        metadata_blocks.append(statement.value)
    if len(metadata_blocks) != 1:
        raise ZenLangError(
            Diagnostic("ZEN222", "a ZPKG requires exactly one _meta block", document_span)
        )

    fields = {
        _target_names(statement)[0]: statement
        for statement in metadata_blocks[0].statements
        if isinstance(statement, Assignment) and len(_target_names(statement)) == 1
    }
    allowed = {
        "_name",
        "_summary",
        "_description",
        "_zenosVersion",
        "_packageVersion",
        "_tags",
        "_maintainers",
        "_dependencies",
    }
    required = allowed - {"_packageVersion"}
    if set(fields) - allowed:
        field = fields[sorted(set(fields) - allowed)[0]]
        raise ZenLangError(
            Diagnostic("ZEN222", "unknown ZPKG metadata field", field.span)
        )
    missing = sorted(required - set(fields))
    if missing:
        raise ZenLangError(
            Diagnostic(
                "ZEN222",
                "missing ZPKG metadata fields: " + ", ".join(missing),
                metadata_blocks[0].span,
            )
        )
    dependencies = fields["_dependencies"].value
    if not isinstance(dependencies, AttrSet):
        raise ZenLangError(
            Diagnostic("ZEN222", "_dependencies must be an attribute set", dependencies.span)
        )
    scopes = {
        _target_names(statement)[0]
        for statement in dependencies.statements
        if isinstance(statement, Assignment) and len(_target_names(statement)) == 1
    }
    if scopes != {"_general", "_build", "_runtime"}:
        raise ZenLangError(
            Diagnostic(
                "ZEN222",
                "_dependencies requires _general, _build, and _runtime",
                dependencies.span,
            )
        )

    package = package_imports[0].package
    package_path = _variable_static_path(package)
    if package.name != "pkgs" or package_path is None or len(package_path) < 2 or package_path[0] != "legacy":
        raise ZenLangError(
            Diagnostic(
                "ZEN222",
                "a ZPKG package import must use $pkgs.legacy.<path>",
                package.span,
            )
        )


def _validate_zmdl_freeform_declarations(statements: tuple[Statement, ...]) -> None:
    declarations: dict[tuple[str, ...], list[tuple[str, AttrSet, StructuralMarker]]] = {}

    def collect(current: tuple[Statement, ...], prefix: tuple[str, ...]) -> None:
        for statement in current:
            if not isinstance(statement, Assignment):
                continue
            body = _option_value_body(statement.value)
            if isinstance(statement.target, StructuralMarker):
                if statement.target.kind != "freeform" or body is None:
                    continue
                identifier = _freeform_name(statement.target)
                if identifier is None:
                    continue
                declarations.setdefault(prefix, []).append(
                    (identifier, body, statement.target)
                )
                collect(body.statements, (*prefix, "{freeform:" + identifier + "}"))
                continue
            if body is not None:
                names = _target_names(statement)
                if names:
                    collect(body.statements, (*prefix, *names))

    collect(statements, ())
    for entries in declarations.values():
        first_identifier = entries[0][0]
        for identifier, _body, marker in entries[1:]:
            if identifier != first_identifier:
                raise ZenLangError(
                    Diagnostic(
                        "ZEN221",
                        "a scope cannot declare incompatible freeform identifiers",
                        marker.span,
                    )
                )
        merged = tuple(
            child
            for _identifier, body, _marker in entries
            for child in body.statements
        )
        conditional = next(
            (
                child
                for child in merged
                if isinstance(child, ActionStatement) and not child.unconditional
            ),
            None,
        )
        if conditional is not None and not _freeform_body_declares_boolean_item(merged):
            raise ZenLangError(
                Diagnostic(
                    "ZEN217",
                    "conditional freeform actions require boolean item type",
                    conditional.span,
                )
            )


def _option_value_body(value: Expression) -> AttrSet | None:
    if isinstance(value, EnableOption):
        return value.body
    if isinstance(value, AttrSet):
        return value
    return None


def _freeform_body_declares_boolean_item(
    statements: tuple[Statement, ...],
) -> bool:
    item_types: list[str] = []
    for statement in statements:
        if not isinstance(statement, Assignment):
            continue
        names = _target_names(statement)
        if names in (("_meta", "type"), ("_meta", "_type")):
            item_types.append(_annotation_type(statement.value))
        elif names == ("_meta",) and isinstance(statement.value, AttrSet):
            for field in statement.value.statements:
                if (
                    isinstance(field, Assignment)
                    and _target_names(field) in (("type",), ("_type",))
                ):
                    item_types.append(_annotation_type(field.value))
    if not item_types or any(item_type != "bool" for item_type in item_types):
        return False
    return not any(
        isinstance(statement, Assignment)
        and (
            isinstance(statement.target, StructuralMarker)
            and statement.target.kind == "freeform"
            or not isinstance(statement.target, StructuralMarker)
            and (names := _target_names(statement))
            and names[0] != "_meta"
        )
        for statement in statements
    )


def validate_import_merges(document: Document) -> None:
    effective: list[Statement] = []
    for statement in document.statements:
        if isinstance(statement, ResolvedImport) and statement.binding is None:
            effective.extend(_effective_statements(statement.document))
        else:
            effective.append(statement)
    bindings: dict[str, Statement] = {}
    for statement in effective:
        name = _statement_binding(statement)
        if name is None:
            continue
        if name in bindings:
            raise ZenLangError(
                Diagnostic(
                    "ZEN218",
                    f"imported lexical binding {name!r} collides with another declaration",
                    statement.span,
                )
            )
        bindings[name] = statement
    leaves: dict[tuple[str, ...], Expression] = {}

    def visit(statements: tuple[Statement, ...] | list[Statement], prefix: tuple[str, ...]) -> None:
        for statement in statements:
            if isinstance(statement, ConditionalStatement):
                visit(statement.body.statements, prefix)
                continue
            if not isinstance(statement, Assignment) or statement.operator != "=":
                continue
            if isinstance(statement.target, StructuralMarker):
                if (
                    statement.target.kind == "freeform"
                    and isinstance(statement.value, AttrSet)
                ):
                    identifier = _freeform_name(statement.target)
                    if identifier is not None:
                        visit(
                            statement.value.statements,
                            (*prefix, "{freeform:" + identifier + "}"),
                        )
                continue
            names = _target_names(statement)
            if not names:
                continue
            path = (*prefix, *names)
            if isinstance(statement.value, AttrSet) and statement.value.statements:
                visit(statement.value.statements, path)
                continue
            conflict = next(
                (
                    existing
                    for existing in leaves
                    if existing != path
                    and (
                        existing[: len(path)] == path
                        or path[: len(existing)] == existing
                    )
                ),
                None,
            )
            if conflict is not None:
                if isinstance(statement.value, AttrSet):
                    continue
                if isinstance(leaves[conflict], AttrSet):
                    del leaves[conflict]
                    conflict = None
            if conflict is not None:
                raise ZenLangError(
                    Diagnostic(
                        "ZEN218",
                        f"incompatible merged assignment at {'.'.join(path)}",
                        statement.span,
                    )
                )
            previous = leaves.get(path)
            if previous is not None and not _merge_compatible(previous, statement.value):
                raise ZenLangError(
                    Diagnostic(
                        "ZEN218",
                        f"incompatible merged assignment at {'.'.join(path)}",
                        statement.span,
                    )
                )
            leaves[path] = statement.value

    visit(effective, ())


def _effective_statements(document: Document) -> list[Statement]:
    imported: list[Statement] = []
    local: list[Statement] = []
    for statement in document.statements:
        if isinstance(statement, ResolvedImport) and statement.binding is None:
            imported.extend(_effective_statements(statement.document))
        else:
            local.append(statement)
    return [*imported, *local]


def _merge_compatible(left: Expression, right: Expression) -> bool:
    if type(left) is not type(right):
        return False
    if isinstance(left, Literal) and isinstance(right, Literal):
        return left.kind == right.kind or {
            left.kind,
            right.kind,
        } <= {"true", "false"}
    if (
        isinstance(left, Variable)
        and isinstance(right, Variable)
        and left.name == right.name == "type"
    ):
        return _variable_static_path(left) == _variable_static_path(right)
    return True


def _variable_static_path(variable: Variable) -> tuple[str, ...] | None:
    values: list[str] = []
    for segment in variable.path:
        if isinstance(segment, IdentifierSegment):
            values.append(segment.name)
        elif isinstance(segment, StringSegment):
            values.append(segment.value)
        else:
            return None
    return tuple(values)


def _validate_statements(
    statements: tuple[Statement, ...],
    kind: FileKind,
    *,
    variables: frozenset[str],
    freeforms: frozenset[str],
    direct_variables: frozenset[str],
    action_context: bool,
    top_level: bool,
    in_meta: bool,
    in_deps: bool,
) -> None:
    visible = set(variables)
    for statement in statements:
        if top_level and not isinstance(statement, _ALLOWED_TOP_LEVEL[kind]):
            _reject_statement(statement, kind)
        _validate_statement(
            statement,
            kind,
            variables=frozenset(visible),
            freeforms=freeforms,
            direct_variables=direct_variables,
            action_context=action_context,
            top_level=top_level,
            in_meta=in_meta,
            in_deps=in_deps,
        )
        binding = _statement_binding(statement)
        if binding is not None:
            if binding in visible:
                raise ZenLangError(
                    Diagnostic("ZEN208", f"local variable {binding!r} is already defined in this scope", statement.span)
                )
            visible.add(binding)


def _validate_statement(
    statement: Statement,
    kind: FileKind,
    *,
    variables: frozenset[str],
    freeforms: frozenset[str],
    direct_variables: frozenset[str],
    action_context: bool,
    top_level: bool = False,
    in_meta: bool = False,
    in_deps: bool = False,
) -> None:
    context = (kind, variables, freeforms, direct_variables)
    if isinstance(statement, ActionStatement):
        if kind is not FileKind.ZMDL:
            _reject_statement(statement, kind)
        if not action_context:
            raise ZenLangError(
                Diagnostic(
                    "ZEN203",
                    "actions are only valid directly inside top-level ZMDL option values",
                    statement.span,
                )
            )
        for guard in statement.guards:
            _validate_expression(guard, *context)
            _require_boolean(guard, "action guard")
        _validate_attr_set(statement.body, *context, action_context=False, in_meta=False, in_deps=False)
        return

    if isinstance(statement, ConditionalStatement):
        if kind is not FileKind.ZCFG:
            _reject_statement(statement, kind)
        _validate_expression(statement.condition, *context)
        _require_boolean(statement.condition, "configuration condition")
        _validate_attr_set(statement.body, *context, action_context=False, in_meta=False, in_deps=False)
        return

    if isinstance(statement, Assignment):
        if statement.operator != "=" and (kind is not FileKind.ZPKG or not in_deps):
            raise ZenLangError(
                Diagnostic(
                    "ZEN207",
                    "'++' and '--' assignment operations are only valid in ZPKG dependency cascades",
                    statement.span,
                )
            )
        if in_deps and not isinstance(statement.value, ListExpr):
            raise ZenLangError(
                Diagnostic("ZEN207", "dependency cascade operations require list values", statement.value.span)
            )
        target_freeforms = freeforms
        if isinstance(statement.target, StructuralMarker):
            _validate_marker(statement.target, kind, variables, freeforms, direct_variables)
            introduced = _freeform_name(statement.target)
            if introduced is not None:
                target_freeforms = freeforms | {introduced}
        else:
            for segment in statement.target:
                _validate_segment(segment, *context)

        target_names = _target_names(statement)
        metadata = in_meta or "_meta" in target_names
        if metadata and kind is FileKind.ZPKG:
            metadata_names = target_names
            if "_meta" in metadata_names:
                metadata_names = metadata_names[metadata_names.index("_meta") + 1 :]
            if any(not name.startswith("_") for name in metadata_names):
                raise ZenLangError(
                    Diagnostic(
                        "ZEN223",
                        "metadata fields must start with '_'",
                        statement.span,
                    )
                )
        dependency_set = (
            kind is FileKind.ZPKG
            and metadata
            and bool(target_names)
            and target_names[-1] == "deps"
            and isinstance(statement.value, AttrSet)
        )
        if in_deps:
            _validate_dependency_assignment(statement)
        if metadata and target_names and target_names[-1] == "_zenosVersion":
            _validate_zenos_version(statement.value)

        is_option = (
            kind is FileKind.ZMDL
            and (top_level or action_context)
            and bool(target_names)
            and "_meta" not in target_names
        )
        freeform_option = False
        if isinstance(statement.target, StructuralMarker):
            freeform_option = (
                kind is FileKind.ZMDL
                and (top_level or action_context)
                and statement.target.kind == "freeform"
            )
            is_option = freeform_option
        if freeform_option and not isinstance(statement.value, AttrSet):
            raise ZenLangError(
                Diagnostic(
                    "ZEN221",
                    "a ZMDL freeform value must be an attribute set",
                    statement.value.span,
                )
            )
        _validate_assignment_value(
            statement.value,
            kind,
            variables,
            target_freeforms,
            direct_variables,
            direct_action_container=is_option,
            freeform_action_container=freeform_option,
            in_meta=metadata,
            in_deps=dependency_set,
        )
        return

    if isinstance(statement, LetStatement):
        _reject_reserved_binding(statement.name, statement.span)
        _validate_type_annotation(statement.annotation, kind, variables, freeforms, direct_variables)
        _validate_expression(statement.value, *context)
        return

    if isinstance(statement, ImportStatement):
        if not top_level:
            raise ZenLangError(
                Diagnostic("ZEN202", "imports are only valid at document scope", statement.span)
            )
        if statement.annotation is not None:
            _validate_type_annotation(statement.annotation, kind, variables, freeforms, direct_variables)
        if statement.binding is not None:
            _reject_reserved_binding(statement.binding, statement.span)
        _validate_expression(statement.path, *context)
        return

    if isinstance(statement, ResolvedImport):
        if not top_level:
            raise ZenLangError(
                Diagnostic("ZEN202", "imports are only valid at document scope", statement.span)
            )
        if statement.annotation is not None:
            _validate_type_annotation(statement.annotation, kind, variables, freeforms, direct_variables)
        if statement.binding is not None:
            _reject_reserved_binding(statement.binding, statement.span)
        return

    if isinstance(statement, PackageImportStatement):
        if kind is not FileKind.ZPKG or not top_level:
            _reject_statement(statement, kind)
        _validate_expression(statement.package, *context)
        return

    if isinstance(statement, InheritStatement):
        if top_level:
            _reject_statement(statement, kind)
        if statement.source is not None:
            _validate_expression(statement.source, *context)
        for name in statement.names:
            _reject_reserved_binding(name, statement.span)


def _validate_assignment_value(
    value: Expression,
    kind: FileKind,
    variables: frozenset[str],
    freeforms: frozenset[str],
    direct_variables: frozenset[str],
    *,
    direct_action_container: bool,
    freeform_action_container: bool,
    in_meta: bool,
    in_deps: bool,
) -> None:
    if isinstance(value, EnableOption):
        if kind is not FileKind.ZMDL:
            raise ZenLangError(Diagnostic("ZEN205", "enableOption is only valid in ZMDL", value.span))
        if not direct_action_container:
            raise ZenLangError(
                Diagnostic(
                    "ZEN206",
                    "enableOption is only valid as a direct top-level ZMDL option value",
                    value.span,
                )
            )
        _validate_attr_set(
            value.body,
            kind,
            variables,
            freeforms,
            direct_variables,
            action_context=True,
            in_meta=False,
            in_deps=False,
        )
    elif isinstance(value, AttrSet):
        if direct_action_container and not freeform_action_container and any(
            isinstance(statement, ActionStatement) and not statement.unconditional
            for statement in value.statements
        ) and not _attr_set_declares_boolean(value):
            raise ZenLangError(
                Diagnostic(
                    "ZEN217",
                    "conditional actions require a boolean option type or enableOption",
                    value.span,
                )
            )
        _validate_attr_set(
            value,
            kind,
            variables,
            freeforms,
            direct_variables,
            action_context=direct_action_container,
            in_meta=in_meta,
            in_deps=in_deps,
        )
    else:
        _validate_expression(value, kind, variables, freeforms, direct_variables)


def _validate_attr_set(
    attr_set: AttrSet,
    kind: FileKind,
    variables: frozenset[str],
    freeforms: frozenset[str],
    direct_variables: frozenset[str],
    *,
    action_context: bool,
    in_meta: bool,
    in_deps: bool,
) -> None:
    if in_deps:
        _validate_dependency_operations(attr_set)
    _validate_statements(
        attr_set.statements,
        kind,
        variables=variables,
        freeforms=freeforms,
        direct_variables=direct_variables,
        action_context=action_context,
        top_level=False,
        in_meta=in_meta,
        in_deps=in_deps,
    )


def _validate_expression(
    expression: Expression,
    kind: FileKind,
    variables: frozenset[str],
    freeforms: frozenset[str],
    direct_variables: frozenset[str],
) -> None:
    context = (kind, variables, freeforms, direct_variables)
    if kind is FileKind.ZCFG:
        _validate_zcfg_expression_form(expression)

    if isinstance(expression, Variable):
        _validate_variable(expression, *context)
    elif isinstance(expression, Reference):
        for segment in expression.path:
            _validate_segment(segment, *context)
    elif isinstance(expression, GroupExpr):
        _validate_expression(expression.value, *context)
    elif isinstance(expression, StructuralMarker):
        _validate_marker(expression, kind, variables, freeforms, direct_variables)
        if kind is FileKind.ZMDL:
            raise ZenLangError(
                Diagnostic(
                    "ZEN204",
                    "ZMDL structural markers are supported only as assignment targets",
                    expression.span,
                )
            )
    elif isinstance(expression, StringExpr):
        for part in expression.parts:
            if isinstance(part, Interpolation):
                if not _is_scalar_compatible(part.expression):
                    raise ZenLangError(
                        Diagnostic("ZEN212", "string interpolation requires a scalar-compatible expression", part.span)
                    )
                _validate_expression(part.expression, *context)
    elif isinstance(expression, ListExpr):
        for item in expression.items:
            _validate_expression(item, *context)
    elif isinstance(expression, AttrSet):
        _validate_attr_set(expression, *context, action_context=False, in_meta=False, in_deps=False)
    elif isinstance(expression, EnableOption):
        raise ZenLangError(
            Diagnostic(
                "ZEN206",
                "enableOption is only valid as a direct top-level ZMDL option value",
                expression.span,
            )
        )
    elif isinstance(expression, UnaryExpr):
        _validate_expression(expression.operand, *context)
        if expression.operator == "!":
            _require_boolean(expression.operand, "operand of '!'")
    elif isinstance(expression, BinaryExpr):
        _validate_expression(expression.left, *context)
        _validate_expression(expression.right, *context)
        if expression.operator in ("&&", "||"):
            _require_boolean(expression.left, f"left operand of {expression.operator!r}")
            _require_boolean(expression.right, f"right operand of {expression.operator!r}")
    elif isinstance(expression, SelectionExpr):
        _validate_expression(expression.value, *context)
        _validate_segment(expression.segment, *context)
    elif isinstance(expression, DefaultExpr):
        _validate_expression(expression.value, *context)
        _validate_expression(expression.default, *context)
    elif isinstance(expression, CallExpr):
        _validate_expression(expression.callee, *context)
        for argument in expression.arguments:
            _validate_expression(argument, *context)
    elif isinstance(expression, IfExpr):
        _validate_expression(expression.condition, *context)
        _require_boolean(expression.condition, "conditional expression")
        _validate_expression(expression.then_value, *context)
        _validate_expression(expression.else_value, *context)
    elif isinstance(expression, LetExpr):
        _validate_statements(
            expression.statements,
            kind,
            variables=variables,
            freeforms=freeforms,
            direct_variables=direct_variables,
            action_context=False,
            top_level=False,
            in_meta=False,
            in_deps=False,
        )
        local_names = variables | {
            binding
            for statement in expression.statements
            if (binding := _statement_binding(statement)) is not None
        }
        _validate_expression(expression.body, kind, local_names, freeforms, direct_variables)
    elif isinstance(expression, WithExpr):
        _validate_expression(expression.scope, *context)
        _validate_expression(expression.body, *context)
    elif isinstance(expression, LambdaExpr):
        for parameter in expression.parameters:
            if parameter.name is not None:
                _reject_reserved_binding(parameter.name, parameter.span)
        if expression.form == "variable" and any(
            parameter.name in _BUILTIN_VARIABLES[kind]
            for parameter in expression.parameters
            if parameter.name is not None
        ):
            raise ZenLangError(
                Diagnostic(
                    "ZEN208",
                    "variable lambda parameters cannot shadow DSL namespaces",
                    expression.span,
                )
            )
        for parameter in expression.parameters:
            if parameter.default is not None:
                _validate_expression(parameter.default, *context)
        lambda_variables = direct_variables
        if expression.form == "variable":
            lambda_variables |= {
                parameter.name for parameter in expression.parameters if parameter.name is not None
            }
        _validate_expression(expression.body, kind, variables, freeforms, lambda_variables)


def _validate_zcfg_expression_form(expression: Expression) -> None:
    if isinstance(expression, (CallExpr, LambdaExpr, WithExpr, LetExpr, IfExpr, Reference, StructuralMarker, EnableOption)):
        raise ZenLangError(
            Diagnostic(
                "ZEN211",
                f"{type(expression).__name__} expressions are not allowed in ZCFG",
                expression.span,
            )
        )
    if isinstance(expression, BinaryExpr) and expression.operator not in _ZCFG_BINARY:
        raise ZenLangError(
            Diagnostic(
                "ZEN211",
                f"operator {expression.operator!r} is not allowed in ZCFG expressions",
                expression.span,
            )
        )
    if isinstance(expression, UnaryExpr) and expression.operator not in ("!", "-"):
        raise ZenLangError(
            Diagnostic("ZEN211", f"operator {expression.operator!r} is not allowed in ZCFG expressions", expression.span)
        )
    if isinstance(expression, UnaryExpr) and expression.operator == "-" and not (
        isinstance(expression.operand, Literal) and expression.operand.kind in ("integer", "float")
    ):
        raise ZenLangError(
            Diagnostic("ZEN211", "ZCFG unary '-' is only valid on numeric literals", expression.span)
        )


def _validate_variable(
    variable: Variable,
    kind: FileKind,
    variables: frozenset[str],
    freeforms: frozenset[str],
    direct_variables: frozenset[str],
) -> None:
    if variable.name in direct_variables:
        return
    if variable.name not in _BUILTIN_VARIABLES[kind]:
        raise ZenLangError(
            Diagnostic(
                "ZEN208",
                f"variable ${variable.name} is not available in {kind.value.upper()} files",
                variable.span,
            )
        )
    if variable.name == "v":
        name = _first_path_name(variable)
        if name is None or name not in variables:
            label = "$v" if name is None else f"$v.{name}"
            raise ZenLangError(Diagnostic("ZEN208", f"undefined local variable {label}", variable.span))
    if variable.name == "f":
        name = _first_path_name(variable)
        if name is None or name not in freeforms:
            label = "$f" if name is None else f"$f.{name}"
            raise ZenLangError(Diagnostic("ZEN208", f"undefined freeform variable {label}", variable.span))
    if variable.name == "name" and variable.path:
        raise ZenLangError(Diagnostic("ZEN208", "$name is a scalar source identity", variable.span))
    for segment in variable.path:
        if isinstance(segment, DynamicSegment):
            _validate_variable(segment.value, kind, variables, freeforms, direct_variables)


def _validate_segment(
    segment: object,
    kind: FileKind,
    variables: frozenset[str],
    freeforms: frozenset[str],
    direct_variables: frozenset[str],
) -> None:
    if isinstance(segment, DynamicSegment):
        _validate_variable(segment.value, kind, variables, freeforms, direct_variables)


def _validate_type_annotation(
    annotation: Expression,
    kind: FileKind,
    variables: frozenset[str],
    freeforms: frozenset[str],
    direct_variables: frozenset[str],
) -> None:
    if isinstance(annotation, GroupExpr):
        _validate_type_annotation(annotation.value, kind, variables, freeforms, direct_variables)
        return
    call: CallExpr | None = annotation if isinstance(annotation, CallExpr) else None
    root = call.callee if call is not None else annotation
    if not isinstance(root, Variable) or root.name != "type" or len(root.path) != 1 or not isinstance(root.path[0], IdentifierSegment):
        raise ZenLangError(Diagnostic("ZEN209", "type annotations must be rooted at $type", annotation.span))
    type_name = root.path[0].name
    arguments = call.arguments if call is not None else ()
    if type_name in _PARAMETERIZED_TYPES and not arguments:
        raise ZenLangError(
            Diagnostic("ZEN209", f"$type.{type_name} requires a type parameter", annotation.span)
        )
    if call is not None and isinstance(call.callee, CallExpr):
        raise ZenLangError(Diagnostic("ZEN209", "invalid nested type application", annotation.span))

    if type_name in ("list", "set", "functionTo"):
        parameter = _single_list_parameter(type_name, arguments, annotation)
        _validate_type_annotation(parameter, kind, variables, freeforms, direct_variables)
    elif type_name == "either":
        parameter_list = _parameter_list(type_name, arguments, annotation)
        if len(parameter_list.items) < 2:
            raise ZenLangError(Diagnostic("ZEN209", "$type.either requires at least two type parameters", annotation.span))
        for item in parameter_list.items:
            _validate_type_annotation(item, kind, variables, freeforms, direct_variables)
    elif type_name == "enum":
        parameter_list = _parameter_list(type_name, arguments, annotation)
        if not parameter_list.items or any(not _is_plain_string(item) for item in parameter_list.items):
            raise ZenLangError(Diagnostic("ZEN209", "$type.enum requires one or more string values", annotation.span))
    elif type_name == "function":
        if not arguments:
            raise ZenLangError(Diagnostic("ZEN209", "$type.function requires parameters", annotation.span))
        for argument in arguments:
            _validate_expression(argument, kind, variables, freeforms, direct_variables)
    elif arguments:
        raise ZenLangError(Diagnostic("ZEN209", f"$type.{type_name} does not accept parameters", annotation.span))


def _single_list_parameter(type_name: str, arguments: tuple[Expression, ...], annotation: Expression) -> Expression:
    parameter_list = _parameter_list(type_name, arguments, annotation)
    if len(parameter_list.items) != 1:
        raise ZenLangError(
            Diagnostic("ZEN209", f"$type.{type_name} requires exactly one type parameter", annotation.span)
        )
    return parameter_list.items[0]


def _parameter_list(type_name: str, arguments: tuple[Expression, ...], annotation: Expression) -> ListExpr:
    if len(arguments) != 1 or not isinstance(arguments[0], ListExpr):
        raise ZenLangError(
            Diagnostic("ZEN209", f"$type.{type_name} parameters must be enclosed in brackets", annotation.span)
        )
    return arguments[0]


def _validate_marker(
    marker: StructuralMarker,
    kind: FileKind,
    variables: frozenset[str],
    freeforms: frozenset[str],
    direct_variables: frozenset[str],
) -> None:
    allowed = {
        FileKind.ZCFG: frozenset(),
        FileKind.ZPKG: frozenset(),
        FileKind.ZMDL: frozenset(("freeform", "alias")),
        FileKind.ZSTR: frozenset(("freeform", "alias", "packages", "programs")),
    }[kind]
    if marker.kind not in allowed:
        raise ZenLangError(
            Diagnostic(
                "ZEN204",
                f"({marker.kind}) structural markers are not allowed in {kind.value.upper()} files",
                marker.span,
            )
        )
    if kind is FileKind.ZMDL and marker.kind == "freeform" and (
        marker.argument is None
        or len(marker.argument) != 1
        or not isinstance(marker.argument[0], IdentifierSegment)
    ):
        raise ZenLangError(
            Diagnostic(
                "ZEN221",
                "a ZMDL freeform marker requires exactly one identifier",
                marker.span,
            )
        )
    for segment in marker.argument or ():
        _validate_segment(segment, kind, variables, freeforms, direct_variables)


def _require_boolean(expression: Expression, label: str) -> None:
    if not _is_boolean_compatible(expression):
        raise ZenLangError(
            Diagnostic("ZEN210", f"{label} must be boolean-compatible", expression.span)
        )


def _is_boolean_compatible(expression: Expression) -> bool:
    if isinstance(expression, GroupExpr):
        return _is_boolean_compatible(expression.value)
    if isinstance(expression, Literal):
        return expression.kind in ("true", "false")
    if isinstance(expression, UnaryExpr):
        return expression.operator == "!" and _is_boolean_compatible(expression.operand)
    if isinstance(expression, BinaryExpr):
        if expression.operator in ("&&", "||"):
            return _is_boolean_compatible(expression.left) and _is_boolean_compatible(expression.right)
        return expression.operator in _BOOLEAN_BINARY
    if isinstance(expression, IfExpr):
        return _is_boolean_compatible(expression.then_value) and _is_boolean_compatible(expression.else_value)
    return isinstance(expression, (Variable, Reference, SelectionExpr, DefaultExpr, CallExpr))


def _is_scalar_compatible(expression: Expression) -> bool:
    if isinstance(expression, GroupExpr):
        return _is_scalar_compatible(expression.value)
    if isinstance(expression, Literal):
        return expression.value is not None
    if isinstance(expression, BinaryExpr):
        return expression.operator not in ("++", "//")
    if isinstance(expression, (StringExpr, PathExpr, Variable, Reference, SelectionExpr, DefaultExpr, CallExpr, UnaryExpr)):
        return True
    if isinstance(expression, IfExpr):
        return _is_scalar_compatible(expression.then_value) and _is_scalar_compatible(expression.else_value)
    return False


def _validate_zenos_version(value: Expression) -> None:
    candidate: str | None = None
    if isinstance(value, Literal) and value.kind == "version":
        candidate = str(value.value)
    elif _is_plain_string(value):
        candidate = "".join(part.value for part in value.parts if isinstance(part, StringText))
    if candidate is None or not _ZENOS_VERSION.fullmatch(candidate):
        raise ZenLangError(
            Diagnostic("ZEN213", "zenosVersion must match X.Y.Z[VARIANT][a|b|l]", value.span)
        )


def _is_plain_string(expression: Expression) -> bool:
    return isinstance(expression, StringExpr) and all(isinstance(part, StringText) for part in expression.parts)


def _attr_set_declares_boolean(value: AttrSet) -> bool:
    for statement in value.statements:
        if not isinstance(statement, Assignment):
            continue
        names = _target_names(statement)
        annotation = statement.value
        if names == ("_meta",) and isinstance(annotation, AttrSet):
            if _attr_set_metadata_type_is_boolean(annotation):
                return True
            continue
        if names not in (("_meta", "type"), ("_meta", "_type")):
            continue
        return (
            isinstance(annotation, Variable)
            and annotation.name == "type"
            and len(annotation.path) == 1
            and isinstance(annotation.path[0], IdentifierSegment)
            and annotation.path[0].name in ("bool", "boolean")
        )
    return False


def _attr_set_metadata_type_is_boolean(value: AttrSet) -> bool:
    for statement in value.statements:
        if isinstance(statement, Assignment) and _target_names(statement) in (("type",), ("_type",)):
            annotation = statement.value
            return (
                isinstance(annotation, Variable)
                and annotation.name == "type"
                and len(annotation.path) == 1
                and isinstance(annotation.path[0], IdentifierSegment)
                and annotation.path[0].name in ("bool", "boolean")
            )
    return False


def _statement_binding(statement: Statement) -> str | None:
    if isinstance(statement, LetStatement):
        return statement.name
    if isinstance(statement, ImportStatement):
        return statement.binding
    if isinstance(statement, ResolvedImport):
        return statement.binding
    return None


def _validate_dependency_assignment(statement: Assignment) -> None:
    names = _target_names(statement)
    if len(names) != 1 or names[0] not in ("global", "build", "run", "export"):
        raise ZenLangError(
            Diagnostic(
                "ZEN215",
                "dependency scopes must be global, build, run, or export",
                statement.span,
            )
        )
    if not isinstance(statement.value, ListExpr):
        return
    for item in statement.value.items:
        _dependency_identity(item)


def _dependency_identity(expression: Expression) -> tuple[str, ...]:
    candidate = expression
    if isinstance(candidate, GroupExpr):
        candidate = candidate.value
    if isinstance(candidate, Variable):
        if (
            candidate.name == "pkgs"
            and len(candidate.path) >= 2
            and isinstance(candidate.path[0], IdentifierSegment)
            and candidate.path[0].name == "zenos"
            and all(isinstance(part, (IdentifierSegment, StringSegment)) for part in candidate.path)
        ):
            return tuple(
                part.name if isinstance(part, IdentifierSegment) else part.value
                for part in candidate.path
            )
    if isinstance(candidate, AttrSet):
        fields: dict[str, Expression] = {}
        for statement in candidate.statements:
            if not isinstance(statement, Assignment) or statement.operator != "=":
                break
            names = _target_names(statement)
            if len(names) != 1 or names[0] in fields:
                break
            fields[names[0]] = statement.value
        else:
            if set(fields) <= {"id", "minVersion"} and "id" in fields:
                identity = _dependency_identity(fields["id"])
                if "minVersion" in fields and not _is_plain_string(fields["minVersion"]):
                    raise ZenLangError(
                        Diagnostic("ZEN215", "dependency minVersion must be a plain string", fields["minVersion"].span)
                    )
                return identity
    raise ZenLangError(
        Diagnostic(
            "ZEN215",
            "dependencies must be $pkgs.zenos.<path> references or { id = ...; minVersion = \"...\"; } records",
            expression.span,
        )
    )


def _dependency_record(expression: Expression) -> tuple[tuple[str, ...], str | None, Expression]:
    candidate = expression.value if isinstance(expression, GroupExpr) else expression
    identity = _dependency_identity(candidate)
    minimum: str | None = None
    if isinstance(candidate, AttrSet):
        for statement in candidate.statements:
            if isinstance(statement, Assignment) and _target_names(statement) == ("minVersion",):
                value = statement.value
                if isinstance(value, StringExpr):
                    minimum = "".join(part.value for part in value.parts if isinstance(part, StringText))
    return identity, minimum, expression


def _validate_dependency_operations(value: AttrSet) -> None:
    operations: dict[str, list[Assignment]] = {
        "global": [],
        "build": [],
        "run": [],
        "export": [],
    }
    for statement in value.statements:
        if not isinstance(statement, Assignment):
            continue
        names = _target_names(statement)
        if len(names) == 1 and names[0] in operations:
            operations[names[0]].append(statement)

    def apply(initial: list[tuple[tuple[str, ...], str | None, Expression]], items: list[Assignment]):
        result = list(initial)
        for statement in items:
            if not isinstance(statement.value, ListExpr):
                continue
            records = [_dependency_record(item) for item in statement.value.items]
            if statement.operator == "=":
                result = []
            for identity, minimum, expression in records:
                existing = next((item for item in result if item[0] == identity), None)
                if statement.operator == "--":
                    if existing is None:
                        raise ZenLangError(
                            Diagnostic(
                                "ZEN215",
                                "cannot remove absent dependency " + ".".join(("$pkgs", *identity)),
                                expression.span,
                            )
                        )
                    result.remove(existing)
                elif existing is None:
                    result.append((identity, minimum, expression))
                elif existing[1] != minimum:
                    raise ZenLangError(
                        Diagnostic(
                            "ZEN215",
                            "conflicting duplicate dependency " + ".".join(("$pkgs", *identity)),
                            expression.span,
                        )
                    )
        return result

    global_dependencies = apply([], operations["global"])
    all_dependencies = list(global_dependencies)
    for scope in ("build", "run", "export"):
        all_dependencies.extend(apply(global_dependencies, operations[scope]))
    short_names: dict[str, tuple[str, ...]] = {}
    for identity, _, expression in all_dependencies:
        previous = short_names.get(identity[-1])
        if previous is not None and previous != identity:
            raise ZenLangError(
                Diagnostic(
                    "ZEN215",
                    f"dependency short name {identity[-1]!r} collides",
                    expression.span,
                )
            )
        short_names[identity[-1]] = identity


_FORBIDDEN_REFERENCE_ROOTS = _RESERVED_BINDINGS


def _validate_executable_names(
    statements: tuple[Statement, ...],
    *,
    lexical: frozenset[str],
    package_scope: bool,
) -> None:
    visible = set(lexical)
    for statement in statements:
        current = lexical
        if isinstance(statement, Assignment):
            _validate_expression_names(statement.value, current, package_scope)
        elif isinstance(statement, LetStatement):
            _validate_expression_names(statement.annotation, current, package_scope)
            _validate_expression_names(statement.value, current, package_scope)
            visible.add(statement.name)
        elif isinstance(statement, ImportStatement):
            if statement.annotation is not None:
                _validate_expression_names(statement.annotation, current, package_scope)
        elif isinstance(statement, ResolvedImport):
            if statement.annotation is not None:
                _validate_expression_names(statement.annotation, current, package_scope)
        elif isinstance(statement, ConditionalStatement):
            _validate_expression_names(statement.condition, current, package_scope)
            _validate_executable_names(statement.body.statements, lexical=current, package_scope=package_scope)
        elif isinstance(statement, ActionStatement):
            for guard in statement.guards:
                _validate_expression_names(guard, current, package_scope)
            _validate_executable_names(statement.body.statements, lexical=current, package_scope=package_scope)
        elif isinstance(statement, InheritStatement) and statement.source is not None:
            _validate_expression_names(statement.source, current, package_scope)
        elif isinstance(statement, InheritStatement):
            for name in statement.names:
                if name in _RESERVED_BINDINGS or name not in visible:
                    raise ZenLangError(
                        Diagnostic(
                            "ZEN216",
                            f"source-less inherit requires a declared lexical name, found {name!r}",
                            statement.span,
                        )
                    )


def _validate_expression_names(
    expression: Expression,
    lexical: frozenset[str],
    package_scope: bool,
) -> None:
    if isinstance(expression, Reference):
        root = expression.path[0]
        name = root.name if isinstance(root, IdentifierSegment) else None
        declared = name is not None and name in lexical and name not in _RESERVED_BINDINGS
        package = (
            name is not None
            and package_scope
            and name not in _FORBIDDEN_REFERENCE_ROOTS
        )
        if not (declared or package):
            raise ZenLangError(
                Diagnostic(
                    "ZEN216",
                    f"executable reference {name or '<dynamic>'!r} is not a declared lexical name or package",
                    expression.span,
                )
            )
        return
    if isinstance(expression, GroupExpr):
        _validate_expression_names(expression.value, lexical, package_scope)
    elif isinstance(expression, StringExpr):
        for part in expression.parts:
            if isinstance(part, Interpolation):
                _validate_expression_names(part.expression, lexical, package_scope)
    elif isinstance(expression, ListExpr):
        for item in expression.items:
            _validate_expression_names(item, lexical, package_scope)
    elif isinstance(expression, AttrSet):
        recursive_names = frozenset()
        if expression.recursive:
            recursive_names = frozenset(
                statement.target[0].name
                for statement in expression.statements
                if isinstance(statement, Assignment)
                and not isinstance(statement.target, StructuralMarker)
                and bool(statement.target)
                and isinstance(statement.target[0], IdentifierSegment)
            )
        _validate_executable_names(
            expression.statements,
            lexical=lexical | recursive_names,
            package_scope=package_scope,
        )
    elif isinstance(expression, EnableOption):
        _validate_executable_names(expression.body.statements, lexical=lexical, package_scope=package_scope)
    elif isinstance(expression, UnaryExpr):
        _validate_expression_names(expression.operand, lexical, package_scope)
    elif isinstance(expression, BinaryExpr):
        _validate_expression_names(expression.left, lexical, package_scope)
        _validate_expression_names(expression.right, lexical, package_scope)
    elif isinstance(expression, SelectionExpr):
        _validate_expression_names(expression.value, lexical, package_scope)
    elif isinstance(expression, DefaultExpr):
        _validate_expression_names(expression.value, lexical, package_scope)
        _validate_expression_names(expression.default, lexical, package_scope)
    elif isinstance(expression, CallExpr):
        _validate_expression_names(expression.callee, lexical, package_scope)
        for argument in expression.arguments:
            _validate_expression_names(argument, lexical, package_scope)
    elif isinstance(expression, IfExpr):
        _validate_expression_names(expression.condition, lexical, package_scope)
        _validate_expression_names(expression.then_value, lexical, package_scope)
        _validate_expression_names(expression.else_value, lexical, package_scope)
    elif isinstance(expression, LetExpr):
        names = {
            statement.target[0].name
            for statement in expression.statements
            if isinstance(statement, Assignment)
            and not isinstance(statement.target, StructuralMarker)
            and bool(statement.target)
            and isinstance(statement.target[0], IdentifierSegment)
        }
        for statement in expression.statements:
            if isinstance(statement, Assignment):
                path = _target_names(statement)
                if path:
                    _reject_reserved_binding(path[0], statement.span)
        inner = lexical | names
        _validate_executable_names(expression.statements, lexical=inner, package_scope=package_scope)
        _validate_expression_names(expression.body, inner, package_scope)
    elif isinstance(expression, WithExpr):
        _validate_expression_names(expression.scope, lexical, package_scope)
        if (
            not isinstance(expression.scope, Variable)
            or expression.scope.name != "pkgs"
            or not expression.scope.path
            or not isinstance(expression.scope.path[0], IdentifierSegment)
            or expression.scope.path[0].name != "zenos"
            or any(
                not isinstance(segment, (IdentifierSegment, StringSegment))
                for segment in expression.scope.path
            )
        ):
            raise ZenLangError(
                Diagnostic(
                    "ZEN216",
                    "with expressions require $pkgs.zenos or a static subtree of it",
                    expression.scope.span,
                )
            )
        _validate_expression_names(expression.body, lexical, True)
    elif isinstance(expression, LambdaExpr):
        names = frozenset(
            parameter.name
            for parameter in expression.parameters
            if parameter.name is not None and expression.form != "variable"
        )
        for parameter in expression.parameters:
            if parameter.default is not None:
                _validate_expression_names(parameter.default, lexical | names, package_scope)
        _validate_expression_names(expression.body, lexical | names, package_scope)


def _reject_reserved_binding(name: str, span: object) -> None:
    if name in _RESERVED_BINDINGS or name.startswith(
        ("_zenFreeformKey", "_zenFreeformValue")
    ):
        raise ZenLangError(
            Diagnostic("ZEN219", f"{name!r} is reserved by the compiler backend", span)
        )


def _validate_boolean_contexts(document: Document) -> None:
    statements = tuple(_effective_statements(document))
    option_types: dict[str, str] = {}
    if document.kind is FileKind.ZMDL:
        for statement in statements:
            if not isinstance(statement, Assignment) or isinstance(statement.target, StructuralMarker):
                continue
            names = _target_names(statement)
            if len(names) == 1 and names[0] != "_meta":
                option_types[names[0]] = _option_value_type(statement.value)

    def walk(statements: tuple[Statement, ...], environment: dict[str, str]) -> None:
        visible = dict(environment)
        for statement in statements:
            if isinstance(statement, LetStatement):
                visible[statement.name] = _annotation_type(statement.annotation)
                continue
            if isinstance(statement, ConditionalStatement):
                _require_typed_boolean(statement.condition, visible, option_types, "configuration condition")
                walk(statement.body.statements, visible)
                continue
            if isinstance(statement, ActionStatement):
                for guard in statement.guards:
                    _require_typed_boolean(guard, visible, option_types, "action guard")
                walk(statement.body.statements, visible)
                continue
            if isinstance(statement, Assignment):
                body = (
                    statement.value.body
                    if isinstance(statement.value, EnableOption)
                    else statement.value
                    if isinstance(statement.value, AttrSet)
                    else None
                )
                if body is not None:
                    walk(body.statements, visible)

    walk(statements, {})


def _require_typed_boolean(
    expression: Expression,
    environment: dict[str, str],
    option_types: dict[str, str],
    label: str,
) -> None:
    if _contains_call(expression):
        raise ZenLangError(Diagnostic("ZEN220", f"{label} cannot contain function calls", expression.span))
    if _boolean_type(expression, environment, option_types) != "bool":
        raise ZenLangError(
            Diagnostic(
                "ZEN220",
                f"{label} requires a known boolean type; use 'or false' to mark a deferred $cfg boolean",
                expression.span,
            )
        )


def _boolean_type(
    expression: Expression,
    environment: dict[str, str],
    option_types: dict[str, str],
) -> str:
    if isinstance(expression, GroupExpr):
        return _boolean_type(expression.value, environment, option_types)
    if isinstance(expression, Literal):
        return "bool" if expression.kind in ("true", "false") else "other"
    if isinstance(expression, Variable):
        if expression.name == "v":
            name = _first_path_name(expression)
            return environment.get(name or "", "unknown") if len(expression.path) == 1 else "unknown"
        if expression.name == "path":
            name = _first_path_name(expression)
            return option_types.get(name or "", "unknown") if len(expression.path) == 1 else "unknown"
        return "unknown"
    if isinstance(expression, DefaultExpr):
        default_type = _boolean_type(expression.default, environment, option_types)
        if _is_cfg_selection(expression.value) and default_type == "bool":
            return "bool"
        value_type = _boolean_type(expression.value, environment, option_types)
        return "bool" if value_type == default_type == "bool" else "unknown"
    if isinstance(expression, UnaryExpr):
        return "bool" if expression.operator == "!" and _boolean_type(expression.operand, environment, option_types) == "bool" else "other"
    if isinstance(expression, BinaryExpr):
        if expression.operator in ("&&", "||"):
            return "bool" if (
                _boolean_type(expression.left, environment, option_types) == "bool"
                and _boolean_type(expression.right, environment, option_types) == "bool"
            ) else "unknown"
        if expression.operator in _BOOLEAN_BINARY:
            return "bool"
        return "other"
    if isinstance(expression, IfExpr):
        return "bool" if (
            _boolean_type(expression.condition, environment, option_types) == "bool"
            and _boolean_type(expression.then_value, environment, option_types) == "bool"
            and _boolean_type(expression.else_value, environment, option_types) == "bool"
        ) else "unknown"
    return "unknown"


def _contains_call(expression: Expression) -> bool:
    if isinstance(expression, CallExpr):
        return True
    if isinstance(expression, GroupExpr):
        return _contains_call(expression.value)
    if isinstance(expression, UnaryExpr):
        return _contains_call(expression.operand)
    if isinstance(expression, BinaryExpr):
        return _contains_call(expression.left) or _contains_call(expression.right)
    if isinstance(expression, DefaultExpr):
        return _contains_call(expression.value) or _contains_call(expression.default)
    if isinstance(expression, IfExpr):
        return any(
            _contains_call(value)
            for value in (expression.condition, expression.then_value, expression.else_value)
        )
    if isinstance(expression, SelectionExpr):
        return _contains_call(expression.value)
    return False


def _is_cfg_selection(expression: Expression) -> bool:
    if isinstance(expression, GroupExpr):
        return _is_cfg_selection(expression.value)
    if isinstance(expression, Variable):
        return expression.name == "cfg" and bool(expression.path)
    if isinstance(expression, SelectionExpr):
        return _is_cfg_selection(expression.value)
    return False


def _annotation_type(annotation: Expression) -> str:
    if isinstance(annotation, GroupExpr):
        return _annotation_type(annotation.value)
    root = annotation.callee if isinstance(annotation, CallExpr) else annotation
    if isinstance(root, Variable) and root.name == "type" and root.path:
        part = root.path[0]
        if isinstance(part, IdentifierSegment):
            return "bool" if part.name in ("bool", "boolean") else part.name
    return "unknown"


def _option_value_type(value: Expression) -> str:
    if isinstance(value, EnableOption):
        return "bool"
    if isinstance(value, Literal) and value.kind in ("true", "false"):
        return "bool"
    if isinstance(value, AttrSet):
        for statement in value.statements:
            if isinstance(statement, Assignment) and _target_names(statement) in (("_meta", "type"), ("_meta", "_type")):
                return _annotation_type(statement.value)
            if isinstance(statement, Assignment) and _target_names(statement) == ("_meta",) and isinstance(statement.value, AttrSet):
                for field in statement.value.statements:
                    if isinstance(field, Assignment) and _target_names(field) in (("type",), ("_type",)):
                        return _annotation_type(field.value)
    return "unknown"


def _first_path_name(variable: Variable) -> str | None:
    if variable.path and isinstance(variable.path[0], IdentifierSegment):
        return variable.path[0].name
    return None


def _target_names(statement: Assignment) -> tuple[str, ...]:
    if isinstance(statement.target, StructuralMarker):
        return ()
    names: list[str] = []
    for segment in statement.target:
        if isinstance(segment, IdentifierSegment):
            names.append(segment.name)
        elif isinstance(segment, StringSegment):
            names.append(segment.value)
        else:
            return ()
    return tuple(names)


def _freeform_name(marker: StructuralMarker) -> str | None:
    if marker.kind == "freeform" and marker.argument and isinstance(marker.argument[-1], IdentifierSegment):
        return marker.argument[-1].name
    return None


def _reject_statement(statement: Statement, kind: FileKind) -> None:
    label = {
        ActionStatement: "action",
        ConditionalStatement: "conditional",
        InheritStatement: "inherit",
    }.get(type(statement), type(statement).__name__)
    raise ZenLangError(
        Diagnostic(
            "ZEN202",
            f"{label} statements are not allowed at this location in {kind.value.upper()} files",
            statement.span,
        )
    )
