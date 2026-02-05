{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.tactile;

  mkKeybindOption =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

  meta = {
    description = ''
      Grid-based window organization and layout manager

      This module installs and configures the **Tactile** extension for GNOME.
      Tactile is a tiling window manager extension that allows you to organize 
      windows using a custom grid layout and keyboard shortcuts.

      **Features:**
      - Custom grid layouts.
      - Keyboard-driven window placement.
      - Multi-monitor support.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.tactile = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Tactile GNOME extension configuration";

    keybindings = {
      global = {
        show-tiles = mkKeybindOption [ "<Super>t" ] "Shortcut to reveal the tiling grid overlay";
        hide-tiles = mkKeybindOption [ "Escape" ] "Shortcut to conceal the tiling grid overlay";
        show-settings = mkKeybindOption [ "<Super><Shift>t" ] "Shortcut to open the Tactile settings panel";
      };

      monitors = {
        next = mkKeybindOption [ "n" ] "Key to move tiles overlay to the next monitor";
        prev = mkKeybindOption [ "p" ] "Key to move tiles overlay to the previous monitor";
      };

      layouts = {
        one = mkKeybindOption [ "1" ] "Shortcut to activate grid layout 1";
        two = mkKeybindOption [ "2" ] "Shortcut to activate grid layout 2";
        three = mkKeybindOption [ "3" ] "Shortcut to activate grid layout 3";
      };
    };

    appearance = {
      colors = {
        text = mkOption {
          type = types.str;
          default = "rgba(255, 255, 255, 1)";
          description = "CSS color for grid labels";
        };
        border = mkOption {
          type = types.str;
          default = "rgba(255, 255, 255, 1)";
          description = "CSS color for tile boundaries";
        };
        background = mkOption {
          type = types.str;
          default = "rgba(0, 0, 0, 0.5)";
          description = "CSS color for tile background area";
        };
      };
      sizes = {
        text = mkOption {
          type = types.int;
          default = 24;
          description = "Pixel font size for grid labels";
        };
        border = mkOption {
          type = types.int;
          default = 2;
          description = "Pixel thickness for grid boundaries";
        };
      };
      gap-size = mkOption {
        type = types.int;
        default = 10;
        description = "Pixel spacing between individual tiles in the grid";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.tactile ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/tactile" = {
            show-tiles = cfg.keybindings.global.show-tiles;
            hide-tiles = cfg.keybindings.global.hide-tiles;
            show-settings = cfg.keybindings.global.show-settings;
            monitor-next = cfg.keybindings.monitors.next;
            monitor-prev = cfg.keybindings.monitors.prev;
            layout-1 = cfg.keybindings.layouts.one;
            layout-2 = cfg.keybindings.layouts.two;
            layout-3 = cfg.keybindings.layouts.three;
            text-color = cfg.appearance.colors.text;
            border-color = cfg.appearance.colors.border;
            background-color = cfg.appearance.colors.background;
            text-size = cfg.appearance.sizes.text;
            border-size = cfg.appearance.sizes.border;
            gap-size = cfg.appearance.gap-size;
          };
        };
      }
    ];
  };
}
