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

  # Offload Config
  offloadJson = pkgs.writeText "offload_config.json" (
    builtins.toJSON {
      offloadThreshold = cfg.roaming.offloadThreshold;
      roamingSafeLimit = cfg.roaming.roamingSafeLimit;
      mainDrive = cfg.drives.mainDrive;
    }
  );

  toUnitName = path: lib.strings.removePrefix "-" (lib.strings.replaceStrings [ "/" ] [ "-" ] path);

  generateTmpfiles =
    structure:
    lib.mapAttrsToList (
      path: rules:
      let
        useFuse = cfg.implementation == "fuse" && rules.target != null;
        type =
          if useFuse then
            "d"
          else if rules.type == "symlink" then
            "L+"
          else
            "d";
        mode = rules.mode or (if type == "L+" then "-" else "0755");
        user = rules.user or "root";
        group = rules.group or "root";
        target = if useFuse then "-" else (rules.target or "-");
      in
      "${type} ${path} ${mode} ${user} ${group} - ${target}"
    ) structure;

  generateFuseServices =
    structure:
    lib.concatMapAttrs (
      path: rules:
      if (cfg.implementation == "fuse" && rules.target != null && path != "/Users") then
        {
          "zenfs-fhs-${toUnitName path}" = {
            description = "ZenFS FUSE Mirror: ${path}";
            wantedBy = [ "multi-user.target" ];
            after = [ "local-fs.target" ];
            requires = [ "local-fs.target" ];
            serviceConfig = {
              ExecStart = "${zenfsPkg}/bin/zenfs-fuse ${rules.target} ${path}";
              ExecStop = "fusermount -u ${path}";
              Restart = "always";
            };
          };
        }
      else
        { }
    ) structure;

