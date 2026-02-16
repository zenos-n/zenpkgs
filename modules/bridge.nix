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

    # 2. Root Legacy Plumbing
    # We use .definitions to bypass evaluation of the config itself.
    # This prevents infinite recursion cycles (config -> zenos.legacy -> config).
    # (lib.mkIf (options.zenos ? legacy) (lib.mkMerge options.zenos.legacy.definitions))

    # # 3. Sandbox Legacy Plumbing
    # # Same strategy: Merge definitions directly to root.
    # (lib.mkIf (options.zenos.sandbox ? legacy) (lib.mkMerge options.zenos.sandbox.legacy.definitions))

    # 4. User Plumbing
    {
      users.users = lib.mapAttrs (
        name: userCfg:
        let
          # Standard generated config
          baseConfig = {
            isNormalUser = true;
            shell = resolveShell (userCfg.shell or "bash");
            packages = userCfg.packages or [ ];
          };
        in
        # MERGE: Base config + Legacy overrides
        # This allows 'legacy' to define things like 'uid', 'extraGroups', 'openssh', etc.
        baseConfig // (userCfg.legacy or { })
      ) config.zenos.users;
    }
  ];
}
