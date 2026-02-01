{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.maintenance;

  # Referenced from global pkgs scope as requested
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
    description = "Configures the ZenOS maintenance and optimization system";
    longDescription = ''
      This module installs and configures the ZenOS maintenance daemon. It schedules
      periodic checks to perform garbage collection, store optimization, and system
      updates when the user is away. It also supports hooks for cleaning up the
      system on shutdown or reboot.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.maintenance = {
    enable = lib.mkEnableOption "ZenOS Maintenance System";

    garbageCollectionAge = lib.mkOption {
      type = lib.types.str;
      default = "14d";
      description = "Time interval for retaining garbage (e.g., 14d, 30d)";
    };

    notificationFrequencyDays = lib.mkOption {
      type = lib.types.int;
      default = 7;
      description = "Interval between maintenance reminders in days";
    };

    updateCommand = lib.mkOption {
      type = lib.types.str;
      default = "nixos-rebuild switch --upgrade";
      description = "Command executed to update the system";
      example = "nix flake update --flake /etc/nixos && nixos-rebuild switch";
    };

    cleanOnShutdown = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Triggers garbage collection during system shutdown";
    };

    cleanOnReboot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Triggers garbage collection during system reboot";
    };
  };

  config = lib.mkIf cfg.enable {

    # Make manually runnable by user
    environment.systemPackages = [ zenos-maintenance ];

    # Create config structure
    systemd.tmpfiles.rules = [
      "d /System/ZenClean 0755 root root -"
      "d /System/Logs 0755 root root -"
      "L+ /System/ZenClean/config.json - - - - ${configFile}"
    ];

    # --- Main Service ---
    systemd.services.zenos-maintenance = {
      description = "ZenOS System Maintenance and Optimization";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${zenos-maintenance}/bin/zenos-maintenance";
        User = "root";
        DeviceAllow = [ "/dev/input/event* r" ];
        CapabilityBoundingSet = "CAP_SYS_ADMIN";
      };
      path = with pkgs; [
        nix
        nixos-rebuild
        libnotify
        systemd
        coreutils
        bash
        procps
        util-linux
        gnugrep
      ];
    };

    # Timer
    systemd.timers.zenos-maintenance = {
      description = "Timer for ZenOS Maintenance";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "10m";
        OnUnitActiveSec = "1d";
        Persistent = true;
      };
    };

    # --- Hooks ---
    systemd.services.zenos-maintenance-shutdown = lib.mkIf cfg.cleanOnShutdown {
      description = "ZenOS Garbage Collection (Shutdown)";
      wantedBy = [ "shutdown.target" ];
      before = [ "shutdown.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${zenos-maintenance}/bin/zenos-maintenance --shutdown";
        TimeoutStartSec = "5m";
      };
      path = with pkgs; [ nix ];
    };

    systemd.services.zenos-maintenance-reboot = lib.mkIf cfg.cleanOnReboot {
      description = "ZenOS Garbage Collection (Reboot)";
      wantedBy = [ "reboot.target" ];
      before = [ "reboot.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${zenos-maintenance}/bin/zenos-maintenance --reboot";
        TimeoutStartSec = "5m";
      };
      path = with pkgs; [ nix ];
    };
  };
}
