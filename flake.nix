{
  description = "ZenPkgs - The Core Dependency Hub for ZenOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
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
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      loader = import ./lib/loader.nix { inherit (nixpkgs) lib; };
      interface = import ./lib/interface.nix { inherit (nixpkgs) lib; };
      dslBundleAdapter = import ./lib/dsl-bundle.nix { inherit (nixpkgs) lib; };
      mkDslArtifacts =
        system:
        let
          bootstrapPkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          zenDsl = bootstrapPkgs.callPackage ./lib/zen-dsl/package.nix {
            testSuite = ./tests/zen-dsl;
          };
          bundle = bootstrapPkgs.runCommand "zenpkgs-dsl-bundle" {
            nativeBuildInputs = [
              zenDsl
              bootstrapPkgs.python3
            ];
            src = self;
          } ''
            mkdir -p source
            cp "$src/structure.zstr" source/structure.zstr
            cp -R "$src/pkgs" source/pkgs
            cp -R "$src/modules" source/modules
            mkdir -p "$out/interfaces" "$out/modules"
            zen-dsl compile-tree \
              --root source \
              --output "$out/bundle.json" \
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
                subtree = "interfaces" if source["kind"] == "zpkg" else "modules"
                destination = output_root / subtree / f"{source['path']}.nix"
                if destination in destinations:
                    raise ValueError(f"duplicate compiled module destination: {destination}")
                destinations.add(destination)
                destination.parent.mkdir(parents=True, exist_ok=True)
                destination.write_text(compiled, encoding="utf-8")
            PY
          '';
          bundleJSON = builtins.fromJSON (builtins.readFile "${bundle}/bundle.json");
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
          interface = {
            imports = [
              legacyOptionModule
              brandingModule
            ];
          };

          default = {
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
          dslModuleContract = import ./tests/dsl-module-parity.nix {
            inherit pkgs;
            inherit (dsl) candidates;
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
          webapps = installedSystemChecks.webapps;
          dsl-module-contract = dslModuleContract;
          zen-dsl = dsl.zenDsl;
          dsl-vm = import ./tests/zen-dsl/vm.nix {
            inherit pkgs;
            zenDsl = dsl.zenDsl;
          };
        }
        // registryChecks
      );
    };
}
