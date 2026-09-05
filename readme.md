# ZenPkgs

The Nix packages repository for ZenOS.

Curated nixpkgs interfaces are named leaves under `pkgs/`. A source such as
`pkgs/apps/browsers/firefox.zpkg` mechanically defines
public identity and registry ID `pkgs.apps.browsers.firefox`, internally
`pkgs.zenos.apps.browsers.firefox`. Duplicate basenames in different directories
are legal; targets are exact and unique, with no alternate alias catalog.
The flake compiles the
repository root in interface mode and uses the path-sorted result for the
overlay, registry documentation, and flattened public package outputs.
The 126-entry normalized contract in `tests/fixtures/package-registry.json`
protects every full public ID, derived target, metadata record, and imported
nixpkgs source path.

The `.zpkg` files are the only package registry declaration source. Each file
has one public package path derived from its location. See
[metadata guidelines](docs/metadata-guidelines.md) for the schema and validation
commands.

Only `_meta` is prefixed: its fields use `name`, `summary`, multiline Markdown
`description`, and dependency scopes `general`, `build`, and `runtime`.
Missing descriptive metadata warns during evaluation and compilation; it is not
replaced with guessed upstream information. Empty or omitted `packageVersion`
defaults to `zenosVersion`. Filesystem paths establish identity, while ZSTR
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
