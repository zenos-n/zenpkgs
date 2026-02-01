# LOCATION: modules/zen-interface.nix
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config;
  bundle = inputs.zenpkgs.lib.bundle or pkgs.lib.bundle or (x: [ ]);

  # Helper to detect conflicts between high-level Zen options and low-level Legacy options
  # Returns a warning string if both are set.
  mkConflict =
    zenVal: legacyPath: name:
    if (zenVal != null && lib.hasAttrByPath legacyPath cfg.legacy) then
      "ZenOS Override: You have configured '${name}' in 'legacy', but it is managed by ZenOS. The ZenOS value will take precedence."
    else
      null;
in
{
  meta = {
    description = "The ZenOS Configuration Schema";
    longDescription = "Defines the high-level system.* and legacy.* options with override logic.";
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options = {
    # --- 1. SYSTEM SCHEMA ---
    system = {
      host.name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Machine hostname";
      };

      packages = lib.mkOption {
        description = "System-wide package tree";
        default = { };
        type = lib.types.attrsOf lib.types.anything;
      };

      programs = lib.mkOption {
        description = "System-wide program configurations";
        default = { };
        type = lib.types.attrsOf lib.types.anything;
      };
    };

    # --- 2. LEGACY PASSTHROUGH ---
    legacy = lib.mkOption {
      description = "Direct passthrough to NixOS options";
      default = { };
      type = lib.types.attrsOf lib.types.anything;
    };

    # --- 3. USER SCHEMA ---
    users = lib.mkOption {
      description = "ZenOS User Configurations";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              packages = lib.mkOption {
                description = "User-specific packages";
                default = { };
                type = lib.types.attrsOf lib.types.anything;
              };
              theme = lib.mkOption {
                description = "User theme settings";
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
    # [ LOGIC ] Zen Configuration Application (High Priority)
    # We use mkForce to ensure Zen settings overwrite Legacy settings if they conflict.
    (lib.mkForce {
      networking.hostName = lib.mkIf (cfg.system.host.name != null) cfg.system.host.name;
      environment.systemPackages = bundle cfg.system.packages;

      home-manager.users = lib.mapAttrs (username: userCfg: {
        home.packages = bundle userCfg.packages;
      }) cfg.users;
    })

    # [ LOGIC ] Legacy Passthrough Application (Standard Priority)
    cfg.legacy

    # [ LOGIC ] Conflict Detection
    {
      warnings = lib.filter (x: x != null) [
        # Check: Hostname
        (mkConflict cfg.system.host.name [ "networking" "hostName" ] "hostname")

        # Check: Steam (Logic is in the programs module, but we can verify here if needed)
        # Note: Complex module conflicts are best handled in their specific files (see below)
      ];
    }
  ];
}
