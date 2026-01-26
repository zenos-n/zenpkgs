{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.apps-menu;

  # --- Helpers for Types ---
  mkOptionStrList =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.apps-menu = {
    enable = mkEnableOption "Apps Menu GNOME extension configuration";

    apps-menu-toggle-menu = mkOptionStrList [ "<Alt>F1" ] "Keybinding to open the applications menu.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.apps-menu ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/apps-menu" = {
            apps-menu-toggle-menu = cfg.apps-menu-toggle-menu;
          };
        };
      }
    ];
  };
}
