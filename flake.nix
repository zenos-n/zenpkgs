{
  description = "ZenPkgs - The Core Dependency Hub for ZenOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
    masterful-gestures = {
      url = "github:doromiert/masterful-gestures";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zenos-next = {
      url = "github:doromiert/zenos-next/c24244cbf474ce21f4c16257eff7a94eeaa8928b";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      loader = import ./lib/loader.nix { inherit (nixpkgs) lib; };
      interface = import ./lib/interface.nix { inherit (nixpkgs) lib; };
      dslBundleAdapter = import ./lib/dsl-bundle.nix { inherit (nixpkgs) lib; };
      optionMappings = import ./mappings/options.nix;
      mkDslArtifacts =
        system:
        let
          bootstrapPkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          zenDsl = bootstrapPkgs.callPackage (inputs.zenos-next + "/packages/zen-dsl.nix") { };
          bundle = bootstrapPkgs.runCommand "zenpkgs-dsl-bundle" {
            nativeBuildInputs = [
              zenDsl
              bootstrapPkgs.python3
            ];
            src = ./dsl;
          } ''
            mkdir -p "$out/interfaces"
            zen-dsl compile-tree \
              --root "$src" \
              --output "$out/bundle.json" \
              --mode interface

            python3 - "$out/bundle.json" "$out/interfaces" <<'PY'
            import json
            from pathlib import Path
            import sys

            bundle_path = Path(sys.argv[1])
            output_root = Path(sys.argv[2])
            with bundle_path.open(encoding="utf-8") as source_file:
                compiled_bundle = json.load(source_file)

            for source in compiled_bundle["sources"]:
                if source["kind"] != "zpkg":
                    continue
                relative = Path(source["path"])
                if relative.is_absolute() or ".." in relative.parts:
                    raise ValueError(f"unsafe bundle source path: {source['path']}")
                destination = output_root / f"{source['path']}.nix"
                destination.parent.mkdir(parents=True, exist_ok=True)
                destination.write_text(source["compiledNix"], encoding="utf-8")
            PY
          '';
          bundleJSON = builtins.fromJSON (builtins.readFile "${bundle}/bundle.json");
          registry = dslBundleAdapter.registryFromBundle {
            bundle = bundleJSON;
            bundlePath = bundle;
          };
        in
        {
          inherit
            bootstrapPkgs
            bundle
            bundleJSON
            registry
            zenDsl
            ;
        };
      # Registry compilation is bootstrapped from nixpkgs without the ZenPkgs
      # overlay, so the overlay cannot depend on itself.
      registryFor = system: (mkDslArtifacts system).registry;
      registry = registryFor (builtins.head systems);
      legacyRoots = [
        "appstream"
        "boot"
        "console"
        "containers"
        "docker-containers"
        "documentation"
        "dysnomia"
        "ec2"
        "environment"
        "fileSystems"
        "fonts"
        "gtk"
        "hardware"
        "i18n"
        "ids"
        "image"
        "isSpecialisation"
        "jobs"
        "krb5"
        "lib"
        "location"
        "meta"
        "minifyStaticFiles"
        "nesting"
        "networking"
        "nix"
        "nixops"
        "nixpkgs"
        "oci"
        "openstack"
        "passthru"
        "power"
        "powerManagement"
        "programs"
        "qt"
        "qt5"
        "security"
        "services"
        "snapraid"
        "sound"
        "specialisation"
        "stubby"
        "swapDevices"
        "system"
        "systemd"
        "time"
        "users"
        "virtualisation"
        "xdg"
        "zramSwap"
      ];
      legacyOptionModule =
        { lib, ... }:
        {
          imports = map (root: lib.mkAliasOptionModule [ "zenos" "legacy" root ] [ root ]) legacyRoots;
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

          zenTree = loader.generateTree ./pkgs;
          mappedTree = interface.buildPackageTree prev registry;
          customTree = if zenTree == { } then { } else inflate zenTree final;
          patchedSeahorse = prev.seahorse.overrideAttrs (old: {
            postPatch = (old.postPatch or "") + ''
              substituteInPlace ssh/source.vala \
                --replace-fail \
                  'this.ssh_homedir = "%s/.ssh".printf(Environment.get_home_dir());' \
                  'this.ssh_homedir = Path.build_filename(Environment.get_user_config_dir(), "ssh");'
            '';
          });
        in
        # ZenPkgs owns one internal package namespace. User-facing package
        # references are prefixed by the zcfg compiler.
        {
          lib = prev.lib // {
            licenses = prev.lib.licenses // utils.licenses;
            platforms = prev.lib.platforms // utils.platforms;
          };
          seahorse = patchedSeahorse;
          zenos = lib.recursiveUpdate (lib.recursiveUpdate { legacy = prev; } mappedTree) customTree;
        };

    in
    {
      # Removed 'inherit inputs;' to silence "unknown flake output" warning
      overlays.default = zenOverlay;

      lib = {
        loader = loader;
        utils = utils;
        dslRegistryFor = registryFor;
        inherit
          dslBundleAdapter
          interface
          optionMappings
          registry
          ;
      };

      # --- NixOS Modules ---
      nixosModules =
        let
          zenosTree = loader.generateTree ./modules;
          legacyTree = loader.generateTree ./legacy/modules;
          programsTree = loader.generateTree ./program-modules;

          # [ HM INJECTION ]
          # Load HM modules for injection into users.
          # We collect these as a list of paths to pass to user-wrapper.nix via _module.args.
          zenHmTree = loader.generateTree ./hm-modules;
          zenHmList = nixpkgs.lib.collect builtins.isPath zenHmTree;

          zenosList = nixpkgs.lib.collect builtins.isPath zenosTree;
          legacyList = nixpkgs.lib.collect builtins.isPath legacyTree;
          programsList = nixpkgs.lib.collect builtins.isPath programsTree;

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
          masterful-gestures = inputs.masterful-gestures.nixosModules.default;
          installed-base = {
            imports = [ ./nixos-modules/installed-base.nix ];
            nix.registry.zenpkgs.flake = self;
          };
          disks = ./nixos-modules/disks.nix;
          oobe = ./nixos-modules/oobe.nix;
          webapps = {
            imports = [
              inputs.home-manager.nixosModules.home-manager
              ./nixos-modules/webapps.nix
            ];
          };
          # popcorn-cache = ./nixos-modules/popcorn-cache.nix;
          interface = {
            imports = [
              # ./nixos-modules/popcorn-cache.nix
              (interface.mkOptionModule optionMappings)
              legacyOptionModule
              brandingModule
              inputs.masterful-gestures.nixosModules.default
            ];
          };

          default = {
            # Pass the collected HM modules to the system arguments.
            # This allows user-wrapper.nix to access them via { zenUserModules, ... }
            _module.args.zenUserModules = zenHmList;

            imports = [
              ./structure.nix
              # ./nixos-modules/popcorn-cache.nix
              legacyOptionModule
              brandingModule
              inputs.masterful-gestures.nixosModules.default
              programInjection
              (interface.mkOptionModule optionMappings)
            ]
            ++ zenosList
            ++ legacyList;
          };
        }
        // zenosTree;

      # --- Home Manager Modules ---
      homeManagerModules =
        let
          zenosTree = loader.generateTree ./hm-modules;
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
          dsl = mkDslArtifacts system;
          registry = dsl.registry;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };

          flatten =
            prefix: value:
            if nixpkgs.lib.isDerivation value then
              {
                "${nixpkgs.lib.concatStringsSep "-" prefix}" = value;
              }
            else if builtins.isAttrs value then
              nixpkgs.lib.foldl' nixpkgs.lib.recursiveUpdate { } (
                nixpkgs.lib.mapAttrsToList (name: child: flatten (prefix ++ [ name ]) child) value
              )
            else
              { };
        in
        {
          dsl-bundle = dsl.bundle;
          registry-docs = pkgs.writeText "zenpkgs-registry.json" (
            builtins.toJSON (interface.registryDocs registry)
          );
          zen-dsl = dsl.zenDsl;
          zenos-rebuild = pkgs.zenos.programs.zenos-rebuild;
        }
        // (flatten [ "zenos" ] (interface.buildPackageTree pkgs registry))
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
              self.nixosModules.interface
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
            interfaceModule = self.nixosModules.interface;
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
        in
        {
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
            if [ -e "$src/mappings/packages.nix" ]; then
              echo "mappings/packages.nix must not be used for package declarations" >&2
              exit 1
            fi

            dsl_nix="$(${pkgs.findutils}/bin/find "$src/dsl" -type f -name '*.nix' -print -quit)"
            if [ -n "$dsl_nix" ]; then
              echo "Nix contributor declaration is forbidden in dsl/: $dsl_nix" >&2
              exit 1
            fi

            bundled_dir="$(${pkgs.findutils}/bin/find "$src/pkgs" -type d \
              \( -name src -o -name resources -o -name assets \) -print -quit)"
            if [ -n "$bundled_dir" ]; then
              echo "bundled package source directory is forbidden: $bundled_dir" >&2
              exit 1
            fi

            bundled_file="$(${pkgs.findutils}/bin/find "$src/pkgs" -type f \
              \( -name '*.zip' -o -name '*.tar' -o -name '*.tar.gz' \
              -o -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' \
              -o -name '*.svg' -o -name '*.ttf' -o -name '*.otf' \
              -o -name '*.woff' -o -name '*.woff2' -o -name '*.mp4' \
              -o -name '*.webm' \) -print -quit)"
            if [ -n "$bundled_file" ]; then
              echo "bundled package payload is forbidden: $bundled_file" >&2
              exit 1
            fi

            touch "$out"
          '';
          installed-base = installedSystemChecks.installed-base;
          oobe = installedSystemChecks.oobe;
          webapps = installedSystemChecks.webapps;
        }
        // registryChecks
      );
    };
}
