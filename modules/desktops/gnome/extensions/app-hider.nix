{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.app-hider;

  # --- Helpers for Types ---
  mkStrList =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

in
{
  meta = {
    description = "Configures the App Hider GNOME extension";
    longDescription = ''
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

    hidden-apps = mkStrList [ ] "Apps that are hidden";

    hidden-search-apps = mkStrList [ ] "Apps that are hidden from search";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.app-hider ];

    # Standard types (b, i, s, as) are handled directly by dconf module
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
