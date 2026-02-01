{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.auto-theme-switcher;

in
{
  meta = {
    description = "Configures the Auto Theme Switcher GNOME extension";
    longDescription = ''
      This module installs and configures the **Auto Theme Switcher** extension for GNOME.
      It automatically toggles the system theme between light and dark modes based on
      custom coordinates or system location services.

      **Features:**
      - Set custom coordinates (Latitude/Longitude).
      - Define a human-readable location name.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.auto-theme-switcher = {
    enable = mkEnableOption "Auto Theme Switcher GNOME extension configuration";

    location = {
      name = mkOption {
        type = types.str;
        default = "";
        example = "San Francisco";
        description = "Human-readable location name used for display";
      };

      latitude = mkOption {
        type = types.str;
        default = "";
        example = "37.7749";
        description = "Latitude for sunset/sunrise calculation";
      };

      longitude = mkOption {
        type = types.str;
        default = "";
        example = "-122.4194";
        description = "Longitude for sunset/sunrise calculation";
      };
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.auto-theme-switcher ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/auto-theme-switcher" = {
            manual-latitude = cfg.location.latitude;
            manual-longitude = cfg.location.longitude;
            location-name = cfg.location.name;
          };
        };
      }
    ];
  };
}
