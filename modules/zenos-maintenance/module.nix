{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.system.maintenance;
  zenos-maintenance = pkgs.zenos.system.zenclean;

  configFile = pkgs.writeText "zenos-maintenance-config.json" (
    builtins.toJSON {
      garbage_age = cfg.garbageCollectionAge;
      notification_freq_days = cfg.notificationFrequencyDays;
      update_command = cfg.updateCommand;
    }
  );
in
{
  meta = {
    description = ''
      ZenOS maintenance and optimization system configuration

      This module installs and configures the ZenOS maintenance daemon. 
      It schedules periodic checks to perform garbage collection, store 
      optimization, and system updates when the user is away.

      ### Key Features
      - **Smart Cleanup:** Schedules GC only during idle periods.
      - **Updates:** Configurable system update hooks.
      - **Hooks:** Cleans the Nix store on shutdown or reboot if enabled.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.system.maintenance = {
    enable = lib.mkEnableOption "ZenOS Maintenance System";

    garbageCollectionAge = lib.mkOption {
      type = lib.types.str;
      default = "14d";
      description = ''
        Retention period for Nix store garbage

        Duration after which inactive generations and unreferenced store paths 
        are eligible for deletion. Example: '14d', '30d'.
      '';
    };

    notificationFrequencyDays = lib.mkOption {
      type = lib.types.int;
      default = 7;
      description = ''
        User alert interval for maintenance tasks

        Determines how often the user is notified about completed cleanup 
        or pending updates.
      '';
    };

    cleanOnShutdown = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Trigger store optimization and GC during system shutdown";
    };

    cleanOnReboot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Trigger store optimization and GC during system reboot";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.zenos-maintenance = {
      description = "ZenOS System Maintenance Service";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${zenos-maintenance}/bin/zenos-maintenance";
        User = "root";
      };
    };

    systemd.timers.zenos-maintenance = {
      description = "Timer for ZenOS Maintenance";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "10m";
        OnUnitActiveSec = "1d";
        Persistent = true;
      };
    };
  };
}
