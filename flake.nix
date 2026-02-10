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
          # [NEW] Import core maintainers
          maintainers = prev.maintainers // (import ./core/maintainers.nix);
          licenses = prev.licenses // {
            napalm = {
              fullName = "Non Aggression Principle Anti-License Mandate";
              url = "https://github.com/negative-zero-inft/nap-license";
            };
          };
        }
      );

      pkgsOverlay =
        final: prev:
        let
          # Load native ZenPkgs
          nativePkgs = import ./core/builder.nix {
            inherit lib;
            pkgs = final;
            path = ./pkgs;
          };

          # Load legacy package maps
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
        ]
        # [RESTORED] Ensure modules are loaded for docs
        ++ (loaders.loadModules ./modules)
        ++ (loaders.loadModules ./legacyMaps/modules);
      };

      integrityCheck = import ./tools/integrity.nix {
        inherit pkgs lib;
        modules = [
          self.nixosModules.default
          home-manager.nixosModules.home-manager
        ]
        # [RESTORED] Ensure modules are loaded for checks
        ++ (loaders.loadModules ./modules);
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
        buildInputs = [
          pkgs.nixfmt-rfc-style
          pkgs.rnix-lsp
          rebuildScript
          docGen
          integrityCheck
        ];
      };
    };
}
