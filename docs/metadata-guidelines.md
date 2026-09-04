# ZenPkgs Metadata Standards

To ensure the documentation site renders correctly and builds pass CI, all packages and modules must adhere to the following metadata schema.

Package interface declarations are named leaves at `pkgs/<path>.zpkg`. Their
location mechanically defines `pkgs.zenos.<path>`; `package.zpkg` is not a valid
leaf name. Nix files remain valid for the flake, internal backend, tests, package
implementations, and modules. The repository has no `dsl/` wrapper directory.
The compiled DSL registry directly supplies the package overlay and public flake
package outputs. `tests/fixtures/package-registry.json` is a normalized contract,
not a second declaration source; checks require all 126 path-derived entries and
their target and imported Nixpkgs paths to remain exact.

## Package Interface Declarations

Add one `.zpkg` file per curated nixpkgs interface at its canonical target path.
For example, `pkgs/apps/utilities/example.zpkg` declares
`pkgs.zenos.apps.utilities.example`:

```zpkg
_meta = {
  _name = "Example";
  _summary = "Curated Example package for ZenOS";
  _description = "Curated Example package for ZenOS";
  _zenosVersion = "1.0.0";
  _packageVersion = "";
  _tags = [ "utility" ];
  _maintainers = [ $m.doromiert ];
  _dependencies = {
    _general = [ ];
    _build = [ ];
    _runtime = [ ];
  };
};

import $pkgs.legacy.example;
```

Identity comes only from the file path. Do not declare `_id`, `_target`,
`_sourcePath`, `_status`, `_aliases`, `_category`, or `_declarationOrder`.
Unavailable curated-app entries belong only to ZenOS Setup and do not get ZPKG
files. The repository root is compiled in interface mode; transitional Nix
recipes remain under `lib/compat/`.
Compilation uses import-from-derivation (IFD), so local evaluators and CI must
allow IFD. Its compiler bootstrap imports nixpkgs without the ZenPkgs overlay,
which keeps registry generation independent of the package tree it creates.

## Module Interface Declarations

ZMDL sources are named leaves at `modules/<path>.zmdl`; `module.zmdl` is not a
valid leaf name. The path mechanically defines the module identity
`zenos.<path>`; `_meta.id` is derived and must not be authored. Desktop modules
use the plural `modules/desktops/` root. The repository-root `structure.zstr`
defines schema only and does not register module files. Existing `.nix` module
implementations are retained temporarily as parity references. Module actions
own system, user, or target-neutral routing independently of source paths.

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
