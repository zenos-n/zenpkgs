{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.notification-timeout;

  meta = {
    description = ''
      Custom notification duration management for GNOME

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
in
{

  options.zenos.desktops.gnome.extensions.notification-timeout = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Notification Timeout GNOME extension configuration";

    ignore-idle = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Ignore user idle state for timeouts

        When enabled, notifications will always timeout regardless of whether the 
        user is currently active or idle.
      '';
    };

    always-normal = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Force normal priority for all notifications

        Treats all incoming notifications as normal priority, preventing them 
        from persisting indefinitely even if sent with high priority.
      '';
    };

    timeout = mkOption {
      type = types.int;
      default = 3000;
      description = ''
        Global notification display duration

        Duration in milliseconds after which notifications will automatically 
        be dismissed from the screen.
      '';
    };
  };

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
