{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.zenos.sandbox;

  resolveShell =
    name:
    if name == "bash" then
      pkgs.bash
    else if name == "fish" then
      pkgs.fish
    else
      pkgs.bash;

  # INHERITANCE HELPER
  # Filters out keys that are strictly ZenOS options, passing the rest to Legacy
  passPrograms =
    zenosPrograms: zenosOptions:
    let
      # Get list of options defined in schema
      defined = builtins.attrNames (zenosOptions);
      # Remove them from the config, leaving only freeform/legacy attrs
      legacyOnly = lib.removeAttrs zenosPrograms defined;
    in
    legacyOnly;

  # --- CONFIGURATION BRIDGE ---
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

  # Apply Logic
  config = lib.mkMerge [
    # 1. Map Sandbox to Internal Modules
    (lib.mkIf (cfg != { }) {
      zenos.system = lib.mkIf (options.zenos ? system && cfg.system != { }) cfg.system;
      zenos.users = lib.mkIf (options.zenos ? users && cfg.users != { }) cfg.users;
      zenos.desktops = lib.mkIf (options.zenos ? desktops && cfg.desktops != { }) cfg.desktops;
      zenos.environment = lib.mkIf (
        options.zenos ? environment && cfg.environment != { }
      ) cfg.environment;
    })

    # 2. AUTOMATIC PROGRAM INHERITANCE (System)
    (lib.mkIf (options.zenos ? system && config.zenos.system.programs != { }) {
      # Map freeform programs to legacy.programs
      legacy.programs =
        passPrograms config.zenos.system.programs options.zenos.system.programs.type.getSubOptions
          [ ];
    })

    # 3. User Plumbing & Inheritance
    {
      users.users = lib.mapAttrs (
        name: userCfg:
        let
          baseConfig = {
            isNormalUser = true;
            shell = resolveShell (userCfg.shell or "bash");
            packages = userCfg.packages or [ ];
          };

          # Calculate User Legacy Programs
          legacyPrograms =
            if userCfg.programs != { } then
              passPrograms userCfg.programs options.zenos.users.type.nestedTypes.elemType.getSubOptions
                [ ].programs.type.getSubOptions
                [ ]
            else
              { };

        in
        # MERGE: Base + Legacy + Program Inheritance
        baseConfig
        // (userCfg.legacy or { })
        // {
          programs = (userCfg.legacy.programs or { }) // legacyPrograms;
        }
      ) (config.zenos.users or { });
    }
  ];
}
