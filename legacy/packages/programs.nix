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
    description = "Maps system.programs to ZenOS optimized configurations";
    longDescription = ''
      This module provides a high-level abstraction for common programs, ensuring they
      are configured according to ZenOS performance and integration standards.

      Key features:
      - Optimized Steam configuration with GameMode enabled by default.
      - Automatic warning system for legacy configuration conflicts.
      - Extensible `autogen` system for quick package enablement.

      It integrates deeply with `zenos.theming` and hardware acceleration layers where applicable.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.system.programs = {
    steam.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Steam gaming suite with ZenOS optimizations";
    };

    autogen = lib.mkOption {
      description = "Automatic configuration for supported utility programs";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to enable this specific autogen program";
            };
          };
        }
      );
    };
  };

  config = lib.mkMerge [
    # Steam Logic
    (lib.mkIf cfg.steam.enable {
      # FORCE the ZenOS preference for gaming performance
      programs.steam.enable = lib.mkForce true;
      programs.gamemode.enable = lib.mkForce true;

      # Warn if legacy configuration is detected to prevent silent overrides
      warnings =
        lib.optional
          (
            config.legacy ? programs && config.legacy.programs ? steam && config.legacy.programs.steam ? enable
          )
          "ZenOS Override: 'legacy.programs.steam' was detected, but 'system.programs.steam' is enabled. ZenOS settings will be enforced.";
    })

    # Autogen Logic
    (lib.mkIf (cfg.autogen.python3.enable or false) {
      environment.systemPackages = [ pkgs.python3 ];
    })
  ];
}
