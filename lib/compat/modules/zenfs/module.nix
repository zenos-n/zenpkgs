{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.zenfs;
  zenfsPkg = pkgs.zenos.system.zenfs;

  configMapFile = pkgs.writeText "config_categories.json" (builtins.toJSON cfg.fhs.configMap);
  ignoreFile = pkgs.writeText "ignore_list.json" (builtins.toJSON cfg.database.ignoredFiles);

  offloadJson = pkgs.writeText "offload_config.json" (
    builtins.toJSON {
      offloadThreshold = cfg.roaming.offloadThreshold;
      roamingSafeLimit = cfg.roaming.roamingSafeLimit;
      mainDrive = cfg.drives.mainDrive;
    }
  );

  toUnitName = path: lib.strings.removePrefix "-" (lib.strings.replaceStrings [ "/" ] [ "-" ] path);

in
{
  meta = {
    description = ''
      ZenOS Filesystem Hierarchy and Roaming Manager

      Manages the low-level filesystem structure for ZenOS, including FHS 
      emulation, roaming user profile management, and automated disk offloading.

      ### Key Features
      - **Roaming:** Dynamically attaches and syncs user data across devices.
      - **Categorization:** Maps configuration files to semantic categories.
      - **Offloading:** Automatically moves infrequently used data to secondary storage.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.zenfs = {
    enable = lib.mkEnableOption "ZenFS system-wide integration";

    roaming = {
      enable = lib.mkEnableOption "roaming user profile support";
      offloadThreshold = lib.mkOption {
        type = lib.types.int;
        default = 90;
        description = "Percentage of disk usage that triggers offloading logic";
      };
      roamingSafeLimit = lib.mkOption {
        type = lib.types.int;
        default = 50;
        description = "Target disk usage percentage after successful offload";
      };
    };

    database = {
      ignoredFiles = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          List of files ignored by ZenFS indexing

          Patterns or filenames that should be skipped by the roaming and 
          categorization services.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.zenfs-watcher = {
      description = "ZenFS File Change Watcher";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${zenfsPkg}/bin/zenfs watcher";
        Restart = "always";
      };
    };

    systemd.services.zenfs-offload = lib.mkIf cfg.roaming.enable {
      description = "ZenFS Disk Usage Offloader";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${zenfsPkg}/bin/zenfs offload -c ${offloadJson}";
      };
    };

    systemd.timers.zenfs-offload = lib.mkIf cfg.roaming.enable {
      description = "Run ZenFS Offloader hourly";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
      };
    };
  };
}
