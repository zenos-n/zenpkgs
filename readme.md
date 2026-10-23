# ZenPkgs

The Nix packages repository for ZenOS.

The registry contains 4153 declarations: 4098 imports and 55 build providers.
Ten former compatibility-only recipes now have canonical ZPKG wrappers; the
existing internal recipes remain trusted transitional builders behind those
declarations, not implicit exports. Their IDs preserve established identities
or explicitly use the `org.zenos.packages` fallback namespace.

See [catalog coverage and verification](docs/package-catalog-expansion.md) and
the [package path migration](docs/package-layout-migration.md).
Shell and terminal configuration is covered in the [shell options guide](docs/shell-terminal-options.md).
Native per-user configuration is covered in the [user options guide](docs/user-options.md).
Codex and Select for Figma use [native program preferences](docs/application-program-options.md).
Desktop configuration is covered in the [system, GNOME, and program options guide](docs/desktop-options.md).
Migration capability coverage and opt-in examples are in the [migration guide](docs/migration-parity.md).

Curated package declarations remain named leaves in the existing category
filesystem under `pkgs/`. Each ZPKG requires `_meta.id`, a reverse-DNS string.
For example, `pkgs/apps/browsers/firefox.zpkg` with ID `org.mozilla.firefox`
exports canonical `pkgs.org.mozilla.firefox` and category alias
`pkgs.byCategories.apps.browsers.firefox`, both the same derivation. Internally
these live below `pkgs.zenos`. There are no old root category aliases.

Registry `id` is `"pkgs." + _meta.id`; `target` splits that metadata ID on dots.
`categoryTarget` splits the relative filesystem path after removing `.zpkg`.
There is one registry entry per declaration; the category view is derived from
it. Preserve established IDs; otherwise author a unique ID under
`org.zenos.packages`. Missing IDs are errors, never implicit fallbacks.
`pkgs.legacy` remains unchanged. See the
[metadata guidelines](docs/metadata-guidelines.md) for the full contract.
Historical registry fixtures and catalog verification must be updated to check
both views before they can certify this contract.

Only `_meta` is prefixed: its fields use `name`, `summary`, multiline Markdown
`description`, and dependency scopes `general`, `build`, and `runtime`.
Missing descriptive metadata warns during evaluation and compilation; it is not
replaced with guessed upstream information. Empty or omitted `packageVersion`
defaults to `zenosVersion`. `_meta.id` establishes package identity, while ZSTR
controls exposure: without a root structure the adapter exports no packages or
module candidates; multiple structures fail.

Dependency declarations are authoritative, including for imported packages, but
the backend's build-input override and runtime-linkage contract is still a design
blocker (D14/D15). Registry metadata preserves the scopes; it does not implement
that availability or invent additive/replacement override semantics.

Package registry compilation uses Nix import-from-derivation (IFD), keeping
generated compiler output in the store instead of the repository. The compiler
is built with a clean, overlay-free nixpkgs bootstrap to avoid a circular
dependency. Evaluators and CI must allow IFD until ZenOS provides a native
evaluator plugin or another non-IFD compiler boundary.

Named ZMDL leaves live under `modules/` and map mechanically to `zenos.<path>`;
their identity is compiler-derived and `_meta.id` must not be authored. Generated
modules remain one target-neutral set of private migration candidates and are
not active in public module outputs, while the existing `.nix` implementations
remain for parity. See
[DSL module candidate checks](docs/dsl-module-candidates.md) for the mapping,
static evaluation/parity checks, blocker exceptions, and VM commands.

ZenOS has one module and configuration graph. System and user actions are
declared together below `modules/`; Home Manager is only an internal lowering
backend for user actions and is not exposed as a separate module tree.

The only root entries are the documented canonical files and directories plus
`.git/`, `.gitignore`, `.github/`, and `.vscode/`. Run the source-policy check
through `path:.` to include ignored and untracked working-tree entries.
