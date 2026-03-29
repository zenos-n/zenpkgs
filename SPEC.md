# ZenOS DSL Specification

**Revision: 0.1.0 — Draft**
**Maintainer: doromiert**

---

## Overview

ZenOS uses three domain-specific file formats that transpile to Nix expressions:

| Extension | Role                    | Scope                                         |
| --------- | ----------------------- | --------------------------------------------- |
| `.zcfg`   | Host/user configuration | Declares system state                         |
| `.zmdl`   | Module definition       | Defines options + implementation              |
| `.zpkg`   | Package definition      | Defines a derivation                          |
| `.zstr`   | Structure definition    | Defines how options and packages are laid out |

All three share a common syntax foundation and the same `$variable` system. They differ in what top-level keys mean and what context is injected at evaluation time.

---

## Part 1 — Universal Syntax

### 1.1 Basic Rules

- Files are **not** wrapped in `{ }` at the top level — the transpiler adds function headers automatically
- Assignment: `key = value`
- Attribute paths: `key.subkey = value`
- String interpolation: `"hello ${$path.username}"`
- Comments: `# single line only`
- Semicolons are **required** — same rules as Nix
- Lists use `[ ]` with space-separated items (same as Nix)
- Multiline strings: `'' ... ''` (same as Nix)

### 1.2 System Variables (`$`)

Available in all three file types unless noted:

| Variable | Resolves To                             | Available In     |
| -------- | --------------------------------------- | ---------------- |
| `$pkgs`  | ZenPkgs package set                     | all              |
| `$lib`   | nixpkgs lib                             | all              |
| `$cfg`   | Evaluated global config                 | `.zmdl`, `.zcfg` |
| `$path`  | Config values at current module's scope | `.zmdl`          |
| `$name`  | Current module/package name string      | all              |
| `$type`  | ZenOS type primitives                   | `.zmdl`, `.zpkg` |
| `$m`     | Maintainers registry                    | all              |
| `$l`     | Licenses registry                       | all              |
| `$c`     | Color primitives                        | `.zmdl`          |
| `$v`     | `_let` variable access                  | `.zmdl`          |
| `$f`     | Freeform identifier (current key name)  | `.zmdl`, `.zstr` |
| `$deps`  | Runtime deps (resolved store paths)     | `.zpkg`          |

### 1.3 `_let` — Typed Variables

Defines a local variable scoped to the current block:

```nix
_let name: $type.string = "default";
_let port: $type.int = 8080;
_let tags: $type.list = [ "web" "api" ];
```

Access via `$v.name`, `$v.port`, etc.

### 1.4 `_meta` Block

Carries documentation and type metadata. Structure varies slightly per file type — see each section below. Common fields:

```nix
_meta = {
  brief = "Short one-liner description";
  description = ''
    Longer markdown description.
  '';
  maintainers = [ $m.doromiert ];
  license = $l.napalm;
};
```

---

## Part 2 — `.zcfg` — Host Configuration

### 2.1 Purpose

`.zcfg` files are the user-facing configuration layer. They declare the desired state of a ZenOS system. They should read like a plain list of "things I want" with minimal boilerplate.

### 2.2 Redesigned Syntax

The full redesign introduces the following over the current `zen-core.nix` implementation:

#### 2.2.1 Implicit Boolean Activation

Setting a module to `true` enables it with all defaults. Setting to `false` explicitly disables it.

```nix
system.programs.keepassxc = true;
system.programs.firefox = false;  # explicitly disabled
```

When set to `true`, all children default to their `_meta.default` values defined in the corresponding `.zmdl`.

#### 2.2.2 Inline Configuration

Partial config merges with defaults for unset fields:

```nix
system.programs.keepassxc = {
  autostart = true;
  theme = "light";
};
```

#### 2.2.3 User Scoping

```nix
users.alex = {
  programs.keepassxc = true;

  legacy = {
    isNormalUser = true;
    shell = $pkgs.zsh;
  };
};
```

#### 2.2.4 Package Selection

Packages are selected from the `pkgs.zenos` tree by path:

```nix
system.packages = {
  utils.bat = true;
  utils.ripgrep = true;
  dev.rust = true;
};
```

#### 2.2.5 Legacy Passthrough

Direct NixOS config passthrough via `legacy`:

