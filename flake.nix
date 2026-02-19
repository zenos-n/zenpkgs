{
  description = "ZenPKGS - Negative Zero Overlay & Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib;
      zenCore = import ./lib/zen-core.nix { inherit lib inputs; };
      moduleTree = zenCore.mkModuleTree ./modules;

      autoMounter =
        { lib, ... }:
        {
          options.zenos =
            let
              # 1. Define the Legacy Passthrough Option
              legacyOption = lib.mkOption {
                type = lib.types.attrs;
                default = { };
                description = "Passthrough attributes to the underlying NixOS configuration";
              };

              # 2. Common Options
              commonOptions = { };

              # 3. Programs Submodule (With Internal Legacy Support)
              programsSubmodule = lib.types.submodule {
                imports = moduleTree.programModules or [ ];
                options = commonOptions // {
                  # Allows users to specify legacy programs inside the programs block
                  legacy = legacyOption;
                };
                # ALLOW ARBITRARY ATTRIBUTES (for automatic inheritance)
              };
            in
            {
              # --- ROOT LEVEL LEGACY ---
              legacy = legacyOption;

              users = lib.mkOption {
                type = lib.types.attrsOf (
                  lib.types.submodule {
                    imports = moduleTree.userModules or [ ];
                    options = commonOptions // {
                      # --- USER LEVEL LEGACY ---
                      legacy = legacyOption;

                      programs = lib.mkOption {
                        type = programsSubmodule;
                        default = { };
                      };
                    };
                  }
                );
                default = { };
              };

              system = lib.mkOption {
                type = lib.types.submodule {
                  imports = moduleTree.system or [ ];
                  options = commonOptions // {
                    programs = lib.mkOption {
                      type = programsSubmodule;
                      default = { };
                    };
                  };
                };
                default = { };
              };
            }
            // (
              let
                special = [
                  "system"
                  "userModules"
                  "programModules"
                ];
                generic = lib.removeAttrs moduleTree special;
              in
              lib.mapAttrs (
                name: paths:
                lib.mkOption {
                  type = lib.types.submodule {
                    imports = paths;
                    options = commonOptions;
                  };
                  default = { };
                }
              ) generic
            );
        };
    in
    {
      inputs = inputs;
      lib = (zenCore.mkLib ./lib) // {
        core = import ./lib/zen-core.nix;
      };

      overlays.default = final: prev: {
        zenos = (prev.zenos or { }) // (zenCore.mkPackageTree final ./pkgs);
      };

      nixosModules.structure =
        { ... }:
        {
          imports = [
            ./modules/bridge.nix
            autoMounter
          ];
        };

      nixosModules.default =
        { ... }:
        {
          imports = [ self.nixosModules.structure ];
          nixpkgs.overlays = [ self.overlays.default ];
        };

      docs =
        let
          gen =
            system:
            import ./lib/docs.nix {
              inherit
                inputs
                self
                system
                moduleTree
                ;
            };
        in
        {
          x86_64-linux = gen "x86_64-linux";
          aarch64-linux = gen "aarch64-linux";
        };
    };
}
