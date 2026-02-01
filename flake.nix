{
  description = "ZenPkgs - The Core Dependency Hub for ZenOS";

  inputs = {
    # --- Core Repositories ---
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";

    # --- Software Collections ---
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

      # --- Logic adapted from Flake 1 (Robust recursive scanning) ---

      # Recursively generate a tree of modules from a directory
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
                  # FIX: Inject custom maintainers into the lib scope
                  maintainers = f.lib.maintainers // (import ./lib/maintainers.nix { inherit (f) lib; });
                  platforms = f.lib.platforms // {
                    zenos = f.lib.platforms.linux ++ [ "x86_64-linux" ];
                  };
                };
              }
            else
              lib.recurseIntoAttrs (lib.mapAttrs (name: value: inflateTree value f p) tree);

          # Scans ./pkgs (Standard behavior from Flake 1)
          tree = if builtins.pathExists ./pkgs then generatePackageTree ./pkgs else null;
        in
        if tree == null then { } else { zenos = inflateTree tree final prev; };

    in
    {
      inherit inputs;
      overlays.default = zenOverlay;

      lib = {
        mkUtils = import ./lib/utils.nix;
        # bundle: converts config trees to flat lists (from Flake 2)
        bundle = rootSet: nixpkgs.lib.collect nixpkgs.lib.isDerivation rootSet;
      };

      # NixOS Modules (System Level)
      nixosModules =
        let
          scannedModules = if builtins.pathExists ./modules then generateModuleTree ./modules else { };
          interface =
            if builtins.pathExists ./modules/zen-interface.nix then
              { interface = import ./modules/zen-interface.nix; }
            else
              { };
        in
        scannedModules // interface;

      # Home Manager Modules (User Level)
      homeManagerModules =
        if builtins.pathExists ./hm-modules then generateModuleTree ./hm-modules else { };

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };
          # Dynamically expose top-level packages from the generated zenos tree
          zenPkgNames =
            if builtins.pathExists ./pkgs then
              builtins.attrNames (nixpkgs.lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./pkgs))
            else
              [ ];

          dynamicPkgs =
            if zenPkgNames == [ ] then { } else nixpkgs.lib.genAttrs zenPkgNames (name: pkgs.zenos.${name});
        in
        dynamicPkgs
        // {
          # Default package to satisfy 'nix build .' and 'nix run .'
          default = pkgs.writeShellScriptBin "zenpkgs-info" ''
            echo "ZenPkgs - The Core Dependency Hub for ZenOS"
            echo "Available packages: ${builtins.concatStringsSep ", " zenPkgNames}"
          '';
        }
      );

      # --- Documentation & Audit (From Flake 1) ---
      docData = forAllSystems (
        system:
        import ./lib/doc-gen.nix {
          pkgs = import nixpkgs { inherit system; };
          inherit system;
          flake = self;
        }
      );

      audit = forAllSystems (
        system:
        import ./lib/audit.nix {
          pkgs = import nixpkgs { inherit system; };
          inherit system;
          flake = self;
        }
      );
    };
}
