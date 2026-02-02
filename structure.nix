# LOCATION: flake.nix
# DESCRIPTION: The Entry Point. Defines the ZenOS Sandbox and Mapping.

{
  description = "ZenPkgs - The Core Dependency Hub for ZenOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    nix-gaming.url = "github:fufexan/nix-gaming";
    vsc-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixcord.url = "github:kaylorben/nixcord";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      loader = import ./lib/loader.nix { inherit (nixpkgs) lib; };

      # Import Utils with Inputs Context
      utils = import ./lib/utils.nix {
        inherit (nixpkgs) lib;
        inherit inputs self;
      };

      # --- Package Overlay ---
      zenOverlay =
        final: prev:
        let
          lib = prev.lib;
          inflate =
            tree: f:
            if builtins.isPath tree then
              f.callPackage tree {
                lib = f.lib // {
                  # INJECT: Custom definitions
                  licenses = f.lib.licenses // utils.licenses;
                  platforms = f.lib.platforms // utils.platforms;
                  maintainers =
                    f.lib.maintainers
                    // (
                      if builtins.pathExists ./lib/maintainers.nix then
                        import ./lib/maintainers.nix { inherit (f) lib; }
                      else
                        { }
                    );
                  zenUtils = utils;
                };
              }
            else
              lib.recurseIntoAttrs (lib.mapAttrs (name: value: inflate value f) tree);

          zenTree = loader.generateTree ./pkgs;
          legacyTree = loader.generateTree ./legacy/packages;
        in
        # 1. Base Legacy (Safeguard)
        {
          legacy = prev;
        }
        # 2. Legacy Mappers (Custom maps like 'win-browser')
        // (if legacyTree == { } then { } else inflate legacyTree final)
        # 3. ZenPkgs Priority (Overwrites upstream)
        // (if zenTree == { } then { } else inflate zenTree final);

    in
    {
      inherit inputs;
      overlays.default = zenOverlay;

      lib = {
        loader = loader;
        utils = utils;
      };

      # --- NixOS Modules ---
      nixosModules =
        let
          zenosTree = loader.generateTree ./modules;
          legacyTree = loader.generateTree ./legacy/modules;
          programsTree = loader.generateTree ./programModules;

          zenosList = nixpkgs.lib.collect builtins.isPath zenosTree;
          legacyList = nixpkgs.lib.collect builtins.isPath legacyTree;
          programsList = nixpkgs.lib.collect builtins.isPath programsTree;

          # [ CORE INFRASTRUCTURE: THE SANDBOX ]
          coreModule =
            { lib, config, ... }:
            let
              # Access the Sandbox Configuration
              zCfg = config.zenos.config;
            in
            {
              options = {
                # This is the "God Object" for the User.
                # If user tries to define keys outside the known submodules here, it CRASHES.
                zenos.config = lib.mkOption {
                  description = "The Strict ZenOS User Configuration Sandbox.";
                  default = { };
                  type = lib.types.submodule {
                    # STRICT MODE: No freeformType at root means undefined options will CRASH.

                    options = {
                      # 1. SYSTEM
                      # Inside here, we are safe to use the name 'system' because it's just a field.
                      system = lib.mkOption {
                        description = "System Configuration (Boot, Kernel, Hardware)";
                        default = { };
                        type = lib.types.submodule { freeformType = lib.types.attrs; };
                      };

                      # 2. USERS
                      users = lib.mkOption {
                        description = "User Configuration";
                        default = { };
                        type = lib.types.submodule { freeformType = lib.types.attrs; };
                      };

                      # 3. ENVIRONMENT
                      environment = lib.mkOption {
                        description = "Environment Variables";
                        default = { };
                        type = lib.types.submodule { freeformType = lib.types.attrs; };
                      };

                      # 4. LEGACY (The Escape Hatch)
                      legacy = lib.mkOption {
                        description = "Direct Access to Upstream Options";
                        default = { };
                        type = lib.types.submodule { freeformType = lib.types.attrs; };
                      };

                      # 5. DESKTOPS
                      desktops = lib.mkOption {
                        description = "Desktop Environment Config";
                        default = { };
                        type = lib.types.submodule { freeformType = lib.types.attrs; };
                      };
                    };
                  };
                };
              };

              # [ THE WIRING ]
              # Map the Sandbox values to the real NixOS system.
              # We use mkMerge so multiple modules can contribute (though usually it's just one).
              config = lib.mkMerge [
                # 1. Legacy Direct Mapping
                zCfg.legacy

                # 2. System Mapping
                # Note: We pull specific keys. 'system' upstream is strict, so we map meticulously.
                {
                  boot = zCfg.system.boot or { };
                  system.activationScripts = zCfg.system.activationScripts or { };
                  # Add mappings here as you encounter needs for upstream 'system.*' options
                }

                # 3. Environment Mapping
                {
                  environment.variables = zCfg.environment.variables or { };
                  environment.sessionVariables = zCfg.environment.sessionVariables or { };
                  environment.etc = zCfg.environment.etc or { };
                  # Note: We purposely DO NOT map systemPackages here automatically.
                }

                # 4. Users Mapping
                # Since upstream 'users' is a prefix for 'users.users', 'users.groups', etc.
                # and zCfg.users is a freeform set containing those keys, we can map directly.
                {
                  users = zCfg.users;
                }

                # 5. Desktops Mapping
                # Assuming 'desktops' modules in ZenPkgs look for 'config.zenos.config.desktops'
                # If they look for root options, map them here.
                # For now, we assume Zen modules are smart enough to read zenos.config directly.
              ];
            };

          # Dynamic Injection for Program Modules
          programInjection =
            { lib, ... }:
            {
              # 1. Define the Options (Type/Structure)
              options = {
                users.users = lib.mkOption {
                  type = lib.types.attrsOf (
                    lib.types.submodule {
                      # Extend the user submodule to include 'programs'
                      imports = [
                        {
                          options.programs = {
                            imports = programsList;
                          };
                        }
                      ];
                    }
                  );
                };
              };

              # 2. Define the Configuration (Values)
              config = {
                system.programs = {
                  imports = programsList;
                };
              };
            };
        in
        {
          zenos = zenosTree;
          legacy = legacyTree;
          programs = programsTree;
          core = coreModule;

          default = {
            imports = [
              ./structure.nix
              coreModule # <--- INJECTED HERE
              programInjection
            ]
            ++ zenosList
            ++ legacyList;
          };
        }
        // zenosTree;

      # --- Home Manager Modules ---
      homeManagerModules =
        let
          zenosTree = loader.generateTree ./hmModules;
          legacyTree = loader.generateTree ./legacy/home;

          zenosList = nixpkgs.lib.collect builtins.isPath zenosTree;
          legacyList = nixpkgs.lib.collect builtins.isPath legacyTree;
        in
        {
          zenos = zenosTree;
          legacy = legacyTree;
          default = {
            imports = zenosList ++ legacyList;
          };
        }
        // zenosTree;

      # --- Packages ---
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };
          zenPkgNames =
            if builtins.pathExists ./pkgs then
              builtins.attrNames (nixpkgs.lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./pkgs))
            else
              [ ];
        in
        if zenPkgNames == [ ] then { } else nixpkgs.lib.genAttrs zenPkgNames (name: pkgs.${name})
      );
    };
}
