{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.weatherornot;

in
{
  meta = {
    description = "Configures the Weather Or Not GNOME extension";
    longDescription = ''
      This module installs and configures the **Weather Or Not** extension for GNOME.
      It allows you to place the weather indicator in various positions on the panel,
      such as next to the clock or on the left/right sides.

      **Features:**
      - Flexible positioning of the weather indicator.
      - Integration with the clock menu.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.weatherornot = {
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
      description = "Indicator position";
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
