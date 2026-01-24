{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib // {
        licenses = pkgs.lib.licenses // {
          napl = {
            shortName = "napl";
            fullName = "The Non-Aggression License 1.0";
            url = "https://github.com/negative-zero-inft/nap-license";
            free = true;
            redistributable = true;
            copyleft = true;
          };
        };
      };
      zenPkgsMaintainers = import ./maintainers.nix { inherit pkgs lib; };

      zenModulesRaw = builtins.readDir ./modules;
      moduleDirs = lib.filterAttrs (n: t: t == "directory") zenModulesRaw;
      zenModules = lib.mapAttrs (n: v: pkgs.callPackage ./modules/${n}/module.nix { }) moduleDirs;

      zenPkgsRaw = builtins.readDir ./pkgs;
      packageDirs = lib.filterAttrs (n: t: t == "directory") zenPkgsRaw;
      zenPkgs = lib.mapAttrs (
        n: v:
        pkgs.callPackage ./pkgs/${n}/package.nix {
          inherit lib;
          maintainers = zenPkgsMaintainers;
        }
      ) packageDirs;
    in
    {
      packages.${system} = zenPkgs;

      nixosModules.${system} = zenModules;
    };
}
