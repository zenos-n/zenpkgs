{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.auto-theme-switcher;

  meta = {
    description = ''
      Automatic light and dark theme switching for GNOME

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
in
{

  options.zenos.desktops.gnome.extensions.auto-theme-switcher = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Auto Theme Switcher GNOME extension configuration";

    location = {
      name = mkOption {
        type = types.str;
        default = "";
        example = "San Francisco";
        description = ''
          Human-readable location label

          Custom name used to identify the location in the user interface.
        '';
      };

      latitude = mkOption {
        type = types.str;
        default = "";
        example = "37.7749";
        description = ''
          Geographic latitude

          Latitude coordinate used for sunset and sunrise calculations.
        '';
      };

      longitude = mkOption {
        type = types.str;
        default = "";
        example = "-122.4194";
        description = ''
          Geographic longitude

          Longitude coordinate used for sunset and sunrise calculations.
        '';
      };
    };
  };

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