```nix
legacy = {
  networking.hostName = "zephyr";
  boot.loader.systemd-boot.enable = true;
  time.timeZone = "Europe/Warsaw";
};
```

#### 2.2.6 Imports

See Part 5 — `_import` is universal across all file types.

#### 2.2.7 Conditionals

```nix
# Only applies if condition is true at eval time
if $cfg.system.desktop.enable {
  system.programs.pipewire = true;
}
```

#### 2.2.8 Full Example

```nix
conf("hardware.zcfg");

legacy = {
  networking.hostName = "zephyr";
  time.timeZone = "Europe/Warsaw";
  boot.loader.systemd-boot.enable = true;
  system.stateVersion = "25.11";
};

system = {
  packages = {
    utils.bat = true;
    utils.ripgrep = true;
    dev.rust = true;
  };

  programs = {
    pipewire = true;
    bluetooth = { enable = true; };
  };
};

users.alex = {
  legacy = {
    isNormalUser = true;
    shell = $pkgs.zsh;
    extraGroups = [ "wheel" "audio" "video" ];
  };

  programs = {
    keepassxc = {
      autostart = true;
      theme = "dark";
    };
    firefox = true;
  };

  packages = {
    utils.bat = true;
  };
};
```

---

## Part 3 — `.zmdl` — Module Definition

### 3.1 Purpose

`.zmdl` files define system options and their implementations. Each file maps to one module in the `zenos.*` namespace.

### 3.2 Top-Level Structure

```nix
_meta = {
  brief = "Module description";
  description = ''...'';
  maintainers = [ $m.doromiert ];
  license = $l.napalm;
};

# Options are declared as named attribute sets with _meta.type
# Actions implement the config changes

optionName = {
  _meta = {
    type = $type.boolean;
    default = false;
    brief = "Brief description of this option";
  };
  ! { ... }    # _action: applies when this option's path is truthy
  s! { ... }   # _saction: system-level NixOS config
  u! { ... }   # _uaction: cascades to all users (or current user if in user scope)
};
```

### 3.3 Action Shorthands

Actions are the implementation layer of a module. There are two classes:

- **Conditional (`!`)** — fires only when the option's value is truthy (i.e. the user has enabled it)
- **Unconditional (`!!`)** — fires always when the module is loaded, regardless of any option value. Use for base setup: registering service skeletons, creating required directories, writing base configs that conditional actions then extend.

| Shorthand | Class         | Scope                      |
| --------- | ------------- | -------------------------- |
| `! { }`   | Conditional   | Generic                    |
| `!! { }`  | Unconditional | Generic                    |
| `s! { }`  | Conditional   | NixOS system config        |
| `s!! { }` | Unconditional | NixOS system config        |
| `u! { }`  | Conditional   | Home Manager / user config |
| `u!! { }` | Unconditional | Home Manager / user config |

Multiple action blocks can co-exist on the same option. All six can be defined simultaneously.

#### Action Block Bodies

Action block bodies are **vanilla Nix expressions** with `$`-variable substitution applied. This means:

- `let ... in { ... }` works inside action blocks
- Standard Nix library functions are available via `$lib`
- Package overrides work: `$pkgs.foo.override { opt = $path.val; }`
- `$lib.gvariant.mkTuple`, `$lib.gvariant.mkUint32`, etc. all work

```nix
s! {
  let
    myPkg = $pkgs.zenos.zenboot.override {
      timeout = $path.timeout;
      osIcon  = $path.osIcon;
    };
    helper = x: x + 1;
  in {
    environment.systemPackages = [ myPkg ];
    boot.loader.timeout = helper $path.timeout;
  };
};
```

`_action`, `_saction`, and `_uaction` are **not** valid keywords — use the shorthand forms exclusively.

#### Dependency Guards

Conditional actions can require additional conditions beyond the option's own value:

```nix
s! [ $path.enable $cfg.system.desktop.enable ] {
  services.pipewire.enable = true;
};
```

All conditions in `[ ]` must be truthy for the block to apply. Unconditional actions (`!!`) do not accept dependency guards — they always run.

### 3.4 `enableOption` Sugar

The `enableOption` helper creates a standard boolean toggle with a generated description:

