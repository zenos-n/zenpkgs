# ZenOS DSL

The current implementation is documented under [Shared language front end](#shared-language-front-end)
and [Foundation validation](#foundation-validation). The MVP notes below are
historical documentation for `zcfg-legacy`, not the current language contract.

## Historical zcfg MVP

`zcfg` is a dependency-free Python compiler for a deliberately restricted,
Nix-like ZenOS configuration language. It validates a source tree before
emitting a deterministic Nix function.

## Commands

From this directory:

```sh
python3 zcfg.py check system.zcfg
python3 zcfg.py compile system.zcfg -o system.nix
python3 zcfg.py ast system.zcfg
```

Every command accepts `--diagnostic-format human` (the default) or
`--diagnostic-format json`. `check` emits no human output on success; in JSON
mode it emits an empty diagnostics array. Diagnostics use exit status 1, while
argument errors use argparse's exit status 2.

## Grammar

```text
document    := import* assignment* EOF
import      := "import" RELATIVE_PATH ";"
assignment  := attr_path "=" value ";"
attr_path   := IDENT ("." IDENT)*
value       := STRING | INTEGER | "true" | "false" | "null"
             | pkgs_ref | list | attr_set
pkgs_ref    := "$pkgs" "." attr_path
list        := "[" value* "]"
attr_set    := "{" assignment* "}"
```

Identifiers begin with an ASCII letter or underscore and then contain letters,
digits, `_`, `-`, or `'`. Strings are double quoted and support `\"`, `\\`,
`\/`, `\n`, `\r`, `\t`, and four-digit `\u` escapes. Integers are signed
64-bit decimal values. `#` starts a line comment.

Imports are bare paths beginning with `./` or `../` and ending in `.zcfg`:

```zcfg
import ./hardware/base.zcfg;

system.network.hostName = "zenos";
system.software.packages = [
  $pkgs.catalog.git
  $pkgs.catalog.gnome-console
];

# Explicit access to an underlying NixOS option.
legacy.boot.kernelParams = [ "quiet" ];
```

Imports are resolved relative to the importing file. Imported documents merge
in declaration order, and local assignments merge last. Attribute sets merge
recursively; lists and scalar values are replaced by the later value. A local
leaf cannot be assigned twice, including through dotted and nested forms.
Import cycles and unreadable files are errors.

Only `$pkgs` attribute references are accepted. Package paths are resolved
inside the curated ZenPkgs namespace; `$pkgs.catalog.firefox`, for example,
compiles to `pkgs.zenos.catalog.firefox`. Arbitrary identifiers, function calls,
interpolation, arithmetic, conditionals, `with`, `let`, quoted attribute names,
URL/absolute imports, floats, and comma-separated lists are unsupported and
rejected.

User configuration paths omit the internal `zenos` root. The compiler adds it
to the generated Nix function, so `system.network.hostName` becomes
`zenos.system.network.hostName`. The user-facing `legacy` root is the explicit
passthrough for underlying NixOS options and becomes `zenos.legacy` internally.

The generated file always has this interface:

```nix
{ pkgs }:
{
  zenos = {
    # deterministically sorted configuration
  };
}
```

Run the test suite with:

```sh
python3 -m unittest discover -s tests -v
```

## Shared language front end

`zenlang` is the span-aware parser and compiler front end for `.zcfg`, `.zmdl`,
`.zpkg`, and `.zstr`. The public API includes:

```python
from zenlang import (
    ast_to_dict,
    check_tree,
    compile_document,
    compile_tree,
    parse,
    parse_file,
    tokenize,
    validate,
)
```

The source filename determines the language kind. `parse` and `parse_file`
perform syntax and file-kind validation by default and raise `ZenLangError`
with a stable `ZENxxx` diagnostic. AST dataclasses are frozen and contain
source spans. Serialized documents identify grammar and IR version `1.0.0Na`.

`parse_file` recursively validates the import graph. Imports are local relative
paths, must exist, and must have the same extension as their importer. By
default they are logically confined to the entry file's parent directory;
callers with a wider source tree can pass `import_root=...` explicitly. Final
file symlinks may target regular files outside that logical root, including
through bounded directory-symlink chains such as `/Users` to `/home`, while
directory symlinks encountered before the logical final component are rejected.
The CLI exposes the same boundary as
`--import-root`. Cycles and excessive import depth are rejected with import
traces; bare imported documents are merged in source order before local
declarations. Bound imports produce isolated record values with annotation
checks, rather than exposing AST descriptors. They never become Nix `import`
expressions. Legacy `import ./file.zcfg;` remains accepted with a
deprecation warning; new sources use `_import`.

Executable bare names must be declared lexical bindings. Evaluator and backend
roots are reserved, and package names are available bare only inside
`with $pkgs.zenos;` or a static subtree such as
`with $pkgs.zenos.legacy;`. Boolean guards use `_let` annotations and ZMDL
option metadata; an unknown `$cfg` selection must use a boolean default such as
`or false` as an explicit deferred-type marker in source-only checks. Schema-backed
checks admit bare `$cfg` guards and check their boolean shape against mounted
types. A fallback does not convert an existing nonboolean value to a boolean.
Calls are not valid guards. DSL
path literals lower to real Nix paths relative to the declaring source file.
Typed interpolation handles scalar values and retains path/package string context.

```sh
python3 -m zenlang check module.zmdl
python3 -m zenlang ast package.zpkg
python3 -m zenlang compile system.zcfg -o system.nix
python3 -m zenlang compile sources/modules/programs/example.zmdl --root sources -o module.nix
python3 -m zenlang compile package.zpkg --mode interface -o package.nix
python3 -m zenlang check-tree --root sources
python3 -m zenlang compile-tree --root sources --output bundle.json
```

The installed `zen-dsl` executable provides the same commands and uses the
shared parser and compiler for all four formats. Standalone ZMDL compilation
requires an explicit `--root` and derives identity only from a source path below
`<root>/modules/`; repository-tree mode uses the same mapping. ZPKG defaults to
`--mode build` and also supports `--mode interface`. The installed `zcfg`
executable is an alias of this canonical frontend; the previous restricted
implementation is available as `zcfg-legacy` during migration.

Tree commands recursively discover the four source extensions without entering
symlink directories. They reject relative path case collisions and trees over
4096 source files, and validate every import relative to the requested root.
Every ZMDL must be a named leaf below `modules/`; generic `default`, `index`, and
`module` leaves, duplicate or case-colliding identities, and any authored
`_meta.id` are rejected. `modules/desktops/gnome.zmdl` has canonical
module identity `zenos.desktops.gnome` and compiles at that option path. Module
records do not infer system/user targets; each ZMDL action carries its own scope.

A ZMDL `(freeform id)` declares open keys at its declaration position. Freeform
scopes may coexist with named sibling options and may nest; each body describes
the value below one open key. The `id` is lexical rather than an option name, so
`$f.id` is the current key and remains visible in nested expressions and
lambdas until shadowed by an inner declaration. Named option trees compile to
submodules, and each open scope becomes that submodule's `freeformType`.

Actions inside a freeform are transposed over the keys present at that scope.
Each action assignment remains a separate module definition, including static
and overlapping dynamic targets, so the target option type retains control of
merge behavior. The compiler keeps target roots static while deferring mapped
values, avoiding recursive forcing of the top-level module configuration.
Conditional freeform actions require a boolean item type and are gated by each
item's value; unconditional actions run for every configured key. `_let`
bindings remain lexical to subsequent action definitions, and `inherit` keeps
ordinary attribute-set semantics during transposition. Imported dotted and
nested declarations are canonicalized before their option schemas are merged.

`compile-tree` atomically writes deterministic JSON with bundle, grammar, and IR
versions. Semantic descriptors use `zenlang.semantic/2` and bundles use
`zenlang.bundle/2`. Each sorted source entry contains its relative path, kind,
span-free semantic descriptor, and compiled Nix text. The bundle's sorted `modules`
records expose each source path, path-derived identity, and full option path.
`structure.zstr` controls schema, freeforms, aliases, package/program selectors,
and explicit ZMDL subtree mounts. ZPKG interface mode emits
static semantic descriptors and does not require or evaluate the package
runtime. This frontend does not claim the future complete configuration schema
or package runtime; unsupported backend semantics are reported as source
diagnostics.

## Foundation validation

`check` without a schema validates syntax and local semantics. Mounted ZCFG
validation uses the actual trusted NixOS/ZSTR context, not the browser index:

```sh
zen-dsl validate host.zcfg --trusted-context scripts/schema-context.nix
zen-dsl compile host.zcfg --trusted-context scripts/schema-context.nix -o host.nix
```

The trusted context is a Nix function accepting `{ requests }` and returning the
schema exporter result. The supplied script binds the production runtime and
its package tree. This mode parses the source once, refreshes literal and path
requests, and validates the same AST. It does not import the compiled ZCFG into
the context. Evaluating the context is opt-in trusted execution, with a 120-second
timeout (`--context-timeout`, at most 600), a 32 MiB response budget and a 1 MiB
backend-log budget. Exceeding a live output budget or the timeout terminates the
evaluation and cleans up its temporary files. Backend diagnostics remain visible.

Offline validation can also consume a previously exported context without
launching any process:

```sh
zen-dsl schema-requests host.zcfg > requests.json
# Export the trusted context with lib/schema-validation.nix and these requests.
zen-dsl validate host.zcfg --schema schema.json
zen-dsl compile host.zcfg --schema schema.json -o host.nix
```

The exporter accepts `evaluated`, `bundle`, `packageTree`, and `requests`.
The first three must describe the same runtime, without loading the ZCFG being
checked. Exact path queries resolve concrete user/freeform keys and requested
legacy package selectors without enumerating the upstream package universe.
Only literal request data is checked using the upstream option types;
source expressions are not executed for inspection. Exit status 1 reports an
error, and 2 reports incomplete validation. Unsupported expressions, dynamic
values, and bounded or unavailable schema areas are not silently accepted.
Compiling with `--schema` preserves existing output on either result. Context
generation must be repeated when the configuration literals or runtime change;
`--trusted-context` performs that refresh automatically. Request/query count is
limited to 4096 and path depth to 64. Unqueried areas remain unsupported, not
implicitly absent. Typed runtime-dependent guards remain incomplete because
static validation does not evaluate their truth value. Partial descent through
value-typed collections also remains incomplete: checking only an element would
bypass constraints on its enclosing record. Whole-record literal assignments
retain the enclosing runtime checks.

Run the real production-context acceptance in the VM with
`PYTHONPATH=lib/zen-dsl python3 tests/schema-validation/production.py`.

Developers have full `$lib` access. Backend evaluation of developer modules is
trusted execution, not a sandbox. Bound record imports and `_let` values retain
their lexical scope, and supplied annotations are checked when evaluated.
Function parameter labels do not constitute inferred argument/return signatures;
`functionTo` checks a declared return type when the function is called.

ZPKG parsing and data-only interface compilation can retain dependency metadata.
Executable compilation and package evaluation reject nonempty `general`, `build`,
or `runtime` scopes until D14's override/linkage mechanics are specified. Empty
and omitted scopes preserve the imported derivation's identity. This is explicit
unsupported-feature handling, not an implementation of dependency linkage.

Read compiled JSON bundles with `lib/read-dsl-bundle.nix`. It decodes data without
Nix string context and restores asset references on generated code. Production
bundles compile from filtered immutable sources so emitted paths do not point to
temporary builder directories. `checks.x86_64-linux.dsl-bundle-context` verifies
that executable fragments retain and can read their referenced assets.

Module-local aliases require ZSTR mounting; their current supported boundaries
and VM acceptance commands are in `tests/mounting/module-aliases.md`. General
alias/local precedence, custom builders, and dependency linkage remain undecided.
The foundation checks do not certify all existing library options' enabled
behavior, activation, or boot. Run integration acceptance in a ZenOS VM.
