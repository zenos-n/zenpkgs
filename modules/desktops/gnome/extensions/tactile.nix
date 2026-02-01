{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.tactile;

  # Helper for keybinding options
  mkKeybindOption =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

in
{
  meta = {
    description = "Configures the Tactile GNOME extension";
    longDescription = ''
      This module installs and configures the **Tactile** extension for GNOME.
      Tactile is a tiling window manager extension that allows you to organize windows
      using a custom grid layout and keyboard shortcuts.

      **Features:**
      - Custom grid layouts.
      - Keyboard-driven window placement.
      - Multi-monitor support.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.tactile = {
    enable = mkEnableOption "Tactile GNOME extension configuration";

    # --- Keybindings ---
    keybindings = {
      global = {
        show-tiles = mkKeybindOption [ "<Super>t" ] "Show tiles overlay";
        hide-tiles = mkKeybindOption [ "Escape" ] "Hide tiles overlay";
        show-settings = mkKeybindOption [ "<Super><Shift>t" ] "Show settings panel";
      };

      monitors = {
        next = mkKeybindOption [ "space" ] "Move tiles to next monitor";
        previous = mkKeybindOption [ "<Shift>space" ] "Move tiles to previous monitor";
      };

      layouts = {
        select-1 = mkKeybindOption [ "1" ] "Switch to Layout 1";
        select-2 = mkKeybindOption [ "2" ] "Switch to Layout 2";
        select-3 = mkKeybindOption [ "3" ] "Switch to Layout 3";
        select-4 = mkKeybindOption [ "4" ] "Switch to Layout 4";
      };

      # Tile Activation Keys
      tiles = {
        # Row 0
        "0-0" = mkKeybindOption [ "q" ] "Tile 0:0";
        "1-0" = mkKeybindOption [ "w" ] "Tile 1:0";
        "2-0" = mkKeybindOption [ "e" ] "Tile 2:0";
        "3-0" = mkKeybindOption [ "r" ] "Tile 3:0";
        # Row 1
        "0-1" = mkKeybindOption [ "a" ] "Tile 0:1";
        "1-1" = mkKeybindOption [ "s" ] "Tile 1:1";
        "2-1" = mkKeybindOption [ "d" ] "Tile 2:1";
        "3-1" = mkKeybindOption [ "f" ] "Tile 3:1";
        # Row 2
        "0-2" = mkKeybindOption [ "z" ] "Tile 0:2";
        "1-2" = mkKeybindOption [ "x" ] "Tile 1:2";
        "2-2" = mkKeybindOption [ "c" ] "Tile 2:2";
        "3-2" = mkKeybindOption [ "v" ] "Tile 3:2";
      };
    };

    # --- Layout Definitions ---
    layouts = {
      one = {
        cols = {
          "0" = mkOption {
            type = types.int;
            default = 1;
            description = "Column 0 weight";
          };
          "1" = mkOption {
            type = types.int;
            default = 1;
            description = "Column 1 weight";
          };
          "2" = mkOption {
            type = types.int;
            default = 1;
            description = "Column 2 weight";
          };
          "3" = mkOption {
            type = types.int;
            default = 1;
            description = "Column 3 weight";
          };
          "4" = mkOption {
            type = types.int;
            default = 0;
            description = "Column 4 weight";
          };
        };
        rows = {
          "0" = mkOption {
            type = types.int;
            default = 1;
            description = "Row 0 weight";
          };
          "1" = mkOption {
            type = types.int;
            default = 1;
            description = "Row 1 weight";
          };
          "2" = mkOption {
            type = types.int;
            default = 0;
            description = "Row 2 weight";
          };
        };
      };

      two = {
        cols = {
          "0" = mkOption {
            type = types.int;
            default = 1;
            description = "Column 0 weight";
          };
          "1" = mkOption {
            type = types.int;
            default = 1;
            description = "Column 1 weight";
          };
          "2" = mkOption {
            type = types.int;
            default = 1;
            description = "Column 2 weight";
          };
        };
        rows = {
          "0" = mkOption {
            type = types.int;
            default = 1;
            description = "Row 0 weight";
          };
          "1" = mkOption {
            type = types.int;
            default = 1;
            description = "Row 1 weight";
          };
        };
      };

      three = {
        cols = {
          "0" = mkOption {
            type = types.int;
            default = 1;
            description = "Column 0 weight";
          };
          "1" = mkOption {
            type = types.int;
            default = 1;
            description = "Column 1 weight";
          };
        };
        rows = {
          "0" = mkOption {
            type = types.int;
            default = 1;
            description = "Row 0 weight";
          };
          "1" = mkOption {
            type = types.int;
            default = 1;
            description = "Row 1 weight";
          };
        };
      };
    };

    # --- Monitor Configuration ---
    monitors = {
      "0" = mkOption {
        type = types.int;
        default = 1;
        description = "Layout index for Monitor 0";
      };
      "1" = mkOption {
        type = types.int;
        default = 1;
        description = "Layout index for Monitor 1";
      };
      "2" = mkOption {
        type = types.int;
        default = 1;
        description = "Layout index for Monitor 2";
      };
    };

    # --- Appearance ---
    appearance = {
      colors = {
        text = mkOption {
          type = types.str;
          default = "rgba(128,128,255,1.0)";
          description = "Text color (CSS string)";
        };
        border = mkOption {
          type = types.str;
          default = "rgba(128,128,255,0.5)";
          description = "Border color (CSS string)";
        };
        background = mkOption {
          type = types.str;
          default = "rgba(128,128,255,0.1)";
          description = "Background color (CSS string)";
        };
      };

      sizes = {
        text = mkOption {
          type = types.int;
          default = 48;
          description = "Text size";
        };
        border = mkOption {
          type = types.int;
          default = 1;
          description = "Border size";
        };
        gap = mkOption {
          type = types.int;
          default = 0;
          description = "Gap size";
        };
      };

      grid = {
        cols = mkOption {
          type = types.int;
          default = 4;
          description = "Number of grid columns";
        };
        rows = mkOption {
          type = types.int;
          default = 3;
          description = "Number of grid rows";
        };
      };
    };

    # --- Behavior ---
    behavior = {
      maximize = mkOption {
        type = types.bool;
        default = true;
        description = "Maximize window when possible";
      };
      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Log debug information";
      };
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.tactile ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/tactile" = {
            # Shortcuts
            show-tiles = cfg.keybindings.global.show-tiles;
            hide-tiles = cfg.keybindings.global.hide-tiles;
            next-monitor = cfg.keybindings.monitors.next;
            prev-monitor = cfg.keybindings.monitors.previous;
            show-settings = cfg.keybindings.global.show-settings;

            layout-1 = cfg.keybindings.layouts.select-1;
            layout-2 = cfg.keybindings.layouts.select-2;
            layout-3 = cfg.keybindings.layouts.select-3;
            layout-4 = cfg.keybindings.layouts.select-4;

            # Tile Keys
            tile-0-0 = cfg.keybindings.tiles."0-0";
            tile-1-0 = cfg.keybindings.tiles."1-0";
            tile-2-0 = cfg.keybindings.tiles."2-0";
            tile-3-0 = cfg.keybindings.tiles."3-0";
            tile-0-1 = cfg.keybindings.tiles."0-1";
            tile-1-1 = cfg.keybindings.tiles."1-1";
            tile-2-1 = cfg.keybindings.tiles."2-1";
            tile-3-1 = cfg.keybindings.tiles."3-1";
            tile-0-2 = cfg.keybindings.tiles."0-2";
            tile-1-2 = cfg.keybindings.tiles."1-2";
            tile-2-2 = cfg.keybindings.tiles."2-2";
            tile-3-2 = cfg.keybindings.tiles."3-2";

            # Layout 1
            col-0 = cfg.layouts.one.cols."0";
            col-1 = cfg.layouts.one.cols."1";
            col-2 = cfg.layouts.one.cols."2";
            col-3 = cfg.layouts.one.cols."3";
            col-4 = cfg.layouts.one.cols."4";
            row-0 = cfg.layouts.one.rows."0";
            row-1 = cfg.layouts.one.rows."1";
            row-2 = cfg.layouts.one.rows."2";

            # Layout 2
            layout-2-col-0 = cfg.layouts.two.cols."0";
            layout-2-col-1 = cfg.layouts.two.cols."1";
            layout-2-col-2 = cfg.layouts.two.cols."2";
            layout-2-row-0 = cfg.layouts.two.rows."0";
            layout-2-row-1 = cfg.layouts.two.rows."1";

            # Layout 3
            layout-3-col-0 = cfg.layouts.three.cols."0";
            layout-3-col-1 = cfg.layouts.three.cols."1";
            layout-3-row-0 = cfg.layouts.three.rows."0";
            layout-3-row-1 = cfg.layouts.three.rows."1";

            # Monitors
            monitor-0-layout = cfg.monitors."0";
            monitor-1-layout = cfg.monitors."1";
            monitor-2-layout = cfg.monitors."2";

            # Appearance
            text-color = cfg.appearance.colors.text;
            border-color = cfg.appearance.colors.border;
            background-color = cfg.appearance.colors.background;
            text-size = cfg.appearance.sizes.text;
            border-size = cfg.appearance.sizes.border;
            gap-size = cfg.appearance.sizes.gap;
            grid-cols = cfg.appearance.grid.cols;
            grid-rows = cfg.appearance.grid.rows;

            # Behavior
            maximize = cfg.behavior.maximize;
            debug = cfg.behavior.debug;
          };
        };
      }
    ];
  };
}
