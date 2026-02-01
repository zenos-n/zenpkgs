{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config;
  # Import the bundle function from ZenPkgs lib
  bundle = inputs.zenpkgs.lib.bundle or pkgs.lib.bundle;
in
{
  meta = {
    description = "Provides the core ZenOS configuration interface";
    longDescription = ''
      Defines the high-level `packages` and `user` options that allow for
      structured, user-friendly system configuration.

      Integrates `zenpkgs` mapping logic into the NixOS module system,
      enabling the use of the `packages.category.tool` syntax.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options = {
    # 1. System-Wide Package Interface (Zen)
    packages = lib.mkOption {
      description = "ZenOS structured package configuration";
      default = { };
      type = lib.types.attrsOf lib.types.anything;
    };

    # 2. Legacy Option Passthrough
    legacy = lib.mkOption {
      description = "Legacy NixOS configuration passthrough";
      default = { };
      type = lib.types.attrsOf lib.types.anything;
    };

    # 3. User-Specific Interface
    user = lib.mkOption {
      description = "ZenOS user configurations";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (
          { ... }:
          {
            options = {
              packages = lib.mkOption {
                description = "User-specific structured packages";
                default = { };
                type = lib.types.attrsOf lib.types.anything;
              };

              # Legacy passthrough for Home Manager
              legacy = lib.mkOption {
                description = "Legacy Home Manager configuration passthrough";
                default = { };
                type = lib.types.attrsOf lib.types.anything;
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkMerge [
    # --- Zen Logic ---
    {
      environment.systemPackages = bundle cfg.packages;

      home-manager.users = lib.mapAttrs (username: userCfg: {
        home.packages = bundle userCfg.packages;
        imports = [ { inherit (userCfg) legacy; } ];
      }) cfg.user;
    }

    # --- Legacy Logic ---
    cfg.legacy
  ];
}
