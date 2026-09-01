{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.oobe;
  extensionUuid = "zenos-oobe-mode@neg-zero.com";
  servicePath = "/run/wrappers/bin:/run/current-system/sw/bin";
  napalmLicense =
    lib.licenses.napalm or {
      shortName = "napalm";
      fullName = "NAPALM: The Non-Aggression Principle Anti-License Mandate 2.0";
      url = "https://github.com/negative-zero-inft/nap-license";
      free = false;
      redistributable = true;
      copyleft = true;
    };
  blackWallpaper = pkgs.writeText "zenos-oobe-black.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" width="1" height="1">
      <rect width="1" height="1" fill="#000000"/>
    </svg>
  '';
  gnomeSessionCommand = "${pkgs.coreutils}/bin/env XDG_SESSION_TYPE=wayland XDG_SESSION_CLASS=user XDG_SESSION_DESKTOP=GNOME XDG_CURRENT_DESKTOP=GNOME GNOME_SHELL_SESSION_MODE=zenos-oobe ${config.services.displayManager.sessionData.wrapper} ${pkgs.gnome-session}/bin/gnome-session";
in
{
  options.zenos.oobe = {
    _meta = lib.mkOption {
      internal = true;
      default = {
        description = ''
          Provides the temporary ZenOS out-of-box experience

          Creates a disposable setup session for short-path installs. The final
          Setup-generated configuration disables this module before reboot.
        '';
        license = napalmLicense;
        maintainers = lib.optional (lib.maintainers ? doromiert) lib.maintainers.doromiert;
        platforms = lib.platforms.linux;
      };
    };

    enable = lib.mkEnableOption "the temporary ZenOS out-of-box experience";

    setupPackage = lib.mkOption {
      type = lib.types.package;
      example = lib.literalExpression "pkgs.zenos.setup";
      description = ''
        Setup application package launched for OOBE

        The package must expose its executable through `meta.mainProgram`.
      '';
    };

    extensionPackage = lib.mkOption {
      type = lib.types.package;
      example = lib.literalExpression "pkgs.zenos.oobe-extension";
      description = ''
        GNOME Shell extension and mode package used by OOBE

        The package must install the `zenos-oobe` GNOME Shell mode and its
        companion extension.
      '';
    };

    extraExtensionPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional GNOME extension packages made available during OOBE.";
    };

    extraExtensionUuids = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional GNOME extension UUIDs enabled during OOBE.";
    };

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "SSH public keys accepted by the temporary OOBE account.";
    };

    userName = lib.mkOption {
      type = lib.types.str;
      default = "zenos";
      description = ''
        Temporary account name used by OOBE

        The account is created only while OOBE is enabled and is removed when
        the final configuration is rebuilt with OOBE disabled.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.setupPackage.meta ? mainProgram;
        message = "zenos.oobe.setupPackage must define meta.mainProgram";
      }
    ];

    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = lib.mkForce false;
    services.gnome.gnome-initial-setup.enable = false;
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = true;
        PermitEmptyPasswords = true;
        PermitRootLogin = "no";
      };
    };
    services.greetd = {
      enable = true;
      restart = false;
      settings = {
        initial_session = {
          command = gnomeSessionCommand;
          user = cfg.userName;
        };
        default_session = {
          command = gnomeSessionCommand;
          user = cfg.userName;
        };
      };
    };

    systemd.services.greetd.environment = {
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_CLASS = "user";
      XDG_SESSION_DESKTOP = "GNOME";
    };

    systemd.user.services."org.gnome.Shell@" = {
      overrideStrategy = "asDropin";
      path = lib.mkForce [ ];
      environment = {
        PATH = servicePath;
        ZENOS_OOBE = "1";
      };
      serviceConfig.ExecStart = lib.mkForce [
        ""
        "${pkgs.gnome-shell}/bin/gnome-shell --mode=zenos-oobe"
      ];
    };

    systemd.user.services.zenos-oobe = {
      description = "ZenOS out-of-box experience";
      wantedBy = [ "graphical-session.target" ];
      after = [ "gnome-session.target" ];
      partOf = [ "graphical-session.target" ];
      path = lib.mkForce [ ];
      environment = {
        PATH = servicePath;
        ZENOS_OOBE = "1";
      };
      unitConfig.ConditionUser = cfg.userName;
      serviceConfig = {
        Type = "exec";
        ExecStart = "${lib.getExe cfg.setupPackage} --oobe";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };

    users = {
      mutableUsers = false;
      users = {
        root.hashedPassword = lib.mkDefault "!";
        ${cfg.userName} = {
          isNormalUser = true;
          description = "ZenOS Setup";
          initialHashedPassword = "";
          openssh.authorizedKeys.keys = cfg.authorizedKeys;
          extraGroups = [
            "input"
            "networkmanager"
            "video"
            "wheel"
          ];
        };
      };
    };

    environment = {
      systemPackages = [
        cfg.extensionPackage
        cfg.setupPackage
      ] ++ cfg.extraExtensionPackages;
      sessionVariables.ZENOS_OOBE = "1";
      gnome.excludePackages = [ pkgs.gnome-tour ];
    };

    hardware.graphics.enable = true;

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [ extensionUuid ] ++ cfg.extraExtensionUuids;
            favorite-apps = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          };
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            enable-animations = true;
          };
          "org/gnome/desktop/background" = {
            color-shading-type = "solid";
            picture-options = "none";
            picture-uri = "file://${blackWallpaper}";
            picture-uri-dark = "file://${blackWallpaper}";
            primary-color = "#000000";
            secondary-color = "#000000";
          };
          "org/gnome/desktop/lockdown" = {
            disable-lock-screen = true;
            disable-log-out = true;
            disable-user-switching = true;
          };
          "org/gnome/desktop/session".idle-delay = lib.gvariant.mkUint32 0;
          "org/gnome/settings-daemon/plugins/power" = {
            sleep-inactive-ac-type = "nothing";
            sleep-inactive-battery-type = "nothing";
          };
        };
        locks = [
          "/org/gnome/shell/disable-user-extensions"
          "/org/gnome/shell/enabled-extensions"
        ];
      }
    ];

    systemd.tmpfiles.rules = [
      "d /Config 0755 root root -"
      "d /Config/ZenOS 0755 root root -"
      "d /home/${cfg.userName}/.local 0700 ${cfg.userName} users -"
      "d /home/${cfg.userName}/.local/share 0700 ${cfg.userName} users -"
      "d /home/${cfg.userName}/.local/share/gnome-shell 0700 ${cfg.userName} users -"
      "f /home/${cfg.userName}/.local/share/gnome-shell/lock-warning-shown 0600 ${cfg.userName} users -"
      "z /Config/ZenOS/Flake 0775 ${cfg.userName} users -"
      "Z /Config/ZenOS/Flake - ${cfg.userName} users -"
    ];
  };
}
