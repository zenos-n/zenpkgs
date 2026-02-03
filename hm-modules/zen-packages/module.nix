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

  zenPkgs =
    pkgs.zenos
      or (throw "ZenPkgs Error: 'pkgs.zenos' is missing. Ensure your 'pkgs' argument includes the ZenPkgs overlay.");

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
    description = ''
      Structured tree-based package selection system for ZenOS

      This module allows users to install packages from the ZenPkgs set 
      using a declarative attribute tree. It maps keys in your config 
      directly to derivations in `pkgs.zenos`.

      ### Usage Example
      ```nix
      zenos.packages = {
        editors.vscode = true;
        browsers.firefox = { };
      };
      ```
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options = {
    packages = mkOption {
      type = types.submodule { freeformType = types.attrs; };
      default = { };
      description = ''
        Global package selection tree

        The primary interface for installing ZenOS software categories. 
        Setting a leaf node to `true` or `{}` triggers installation.
      '';
    };

    zenos.packages = mkOption {
      type = types.submodule { freeformType = types.attrs; };
      default = { };
      description = "Alias for the global package selection tree";
    };
  };

  config = {
    environment.systemPackages = findPackages [ ] cfg;
  };
}
