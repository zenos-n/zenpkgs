{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.zenos.zenlink;
in
{
  meta = {
    description = ''
      Android to ZenOS communication bridge service

      **ZenLink User Module**

      This module manages the ZenLink daemon for the current user session.
      ZenLink enables audio and camera streaming between Android devices and ZenOS.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.zenlink = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable the ZenLink Android bridge service
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.zenos.system.zenlink;
      defaultText = literalExpression "pkgs.zenos.system.zenlink";
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

    # The config file (~/.config/zenlink/state.conf) is intentionally
    # NOT managed by Home Manager to allow the imperative `zl-config`
    # tool to modify it at runtime without read-only errors.

    systemd.zenlink = mkIf cfg.autoStart {
      Unit = {
        Description = "ZenLink Daemon";
        After = [
          "graphical-session.target"
          "pipewire.service"
        ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/zl-daemon";
        Restart = "on-failure";
        RestartSec = "3s";
        Environment = "PATH=${lib.makeBinPath [ cfg.package ]}:$PATH";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
