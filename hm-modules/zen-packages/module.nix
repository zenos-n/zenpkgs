{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.packages;
  inherit (lib)
    mkIf
    mkOption
    types
    flatten
    mapAttrsToList
    attrByPath
    isDerivation
    concatStringsSep
    recursiveUpdate
    ;

  # [1] Construct Mapping
  # Merges standard packages and sandboxed config packages for the user environment
  mappedCfg = recursiveUpdate cfg (config.zenos.config.packages or { });

  # [2] Source Selection
  # Fallback or throw if zenos is missing (Home Manager context)
  zenPkgs =
    pkgs.zenos
      or (throw "ZenPkgs HM Error: 'pkgs.zenos' is missing. Ensure your Home Manager 'pkgs' includes the ZenPkgs overlay.");

  # Recursive function to map the tree structure to actual derivations
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
              "ZenPkgs HM Warning: Package 'pkgs.zenos.${concatStringsSep "." currentPath}' not found."
              [ ]
          else
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
    description = "Provides a structured tree-based package selection system for Home Manager";
    longDescription = ''
      This module provides the Home Manager implementation of the ZenPkgs 
      structured package picker. It allows users to manage their personal 
      software environment using a clean, categorized attribute tree.

      ### Features
      - **Declarative Environments:** Organize user software into logical categories.
      - **Sandbox Integration:** Respects `zenos.config` definitions within the HM context.
      - **Safe Installation:** Resolves tree paths directly to `home.packages`.

      Note: This module intentionally avoids aliasing the root `packages` path 
      to prevent conflicts with native Home Manager package lists.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options = {
    zenos.packages = mkOption {
      description = "Structured tree of packages to install for the current user from the ZenOS package set";
      default = { };
      type = types.submodule {
        freeformType = types.attrs;
      };
    };

    zenos.config = mkOption {
      description = "Sandboxed configuration container for the current Home Manager user";
      default = { };
      type = types.submodule {
        freeformType = types.attrs;
        options = {
          packages = mkOption {
            type = types.submodule { freeformType = types.attrs; };
            default = { };
            description = "Structured packages defined within the sandboxed HM configuration";
          };
        };
      };
    };
  };

  config = {
    # Resolve the final package list and inject into the Home Manager environment
    home.packages = findPackages [ ] mappedCfg;
  };
}
