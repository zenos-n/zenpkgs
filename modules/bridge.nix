{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.zenos.sandbox;

  # INHERITANCE HELPER
  passPrograms =
    zenosPrograms: zenosOptions:
    let
      # Get list of options defined in schema (including our new .legacy)
      defined = builtins.attrNames (zenosOptions);
      # Remove them from the config, leaving only freeform/legacy attrs
      legacyOnly = lib.removeAttrs zenosPrograms defined;
    in
    legacyOnly;

  # Combined legacy programs for a specific context
  getLegacyPrograms =
    zenosPrograms: zenosOptions:
    let
      explicitLegacy = zenosPrograms.legacy or { };
      inheritedLegacy = passPrograms zenosPrograms zenosOptions;
    in
    lib.recursiveUpdate explicitLegacy inheritedLegacy;
in
{
  # Define the sandbox options (user-facing)
  options.zenos.sandbox = {
    system = lib.mkOption {
      description = "System-level configuration sandbox";
      default = { };
      type = lib.types.attrs;
    };
    users = lib.mkOption {
      description = "User-level configuration sandbox";
      default = { };
      type = lib.types.attrs;
    };
    desktops = lib.mkOption {
      description = "Desktop environment sandbox";
      default = { };
      type = lib.types.attrs;
    };
    environment = lib.mkOption {
      description = "Global environment sandbox";
      default = { };
      type = lib.types.attrs;
    };
    legacy = lib.mkOption {
      description = "Global Legacy Passthrough";
      default = { };
      type = lib.types.attrs;
    };
  };

  config = lib.mkMerge [
    # 1. Map Sandbox
    (lib.mkIf (cfg != { }) {
      zenos.system = lib.mkIf (options.zenos ? system && cfg.system != { }) cfg.system;
      zenos.users = lib.mkIf (options.zenos ? users && cfg.users != { }) cfg.users;
      zenos.desktops = lib.mkIf (options.zenos ? desktops && cfg.desktops != { }) cfg.desktops;
      zenos.environment = lib.mkIf (
        options.zenos ? environment && cfg.environment != { }
      ) cfg.environment;
    })

    # 2. System Program Inheritance
    (lib.mkIf (options.zenos ? system && config.zenos.system.programs != { }) {
      legacy.programs =
        getLegacyPrograms config.zenos.system.programs options.zenos.system.programs.type.getSubOptions
          [ ];
    })

    # 3. User Plumbing
    {
      users.users = lib.mapAttrs (
        name: userCfg:
        let
          baseConfig = {
          };

          # User specific legacy programs
          legacyPrograms =
            if userCfg.programs != { } then
              getLegacyPrograms userCfg.programs options.zenos.users.type.nestedTypes.elemType.getSubOptions
                [ ].programs.type.getSubOptions
                [ ]
            else
              { };

        in
        baseConfig
        // (userCfg.legacy or { })
        // {
          programs = (userCfg.legacy.programs or { }) // legacyPrograms;
        }
      ) (config.zenos.users or { });
    }
  ];
}
