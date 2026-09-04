{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.weatherornot;

  meta = {
    description = ''
      Flexible weather indicator positioning for the panel

      This module installs and configures the **Weather Or Not** extension for GNOME.
      It allows you to decouple the weather indicator from the date menu and place 
      it in various positions across the top bar.

      **Features:**
      - Move weather to the left, center, or right of the clock.
      - Integrated panel alignment options.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.weatherornot = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Weather Or Not GNOME extension configuration";

    position = mkOption {
      type = types.enum [
        "left"
        "clock-left"
        "clock-left-centered"
        "clock-right-centered"
        "clock-right"
        "right"
      ];
      default = "clock-right";
      description = ''
        Panel anchor position for the weather icon

        Determines where the weather information is rendered relative to the 
        system clock or panel edges.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.weather-or-not ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/weatherornot" = {
            position = cfg.position;
          };
        };
      }
    ];
  };
}