```nix
enable = enableOption {
  _meta.brief = "Install and enable $name";

  s! {
    environment.systemPackages = [ $pkgs.someapp ];
  };
};
```

This is equivalent to `_meta.type = $type.boolean` + a default of `false`.

### 3.5 `_let` Variables

```nix
_let defaultPort: $type.int = 8080;

port = {
  _meta = {
    type = $type.int;
    default = $v.defaultPort;
    brief = "Port to listen on";
  };
};
```

### 3.6 Freeform Scopes

`(freeform id)` declares an open attribute set where the key name is dynamically accessible via `$f.id`:

```nix
(freeform instance) = {
  _meta.brief = "A named $name instance";

  s! {
    services.myapp.instances.$f.instance = { ... };
  };
};
```

### 3.7 Type System (`$type`)

#### Primitives

| Type                           | Nix Equivalent                  | Description               |
| ------------------------------ | ------------------------------- | ------------------------- |
| `$type.bool` / `$type.boolean` | `types.bool`                    | Boolean                   |
| `$type.string`                 | `types.str`                     | UTF-8 string              |
| `$type.int`                    | `types.int`                     | Integer                   |
| `$type.float`                  | `types.float`                   | Float                     |
| `$type.null`                   | `types.nullOr types.anything`   | Null / unset              |
| `$type.path`                   | `types.path`                    | Nix-aware filesystem path |
| `$type.package`                | `types.package`                 | Single derivation         |
| `$type.packages`               | `types.attrsOf types.anything`  | Package tree scope        |
| `$type.color`                  | `types.str` (with `#` stripped) | Color string              |
| `$type.function (args)`        | `types.unspecified`             | Callable block            |

#### Typed Collections

Collections take a type parameter in brackets. The type parameter can itself be a typed collection (nested).

**List:**

```nix
$type.list [ $type.string ]           # listOf str
$type.list [ $type.int ]              # listOf int
$type.list [ $type.package ]          # listOf package
$type.list [ $type.list [ $type.string ] ]  # listOf (listOf str)
```

→ `lib.types.listOf <inner>`

**Set (attrsOf):**

Keys in a Nix attrset are always strings, so only the value type is specified.

```nix
$type.set [ $type.string ]            # attrsOf str
$type.set [ $type.int ]               # attrsOf int
$type.set [ $type.package ]           # attrsOf package
$type.set [ $type.list [ $type.int ] ] # attrsOf (listOf int)
```

→ `lib.types.attrsOf <value type>`

Bare `$type.set` (no brackets) remains `types.attrs` — untyped attrset.

**Function return type** (for options whose value is a callable):

```nix
$type.functionTo [ $type.string ]   # types.functionTo types.str
$type.functionTo [ $type.int ]      # types.functionTo types.int
$type.functionTo [ $type.package ]  # types.functionTo types.package
```

→ `lib.types.functionTo <return type>`

Note: `$type.function (args)` (no `To`) is for _callable logic blocks_. `$type.functionTo [ t ]` is for options that _store_ a function.

**Either (union):**

Accepts two or more types. All are valid for the option.

```nix
$type.either [ $type.string $type.int ]              # either str int
$type.either [ $type.string $type.int $type.bool ]   # one of string, int, bool
$type.either [ $type.string $type.list [ $type.int ] ] # string or list of int
```

→ `lib.types.either t1 (lib.types.either t2 t3 ...)` (left-folded)

**Enum:**

```nix
$type.enum [ "dark" "light" "classic" ]   # one of these string literals
```

→ `lib.types.enum [ "dark" "light" "classic" ]`

### 3.8 Full Example

```nix
_meta = {
  brief = "KeePassXC Password Manager";
  description = "Installs KeePassXC and manages its configuration.";
  maintainers = [ $m.doromiert ];
  license = $l.napalm;
};

# Unconditional: always register the config directory structure
s!! {
  environment.etc."zenos/keepassxc".source = ./assets/keepassxc-defaults;
};

enable = enableOption {
  _meta.brief = "Install $name";
  _meta.description = "Installs KeePassXC and writes the default config file.";

  u! {
    legacy.home-manager = {
      home.packages = [ $pkgs.keepassxc ];
      home.file.".config/keepassxc/keepassxc.ini".text = ''
        [General]
        ConfigVersion=2

        [GUI]
        ApplicationTheme=${$path.theme}
      '';
    };
  };

  s! {
    environment.systemPackages = [ $pkgs.keepassxc ];
    services.xserver.displayManager.sessionCommands =
      if $path.autostart then "${$pkgs.keepassxc}/bin/keepassxc &" else "";
  };
};

autostart = {
  _meta = {
    type = $type.boolean;
    default = false;
    brief = "Launch $name automatically on login";
    description = "Adds KeePassXC to display manager session commands.";
  };
};

theme = {
  _meta = {
    type = $type.enum [ "dark" "light" "classic" ];
    default = "dark";
    brief = "UI theme for $name";
  };
};
```

