{
  description = "ZenOS - System Architecture Framework";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
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
      # The coreModule now ONLY provides options.
      # Logic is handled by the builder and the host generator to prevent recursion.
      coreModule =
        { config, lib, ... }:
        {
          options.zenos = {
            legacy = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = { };
              description = "Raw NixOS options merged at the root level.";
            };

            system = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  programs = lib.mkOption {
                    type = lib.types.submodule {
                      options = {
                        legacy = lib.mkOption {
                          type = lib.types.attrsOf lib.types.anything;
                          default = { };
                          description = "Raw NixOS system-level program settings.";
                        };
                      };
                    };
                    default = { };
                  };
                };
              };
              default = { };
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
                        description = "Raw NixOS user settings mapped to users.users.${name}.";
                      };
                      programs = lib.mkOption {
                        type = lib.types.submodule {
                          options = {
                            legacy = lib.mkOption {
                              type = lib.types.attrsOf lib.types.anything;
                              default = { };
                              description = "Raw program settings for ${name} (e.g., mapped via Home Manager).";
                            };
                          };
                        };
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

          # -- PASSTHROUGH CONFIGURATION --
          # Automatically map the evaluated legacy configs back to the actual NixOS attributes.
          config = {
            programs = config.zenos.system.programs.legacy;

            users.users = lib.mapAttrs (
              name: userCfg: builtins.removeAttrs userCfg.legacy [ "home-manager" ]
            ) config.zenos.users;

            home-manager.users = lib.mapAttrs (
              name: userCfg: userCfg.legacy.home-manager or { }
            ) config.zenos.users;
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
