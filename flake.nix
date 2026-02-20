{
  description = "ZenPKGS - Negative Zero Overlay & Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      zenCore = import ./lib/zen-core.nix { inherit lib inputs; };
      moduleTree = zenCore.mkModuleTree ./modules;

      autoMounter =
        { lib, pkgs, ... }:
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
              pkgSetType = lib.types.attrsOf (lib.types.either lib.types.bool lib.types.attrs);
              commonOptions = {
                meta = lib.mkOption {
                  type = lib.types.attrs;
                  default = { };
                  description = "ZenOS internal module metadata";
                };

                # NEW: The aggregation buffer for programs
                __installPackages = lib.mkOption {
                  type = lib.types.listOf lib.types.package;
                  default = [ ];
                  description = "Internal buffer of packages requested by enabled programs";
                };

                __configFiles = lib.mkOption {
                  type = lib.types.attrs;
                  default = { };
                  description = "Internal buffer of configuration files (mapped to /etc or ~/.config)";
                };

                _devlegacy = legacyOption;
              };

              # 3. Programs Submodule (With Internal Legacy Support)
              programsSubmodule = lib.types.submoduleWith {
                modules = (moduleTree.programs or [ ]) ++ [
                  {
                    options = commonOptions // {
                      # Allows users to specify legacy programs inside the programs block
                      legacy = legacyOption;
                    };
                  }
                ];
                specialArgs = {
                  inherit pkgs;
                  hm = home-manager.lib.hm;
                };
              };
            in
            {
              # --- ROOT LEVEL LEGACY ---
              legacy = legacyOption;

              users = lib.mkOption {
                type = lib.types.attrsOf (
                  lib.types.submodule {
                    options = {
                      legacy = legacyOption;
                      packages = lib.mkOption {
                        type = pkgSetType;
                        default = { };
                      };
                      programs = lib.mkOption {
                        type = programsSubmodule;
                        default = { };
                      };
                    }
                    // commonOptions;
                  }
                );
                default = { };
              };

              system = lib.mkOption {
                type = lib.types.submodule {
                  imports = moduleTree.system or [ ];
                  options = commonOptions // {
                    packages = lib.mkOption {
                      type = pkgSetType;
                      default = { };
                    };
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
                  "programs" # Add this to prevent root mounting
                ];
                generic = lib.removeAttrs moduleTree special;
              in
              lib.mapAttrs (
                name: paths:
                lib.mkOption {
                  type = lib.types.submoduleWith {
                    modules = paths ++ [ { options = commonOptions; } ];
                    specialArgs = {
                      hm = home-manager.lib.hm;
                      inherit pkgs;
                    };
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
          _module.args = {
            # Pass the raw moduleTree so bridge.nix can see the structure
            inherit moduleTree;
          };
          imports = [
            home-manager.nixosModules.home-manager
            ./modules/bridge.nix
            autoMounter
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
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
