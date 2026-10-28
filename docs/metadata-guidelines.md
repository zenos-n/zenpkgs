# ZenPkgs Metadata Standards

The sibling `zenos-n-next/design/node-metadata.md`, `zpkg-format.md`,
`package-tree.md`, and `mounting-and-build-decisions.md` are authoritative.

## Package Identity

Every ZPKG requires `_meta.id`, a nonempty reverse-DNS string without the
`pkgs.` prefix. Preserve an established upstream ID where one exists (for
example `org.mozilla.firefox`). Software owned by Negative Zero or ZenOS uses
`com.neg-zero.<project>`. For a third-party package without a verified upstream
ID, explicitly author `unknown.<normalized leaf package name>`, for example
`unknown.example`. Use only the filename stem, never category segments. Preserve
spelling and case; encode punctuation as `-u<hex code point>-` and prefix names
beginning with a digit with `p-` (for example, `foo_bar` becomes `foo-u5f-bar`).
Fallback names must be unique. Missing IDs remain errors.

The registry contains one record per declaration:

- `id = "pkgs." + _meta.id` is the canonical public identity.
- `target = _meta.id.split(".")` is the canonical target, without `pkgs`.
- `categoryTarget` is the relative filesystem path below `pkgs/`, split into
  segments after removing `.zpkg`.

For `pkgs/apps/browsers/firefox.zpkg` with `_meta.id = "org.mozilla.firefox"`,
`id` is `pkgs.org.mozilla.firefox`, `target` is
`[ "org" "mozilla" "firefox" ]`, and `categoryTarget` is
`[ "apps" "browsers" "firefox" ]`.

The public views are `pkgs.org.mozilla.firefox` and
`pkgs.byCategories.apps.browsers.firefox`; generated Nix uses
`pkgs.zenos.org.mozilla.firefox` and
`pkgs.zenos.byCategories.apps.browsers.firefox`. Both resolve to the same
derivation. `byCategories` is a derived alias view, not a second registry entry
or a second build. Old root category aliases such as
`pkgs.apps.browsers.firefox` are not exported.

Keep the existing category filesystem. Moving a file changes `categoryTarget`
and its category selector, but preserves the canonical identity when `_meta.id`
is unchanged. Canonical IDs and category targets must be unique; duplicate IDs,
malformed or missing IDs, and conflicting exported paths are errors. The two
views must not overwrite each other or the reserved `legacy` view.

ZSTR controls exposure of both views. No root structure means no exported
packages or options. `pkgs.legacy` (internally `pkgs.zenos.legacy`) remains the
direct pinned Nixpkgs view, with no ZPKG metadata or ID requirement.

Do not author `target`, `categoryTarget`, `sourcePath`, `status`, `aliases`, or
`category` metadata. Registry `sourcePath` records the imported Nixpkgs attribute
path. `package.zpkg` is reserved and `pkgs/legacy/` must not exist.

The compiled registry feeds the overlay and flake outputs. Registry fixtures
are verification snapshots, not a second declaration source; historical
filesystem-ID fixtures do not certify the new two-view contract.

## Package Declarations

Only `_meta` is prefixed. Its fields and dependency scopes are unprefixed:

```zpkg
_meta = {
  id = "unknown.example";
  name = "Example";
  summary = "An example package for ZenOS";
  description = ''
    Provides an example utility with **Markdown** documentation.
  '';
  zenosVersion = "1.0.0";
  packageVersion = "";
  tags = [ "utility" ];
  maintainers = [ $m.doromiert ];
  license = $l.mit;
  dependencies = {
    general = [ $pkgs.legacy.zlib ];
    build = [ $pkgs.legacy.pkg-config ];
    runtime = [ $pkgs.legacy.openssl ];
  };
};

import $pkgs.legacy.example;
```

`packageVersion` is the original package version; an empty or omitted value
defaults to `zenosVersion`. Verify the actual license instead of assuming one.
Package source code, assets, and implementation payload belong in a dedicated
external repository, not in ZenPkgs. Repository-local Markdown is documentation.
Custom builder and source-pinning syntax remain undecided.

