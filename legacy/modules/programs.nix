{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.system.programs;
in
{
  meta = {
    description = "Optimized configurations for core system programs";
    longDescription = ''
      This module serves as the primary bridge between high-level system requirements 
      and NixOS-specific configurations for application suites like Steam.

      ### Features
      - **Steam Integration**: Automatically configures the Steam gaming suite with 
        `gamemode` enabled and enforced performance settings.
      - **Autogen System**: A flexible attribute-based configurator to enable utility 
        packages (like Python) without manual environment declarations.
      - **Legacy Compatibility**: Includes a safety layer that warns users if legacy 
        configuration paths are detected while ZenOS overrides are active.

      This module is designed to integrate with ZenOS hardware profiles to ensure 
      optimal binary execution settings.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.system.programs = {
    steam.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Steam gaming suite with ZenOS performance optimizations";
      example = true;
    };

    autogen = lib.mkOption {
      description = "The Universal App Configurator for automated program enablement";
      default = { };
      example = {
        python3.enable = true;
      };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable the parent program in the system environment";
            };
          };
        }
      );
    };
  };

  config = lib.mkMerge [
    # Steam Logic
    (lib.mkIf cfg.steam.enable {
      # We use mkForce to ensure ZenOS standards override any conflicting legacy settings
      programs.steam.enable = lib.mkForce true;
      programs.gamemode.enable = lib.mkForce true;

      # Warn if the user is attempting to use legacy NixOS paths alongside this module
      warnings =
        lib.optional
          (
            config.legacy ? programs && config.legacy.programs ? steam && config.legacy.programs.steam ? enable
          )
          "ZenOS Warning: 'legacy.programs.steam' detected. The 'system.programs.steam' module is currently enforcing optimized settings.";
    })

    # Autogen Logic
    # Note: If these packages are defined in our local tree, we prefer using pkgs.zenos
    (lib.mkIf (cfg.autogen.python3.enable or false) {
      environment.systemPackages = [ pkgs.python3 ];
    })
  ];
}
