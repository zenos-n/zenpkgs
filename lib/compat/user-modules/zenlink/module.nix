{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.zenos.zenlink;
  meta = {
    description = ''
      ZenLink native phone integration

      **ZenLink User Module**

      This module manages the ZenLink daemon for the current user session.
      ZenLink enables audio and camera streaming between Android devices and ZenOS.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.zenlink = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable the ZenLink Android bridge service
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.zenos.byCategories.system.zenlink;
      defaultText = literalExpression "pkgs.zenos.byCategories.system.zenlink";
      description = ''
        The ZenLink package to install
      '';
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to auto-start the ZenLink daemon with the session
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    dconf.settings."org/gnome/shell" = {
      enabled-extensions = [ "zenlink@zenos-n.github.io" ];
      disabled-extensions = [ "gsconnect@andyholmes.github.io" ];
    };
    dconf.settings."org/zenos/zenlink".enabled = cfg.autoStart;
    xdg.dataFile."dbus-1/services/org.zenos.ZenLink.service".text = ''
      [D-BUS Service]
      Name=org.zenos.ZenLink
      Exec=${cfg.package}/bin/zenlink
      SystemdService=zenlink.service
    '';
    systemd.user.services.zenlink = {
      Unit = {
        Description = "ZenLink device service";
        After = [ "graphical-session-pre.target" "pipewire.service" "pipewire-pulse.service" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "dbus";
        BusName = "org.zenos.ZenLink";
        ExecStart = "${cfg.package}/bin/zenlink";
        Restart = "on-failure";
        RestartSec = "3s";
      };
      Install.WantedBy = lib.optionals cfg.autoStart [ "graphical-session.target" ];
    };
  };
}
