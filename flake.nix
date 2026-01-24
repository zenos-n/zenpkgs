{
  description = "ZenPkgs - A collection of packages and modules for ZenOS";

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

      generateModuleTree =
        path:
        let
          entries = builtins.readDir path;
        in
        nixpkgs.lib.filterAttrs (n: v: v != null) (
          nixpkgs.lib.mapAttrs (
            name: type:
            if type == "directory" then
              # Priority 1: Directory with default.nix is a module
              if builtins.pathExists (path + "/${name}/default.nix") then
                path + "/${name}/default.nix"
              else
                # Priority 2: Recurse into directory
                let
                  subtree = generateModuleTree (path + "/${name}");
                in
                if subtree == { } then null else subtree
            # Priority 3: Standalone .nix file is a module
            else if type == "regular" && nixpkgs.lib.hasSuffix ".nix" name && name != "default.nix" then
              path + "/${name}"
            else
              null
          ) entries
        );

      zenOverlay =
        final: prev:
        let
          lib = prev.lib;

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

      nixosModules = if builtins.pathExists ./modules then generateModuleTree ./modules else { };

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

      lib.mkUtils = import ./lib/utils.nix;
    };
}