---

## Part 4 — `.zpkg` — Package Definition

### 4.1 Purpose

`.zpkg` files define a single derivation. They compile to a `pkgs.stdenv.mkDerivation` or `pkgs.rustPlatform.buildRustPackage` call (or other builders), with ZenOS ADL applied automatically.

### 4.2 Top-Level Keys

| Key      | Required | Description             |
| -------- | -------- | ----------------------- |
| `_meta`  | Yes      | Package metadata + deps |
| `_src`   | Yes      | Source fetcher          |
| `_build` | Yes      | Build configuration     |

### 4.3 `_meta` Block

```nix
_meta = {
  brief = "Short description";
  description = "Longer description";
  version = "1.2.3";
  maintainers = [ $m.doromiert ];
  license = $l.mit;

  deps = {
    global  = [ $pkgs.zlib $pkgs.openssl ];  # base pool
    build   = ++[ $pkgs.rustc $pkgs.cargo ]; # global + build tools
    run     = --[ $pkgs.openssl ];           # global minus openssl at runtime
    export  = [ $pkgs.zlib ];               # propagated to dependents (overwrites global)
  };
};
```

#### 4.3.1 Dep Cascade Rules

Each scope starts from `global` and applies modifiers:

| Syntax              | Behavior                             |
| ------------------- | ------------------------------------ |
| `= [ a b ]`         | Ignore global, use exactly this list |
| `= ++[ a b ]`       | `global ++ [ a b ]`                  |
| `= --[ a b ]`       | `global` with `a`, `b` removed       |
| `= --[ a ] ++[ b ]` | Chain: remove `a`, then append `b`   |
| _(omitted)_         | Inherit `global` unchanged           |

Operators are resolved left-to-right. Multiple `++` and `--` can be chained on the same line.

If `deps` is a flat list (not an attrset), it is treated as `deps.global` with all other scopes inheriting.

#### Nix Mapping

| ZenOS scope   | Nix parameter           |
| ------------- | ----------------------- |
| `deps.build`  | `nativeBuildInputs`     |
| `deps.run`    | `buildInputs`           |
| `deps.export` | `propagatedBuildInputs` |

### 4.4 `_src` Block

Accepts any fetcher from the injected `src.*` namespace, or a raw string (falls back to `fetchTarball`):

```nix
# GitHub
_src = src.github {
  owner = "sharkdp";
  repo = "bat";
  rev = "v0.24.0";
  hash = "sha256-...";
};

# URL tarball
_src = src.tarball {
  url = "https://example.com/app-1.0.tar.gz";
  hash = "sha256-...";
};

# Plain URL string (shorthand for fetchTarball)
_src = "https://example.com/app-1.0.tar.gz";

# Git
_src = src.git {
  url = "https://github.com/foo/bar";
  rev = "abc1234";
  hash = "sha256-...";
};
```

Available fetchers: `src.github`, `src.url`, `src.tarball`, `src.git`

### 4.5 `_build` Block

#### stdenv (default)

```nix
_build = {
  type = $type.stdenv;  # optional, this is the default

  buildPhase = ''
    make -j$NIX_BUILD_CORES
  '';
  installPhase = ''
    make install PREFIX=$out
  '';
};
```

#### Cargo / Rust

```nix
_build = {
  type = $type.cargo;
  cargoHash = "sha256-...";

  # Optional overrides
  postConfigure = ''
    export LIBGIT2_SYS_USE_PKG_CONFIG=1
  '';
};
```

### 4.6 ADL — Auto Dynamic Linking

