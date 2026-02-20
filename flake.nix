{
  description = "ZenOS - System Architecture Framework";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";

      zenBuilder = import ./lib/module-builder.nix { inherit lib; };
      zenCore = import ./lib/zen-core.nix { inherit lib inputs; };

      zenOSModules = zenBuilder.mapZenModules ./modules [ ];

      # The coreModule now ONLY provides options.
      # Logic is handled by the builder and the host generator to prevent recursion.
      coreModule =
        { ... }:
        {
          options.zenos = {
            legacy = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = { };
              description = "Raw NixOS options merged at the root level.";
            };

            users = lib.mkOption {
              type = lib.types.attrsOf (
                lib.types.submodule (
                  { name, ... }:
                  {
                    options = {
                      legacy = lib.mkOption {
                        type = lib.types.attrsOf lib.types.anything;
                        default = { };
                        description = "Raw NixOS user settings for ${name}.";
                      };
                      programs = lib.mkOption {
                        type = lib.types.attrsOf lib.types.anything;
                        default = { };
                      };
                    };
                  }
                )
              );
              default = { };
              description = "ZenOS user configurations.";
            };
          };
        };

      allZenModules = zenOSModules ++ [ coreModule ];

    in
    {
      lib.core = zenCore;
      overlays.default = final: prev: {
        zenos = (zenCore.mkPackageTree prev ./pkgs) // {
          legacy = prev;
        };
      };
      nixosModules.default = {
        imports = allZenModules;
      };
      nixosModules.structure = {
        imports = allZenModules;
      };

      docs = import ./lib/docs.nix {
        inherit inputs self system;
        zenOSModules = allZenModules;
        moduleTree =
          let
            getFiles =
              dir:
              if builtins.pathExists dir then
                zenCore.walkDir dir (n: t: t == "regular" && (lib.hasSuffix ".nix" n || lib.hasSuffix ".zmdl" n))
              else
                [ ];
          in
          {
            modules = map (e: e.absPath) (getFiles ./modules);
          };
      };
    };
}
