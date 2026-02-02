# LOCATION: hmModules/zen-packages.nix
# DESCRIPTION: Home Manager version of the package picker

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.packages;

  # [FIX] Fallback or throw if zenos is missing (Home Manager context)
  zenPkgs =
    pkgs.zenos
      or (throw "ZenPkgs HM Error: 'pkgs.zenos' is missing. Ensure your Home Manager 'pkgs' includes the ZenPkgs overlay.");

  findPackages =
    path: attrs:
    lib.flatten (
      lib.mapAttrsToList (
        name: value:
        let
          currentPath = path ++ [ name ];
          pkg = lib.attrByPath currentPath null zenPkgs;
        in
        if value == true || value == { } then
          if pkg != null && lib.isDerivation pkg then
            [ pkg ]
          else if pkg == null then
            builtins.trace
              "ZenPkgs HM Warning: Package 'pkgs.zenos.${lib.concatStringsSep "." currentPath}' not found."
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
  options = {
    zenos.packages = lib.mkOption {
      description = "Select packages to install from pkgs.zenos using a tree structure.";
      default = { };
      type = lib.types.submodule {
        freeformType = lib.types.attrs;
      };
    };

    # We do NOT alias top-level 'packages' here because it might conflict
    # if the user defines 'packages = []' (which is invalid in HM, but confusing).
  };

  config = {
    home.packages = findPackages [ ] cfg;
  };
}
