# ZenPkgs Metadata Standards

To ensure the documentation site renders correctly and builds pass CI, all Packages and Modules must adhere to the following metadata schema.

## 1. Required Fields

Every `package.nix` (in `meta` set) and `module.nix` (top-level `meta` set) **MUST** contain:

| Field             | Type              | Description                                                   |
| :---------------- | :---------------- | :------------------------------------------------------------ |
| `description`     | `str`             | A concise, one-line summary.                                  |
| `longDescription` | `str` (multiline) | Detailed documentation supporting Markdown.                   |
| `maintainers`     | `list`            | List of maintainers (e.g., `with lib.maintainers; [ user ]`). |
| `license`         | `set`             | The licensing attribute (default: `lib.licenses.napl`).       |
| `platforms`       | `list`            | Supported platforms (default: `lib.platforms.zenos`).         |

## 2. Style Guidelines

### `description`

- **Do** keep it under 80 characters if possible.
- **Do** start with a capital letter.
- **Do not** end with a period.
- **Example:** `"Configures the ZenOS bootloader theme"`

### `longDescription`

- **Format:** Use standard Markdown.
- **Content:**
  - Explain _what_ the module/package does.
  - Explain _why_ a user would want to enable/install it.
  - List key integration points (e.g., "Integrates with `zenos.theming`").
  - **Warnings:** If experimental, use a blockquote: `> **Warning:** ...`
- **Code Blocks:** Use syntax highlighting (e.g., ```nix).

### `maintainers`

- Must map to a valid handle in `lib/maintainers.nix` (or nixpkgs).
- If you are the sole author, add yourself.

### `platforms`

- **`platforms.zenos`**: Packages/Modules that depend on ZenOS-specific configuration or infrastructure.
- **`platforms.linux`**: Generic packages that can run on any Linux distro.

## 3. Options Metadata

Options declared via `mkOption` **MUST** have a `description`.

- **`description`**: Mandatory. Plain text summary.
- **`longDescription`**: Optional. Use this for complex options that require examples or detailed behavior explanation.
- **`example`**: Recommended for non-boolean types.

## 4. Enforcement

Run the audit tool to verify compliance:

```bash
nix eval .#audit.x86_64-linux --json | jq
```
