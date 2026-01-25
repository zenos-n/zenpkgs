{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.notification-timeout;

  # --- Helpers for Types ---
  mkBool =
    default: description:
    mkOption {
      type = types.bool;
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

in
{
  options.zenos.desktops.gnome.extensions.notification-timeout = {
    enable = mkEnableOption "Notification Timeout GNOME extension configuration";

    ignore-idle = mkBool true "Ignores idle user - always timeout.";
    always-normal = mkBool true "Always treat notifications as normal priority.";
    timeout = mkInt 3000 "Notification timeout in milliseconds.";
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
