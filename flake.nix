# LOCATION: zenpkgs/flake.nix
# DESCRIPTION: Imports ./lib/utils.nix and exports it.

{
  description = "ZenPKGS - Custom Package Set";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      zenOverlay =
        final: prev:
        let
          lib = prev.lib;

          # PHASE 1: Pure Discovery
          generatePackageTree =
            path:
            let
              entries = builtins.readDir path;
              isPackage = builtins.pathExists (path + "/package.nix");
            in
            if isPackage then
              path + "/package.nix"
            else
              let
                subDirs = lib.filterAttrs (n: v: v == "directory") entries;
                children = lib.mapAttrs (name: _: generatePackageTree (path + "/${name}")) subDirs;
                validChildren = lib.filterAttrs (n: v: v != null) children;
              in
              if validChildren == { } then null else validChildren;

          # PHASE 2: Inflation
          inflateTree =
            tree: f: p:
            if builtins.isPath tree then
              f.callPackage tree {
                lib = f.lib // {
                  licenses = f.lib.licenses // {
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
              }
            else
              lib.recurseIntoAttrs (lib.mapAttrs (name: value: inflateTree value f p) tree);

          tree = generatePackageTree ./pkgs;
        in
        if tree == null then { } else inflateTree tree final prev;

    in
    {
      overlays.default = zenOverlay;

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };
          zenPkgNames = builtins.attrNames (
            nixpkgs.lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./pkgs)
          );
        in
        nixpkgs.lib.genAttrs zenPkgNames (name: pkgs.${name})
      );

      # EXPORT: Import the implementation from the file
      lib.mkUtils = import ./lib/utils.nix;
    };
}
