{
  pkgs,
  lib,
  modules,
}:

let
  # Fix Recursion 1: Instantiate loaders locally so they are available as specialArgs
  loaders = import ../lib/loaders.nix { inherit lib; };

  # Fix Recursion 2: Mock inputs required by framework.nix
  zenpkgsInputs = {
    self = {
      outPath = ./..;
    };
    nixpkgs = {
      outPath = pkgs.path;
    };
    home-manager = {
      outPath = ./..;
    };
  };

  # 1. Full System Evaluation
  eval = lib.nixosSystem {
    system = "x86_64-linux";

    # CRITICAL: Pass specialArgs to prevent infinite recursion in framework.nix
    specialArgs = {
      inherit loaders zenpkgsInputs;
    };

    modules = modules ++ [
      # Dummy config to satisfy assertions
      (
        { pkgs, ... }:
        {
          system.stateVersion = lib.versions.majorMinor lib.version;
          boot.loader.grub.enable = false;
          fileSystems."/".device = "/dev/null";

          # FIXED: Correct option path for NixOS modules
          nixpkgs.config.allowUnfree = true;
        }
      )

      # FIX: Resolve collision between framework.nix and NixOS users-groups.nix
      # Your framework defines 'users.users.<name>.home' as an internal option.
      # NixOS defines 'users.users.<name>.home' as the home directory path.
      # We shadow the NixOS one or disable the conflict check for docs.
      (
        { lib, ... }:
        {
          options.users.users = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                options.home = lib.mkOption {
                  visible = false; # Try to suppress visibility to avoid collision
                  # We use mkForce/mkOverride to ensure the evaluator doesn't crash on the double declaration
                  # though usually, the module system requires unique declarations.
                };
              }
            );
          };
        }
      )
    ];
  };

  # 2. Extract Options
  optionsDoc = pkgs.nixosOptionsDoc {
    options = eval.options;
    transformOptions =
      opt:
      opt
      // {
        # Strip declarations to reduce file size (optional)
        declarations = [ ];
      };
  };

in
pkgs.writeShellScriptBin "zen-doc-gen" ''
  echo "[ZenDoc] Extracting FULL NixOS Option Tree..."
  OPTIONS_JSON="${optionsDoc.optionsJSON}/share/doc/nixos/options.json"

  echo "[ZenDoc] Processing options..."
  ${pkgs.python3}/bin/python3 ${./doc_gen.py} "$OPTIONS_JSON"

  echo "[ZenDoc] Done."
''
