{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;
      zenPkgsMaintainers = import ./maintainers.nix { inherit pkgs lib; };

      zenModulesRaw = builtins.readDir ./modules;
      moduleDirs = lib.filterAttrs (n: t: t == "directory") zenModulesRaw;
      zenModules = lib.mapAttrs (n: v: pkgs.callPackage ./modules/${n}/module.nix { }) moduleDirs;

      zenPkgsRaw = builtins.readDir ./pkgs;
      packageDirs = lib.filterAttrs (n: t: t == "directory") zenPkgsRaw;
      zenPkgs = lib.mapAttrs (
        n: v: pkgs.callPackage ./pkgs/${n}/package.nix { maintainers = zenPkgsMaintainers; }
      ) packageDirs;
    in
    {
      packages.${system} = zenPkgs;

      nixosModules.${system} = zenModules;
    };
}
