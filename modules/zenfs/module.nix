{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.zenfs;
  # Points to pkgs/system/zenfs based on flake structure
  zenfsPkg = pkgs.system.zenfs;

  configMapFile = pkgs.writeText "config_categories.json" (builtins.toJSON cfg.fhs.configMap);
  ignoreFile = pkgs.writeText "ignore_list.json" (builtins.toJSON cfg.database.ignoredFiles);

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
    description = "ZenFS Custom FHS and Roaming Drive Management";
    maintainers = with lib.maintainers; [ doromiert ];
    platforms = lib.platforms.zenos;
  };

  options.zenos.zenfs = {
    enable = lib.mkEnableOption "ZenFS";

    implementation = lib.mkOption {
      type = lib.types.enum [
        "symlink"
        "fuse"
      ];
      default = "symlink";
      description = "Method for presenting the FHS. 'fuse' uses custom python FUSE. 'symlink' uses standard symlinks.";
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
              };
              target = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              mode = lib.mkOption {
                type = lib.types.str;
                default = "0755";
              };
              user = lib.mkOption {
                type = lib.types.str;
                default = "root";
              };
              group = lib.mkOption {
                type = lib.types.str;
                default = "root";
              };
            };
          }
        );
        default = {
          # --- SYSTEM ---
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
          # --- CONFIG ---
          "/Config" = {
            type = "directory";
          };
          "/Config/Other" = {
            type = "symlink";
            target = "/etc";
          };
          # --- APPS ---
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
          # --- LIVE ---
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
          # --- MOUNT ---
          "/Mount" = {
            type = "directory";
          };
          "/Mount/Roaming" = {
            type = "directory";
          };
          "/Mount/Drives" = {
            type = "directory";
          };
          # --- USERS ---
          "/Users" = {
            type = "symlink";
            target = "/home";
          };
          "/Users/Admin" = {
            type = "symlink";
            target = "/root";
          };
        };
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
    };

    roaming.enable = lib.mkEnableOption "Roaming Drive support";
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

    services.udev.extraRules = lib.mkIf cfg.roaming.enable ''
      ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", TAG+="systemd", ENV{SYSTEMD_WANTS}+="zenfs-mount@%k.service"
    '';
  };
}
