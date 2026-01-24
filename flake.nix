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

          # PHASE 1: Pure Discovery
          # Scans the disk and builds a tree of paths.
          # Returns: path (if package) OR attrset (if category) OR null (if empty)
          # Does NOT involve 'final', 'prev', or 'callPackage'.
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

                # Recursively map children
                children = lib.mapAttrs (name: _: generatePackageTree (path + "/${name}")) subDirs;

                # Filter out nulls (empty directories)
                validChildren = lib.filterAttrs (n: v: v != null) children;
              in
              if validChildren == { } then null else validChildren;

          # PHASE 2: Inflation
          # Takes the pure tree and applies the overlay logic (callPackage).
          inflateTree =
            tree: final: prev:
            if builtins.isPath tree then
              # It's a path, so it's a package
              final.callPackage tree { inherit lib; }
            else
              # It's a set, so it's a category
              lib.recurseIntoAttrs (lib.mapAttrs (name: value: inflateTree value final prev) tree);

          zenPkgNames = builtins.attrNames (
            lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./pkgs)
          );

          # The Overlay
          # We generate the tree structure once (purely), then inflate it with Nix logic.
          zenOverlay =
            final: prev:
            let
              tree = generatePackageTree ./pkgs;
            in
            if tree == null then { } else inflateTree tree final prev;

          pkgs = import nixpkgs {
            inherit system;
            overlays = [ zenOverlay ];
          };

        in
        lib.genAttrs zenPkgNames (name: pkgs.${name})
      );
    };
}
