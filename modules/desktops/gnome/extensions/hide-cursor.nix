{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.hide-cursor;

  # --- Helpers for Types ---
  mkInt =
    default: description:
    mkOption {
      type = types.int;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.hide-cursor = {
    enable = mkEnableOption "Hide Cursor GNOME extension configuration";

    timeout = mkInt 5 "Time in seconds after which the cursor is hidden when idle.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.hide-cursor ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/hide-cursor-elcste-com" = {
            timeout = cfg.timeout;
          };
        };
      }
    ];
  };
}
