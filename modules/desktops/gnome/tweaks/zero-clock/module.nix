{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.zenos.desktops.gnome.tweaks.zeroClock;
in
{
  options.zenos.desktops.gnome.tweaks.zeroClock = {
    enable = lib.mkEnableOption "Zero GNOME clock font";
  };

  config = lib.mkIf cfg.enable {

    zenos.desktops.gnome.extensions = {
      customize-clock-on-lockscreen = {
        enable = true;
        time = {
          enable = true;
          text = "%H%n%M";
          font = {
            family = "ZeroMono";
            weight = "100";
            size = 84;
          };
        };
        date = {
          enable = true;
          text = "%d.%m.%Y";
          font = {
            family = "ZeroClock";
            weight = "100";
            size = 24;
          };
        };
      };
    };
    user-theme = {
      enable = true;
      theme.cssOverride = ''
        /* The Top Bar Clock */
        .clock-display {
            font-family: 'ZeroClock', sans-serif !important;
            font-weight: normal !important;
            font-style: normal !important;
            font-size: 12px;
        }
      '';
    };
  };
}
