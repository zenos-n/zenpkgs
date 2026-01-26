{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.weatherornot;

  mkStr =
    default: description:
    mkOption {
      type = types.str;
      default = default;
      description = description;
    };
in
{
  options.zenos.desktops.gnome.extensions.weatherornot = {
    enable = mkEnableOption "Weather Or Not GNOME extension configuration";

    position = mkStr "clock-right" "Indicator position (left, clock-left, clock-left-centered, clock-right-centered, clock-right, right).";
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