## Descriptions And Diagnostics

Common descriptive fields are `name`, `summary`, `description`, `tags`,
`maintainers`, and `license`. Use `summary` for short list/search text and
`description` for multiline Markdown. Plain paragraphs are valid Markdown;
headings and formatting are optional. Quoted descriptions are invalid.

`description = _import "./description.md";` loads Markdown relative to the
declaring ZPKG or ZMDL and must remain inside the repository. It does not evaluate
Nix or parse the Markdown as DSL. The adapter preserves the emitted description
text, including whitespace, and normalized unprefixed metadata keys.

Every exposed package and option node, including branches and freeform schemas,
must be checked during evaluation and compilation. Missing descriptive fields
warn with full node path and source location, rather than failing a build.
Missing, malformed, or duplicate package IDs fail. Empty descriptions also warn. Unknown metadata fields warn, with a spelling
suggestion when available. Invalid supplied types, versions, references, scopes,
weights, defaults, and conflicting identities are errors, not missing metadata.

For incomplete package descriptors, the adapter uses empty strings for missing
text/version fields, empty lists for tags and maintainers, and `null` for an
unknown license. These are diagnostic fallbacks, not assertions about upstream
metadata. Omitted dependency scopes become empty lists without warnings.
`weight` is optional and exceptional; omit it for normal backend priority.

## Dependency Blocker

`general` dependencies must be available during building and at runtime;
`build` dependencies only during building; `runtime` dependencies only at
runtime. Old `global`/`run`/`export` scopes and dependency cascades are unsupported.
The three scopes are authoritative even for imported Nixpkgs packages.

The registry preserves these declarations but does not implement dependency
availability by decorating metadata. The backend contract for overriding an
imported package's build inputs and its runtime linkage remains undecided
(D14/D15 in the authority's `DESIGN-ISSUES.md`). No additive/replacement override
semantics are assumed here. Until that decision is made, the interface adapter
retains upstream derivation identity; nonempty dependency declarations must not
be presented as an implemented build/runtime override.

## Module Metadata

Named ZMDL leaves at `modules/<path>.zmdl` derive identity `zenos.<path>`;
`module.zmdl` and authored `_meta.id` are invalid. ZSTR mounts module trees and
controls exposure. System, user, and target-neutral actions determine routing,
not separate public module roots. Home Manager is an internal lowering backend.

Options additionally describe `type` and, when appropriate, `default`.
`zenosVersion` inherits from the parent unless explicitly overridden. An
unresolved effective version warns. Deliberately omitted defaults are allowed;
evaluation fails only when a required value is unavailable. Metadata records
and dependency scopes are not option nodes.

## Verification

Update `tests/fixtures/package-registry.json` alongside declaration changes and
review exact public IDs, targets, imported paths, and metadata. Package checks
must cover canonical IDs and targets, filesystem `categoryTarget` values,
same-derivation category aliases without duplicate records, unchanged legacy,
absent old root category aliases, missing/malformed/duplicate IDs, conflicting
exports, structure exposure, and metadata defaults and scope decoding. Existing
historical results do not establish acceptance of the new contract.

Run acceptance checks inside a ZenOS VM, not on the host:

```bash
nix build path:.#checks.x86_64-linux.registry-contract \
  path:.#checks.x86_64-linux.registry-path-identities \
  path:.#checks.x86_64-linux.registry-invalid-identities \
  path:.#checks.x86_64-linux.registry-structure-exposure \
  path:.#checks.x86_64-linux.registry-metadata-defaults \
  --no-link --print-build-logs --option allow-import-from-derivation true
```

Compilation uses import-from-derivation with an overlay-free Nixpkgs bootstrap
to avoid a registry/overlay cycle. Evaluators must allow IFD. Compiler diagnostics
and runtime mounting checks are separate integration responsibilities; the
package registry checks do not claim full module activation or dependency
override coverage.
