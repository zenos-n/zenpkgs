{
  description = "ZenPkgs - The Core Dependency Hub for ZenOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/v1.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware/31cc5f4d9b9ba601071e8b8504601b9b176e2756";
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.7.0";
    # Upstream release tags predate its flake, so pin the latest commit.
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS/23be28be9808ebc8f8bf1da5eed673fd6c6b62bc";
    nix-gaming.url = "github:fufexan/nix-gaming/7504a53ba97299b8d0536625aec3683aca8a700f";
    vsc-extensions.url = "github:nix-community/nix-vscode-extensions/10cb8298d5bf73196c70f7ba25a7aac01d3b9b4f";
    nixcord.url = "github:kaylorben/nixcord/2f2c1f3be0e90ccc8a083d1b83ebf2ebb4e1edff";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft/d3d8c17890760791f755b122eac30b19ea74443c";
    nur = {
      url = "github:nix-community/NUR/b3d988c4a22356f4bbffec07952f30c7771509cb";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    masterful-gestures = {
      url = "github:doromiert/masterful-gestures/7bc5670a750ba84f205aa2e82eaaf6c9fa45212f";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-popcorn.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpwamaker = {
      url = "github:doromiert/nixpwamaker/1.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    source-plymouth = {
      url = "github:zenos-n/plymouth-theme/1.0.0";
      flake = false;
    };
    source-rebuild = {
      url = "github:zenos-n/zenos-rebuild/6345106c44d99e6354944666e773a365e3ea8ed9";
      flake = false;
    };
    source-recovery = {
      url = "github:zenos-n/zenos-recovery-tools/cbde70da98e573dc42d325245370d99e37997017";
      flake = false;
    };
    source-refind-installer = {
      url = "github:zenos-n/zenos-refind-installer/0908c40f6743f9e8ddb132f47c894ada5ce5e7f3";
      flake = false;
    };
    source-refind-theme = {
      url = "github:zenos-n/zenos-refind-theme/159673a46343a66cc077876ba57ff4f28d3ba0a3";
      flake = false;
    };
    source-setup = {
      url = "github:zenos-n/zenos-setup/d762a9405f739361dcf941a1653a4ac39fb8cc13";
      flake = false;
    };
    source-shell-defaults = {
      url = "github:zenos-n/zenos-shell-defaults/29d54418b0e7e966e33a0f5766b92d9c94b1345e";
      flake = false;
    };
    source-oobe = {
      url = "github:zenos-n/zenos-oobe-mode-extension/1.0.0";
      flake = false;
    };
    source-zenfs = {
      url = "github:zenos-n/zenfs/6a6ac505bd153b5235170e3e021138166c9c4bda";
      flake = false;
    };
    # Development snapshots of the extracted package sources. These repositories
    # can be published and replaced with release or latest-commit URLs without changing ZPKGs.
    source-vr-tools = {
      url = "path:/home/doromiert/Projects/zenos-vr";
      flake = false;
    };
    source-alvr-compat = {
      url = "path:/home/doromiert/Projects/alvr-zenos-compat";
      flake = false;
    };
    source-haptics = { url = "path:/home/doromiert/Projects/haptics++"; flake = false; };
    source-zane-indicator = { url = "path:/home/doromiert/Projects/zenos-zane-indicator"; flake = false; };
    source-vision-indicator = { url = "path:/home/doromiert/Projects/zenos-vision-indicator"; flake = false; };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      loader = import ./lib/loader.nix { inherit (nixpkgs) lib; };
      interface = import ./lib/interface.nix { inherit (nixpkgs) lib; };
      packageOutputs = import ./lib/package-outputs.nix { inherit (nixpkgs) lib; };
      dslBundleAdapter = import ./lib/dsl-bundle.nix { inherit (nixpkgs) lib; };
      zstrRuntime = import ./lib/zstr-runtime.nix { inherit (nixpkgs) lib; };
      mkDslArtifacts =
        system:
        let
          bootstrapPkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          zenDsl = bootstrapPkgs.callPackage ./lib/zen-dsl/package.nix {
            testSuite = ./tests/zen-dsl;
            nixpkgsSrc = nixpkgs;
          };
          bundle =
            bootstrapPkgs.runCommand "zenpkgs-dsl-bundle"
              {
                enableParallelBuilding = true;
                nativeBuildInputs = [
                  zenDsl
                  bootstrapPkgs.python3
                ];
                src = builtins.path {
                  path = self;
                  name = "zenpkgs-dsl-source";
                  filter =
                    path: _:
                    path == toString self
                    ||
                      builtins.elem
                        (builtins.head (nixpkgs.lib.splitString "/" (nixpkgs.lib.removePrefix "${self}/" path)))
                        [
                          "structure.zstr"
                          "pkgs"
                          "modules"
                          "docs"
                        ];
                };
              }
              ''
                mkdir -p "$out/interfaces" "$out/modules" "$out/builds"
                zen-dsl compile-tree \
                  --root "$src" \
                  --output "$out/bundle.json" \
                  --jobs "$NIX_BUILD_CORES" \
                  --no-cache \
                  --mode interface

                python3 - "$out/bundle.json" "$out" <<'PY'
                import json
                from pathlib import Path
                import sys

                bundle_path = Path(sys.argv[1])
                output_root = Path(sys.argv[2])
                with bundle_path.open(encoding="utf-8") as source_file:
                    compiled_bundle = json.load(source_file)

                def canonical_source(source):
                    raw_path = source.get("path")
                    kind = source.get("kind")
                    if not isinstance(raw_path, str):
                        raise ValueError("bundle source path must be a string")
                    relative = Path(raw_path)
                    if relative.is_absolute() or ".." in relative.parts or relative.as_posix() != raw_path:
                        raise ValueError(f"unsafe bundle source path: {raw_path}")
                    if kind == "zstr":
                        if raw_path != "structure.zstr":
                            raise ValueError(f"structure must be repository-root structure.zstr: {raw_path}")
                        return
                    roots = {"zpkg": ("pkgs", ".zpkg", "package"), "zmdl": ("modules", ".zmdl", "module")}
                    if kind not in roots:
                        raise ValueError(f"unsupported repository DSL source: {raw_path}")
                    root, suffix, reserved_leaf = roots[kind]
                    if len(relative.parts) < 2 or relative.parts[0] != root or relative.suffix != suffix:
                        raise ValueError(f"noncanonical {kind} source location: {raw_path}")
                    if relative.stem == reserved_leaf:
                        raise ValueError(f"reserved {kind} leaf name: {raw_path}")

                destinations = set()
                for source in compiled_bundle["sources"]:
                    canonical_source(source)
                    if source["kind"] not in {"zpkg", "zmdl"}:
                        continue
                    relative = Path(source["path"])
                    compiled = source.get("compiledNix")
                    if not isinstance(compiled, str) or not compiled:
                        raise ValueError(f"missing compiled Nix for bundle source: {source['path']}")
                    artifacts = [("interfaces" if source["kind"] == "zpkg" else "modules", compiled)]
                    if source["kind"] == "zpkg":
                        build = source.get("buildNix")
                        if not isinstance(build, str) or not build:
                            raise ValueError(f"missing executable package provider: {source['path']}")
                        artifacts.append(("builds", build))
                    for subtree, code in artifacts:
                        destination = output_root / subtree / f"{source['path']}.nix"
                        if destination in destinations:
                            raise ValueError(f"duplicate compiled module destination: {destination}")
                        destinations.add(destination)
                        destination.parent.mkdir(parents=True, exist_ok=True)
                        destination.write_text(code, encoding="utf-8")
                PY
              '';
          bundleJSON =
            if builtins.pathExists (self + "/structure.zstr") then
              import ./lib/read-dsl-bundle.nix "${bundle}/bundle.json"
            else
              {
                bundleVersion = "zenlang.bundle/2";
                sources = [ ];
                modules = [ ];
                structure = {
                  present = false;
                  mounts = [ ];
                  nodes = [ ];
                };
              };
          registry = dslBundleAdapter.registryFromBundle {
            bundle = bundleJSON;
            bundlePath = bundle;
          };
          candidates = dslBundleAdapter.modulesFromBundle {
            bundle = bundleJSON;
            bundlePath = bundle;
          };
        in
        {
          inherit
            bootstrapPkgs
            bundle
            bundleJSON
            candidates
            registry
            zenDsl
            ;
        };
      # Registry compilation is bootstrapped from nixpkgs without the ZenPkgs
      # overlay, so the overlay cannot depend on itself.
      registryFor = system: (mkDslArtifacts system).registry;
      registry = registryFor (builtins.head systems);
      legacyOptionModule =
        { config, lib, ... }:
        {
          options.zenos.legacy = lib.mkOption {
            type = lib.types.lazyAttrsOf lib.types.raw;
            readOnly = true;
            default = removeAttrs config [ "zenos" ];
            description = "Lazy mirror of the NixOS root excluding zenos";
          };
        };
      brandingModule =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          release = config.zenos.system.release;
        in
        {
          options.zenos.system.release = {
            version = lib.mkOption {
              type = lib.types.strMatching "^[0-9]+\\.[0-9]+\\.[0-9]+N$";
              default = "1.0.0N";
              description = "ZenOS release version before channel and revision suffixes.";
            };
            channel = lib.mkOption {
              type = lib.types.enum [
                "beta"
                "stable"
              ];
              default = "beta";
              description = "ZenOS release channel.";
            };
            revision = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Short source revision included in development release names.";
            };
            stateVersion = lib.mkOption {
              type = lib.types.enum [ "1.0.0" ];
              default = "1.0.0";
              description = "ZenOS compatibility version used by persistent system state.";
            };
            full = lib.mkOption {
              type = lib.types.str;
              readOnly = true;
              default =
                if release.channel == "beta" then
                  "${release.version}b (${if release.revision == null then "unknown" else release.revision})"
                else
                  release.version;
              description = "Complete user-facing ZenOS release string.";
            };
          };

          config = {
            zenos.system.branding = {
              distroId = lib.mkDefault "zenos";
              distroName = lib.mkDefault "ZenOS";
            };

            system.nixos = {
              vendorId = lib.mkDefault "zenos";
              vendorName = lib.mkDefault "ZenOS";
              extraOSReleaseArgs = {
                ANSI_COLOR = "0;38;2;197;50;255";
                DOCUMENTATION_URL = "https://zenos.neg-zero.com";
                HOME_URL = "https://zenos.neg-zero.com";
                LOGO = "zenos";
                PRETTY_NAME = "ZenOS ${release.full}";
                SUPPORT_URL = "https://zenos.neg-zero.com";
                VENDOR_URL = "https://neg-zero.com";
                VERSION = release.full;
                VERSION_ID = release.version;
              };
            };
            system.stateVersion =
              {
                "1.0.0" = "26.05";
              }
              .${release.stateVersion};

            environment = {
              etc."machine-info".text = lib.mkDefault ''
                PRETTY_HOSTNAME="${config.networking.hostName}"
              '';
              shellAliases = {
                ll = "eza --long --all --group-directories-first --icons=auto";
                ls = "eza --group-directories-first --icons=auto";
                tree = "eza --tree --group-directories-first --icons=auto";
              };
              systemPackages = [
                pkgs.zenos.apps.system.eza
                pkgs.zenos.theming.icons.zenos-icons
              ];
            };

            fonts = {
              packages = [
                pkgs.zenos.apps.fonts.atkinson-hyperlegible
                pkgs.zenos.apps.fonts.atkinson-hyperlegible-mono
                pkgs.zenos.apps.fonts.inter
                pkgs.zenos.theming.fonts.zero.mono
                pkgs.zenos.theming.fonts.zero.regular
              ];
              fontconfig.defaultFonts = {
                monospace = [ "AtkynsonMono NF" ];
                sansSerif = [ "Atkinson Hyperlegible" ];
              };
            };

            boot = {
              initrd.verbose = lib.mkDefault false;
              kernelParams = lib.mkAfter [
                "quiet"
                "splash"
                "loglevel=3"
                "rd.systemd.show_status=auto"
                "rd.udev.log_level=3"
              ];
            };
          };
        };

      # Import Utils with Inputs Context
      utils = import ./lib/utils.nix {
        inherit (nixpkgs) lib;
        inherit inputs self;
      };
      dslLibrary = { inherit (utils) mkVersionString; };

      # --- Package Overlay ---
      zenOverlay =
        final: prev:
        let
          lib = prev.lib;
          registry = registryFor prev.stdenv.hostPlatform.system;
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

          zenTree = loader.generateTree ./lib/compat/package-recipes;
          mappedTree = interface.buildPackageTreeWith {
            pkgs = final;
            legacyPkgs = prev;
            inherit registry;
            packageArgs = {
              maintainers = import ./lib/maintainers.nix { inherit lib; };
              licenses = lib.licenses // utils.licenses;
            };
          };
          customTree = if zenTree == { } then { } else inflate zenTree final;
        in
        # ZenPkgs owns one internal package namespace. User-facing package
        # references are prefixed by the zcfg compiler.
        {
          lib = prev.lib // {
            licenses = prev.lib.licenses // utils.licenses;
            platforms = prev.lib.platforms // utils.platforms;
            zenPackageSources = {
              popcornNixpkgs = inputs.nixpkgs-popcorn.outPath;
              vrTools = inputs.source-vr-tools.outPath;
              alvrCompat = inputs.source-alvr-compat.outPath;
              haptics = inputs.source-haptics.outPath;
              zaneIndicator = inputs.source-zane-indicator.outPath;
              visionIndicator = inputs.source-vision-indicator.outPath;
            };
          };
          zenos =
            if zstrRuntime.packageExposure (mkDslArtifacts prev.stdenv.hostPlatform.system).bundleJSON then
              assert packageOutputs.checkLegacyOwnership {
                inherit registry;
                sourceTree = zenTree;
              };
              lib.recursiveUpdate (lib.recursiveUpdate { legacy = prev; } mappedTree) customTree
            else
              { };
        };

    in
    {
      # Removed 'inherit inputs;' to silence "unknown flake output" warning
      overlays.default = zenOverlay;

      lib = {
        loader = loader;
        utils = utils;
        dslRegistryFor = registryFor;
        dslBundleFor = system: (mkDslArtifacts system).bundleJSON;
        inherit zstrRuntime dslLibrary;
        inherit
          dslBundleAdapter
          interface
          registry
          ;
      };

      # --- NixOS Modules ---
      nixosModules =
        let
          zenosTree = loader.generateTree ./lib/compat/modules;
          legacyTree = loader.generateTree ./lib/compat/legacy/modules;

          # Transitional user-action backend implementations. These are part of
          # the unified ZenOS module graph, not a separate public module tree.
          zenUserBackendTree = loader.generateTree ./lib/compat/user-modules;
          zenUserBackendList = nixpkgs.lib.collect builtins.isPath zenUserBackendTree;

          coreModules = nixpkgs.lib.collect builtins.isPath zenosTree.core;
          gnomeBaseModule = zenosTree.desktops.gnome.base."module.nix";
          transitionalSystemModules = [
            ./lib/compat/system-modules/installed-base.nix
            ./lib/compat/system-modules/disks.nix
            ./lib/compat/system-modules/oobe.nix
            ./lib/compat/system-modules/webapps.nix
          ];
        in
        {
          zenos = zenosTree;
          legacy = legacyTree;
          masterful-gestures = inputs.masterful-gestures.nixosModules.default;
          installed-base = {
            imports = [ ./lib/compat/system-modules/installed-base.nix ];
            nix.registry.zenpkgs.flake = self;
          };
          disks = ./lib/compat/system-modules/disks.nix;
          oobe = ./lib/compat/system-modules/oobe.nix;
          webapps = {
            imports = [
              inputs.home-manager.nixosModules.home-manager
              ./lib/compat/system-modules/webapps.nix
            ];
          };
          # Popcorn remains disabled pending a complete module.
          compatibility-interface = {
            imports = [
              legacyOptionModule
              brandingModule
            ];
          };

          compatibility-default = {
            _module.args.zenUserModules = zenUserBackendList;
            nix.registry.zenpkgs.flake = self;

            imports = [
              inputs.home-manager.nixosModules.home-manager
              inputs.disko.nixosModules.disko
              legacyOptionModule
              brandingModule
            ]
            ++ coreModules
            ++ [ gnomeBaseModule ]
            ++ transitionalSystemModules;
          };
          interface = self.nixosModules.default;
          default = {
            imports = [
              ./lib/compat/system-modules/installed-runtime.nix
              ./lib/compat/system-modules/oobe-runtime.nix
              inputs.home-manager.nixosModules.home-manager
              inputs.nix-flatpak.nixosModules.nix-flatpak
              inputs.masterful-gestures.nixosModules.default
              inputs.disko.nixosModules.disko
              (zstrRuntime.moduleFromBundle {
                bundle = (mkDslArtifacts (builtins.head systems)).bundleJSON;
                extraLib = dslLibrary;
              })
            ];
            nixpkgs.overlays = [ self.overlays.default ];
            home-manager.sharedModules = [
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
              ({ lib, ... }: { services.flatpak.enable = lib.mkDefault false; })
              inputs.nixcord.homeModules.nixcord
              inputs.nixpwamaker.homeManagerModules.pwamaker
            ];
          };
        }
        // zenosTree;

      # --- Packages ---
      packages = forAllSystems (
        system:
        let
          dsl = mkDslArtifacts system;
          registry = dsl.registry;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };

        in
        if !zstrRuntime.packageExposure dsl.bundleJSON then
          { }
        else
          packageOutputs.flatten {
            inherit registry;
            tree = pkgs.zenos;
            reserved = {
              dsl-bundle = dsl.bundle;
              registry-docs = pkgs.writeText "zenpkgs-registry.json" (
                builtins.toJSON (interface.registryDocs registry)
              );
              zen-dsl = dsl.zenDsl;
              zenos-rebuild = pkgs.zenos.apps.system.zenos.zenos-rebuild;
            };
          }
      );

      legacyPackages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };
        in
        if !zstrRuntime.packageExposure (mkDslArtifacts system).bundleJSON then
          { }
        else
          {
            legacy = pkgs.zenos.legacy // {
              nvim = pkgs.zenos.legacy.neovim;
            };
          }
      );

      checks = forAllSystems (
        system:
        let
          dsl = mkDslArtifacts system;
          registry = dsl.registry;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };
          legacyConfig = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              self.nixosModules.compatibility-interface
              {
                zenos.system.release.stateVersion = "1.0.0";
                zenos.legacy.users.users.contract.isNormalUser = true;
              }
            ];
          };
          gnomeBaseConfig = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              self.nixosModules.desktops.gnome.base."module.nix"
              {
                nixpkgs = {
                  overlays = [ self.overlays.default ];
                  config.allowUnfree = true;
                };
                system.stateVersion = "26.05";
                zenos.desktops.gnome = {
                  enable = true;
                  extensionPackages = [ pkgs.zenos.desktops.gnome.extensions.forge ];
                  extensionUuids = [ "forge@jmmaranan.com" ];
                };
              }
            ];
          };
          installedSystemChecks = import ./tests/installed-system-modules.nix {
            inherit nixpkgs pkgs system;
            interfaceModule = self.nixosModules.compatibility-interface;
            installedBaseModule = self.nixosModules.installed-base;
            oobeModule = self.nixosModules.oobe;
            webappsModule = self.nixosModules.webapps;
          };
          registryChecks = import ./tests/package-registry.nix {
            expectedRegistry = builtins.fromJSON (builtins.readFile ./tests/fixtures/package-registry.json);
            publicPackages = self.packages.${system};
            inherit interface pkgs registry;
            inherit (nixpkgs) lib;
          };
          dslModuleContract = import ./tests/dsl-module-parity.nix {
            inherit pkgs;
            inherit (dsl) candidates;
          };
          migrationPolicies = import ./tests/migration-options.nix {
            inherit nixpkgs;
            zenosModule = self.nixosModules.default;
          };
        in
        {
          flake-inputs = dsl.bootstrapPkgs.writeText "zenpkgs-flake-inputs.json" (
            builtins.toJSON (import ./tests/flake-inputs.nix)
          );
          migration-options =
            assert nixpkgs.lib.all (value: value) (builtins.attrValues migrationPolicies);
            pkgs.writeText "zenos-migration-options" (builtins.toJSON migrationPolicies);
          migration-packages = import ./tests/migration-packages.nix { inherit pkgs registry; };
          migration-options-vm = import ./tests/migration-options-vm.nix {
            pkgs = dsl.bootstrapPkgs;
            zenosModule = self.nixosModules.default;
            policies = migrationPolicies;
            vrSupervisorSource = inputs.source-vr-tools.outPath + "/src/vr-overlay-supervisor.sh";
          };
          user-options-vm = import ./tests/user-options-vm.nix {
            pkgs = dsl.bootstrapPkgs;
            zenosModule = self.nixosModules.default;
            inherit (dsl) zenDsl;
            homeManagerPath = inputs.home-manager.outPath;
          };
          desktop-options-vm = import ./tests/desktop-options-vm.nix {
            pkgs = dsl.bootstrapPkgs;
            zenosModule = self.nixosModules.default;
            inherit (dsl) zenDsl;
          };
          codex-desktop-vm = import ./tests/codex-desktop-vm.nix {
            inherit pkgs;
            zenosModule = self.nixosModules.default;
          };
          package-catalog-vm = import ./tests/package-catalog-vm.nix {
            pkgs = dsl.bootstrapPkgs;
            zenosModule = self.nixosModules.default;
            inherit (dsl) zenDsl;
            sourceRoot = builtins.path {
              path = self;
              name = "zenpkgs-catalog-source";
              filter = path: _:
                path == toString self || builtins.elem
                  (builtins.head (nixpkgs.lib.splitString "/" (nixpkgs.lib.removePrefix "${self}/" path)))
                  [ "structure.zstr" "pkgs" "modules" "docs" ];
            };
          };
          interface = interface.mkCheck {
            inherit pkgs registry;
            name = "zenpkgs-interface-check";
          };
          legacy-interface =
            assert legacyConfig.config.users.users.contract.isNormalUser;
            assert legacyConfig.config.system.stateVersion == "26.05";
            assert pkgs.zenos.legacy.firefox.outPath == pkgs.firefox.outPath;
            assert !(pkgs ? legacy);
            pkgs.runCommand "zenpkgs-legacy-interface-check" { } "touch $out";
          legacy-packages =
            assert self.legacyPackages.${system}.legacy.nvim.outPath == pkgs.neovim.outPath;
            pkgs.runCommand "zenpkgs-legacy-packages-check" { } "touch $out";
          gnome-base =
            assert builtins.elem pkgs.zenos.desktops.gnome.extensions.forge
              gnomeBaseConfig.config.environment.systemPackages;
            assert gnomeBaseConfig.config.programs.dconf.profiles.user.databases != [ ];
            assert
              (builtins.head gnomeBaseConfig.config.programs.dconf.profiles.user.databases)
              .settings."org/gnome/shell".enabled-extensions == [ "forge@jmmaranan.com" ];
            pkgs.runCommand "zenpkgs-gnome-base-check" { } "touch $out";
          source-policy = pkgs.runCommand "zenpkgs-source-policy-check" { src = self; } ''
            required='AGENTS.md LICENSE docs flake.lock flake.nix lib modules pkgs readme.md scripts structure.zstr tests'
            allowed="$required .git .gitignore .github .vscode"
            for name in AGENTS.md LICENSE flake.lock flake.nix readme.md structure.zstr; do
              if [ ! -f "$src/$name" ] || [ -L "$src/$name" ]; then
                echo "required ZenPkgs root file is missing or invalid: $name" >&2
                exit 1
              fi
            done
            for name in docs lib modules pkgs scripts tests; do
              if [ ! -d "$src/$name" ] || [ -L "$src/$name" ]; then
                echo "required ZenPkgs root directory is missing or invalid: $name" >&2
                exit 1
              fi
            done
            if [ -e "$src/.gitignore" ] && { [ ! -f "$src/.gitignore" ] || [ -L "$src/.gitignore" ]; }; then
              echo "ZenPkgs .gitignore must be a regular file" >&2
              exit 1
            fi
            for name in .git .github .vscode; do
              if [ -e "$src/$name" ] && { [ ! -d "$src/$name" ] || [ -L "$src/$name" ]; }; then
                echo "ZenPkgs $name must be a directory" >&2
                exit 1
              fi
            done

            for entry in "$src"/* "$src"/.[!.]* "$src"/..?*; do
              [ -e "$entry" ] || [ -L "$entry" ] || continue
              name="''${entry##*/}"
              case " $allowed " in
                *" $name "*) ;;
                *) echo "forbidden ZenPkgs root entry: $name" >&2; exit 1 ;;
              esac
              if [ -L "$entry" ]; then
                echo "symlinked ZenPkgs root entry is forbidden: $name" >&2
                exit 1
              fi
            done

            invalid_package="$(${pkgs.findutils}/bin/find "$src/pkgs" \
              \( -type l -o -type f ! -name '*.zpkg' \) -print -quit)"
            if [ -n "$invalid_package" ]; then
              echo "only ZPKG files are allowed in pkgs/: $invalid_package" >&2
              exit 1
            fi
            invalid_module="$(${pkgs.findutils}/bin/find "$src/modules" \
              \( -type l -o -type f ! -name '*.zmdl' \) -print -quit)"
            if [ -n "$invalid_module" ]; then
              echo "only ZMDL files are allowed in modules/: $invalid_module" >&2
              exit 1
            fi

            touch "$out"
          '';
          installed-base = installedSystemChecks.installed-base;
          oobe = installedSystemChecks.oobe;
          oobe-gnome = import ./tests/oobe-gnome.nix {
            inherit nixpkgs pkgs;
            module = self.nixosModules.default;
          };
          webapps = installedSystemChecks.webapps;
          dsl-module-contract = dslModuleContract;
          zen-dsl = dsl.zenDsl;
          dsl-bundle-context = import ./tests/zen-dsl/bundle-context.nix {
            inherit (dsl) bootstrapPkgs;
          };
          version-format = dsl.bootstrapPkgs.writeText "zenos-version-format.json" (
            builtins.toJSON (import ./tests/version-format.nix { inherit (nixpkgs) lib; })
          );
          package-output-collisions = dsl.bootstrapPkgs.writeText "package-output-collisions.json" (
            builtins.toJSON (import ./tests/package-output-collisions.nix { inherit (nixpkgs) lib; })
          );
          zstr-mounting = import ./tests/mounting/check.nix {
            inherit (dsl) bootstrapPkgs;
            inherit nixpkgs;
            home-manager = inputs.home-manager;
          };
          search-index = import ./tests/search/check.nix {
            inherit (dsl) bootstrapPkgs;
            inherit nixpkgs;
            home-manager = inputs.home-manager;
          };
          zstr-production = dsl.bootstrapPkgs.writeText "zstr-production-acceptance.json" (
            # Evaluate the complete derivations, without building their closures
            # merely because their store paths occur in the acceptance report.
            builtins.unsafeDiscardStringContext (
              builtins.toJSON (
                import ./tests/mounting/production.nix {
                  inherit self nixpkgs system;
                }
              )
            )
          );
          dsl-vm = import ./tests/zen-dsl/vm.nix {
            inherit pkgs;
            zenDsl = dsl.zenDsl;
          };
        }
        // registryChecks
      );
    };
}
