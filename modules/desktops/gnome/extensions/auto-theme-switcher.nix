{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.auto-theme-switcher;

  # --- Helpers for Types ---
  mkStr =
    default: description:
    mkOption {
      type = types.str;
      default = default;
      description = description;
    };

  mkInt =
    default: description:
    mkOption {
      type = types.int;
      default = default;
      description = description;
    };

  mkInt64 = mkInt; # Nix int handles 64-bit

in
{
  options.zenos.desktops.gnome.extensions.auto-theme-switcher = {
    enable = mkEnableOption "Auto Theme Switcher GNOME extension configuration";

    manual-latitude = mkStr "" "Latitude for calculation (e.g. '37.7749').";
    manual-longitude = mkStr "" "Longitude for calculation (e.g. '-122.4194').";
    location-name = mkStr "" "Human-readable location name.";

    monitors-last-detection = mkInt64 0 "Timestamp of last monitor detection.";
    data-version = mkInt 0 "Data structure version.";
    migration-notification-pending = mkStr "" "Pending migration notification type.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.auto-theme-switcher ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/auto-theme-switcher" = {
            manual-latitude = cfg.manual-latitude;
            manual-longitude = cfg.manual-longitude;
            location-name = cfg.location-name;
            monitors-last-detection = cfg.monitors-last-detection;
            data-version = cfg.data-version;
            migration-notification-pending = cfg.migration-notification-pending;
          };
        };
      }
    ];
  };
}
