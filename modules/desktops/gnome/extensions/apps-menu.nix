{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.apps-menu;

in
{
  meta = {
    description = ''
      Traditional category-based application menu for GNOME

      This module installs and configures the **Apps Menu** extension for GNOME.
      It adds a traditional application menu to the top bar, organized by category.

      **Features:**
      - Provides a category-based application menu.
      - Configurable keyboard shortcut to toggle the menu.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.apps-menu = {
    enable = mkEnableOption "Apps Menu GNOME extension configuration";

    apps-menu-toggle-menu = mkOption {
      type = types.listOf types.str;
      default = [ "<Alt>F1" ];
      description = ''
        Menu toggle keyboard shortcut

        Keybinding to open the applications menu.
      '';
    };
  };

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
