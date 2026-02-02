{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.packages;
  inherit (lib)
    mkOption
    types
    flatten
    mapAttrsToList
    attrByPath
    isDerivation
    concatStringsSep
    ;

  # Reference the zenos package set, throwing an error if the overlay is missing
  zenPkgs =
    pkgs.zenos
      or (throw "ZenPkgs Error: 'pkgs.zenos' is missing. Ensure your 'pkgs' argument includes the ZenPkgs overlay.");

  # Recursive function to map the boolean/empty-set tree to actual packages
  findPackages =
    path: attrs:
    flatten (
      mapAttrsToList (
        name: value:
        let
          currentPath = path ++ [ name ];
          pkg = attrByPath currentPath null zenPkgs;
        in
        if value == true || value == { } then
          if pkg != null && isDerivation pkg then
            [ pkg ]
          else if pkg == null then
            builtins.trace
              "ZenPkgs Warning: Package 'pkgs.zenos.${concatStringsSep "." currentPath}' not found."
              [ ]
          else
            # Avoid auto-installing children of categories to prevent system bloat
            [ ]
        else if builtins.isAttrs value then
          findPackages currentPath value
        else
          [ ]
      ) attrs
    );

in
{
  meta = {
    description = "Provides a structured tree-based package selection system for ZenOS";
    longDescription = ''
      This module allows users to install packages from the `pkgs.zenos` collection 
      using a structured attribute set (tree) rather than a traditional flat list.

      ### Benefits
      - **Categorization:** Group packages logically by their function (e.g., `desktops.gnome`).
      - **User-Specific Toggling:** Easily enable/disable groups of software per-user.
      - **Sandbox Support:** Integrates with `zenos.config` for declarative user environment management.

      ### Example Usage
      ```nix
      zenos.packages.desktops.gnome.extensions = {
        forge = true;
        gsconnect = true;
      };
      ```
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options = {
    zenos.packages = mkOption {
      description = "Structured tree of packages to install globally from the ZenOS package set";
      default = { };
      type = types.submodule {
        freeformType = types.attrs;
      };
    };

    packages = mkOption {
      description = "System-level alias for `zenos.packages`";
      default = { };
      type = types.submodule {
        freeformType = types.attrs;
      };
    };

    zenos.config = mkOption {
      description = "Sandboxed user configuration container supporting structured package definitions";
      default = { };
      type = types.submodule {
        freeformType = types.attrs;
        options = {
          packages = mkOption {
            type = types.submodule { freeformType = types.attrs; };
            default = { };
            description = "Structured packages defined within the sandboxed configuration";
          };
          zenos.packages = mkOption {
            type = types.submodule { freeformType = types.attrs; };
            default = { };
            description = "Namespaced structured packages within the sandboxed configuration";
          };
        };
      };
    };

    users.users = mkOption {
      type = types.attrsOf (
        types.submodule (
          { config, ... }:
          {
            options.zenos.packages = mkOption {
              description = "User-specific structured package installation tree";
              default = { };
              type = types.submodule { freeformType = types.attrs; };
            };
            config = {
              # NixOS expects a flat list in 'packages'; we generate it from the tree
              packages = findPackages [ ] config.zenos.packages;
            };
          }
        )
      );
    };
  };

  config = {
    # Synchronize the global alias with the primary option
    zenos.packages = config.packages;

    # Merge sandboxed package definitions into the global system set
    packages = config.zenos.config.packages or { };

    # Map the entire tree structure to the system environment
    environment.systemPackages = findPackages [ ] cfg;
  };
}
