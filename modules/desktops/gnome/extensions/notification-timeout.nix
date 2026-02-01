{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.notification-timeout;

in
{
  meta = {
    description = "Configures the Notification Timeout GNOME extension";
    longDescription = ''
      This module installs and configures the **Notification Timeout** extension for GNOME.
      It allows setting a custom timeout for notifications, ensuring they disappear
      automatically after a specified duration.

      **Features:**
      - Configurable timeout duration in milliseconds.
      - Option to ignore user idle state.
      - Force all notifications to be treated as normal priority.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.notification-timeout = {
    enable = mkEnableOption "Notification Timeout GNOME extension configuration";

    ignore-idle = mkOption {
      type = types.bool;
      default = true;
      description = "Ignores idle user - always timeout";
    };

    always-normal = mkOption {
      type = types.bool;
      default = true;
      description = "Always treat notifications as normal priority";
    };

    timeout = mkOption {
      type = types.int;
      default = 3000;
      description = "Notification timeout in milliseconds";
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.notification-timeout ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/notification-timeout" = {
            ignore-idle = cfg.ignore-idle;
            always-normal = cfg.always-normal;
            timeout = cfg.timeout;
          };
        };
      }
    ];
  };
}
