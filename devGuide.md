/\* \* [P17] CLMD ARTIFACT

- TYPE: SYSTEM DOCUMENTATION
- TARGET: ZENOS ARCHITECTURE V2
  \*/

# ZenOS Maintainer & Developer Survival Kit

This document outlines the architectural flow of ZenOS and provides implementation patterns for packages, modules, and hosts within the `zenpkgs` overlay ecosystem.

## 1. Architectural Overview

The ZenOS architecture abstracts standard NixOS evaluation to provide a cleaner user experience (via `.zcfg` files) and strict namespace isolation (`zenos.*`).

- **`flake.nix`**: The public entry point. Consumes `zenpkgs`, executes `zenCore.mkHosts`, and dynamically generates buildable `.iso` targets.
- **`zen-core.nix`**: The internal engine. Handles recursive directory walking, dynamic package injection with auto-pname, and transparent configuration wrapping.
- **`bridge.nix`**: The state translator. Auto-routes modules, manages the set-based package installer, and handles the `legacy` passthrough inheritance.
- **`docs.nix`**: The strict validation layer. Mandates metadata completeness (`meta.brief`) across the ecosystem.

---

## 2. Package Development (`pkgs/`)

`zen-core.nix` uses `mkPackageTree` to recursively scan the `pkgs/` directory. Any `.nix` file (or `default.nix` in a directory) is automatically added to the `zenos` overlay.

### 2.1 Standard Package Snippet

Developers DO NOT need to declare `pname`. The system automatically infers it from the filename or directory name and injects it as a function argument.

```nix
# FILE: pkgs/tools/popcorn-cli.nix
{
    lib,
    stdenv,
    fetchFromGitHub,
    pname, # Automatically injected by zen-core.nix based on filename
}:

stdenv.mkDerivation rec {
    inherit pname;
    version = "1.0.0";

    src = fetchFromGitHub {
        owner = "negative-zero-inft";
        repo = pname;
        rev = version;
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    meta = with lib; {
        # CRITICAL: docs.nix requires `brief` for all pkgs.zenos.*
        brief = "A highly efficient CLI tool for ZenOS operations.";
        homepage = "[https://neg-zero.com](https://neg-zero.com)";
        license = licenses.napalm;
        maintainers = [ maintainers.doromiert ];
    };
}
```

---

## 3. Module Development (`modules/`)

ZenOS uses **Path-Based Auto-Namespacing**. You do not declare `options.zenos.system...`. The engine looks at your file path (e.g., `modules/programs/popcorn.nix`) and automatically maps it to both `system.programs.popcorn` and `users.<name>.programs.popcorn`.

For structural modules (e.g., `modules/desktops/`), the engine routes them to logical endpoints based on internal mapping rules.

### 3.1 Standard Module Snippet

The module receives `cfg` (its own isolated config block) and an `isUserContext` boolean to allow for logic branching between system-wide and user-wide deployments.

```nix
# FILE: modules/programs/popcorn.nix
{ lib, pkgs, cfg, isUserContext, ... }:

{
    # Controls where this module is allowed to be attached.
    # By default, both are true. Blacklist as necessary.
    meta = {
        allowSystem = true;
        allowUser = false; # Example: Kernel tuners can't be user-scoped
    };

    # Relative to your auto-generated namespace
    options = {
        enable = lib.mkEnableOption "Popcorn Kernel tuning";

        strictMode = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enables aggressive memory reaping.";
        };
    };

    # Implementation logic
    config = lib.mkIf cfg.enable {
        # Standard NixOS options go here. The engine bridges them automatically.
        boot.kernel.sysctl = {
            "vm.swappiness" = if cfg.strictMode then 10 else 60;
        };
    };
}
```

---

## 4. Set-Based Package Setup

ZenOS abandons standard NixOS list arrays (`environment.systemPackages = [ pkgs.a pkgs.b ];`) in favor of a declarative boolean tree. This allows easy inheritance, toggling, and overriding of nested packages.

### 4.1 Usage in Configuration

Package trees map 1:1 with the `pkgs.zenos.*` structure.

```nix
# FILE: hosts/doromi-tul/host.zcfg

system.packages = {
    # Installs the root package `pkgs.zenos.amity`
    amity = true;

    tools = {
        # Installs all packages under `pkgs.zenos.tools` (recursively)
        enableAll = true;

        # Explicitly ignore a child package even if enableAll is true
        bloatware = false;
    };

    # Escape hatch for standard NixPkgs outside the ZenOS overlay
    legacy = {
        htop = true;
        fastfetch = true;
    };
};

# User-specific package trees follow the exact same logic
users.doromi.packages = {
    games.minecraft = true;
};
```

---

## 5. The Legacy Escape Hatch (`bridge.nix`)

The `legacy` attribute intercepts variables and recursively applies them to the root NixOS configuration, bypassing the sandbox.

```nix
# FILE: hosts/doromi-tul/host.zcfg

# Maps directly to `networking.hostName` in standard NixOS
legacy.networking.hostName = "doromi-tul";

# Modifies distro identity metadata in standard NixOS
legacy.system.nixos = {
    distroName = "ZenOS";
    distroId = "zenos";
};
```

---

## 6. Host Configurations (`hosts/`)

Files ending in `.zcfg` or `.nzo` are automatically wrapped by the engine. You write raw Nix attribute sets—no function headers (`{ pkgs, ... }:`) are required.

```nix
# FILE: hosts/doromi-tul/host.zcfg

users.doromi = {
    legacy = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
    };
};

system.packages = {
    popcorn-cli = true;
    legacy.git = true;
};

legacy = {
    boot.loader.systemd-boot.enable = true;
    system.stateVersion = "24.05";
    isoImage.isoBaseName = "zenos";
};
```

---

## 7. Build & Generation Commands

**Evaluate an entire Host:**

```bash
nix build .#nixosConfigurations.doromi-tul.config.system.build.toplevel
```

**Generate a bootable ISO:**

```bash
nix build .#doromi-tul-iso
```

**Check Docs Completeness:**

```bash
nix eval .#docs.x86_64-linux
```
