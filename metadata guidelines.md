# ZenPkgs Metadata Standards

To ensure the documentation site renders correctly and builds pass CI, all packages and modules must adhere to the following metadata schema.

Package interface declarations are named leaves at `pkgs/<path>.zpkg`. Their
location mechanically defines `pkgs.zenos.<path>`; `package.zpkg` is not a valid
leaf name. Nix files remain valid for the flake, internal backend, tests, package
implementations, and modules. The repository has no `dsl/` wrapper directory.
The compiled DSL registry directly supplies the package overlay and public flake
package outputs. `tests/fixtures/package-registry.json` is a normalized contract,
not a second declaration source; checks require all 130 entries, 126 active
entries, and their target, alias, and source paths to remain exact.

## Package Interface Declarations

Add one `.zpkg` file per curated nixpkgs interface at its canonical target path.
For example, `pkgs/apps/utilities/example.zpkg` declares
`pkgs.zenos.apps.utilities.example`:

```zpkg
id = "example";
sourcePath = [ "example" ];
aliases = [ [ "catalog" "example" ] ];
status = "active";
meta = {
  displayName = "Example";
  summary = "Curated Example package for ZenOS";
  support = "curated";
  tags = [ "utility" ];
  category = "utilities";
};
```

`id` must equal the leaf filename, excluding `.zpkg`. Targets are derived from
the path and registry entries are sorted by source path; do not declare `target`
or `declarationOrder`. Keep aliases in the canonical ZPKG's `aliases` field. Use
`sourcePath = null`, `aliases = [ ]`, and `status = "unavailable"` for a catalog
entry that does not currently resolve to nixpkgs. The repository root is
compiled in interface mode; package build recipes remain as `.nix` files under
`pkgs/`.
Compilation uses import-from-derivation (IFD), so local evaluators and CI must
allow IFD. Its compiler bootstrap imports nixpkgs without the ZenPkgs overlay,
which keeps registry generation independent of the package tree it creates.

## Module Interface Declarations

ZMDL sources are named leaves at `modules/<path>.zmdl`; `module.zmdl` is not a
valid leaf name. The path mechanically defines the module identity
`zenos.<path>`, and `_meta.id` must exactly equal `<path>` with `/` replaced by
`.`. Desktop modules use the singular `modules/desktop/` root. The canonical
attachments live in the repository-root `structure.zstr`. Existing `.nix`
module implementations are retained temporarily as parity references.

## 1. Required Fields

Every package implementation's `package.nix` (`meta` set) and every
`module.nix` (top-level `meta` set) **MUST** contain:

| Field         | Type              | Description                                                   |
| :------------ | :---------------- | :------------------------------------------------------------ |
| `description` | `str` (multiline) | See "The First Line Rule" below.                              |
| `maintainers` | `list`            | List of maintainers (e.g., `with lib.maintainers; [ user ]`). |
| `license`     | `set`             | The licensing attribute (default: `lib.licenses.napl`).       |
| `platforms`   | `list`            | Supported platforms (default: `lib.platforms.zenos`).         |

## 2. Style Guidelines

### The First Line Rule

To unify documentation across packages and options (which do not support `longDescription`), we use the First Line Rule for the `description` field.

**Structure:**

```nix
description = ''
  Short summary line here (max 80 chars).

  Detailed explanation paragraphs go here.
  You can use standard **Markdown**.

  - List items
  - Code blocks
'';
```

#### Line 1: The Summary

- **Purpose:** Displayed in search results and lists.
- **Constraints:**
  - **Do** start with a capital letter.
  - **Do not** end with a period.
  - **Do** keep it under 80 characters.

#### Line 2+: The Details

- **Purpose:** Displayed on the detailed documentation page.
- **Constraints:**
  - Explain _what_ the module/package does.
  - Explain _why_ a user would want it.
  - List integration points.
  - Separate from the summary with a blank line.

### `maintainers`

- Must map to a valid handle in `lib/maintainers.nix` (or nixpkgs).
- If you are the sole author, add yourself.

### `platforms`

- **`platforms.zenos`**: Packages/Modules that depend on ZenOS-specific configuration or infrastructure.
- **`platforms.linux`**: Generic packages that can run on any Linux distro.

## 3. Options Metadata

Options declared via `mkOption` **MUST** follow the **First Line Rule**.

- **`description`**: Mandatory. Use the multiline string format.
- **`longDescription`**: **FORBIDDEN**. Do not use this attribute in `mkOption` calls; it will cause evaluation errors.
- **`example`**: Recommended for non-boolean types.

## 4. Enforcement

Run the audit tool to verify compliance:

```bash
nix flake check --show-trace
nix eval --file tests/integrity.nix --json | jq
```

Registry changes must also update `tests/fixtures/package-registry.json` in the
same change. Review that JSON diff as the explicit public path and metadata
contract change.
