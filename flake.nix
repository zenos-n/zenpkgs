{
  description = "ZenPkgs - The ZenOS Ecosystem";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      baseSystem = "x86_64-linux";

      loaders = import ./lib/loaders.nix { inherit (nixpkgs) lib; };
      userLib = loaders.loadLib ./lib;

      rebuildScript = pkgs.writeShellScriptBin "zenos-rebuild" ''
        if [ "$1" == "-h" ]; then
          if [ -z "$2" ]; then
            echo "Error: Hostname required."
            exit 1
          fi
          echo "Rebuilding ZenOS for host: $2..."
          sudo nixos-rebuild switch --flake .#$2
        else
          echo "Usage: zenos-rebuild -h <hostname>"
          exit 1
        fi
      '';

      lib = nixpkgs.lib.extend (
        final: prev:
        userLib
        // {
          loaders = loaders;
          licenses = prev.licenses // {
            napalm = {
              fullName = "Non Aggression Principle Anti-License Mandate";
              url = "https://github.com/negative-zero-inft/nap-license";
              free = true;
            };
          };
          platforms = prev.platforms // {
            zenos = [ "x86_64-linux" ];
          };

          # --- MK SYSTEM WITH AUTO-WRAPPING ---
          mkSystem =
            {
              modules,
              specialArgs ? { },
              system,
            }:
            let
              isZenos = prev.hasPrefix "zenos-x64-" system;
              cpuVer = if isZenos then prev.removePrefix "zenos-x64-" system else null;
              microArch = if cpuVer != null then "x86-64-${cpuVer}" else null;
              realSystem = if isZenos then "x86_64-linux" else system;

              # The Wrapper: Takes a user module and injects it into 'zenos'
              wrapModule =
                m:
                if builtins.isPath m || builtins.isString m then
                  { ... }:
                  {
                    zenos = import m;
                  }
                else if builtins.isFunction m then
                  args: { zenos = m args; }
                else
                  { zenos = m; };

            in
            nixpkgs.lib.nixosSystem {
              system = realSystem;
              specialArgs = specialArgs // {
                zenpkgsInputs = inputs;
                inherit loaders;
              };

              # We map over the user-provided modules and wrap them.
              # Then we append the Core Framework (which defines the zenos option).
              modules = (map wrapModule modules) ++ [
                self.nixosModules.default

                (
                  { pkgs, lib, ... }:
                  {
                    nixpkgs.overlays = [ self.overlays.default ];

                    nixpkgs.hostPlatform = lib.mkIf (microArch != null) {
                      system = realSystem;
                      gcc.arch = microArch;
                      gcc.tune = microArch;
                    };

                    environment.systemPackages = [ rebuildScript ];
                  }
                )
              ];
            };
        }
      );

      pkgsOverlay = final: prev: {
        zenos =
          let
            nativePkgs = import ./core/builder.nix {
              inherit lib;
              pkgs = final;
              path = ./pkgs;
            };

            legacyMaps = import ./core/builder.nix {
              inherit lib;
              pkgs = final;
              path = ./legacyMaps/pkgs;
            };
          in
          legacyMaps
          // nativePkgs
          // {
            legacy = prev;
          };
      };

      pkgs = import nixpkgs {
        system = baseSystem;
        overlays = [ pkgsOverlay ];
        config.allowUnfree = true;
      };

      docGen = import ./tools/doc-gen.nix {
        inherit pkgs lib;
        modules = [
          self.nixosModules.default
          home-manager.nixosModules.home-manager

          # [FIX] Inject your custom modules here!
          # This tells the doc generator to scan your 'modules' folder.
        ]
        ++ (loaders.loadModules ./modules);
      };

      integrityCheck = import ./tools/integrity.nix {
        inherit pkgs lib;
        modules = [
          self.nixosModules.default
          home-manager.nixosModules.home-manager
        ];
      };

    in
    {
      overlays.default = pkgsOverlay;
      inherit lib;

      nixosModules.default = ./core/framework.nix;

      apps.${baseSystem} = {
        docs = {
          type = "app";
          program = "${docGen}/bin/zen-doc-gen";
        };
        check = {
          type = "app";
          program = "${integrityCheck}/bin/zen-integrity";
        };
      };

      packages.${baseSystem} = pkgs.zenos // {
        doc-generator = docGen;
        zenos-rebuild = rebuildScript;
        integrity-check = integrityCheck;
      };

      devShells.${baseSystem}.default = pkgs.mkShell {
        packages = with pkgs; [
          nixpkgs-fmt
          jq
          python3
        ];
      };
    };
}
