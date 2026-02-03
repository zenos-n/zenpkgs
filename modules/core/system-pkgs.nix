{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.system;

  # Recursively resolves attribute sets into a flat list of derivations
  resolvePackages =
    path: set:
    lib.concatLists (
      lib.mapAttrsToList (
        name: value:
        let
          currentPath = path ++ [ name ];
          pkgFromPath = lib.attrByPath currentPath null pkgs;
        in
        if lib.isDerivation value then
          [ value ]
        else if lib.isAttrs value && value != { } then
          resolvePackages currentPath value
        else if pkgFromPath != null && lib.isDerivation pkgFromPath then
          [ pkgFromPath ]
        else
          [ ]
      ) set
    );
in
{
  meta = {
    description = ''
      Automated package resolution for ZenOS system sets

      This module allows users to define packages as an attribute set under 
      `zenos.system.packages`. It recursively scans the set and resolves 
      them to actual derivations, either from the provided values or by 
      looking up the path in the global `pkgs` set.

      This is particularly useful for organizing system software into logical 
      categories within your configuration.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.system = {
    packages = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Declarative attribute set of system packages to install

        Attribute set of system packages to be automatically resolved and 
        installed. Leaf nodes can be empty sets to trigger automatic lookup 
        in nixpkgs.
      '';
      example = lib.literalExpression ''
        {
          editors.vim = pkgs.vim;
          tools.git = { }; # Resolves to pkgs.git automatically
        }
      '';
    };
  };

  config = {
    environment.systemPackages = resolvePackages [ ] cfg.packages;
  };
}
