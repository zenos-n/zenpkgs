{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgsRaw = import nixpkgs { inherit system; };

          lib = pkgsRaw.lib // {
            licenses = pkgsRaw.lib.licenses // {
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

          # Recursive discovery function
          # Walks the directory tree. If it finds 'package.nix', it treats it as a package.
          # Otherwise, it treats it as a category and recurses deeper.
          discoverPackages =
            path:
            let
              entries = builtins.readDir path;
              isPackage = builtins.pathExists (path + "/package.nix");
            in
            if isPackage then
              (final: prev: final.callPackage (path + "/package.nix") { inherit lib; })
            else
              (
                final: prev:
                let
                  subDirs = lib.filterAttrs (n: v: v == "directory") entries;

                  # Generate children by calling the recursive function
                  children = lib.mapAttrs (name: _: (discoverPackages (path + "/${name}")) final prev) subDirs;

                  # Filter out empty sets or sets that only contain the recursion flag
                  # This prevents empty directories from appearing as attributes
                  validChildren = lib.filterAttrs (
                    n: v:
                    v != { }
                    && (if (v ? recurseForDerivations) then (builtins.length (builtins.attrNames v) > 1) else true)
                  ) children;
                in
                lib.recurseIntoAttrs validChildren
              );

          zenPkgNames = builtins.attrNames (
            lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./pkgs)
          );

          # Modified overlay to use the recursive discovery
          zenOverlay = final: prev: (discoverPackages ./pkgs) final prev;

          pkgs = import nixpkgs {
            inherit system;
            overlays = [ zenOverlay ];
          };

        in
        lib.genAttrs zenPkgNames (name: pkgs.${name})
      );
    };
}
