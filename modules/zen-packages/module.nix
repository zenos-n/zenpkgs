# LOCATION: modules/zen-packages.nix
# DESCRIPTION: Allows installing packages using a structured syntax mapping to pkgs.zenos

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.packages;

  # [FIX] Handle the case where pkgs.zenos is missing due to missing overlay in specialArgs
  zenPkgs =
    pkgs.zenos
      or (throw "ZenPkgs Error: 'pkgs.zenos' is missing. Ensure your 'pkgs' argument includes the ZenPkgs overlay.");

  # Recursive function to map the boolean/empty-set tree to actual packages
  findPackages =
    path: attrs:
    lib.flatten (
      lib.mapAttrsToList (
        name: value:
        let
          currentPath = path ++ [ name ];
          # Try to locate the package in pkgs.zenos
          pkg = lib.attrByPath currentPath null zenPkgs;
        in
        if value == true || value == { } then
          if pkg != null && lib.isDerivation pkg then
            [ pkg ]
          else if pkg == null then
            builtins.trace
              "ZenPkgs Warning: Package 'pkgs.zenos.${lib.concatStringsSep "." currentPath}' not found."
              [ ]
          else
            # It's a category (e.g. desktops.gnome), don't auto-install children to avoid bloat.
            [ ]
        else if builtins.isAttrs value then
          findPackages currentPath value
        else
          [ ]
      ) attrs
    );

in
{
  options = {
    # 1. The main option
    zenos.packages = lib.mkOption {
      description = "Select packages to install from pkgs.zenos using a tree structure.";
      default = { };
      type = lib.types.submodule {
        freeformType = lib.types.attrs;
      };
    };

    # 2. System Root Alias
    # Allows 'packages = { ... }' in configuration.nix and zenos.config
    packages = lib.mkOption {
      description = "Alias for zenos.packages";
      default = { };
      type = lib.types.submodule {
        freeformType = lib.types.attrs;
      };
    };

    # 3. Sandbox Loader Support
    # Defines the schema for 'zenos.config' so your 'main.nix' import works.
    zenos.config = lib.mkOption {
      description = "Sandboxed user configuration container.";
      default = { };
      type = lib.types.submodule {
        freeformType = lib.types.attrs;
        options = {
          # Allow 'packages' inside the sandbox
          packages = lib.mkOption {
            type = lib.types.submodule { freeformType = lib.types.attrs; };
            default = { };
          };
          # Allow 'zenos.packages' inside the sandbox
          zenos.packages = lib.mkOption {
            type = lib.types.submodule { freeformType = lib.types.attrs; };
            default = { };
          };
        };
      };
    };

    # 4. User Module Injection
    # Extends users.users.<name> to support the structured package picker.
    users.users = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { config, ... }:
          {
            options = {
              # We use 'zenos.packages' here because 'packages' is already defined by NixOS as a list.
              zenos.packages = lib.mkOption {
                description = "User-specific structured package installation.";
                default = { };
                type = lib.types.submodule { freeformType = lib.types.attrs; };
              };
            };
            config = {
              # Convert our tree structure into the flat list NixOS expects
              packages = findPackages [ ] config.zenos.packages;
            };
          }
        )
      );
    };
  };

  config = {
    # 1. Sync aliases (Root <-> zenos.packages)
    zenos.packages = config.packages;

    # 2. Merge Sandbox Config (zenos.config.packages -> zenos.packages)
    # This ensures packages defined in main.nix are actually installed.
    packages = config.zenos.config.packages or { };

    # 3. Install found packages to system
    environment.systemPackages = findPackages [ ] cfg;
  };
}
