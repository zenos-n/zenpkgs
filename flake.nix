# LOCATION: flake.nix
# DESCRIPTION: The Entry Point. Wires the overlay, loader, and structure.

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

          # Dynamic Injection for Program Modules
          programInjection =
            { config, lib, ... }:
            {
              system.programs = {
                imports = programsList;
              };
              users.users = lib.mkOption {
                type = lib.types.attrsOf (
                  lib.types.submodule {
                    options.programs = {
                      imports = programsList;
                    };
                  }
                );
              };
            };
        in
        {
          zenos = zenosTree;
          legacy = legacyTree;
          programs = programsTree;

          default = {
            imports = [
              ./structure.nix
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