ADL is **on by default** for all packages. It automatically splits `deps.run` entries into separate derivations and wires RPATH so the binary finds them at runtime without static linking or recompilation.

To disable:

```nix
_build = {
  type = $type.cargo;
  cargoHash = "sha256-...";
  adl = false;  # opt out
};
```

For Rust packages, ADL operates on `sys` crates (e.g. `zlib-sys`, `libgit2-sys`) that have system library counterparts. Non-sys crates are left as-is. You can explicitly control which crates get the ADL treatment:

```nix
_build = {
  type = $type.cargo;
  cargoHash = "sha256-...";
  adl = {
    shared = [ "zlib-sys" "libgit2-sys" ];  # explicit allowlist
  };
};
```

For stdenv packages, ADL runs `ldd` on the output and auto-generates `makeLibraryPath` from whatever is dynamically linked.

#### ADL Store Deduplication

ADL derivations are content-addressed by crate name + version + hash. If two packages depend on `ballsack-2.1.3.7`, only one derivation is built and both binaries RPATH-point to the same store path. No recompile.

### 4.7 `$deps` — Resolved Store Paths

Inside `_build` hook strings, `$deps.<name>` resolves to the Nix store path of a runtime dep:

```nix
postConfigure = ''
  export ZLIB_ROOT=${$deps.zlib}
  export LIBGIT2_SYS_USE_PKG_CONFIG=1
''
```

### 4.8 Full Example

```nix
_meta = {
  brief = "A cat(1) clone with wings";
  version = "0.24.0";
  maintainers = [ $m.doromiert ];
  license = $l.mit;

  deps = {
    global = [ $pkgs.zlib $pkgs.libgit2 ];
    build  = ++[ $pkgs.pkg-config $pkgs.rustc $pkgs.cargo ];
    run    = --[ $pkgs.libgit2 ]; # don't need libgit2 at runtime in this build
  };
};

_src = src.github {
  owner = "sharkdp";
  repo  = "bat";
  rev   = "v0.24.0";
  hash  = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
};

_build = {
  type      = $type.cargo;
  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  postConfigure = ''
    echo "zlib at: ${$deps.zlib}"
    export ZLIB_ROOT=${$deps.zlib}
  '';
};
```

---

## Part 5 — `_import` — Universal Import System

### 5.1 Purpose

`_import` is a first-class keyword available in all three file types (`.zcfg`, `.zmdl`, `.zpkg`). It replaces the old `conf()` / `importZen` split with a single unified mechanism.

### 5.2 Syntax

```nix
# Bare import — deep recursive merge into current scope
_import "hardware.zcfg";
_import "./themes/dark.zcfg";
_import /etc/zenos/shared.zcfg;   # absolute path

# Bound import — result assigned to a variable, accessible via $v.name
_import colors: $type.set = "./themes/colors.zcfg";
_import port: $type.int = "./defaults/ports.zcfg";

# Untyped bound import — type inferred
_import hw = "./hardware.zcfg";
```

### 5.3 Rules

**Path resolution:**

- Strings starting with `./` or `../` are relative to the current file
- Strings without a prefix are relative to the current file (same as `./`)
- Nix paths (no quotes, starting with `/`) are absolute

**Bare import behavior:**

- The imported file is evaluated in the same `$`-variable context as the current file
- Result is deep-recursively merged into the current scope (`lib.recursiveUpdate`)
- Conflicts: imported file wins (last-write semantics within the merge)
- Multiple bare imports are merged in declaration order, top to bottom

**Bound import behavior:**

- Result is bound as a `_let` variable accessible via `$v.name`
- Type annotation is optional — if provided, the transpiler emits a runtime type check
- The bound value does not merge into scope automatically

### 5.4 Transpiler Output

```nix
# Bare:
_import "hardware.zcfg";
→ __z_import_0 = import ./hardware.zcfg __zargs;
  # (merged at mkConfig time via lib.recursiveUpdate)

# Bound (typed):
_import colors: $type.set = "./themes/colors.zcfg";
→ _v.colors = import ./themes/colors.zcfg __zargs;

# Bound (untyped):
_import hw = "./hardware.zcfg";
→ _v.hw = import ./hardware.zcfg __zargs;
```

Bare imports are collected and merged in order before the rest of the file's config is applied, so local declarations always win over imported ones.

### 5.5 Examples

