# [P17] CLMD - ZenOS Architecture Framework Guide

This document outlines the core concepts, metadata structures, and development patterns for the custom ZenOS Nix framework.

## 1. The Package Tree (`zenpkgs`)

Packages are placed in `./pkgs/` and recursively evaluated. ZenOS supports a
custom package wrapper format alongside standard Nix derivations.

The custom format allows the `docs.nix` harvester to extract rich metadata
without strictly evaluating the derivation, guarding against OOM errors.

### Supported Package Metadata

- `package`: The actual derivation.
- `brief`: A short, 1-2 sentence description.
- `description`: A long-form explanation of the package.
- `maintainers`: A list of maintainers from `maintainers.nix`.
- `license`: The license string (e.g., `"napalm"`).
- `dependencies`: A list of string names of dependencies.

---

## 2. The `.zmdl` Module System

Modules in `./modules/` are recursively discovered and parsed by `module-builder.nix`.
`.zmdl` files are uniquely processed with text-replacement templating before evaluation.

### Magic Variables

When a `.zmdl` file is loaded, these tokens are injected directly into the source:

- `$name` -> The base name of the module (e.g., `hyprland`).
- `$path` -> The full option path (e.g., `zenos.system.programs.hyprland`).
- `$cfg` -> The configuration path for the module (e.g., `config.zenos.system.programs.hyprland`).

### Dual-Scope Architecture (Programs Namespace)

If a module is placed inside `./modules/programs/`, it is compiled as a **Dual-Scope Module**.
It automatically generates options in _two_ places:

1. `zenos.system.programs.$name` (Global system level)
2. `zenos.users.<name>.programs.$name` (Per-user level)

When actions are evaluated, the framework passes an `isUser` boolean to the `action`
function, allowing the module to emit global `environment.systemPackages` when false,
or `home-manager` configurations when true.

### Supported Option Types

`bool`, `string`, `int`, `integer`, `float`, `enum`, `list`, `set`, `null`, `freeform`, `function`.

### Node vs. Leaf Actions

- **Leaf (Option)**: Evaluated only if the boolean is `true`. Receives `{ cfg, isUser }`.
- **Node (Attribute Set)**: Continuously evaluated. Receives `localConfig` and `isUser`.

---

## 3. The `ZCFG` Host Configuration Format

ZenOS allows defining hosts using `.zcfg` or `.nzo` files. This uses a custom AST
cleaner (`importZcfg` in `zen-core.nix`) to allow a flattened, flat-file structure.

If you write `foo = true;`, the parser magically converts it to `foo._enable = true;`
unless it already ends in `enable` or `_enable`. This allows you to rapidly toggle
framework options without deep nesting!
