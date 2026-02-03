# ZenPkgs Metadata Standards

To ensure the documentation site renders correctly and builds pass CI, all Packages and Modules must adhere to the following metadata schema.

## 1. Required Fields

Every `package.nix` (in `meta` set) and `module.nix` (top-level `meta` set) **MUST** contain:

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
nix eval --file tests/integrity.nix --json | jq
```
