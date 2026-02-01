{
  description = "ZenPkgs - The Core Dependency Hub for ZenOS";

  inputs = {
    # --- Core Repositories ---
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # --- System Components ---
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
                  maintainers = f.lib.maintainers // (import ./lib/maintainers.nix { inherit (f) lib; });
                  platforms = f.lib.platforms // {
                    zenos = f.lib.platforms.linux ++ [ "x86_64-linux" ];
                  };
                };
              }
            else
              lib.recurseIntoAttrs (lib.mapAttrs (name: value: inflateTree value f p) tree);

          # 1. Generate the Local Tree (from ./pkgs)
          # This mimics the structure of your folders
          localTree = generatePackageTree ./pkgs;
          localPkgs = if localTree == null then { } else inflateTree localTree final prev;

          # 2. Define the Standard Map (The "Zen" Structure)
          # This maps upstream packages to your preferred hierarchy
          standardMap = {
            # --- Desktops & Environments ---
            desktops = {
              gnome = {
                core = prev.gnome-shell;
                apps = prev.gnome-apps // {
                  nautilus = prev.nautilus;
                  terminal = prev.gnome-console;
                };
                # AUTO-MAPPING: Aliasing the entire gnomeExtensions set
                extensions = prev.gnomeExtensions;
              };
              hyprland = {
                core = prev.hyprland;
                portal = prev.xdg-desktop-portal-hyprland;
              };
            };

            # --- Development ---
            dev = {
              langs = {
                python = prev.python3;
                rust = prev.cargo;
                go = prev.go;
                nix = prev.nix;
              };
              editors = {
                vscode = prev.vscode;
                vim = prev.vim;
              };
            };

            # --- System ---
            sys = {
              kernel = prev.linuxPackages_latest.kernel;
              boot = {
                systemd = prev.systemd;
                grub = prev.grub2;
              };
            };

            # --- Explicit Legacy Access ---
            # You can access raw nixpkgs here if things get confusing
            legacy = prev;
          };

          # 3. MERGE: Local Pkgs + Standard Map
          # lib.recursiveUpdate ensures that if you have ./pkgs/desktops/gnome/extensions/my-cool-extension
          # it is ADDED to the mapped prev.gnomeExtensions, not overwriting it.
          structuredPkgs = lib.recursiveUpdate standardMap localPkgs;
        in
        # EXPORT: We merge 'structuredPkgs' directly into 'final' (the top level pkgs)
        structuredPkgs
        // {
          # We also keep 'zenos' as a namespace just in case you want to be explicit
          zenos = structuredPkgs;
        };

    in
    {
      # [CRITICAL] Re-export inputs so downstream flakes can use them
      inherit inputs;

      overlays.default = zenOverlay;

      # Helper Functions
      lib = {
        mkUtils = import ./lib/utils.nix;

        # [NEW] The Bundle Builder
        # Takes a structured attribute set of packages and flattens it into a list
        # Example: bundle { tools = { a = pkgs.hello; }; } -> [ pkgs.hello ]
        bundle = rootSet: nixpkgs.lib.collect nixpkgs.lib.isDerivation rootSet;
      };

      nixosModules = if builtins.pathExists ./modules then generateModuleTree ./modules else { };
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
          zenPkgNames = builtins.attrNames (
            nixpkgs.lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./pkgs)
          );
        in
        {
          zenos = pkgs.zenos;
        }
      );

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