#### `.zcfg` — splitting a large host config

```nix
# host.zcfg
_import "hardware.zcfg";
_import "users.zcfg";

legacy.networking.hostName = "zephyr";
```

```nix
# hardware.zcfg
legacy = {
  boot.loader.systemd-boot.enable = true;
  fileSystems."/".device = "/dev/nvme0n1p2";
};
```

#### `.zmdl` — importing shared option defaults

```nix
# keepassxc.zmdl
_import defaults: $type.set = "../shared/app-defaults.zmdl";

theme = {
  _meta = {
    type = $type.enum [ "dark" "light" "classic" ];
    default = $v.defaults.theme;
    brief = "UI theme";
  };
};
```

#### `.zpkg` — importing shared build config

```nix
# bat.zpkg
_import rust: $type.set = "../shared/rust-build.zpkg";

_meta = {
  brief = "A cat(1) clone with wings";
  version = "0.24.0";
  deps = $v.rust.deps;
};

_src = src.github {
  owner = "sharkdp";
  repo  = "bat";
  rev   = "v0.24.0";
  hash  = "sha256-...";
};

_build = $v.rust.build // {
  cargoHash = "sha256-...";
};
```

---

## Part 6 — `.zstr` — Structure Definition

`.zstr` files define the top-level ZenOS option namespace. They are not typically user-authored — they exist to describe the shape of the entire config tree and attach modules to it.

For full syntax, `.zstr` uses the same DSL as `.zmdl` but only the structural declarations (`(freeform)`, `(zmdl)`, `(alias)`, `(packages)`, `(programs)`) are meaningful at the top level. See the existing `structure.zstr` for the canonical reference.

---

## Part 7 — Transpiler Behavior Summary

The ZenOS transpiler (`z-dialect.nix`) handles these transforms in order:

1. `_import "path"` → bare merge (collected, merged before local config)
2. `_import name: type = "path"` → `_v.name = import ./path __zargs`
3. `_import name = "path"` → `_v.name = import ./path __zargs` (untyped)
4. `(alias path)` → `{ _type = "alias"; target = "path"; }`
5. `(zmdl name)` → `{ _type = "zmdl"; target = "name"; }`
6. `(programs)` → `{ _type = "programs"; }`
7. `(packages)` → `{ _type = "packages"; }`
8. `(freeform id) =` → `__z_freeform_id =`
9. `s!! {` → `_saction_unconditional = {`
10. `u!! {` → `_uaction_unconditional = {`
11. `!! {` → `_action_unconditional = {`
12. `s! {` → `_saction = {`
13. `u! {` → `_uaction = {`
14. `! {` → `_action = {`
15. `_let name: type = val;` → `_v.name = val;`
16. `$f.id` → `"__Z_FREEFORM_ID__"` (resolved at `mkConfig` time)
17. `$v.name` → `_v.name`
18. `$cfg`, `$pkgs`, `$path`, `$name`, `$lib`, `$l`, `$m`, `$type`, `$c` → `__zargs.*`
19. Dep cascade operators `++[ ]` and `--[ ]` → `{ _op = "++"; val = [...]; }` attrsets (resolved at builder time)

---

## Appendix A — License Registry (`$l.*`)

| Key         | SPDX         | Notes                  |
| ----------- | ------------ | ---------------------- |
| `$l.napalm` | `NAPALM-2.0` | ZenOS custom license   |
| `$l.mit`    | `MIT`        | Standard MIT           |
| `$l.gpl2`   | `GPL-2.0`    | GNU GPL v2             |
| `$l.gpl3`   | `GPL-3.0`    | GNU GPL v3             |
| `$l.lgpl`   | `LGPL-2.1`   | GNU LGPL               |
| `$l.apache` | `Apache-2.0` | Apache 2.0             |
| `$l.mpl`    | `MPL-2.0`    | Mozilla Public License |
| `$l.unfree` | _(none)_     | Proprietary / unfree   |

---

## Appendix B — Maintainer Registry (`$m.*`)

Defined in `lib/maintainers.nix`. Fields: `name`, `email`, `github`, `discord`, `telegram`, `role`.

Current maintainers: `$m.doromiert`, `$m.catnowblue`

---

_End of ZenOS DSL Specification v0.1.0_