in
{
  meta = {
    description = "Configures ZenFS, the declarative file system manager for ZenOS";
    longDescription = ''
      This module configures **ZenFS**, a subsystem responsible for managing the
      filesystem hierarchy in ZenOS. It handles the creation of the FHS structure,
      manages symlinks for configuration mapping, and supports roaming drive offloading.

      **Features:**
      - Declarative definition of the filesystem structure (FHS).
      - Support for both symlink-based and FUSE-based implementations.
      - Roaming drive support for offloading data from the main drive.
      - Automatic configuration mapping via `configMap`.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.zenfs = {
    enable = lib.mkEnableOption "ZenFS";

    drives = {
      mainDrive = lib.mkOption {
        type = lib.types.str;
        description = "UUID of the Main Drive (hosting /home)";
      };
      bootDrive = lib.mkOption {
        type = lib.types.str;
        description = "UUID of the Boot Drive";
      };
    };

    implementation = lib.mkOption {
      type = lib.types.enum [
        "symlink"
        "fuse"
      ];
      default = "symlink";
      description = "Implementation method for the filesystem structure";
    };

    fhs = {
      structure = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              type = lib.mkOption {
                type = lib.types.enum [
                  "directory"
                  "symlink"
                ];
                description = "Type of the filesystem entry";
              };
              target = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Target path for symlinks (optional)";
              };
              mode = lib.mkOption {
                type = lib.types.str;
                default = "0755";
                description = "File permission mode";
              };
              user = lib.mkOption {
                type = lib.types.str;
                default = "root";
                description = "Owner user";
              };
              group = lib.mkOption {
                type = lib.types.str;
                default = "root";
                description = "Owner group";
              };
            };
          }
        );
        default = {
          "/System" = {
            type = "directory";
          };
          "/System/ZenFS" = {
            type = "directory";
          };
          "/System/ZenFS/Database" = {
            type = "directory";
          };
          "/System/State" = {
            type = "symlink";
            target = "/var/lib";
          };
          "/System/Cache" = {
            type = "symlink";
            target = "/var/cache";
          };
          "/System/Spool" = {
            type = "symlink";
            target = "/var/spool";
          };
          "/System/Legacy" = {
            type = "symlink";
            target = "/usr";
          };
          "/System/Packages" = {
            type = "symlink";
            target = "/nix/store";
          };
          "/System/Profiles" = {
            type = "symlink";
            target = "/nix/var/nix/profiles";
          };
          "/System/Logs" = {
            type = "symlink";
            target = "/var/log";
          };
          "/System/Boot" = {
            type = "symlink";
            target = "/boot";
          };
          "/Config" = {
            type = "directory";
          };
          "/Config/Other" = {
            type = "symlink";
            target = "/etc";
          };
          "/Apps" = {
            type = "directory";
          };
          "/Apps/Binaries" = {
            type = "symlink";
            target = "/run/current-system/sw/bin";
          };
          "/Apps/Flatpak" = {
            type = "symlink";
            target = "/var/lib/flatpak";
          };
          "/Apps/Containers" = {
            type = "symlink";
            target = "/var/lib/containers";
          };
          "/Apps/Portable" = {
            type = "directory";
          };
          "/Live" = {
            type = "directory";
          };
          "/Live/Processes" = {
            type = "symlink";
            target = "/proc";
          };
          "/Live/Kernel" = {
            type = "symlink";
            target = "/sys";
          };
          "/Live/Runtime" = {
            type = "symlink";
            target = "/run";
          };
          "/Live/Memory" = {
            type = "symlink";
            target = "/dev/shm";
          };
          "/Live/Temp" = {
            type = "symlink";
            target = "/tmp";
          };
          "/Live/Devices" = {
            type = "symlink";
            target = "/dev";
          };
          "/Mount" = {
            type = "directory";
          };
          "/Mount/Roaming" = {
            type = "directory";
          };
          "/Mount/Drives" = {
            type = "directory";
          };
          "/Users" = {
            type = "symlink";
            target = "/home";
          };
          "/Users/Admin" = {
            type = "symlink";
            target = "/root";
          };
        };
        description = "Filesystem hierarchy structure definition";
      };

      configMap = lib.mkOption {
        type = lib.types.attrsOf (lib.types.listOf lib.types.str);
        default = {
          Audio = [
            "/etc/wireplumber"
            "/etc/pipewire"
            "/etc/pulse"
            "/etc/alsa"
          ];
          Bluetooth = [ "/etc/bluetooth" ];
          Desktop = [
            "/etc/dconf"
            "/etc/xdg"
          ];
          Display = [
            "/etc/X11"
            "/etc/wayland"
          ];
          Fonts = [ "/etc/fonts" ];
          Hardware = [
            "/etc/udev"
            "/etc/libinput"
          ];
          Network = [
            "/etc/hosts"
            "/etc/NetworkManager"
            "/etc/wpa_supplicant"
            "/etc/ssh"
          ];
          Nix = [ "/etc/nix" ];
          Security = [
            "/etc/sudoers"
            "/etc/pam.d"
            "/etc/firejail"
          ];
          Services = [ "/etc/systemd" ];
          System = [
            "/etc/fstab"
            "/etc/hostname"
            "/etc/locale.conf"
            "/etc/localtime"
          ];
          User = [
            "/etc/passwd"
            "/etc/group"
            "/etc/shadow"
          ];
          ZenOS = [ ];
        };
        description = "Mapping of configuration categories to file paths";
      };
    };

    database.ignoredFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        ".config"
        ".local"
        ".mozilla"
        ".cache"
        ".bash_history"
        "Downloads/Temp"
      ];
      description = "List of files to be ignored by the ZenFS database";
    };

    roaming = {
      enable = lib.mkEnableOption "Roaming Drive support";

      offloadThreshold = lib.mkOption {
        type = lib.types.int;
        default = 80;
        description = "Percentage of Main Drive usage to trigger offloading";
      };

      roamingSafeLimit = lib.mkOption {
        type = lib.types.int;
        default = 90;
        description = "Percentage of Roaming Drive usage to stop prioritizing it";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      zenfsPkg
    ]
    ++ lib.optionals (cfg.implementation == "fuse") [ pkgs.fuse ];

    systemd.tmpfiles.rules = (generateTmpfiles cfg.fhs.structure) ++ [
      "L+ /System/ZenFS/config_categories.json - - - - ${configMapFile}"
      "L+ /System/ZenFS/ignore_list.json - - - - ${ignoreFile}"
      "d /Config/ZenOS 0755 root root -"
      "d /Config/System 0755 root root -"
    ];

    systemd.services = generateFuseServices cfg.fhs.structure // {
      zenfs-core = {
        description = "ZenFS Core Service";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zenfsPkg}/bin/zenfs core";
        };
      };

      zenfs-roaming = {
        description = "ZenFS Roaming Sync";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zenfsPkg}/bin/zenfs roaming";
        };
      };

      zenfs-fuse = lib.mkIf (cfg.implementation == "fuse") {
        description = "ZenFS FUSE Daemon (Users Union)";
        wantedBy = [ "multi-user.target" ];
        after = [ "local-fs.target" ];
        serviceConfig = {
          ExecStart = "${zenfsPkg}/bin/zenfs-fuse /home /Users";
          ExecStop = "fusermount -u /Users";
          Restart = "always";
        };
      };

      zenfs-watcher = lib.mkIf cfg.roaming.enable {
        description = "ZenFS Filesystem Watcher";
        wantedBy = [ "multi-user.target" ];
        after =
          if cfg.implementation == "fuse" then [ "zenfs-fuse.service" ] else [ "zenfs-roaming.service" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${zenfsPkg}/bin/zenfs watcher";
          Restart = "always";
        };
      };

      # New Offload Service (Periodic)
      zenfs-offload = lib.mkIf cfg.roaming.enable {
        description = "ZenFS Disk Usage Offloader";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zenfsPkg}/bin/zenfs offload -c ${offloadJson}";
        };
      };

      zenfs-roaming-checker = {
        description = "ZenFS Boot Checker";
        wantedBy = [ "multi-user.target" ];
        after = [ "local-fs.target" ];
        requires = [ "local-fs.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zenfsPkg}/bin/zenfs checker";
        };
      };

      "zenfs-mount@" = lib.mkIf cfg.roaming.enable {
        description = "ZenFS Mount %i";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zenfsPkg}/bin/zenfs attach %i";
        };
      };
    };

    # Timer for Offloader
    systemd.timers.zenfs-offload = lib.mkIf cfg.roaming.enable {
      description = "Run ZenFS Offloader hourly";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
      };
    };

    services.udev.extraRules = lib.mkIf cfg.roaming.enable ''
      ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", TAG+="systemd", ENV{SYSTEMD_WANTS}+="zenfs-mount@%k.service"
    '';
  };
}
