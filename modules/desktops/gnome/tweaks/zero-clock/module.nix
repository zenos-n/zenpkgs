{
  config,
  lib,
  ...
}:

let
  cfg = config.zenos.desktops.gnome.tweaks.zeroClock;

in
{
  meta = {
    description = ''
      GNOME lock screen and top bar clock font tweak

      Applies the "Zero" font style to the GNOME lock screen clock and the top bar clock. 
      It utilizes `customize-clock-on-lockscreen` for the lock screen and a CSS 
      override via `user-theme` for the top bar.

      **Features:**
      - Sets "ZeroMono" font for the lock screen time.
      - Sets "ZeroClock" font for the lock screen date and top bar clock.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.tweaks.zeroClock = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable the Zero GNOME clock font tweak

        When enabled, this modifies the typography of the shell clock to match 
        the ZenOS aesthetic using ZeroMono and ZeroClock fonts.
      '';
    };
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
  };
}
