# zcfg MVP

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
declarations. Bound imports remain isolated typed AST values and never become
Nix `import` expressions. Legacy `import ./file.zcfg;` remains accepted with a
deprecation warning; new sources use `_import`.

Executable bare names must be declared lexical bindings. Evaluator and backend
roots are reserved, and package names are available bare only inside
`with $pkgs.zenos;` or a static subtree such as
`with $pkgs.zenos.legacy;`. Boolean guards use `_let` annotations and ZMDL
option metadata; an unknown `$cfg` selection must use a boolean default such as
`or false` as an explicit deferred-type marker. Calls are not valid guards. DSL
path literals remain tagged path descriptors rather than being coerced to strings.

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
`structure.zstr` provides schema, freeforms, aliases, and package/program
selectors; it does not attach or register ZMDL files. ZPKG interface mode emits
static semantic descriptors and does not require or evaluate the package
runtime. This frontend does not claim the future complete configuration schema
or package runtime; unsupported backend semantics are reported as source
diagnostics.
