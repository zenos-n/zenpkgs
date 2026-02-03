{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.app-hider;

in
{
  meta = {
    description = ''
      Hide specific applications from the GNOME app grid and search

      This module installs and configures the **App Hider** extension for GNOME.
      It allows hiding specific applications from the application grid and search results.

      **Features:**
      - Hide apps from the app grid.
      - Hide apps from search results.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.app-hider = {
    enable = mkEnableOption "App Hider GNOME extension configuration";

    hidden-apps = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        List of hidden application IDs

        Applications that are hidden from the standard app grid.
      '';
    };

    hidden-search-apps = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        List of applications hidden from search

        Applications that are hidden specifically from GNOME Shell search results.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.app-hider ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/app-hider" = {
            hidden-apps = cfg.hidden-apps;
            hidden-search-apps = cfg.hidden-search-apps;
          };
        };
      }
    ];
  };
}
