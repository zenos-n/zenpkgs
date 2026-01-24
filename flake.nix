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

          zenPkgNames = builtins.attrNames (
            lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./pkgs)
          );

          zenOverlay =
            final: prev:
            lib.genAttrs zenPkgNames (name: final.callPackage ./pkgs/${name}/package.nix { inherit lib; });

          pkgs = import nixpkgs {
            inherit system;
            overlays = [ zenOverlay ];
          };

        in
        lib.genAttrs zenPkgNames (name: pkgs.${name})
      );
    };
}
