{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.search-light;

in
{
  meta = {
    description = ''
      Spotlight-style search overlay for GNOME Shell

      This module installs and configures the **Search Light** extension for GNOME.
      It replaces the default search with a macOS Spotlight-like search overlay,
      centered on the screen with customizable styling and shortcuts.

      **Features:**
      - Spotlight-like search interface.
      - Customizable appearance (colors, borders, transparency, blur).
      - Configurable keyboard shortcuts.
      - Unit and currency converters.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.search-light = {
    enable = mkEnableOption "Search Light GNOME extension configuration";

    border-radius = mkOption {
      type = types.float;
      default = 0.0;
      description = ''
        Visual corner rounding radius

        Pixel radius for the search overlay corners. Defaults to 0 for 
        sharp square corners.
      '';
    };

    border-color = mkOption {
      type = types.str;
      default = "(1.0,1.0,1.0,1.0)";
      description = ''
        Search overlay border color

        GVariant tuple defining the RGBA components of the overlay border.
      '';
    };

    border-thickness = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Search overlay border width

        Pixel thickness of the border drawn around the search interface.
      '';
    };

    background-color = mkOption {
      type = types.str;
      default = "(0.0,0.0,0.0,0.9)";
      description = ''
        Search overlay background color

        GVariant tuple defining the RGBA components of the primary 
        search window background.
      '';
    };

    scale-width = mkOption {
      type = types.float;
      default = 0.5;
      description = "Window width relative to the monitor width (0.0 - 1.0)";
    };

    scale-height = mkOption {
      type = types.float;
      default = 0.4;
      description = "Window height relative to the monitor height (0.0 - 1.0)";
    };

    preferred-monitor = mkOption {
      type = types.int;
      default = -1;
      description = ''
        Target display index

        The monitor index where the search box should appear (-1 for 
        primary monitor).
      '';
    };

    monitor-count = mkOption {
      type = types.int;
      default = 1;
      description = "Internal state tracker for available system monitors";
    };

    shortcut-search = mkOption {
      type = types.listOf types.str;
      default = [ "<Super>space" ];
      description = "Primary keyboard shortcut to trigger the search overlay";
    };

    secondary-shortcut-search = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Alternative shortcut to trigger the search overlay";
    };

    popup-at-cursor-monitor = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Reveal overlay at mouse location

        Whether to display the search box on the monitor currently 
        containing the mouse pointer.
      '';
    };

    blur-background = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable background blur

        Applies a gaussian blur effect to the desktop area behind the 
        search overlay.
      '';
    };

    blur-sigma = mkOption {
      type = types.int;
      default = 30;
      description = "Gaussian sigma value determining the strength of the blur";
    };

    blur-brightness = mkOption {
      type = types.float;
      default = 0.6;
      description = "Luminance multiplier for the blurred background area";
    };

    font-size = mkOption {
      type = types.int;
      default = 12;
      description = "Base pixel font size for search results and metadata";
    };

    entry-font-size = mkOption {
      type = types.int;
      default = 24;
      description = "Large pixel font size for the active search input field";
    };

    text-color = mkOption {
      type = types.str;
      default = "(1.0,1.0,1.0,1.0)";
      description = "GVariant tuple defining the RGBA color of the result text";
    };

    show-panel-icon = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Display top bar status icon

        Whether to show the Search Light icon in the GNOME panel for 
        mouse interaction.
      '';
    };

    unit-converter = mkOption {
      type = types.bool;
      default = true;
      description = "Enable real-time unit conversion inside the search results";
    };

    currency-converter = mkOption {
      type = types.bool;
      default = true;
      description = "Enable real-time currency conversion inside the search results";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.search-light ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/search-light" = {
            border-radius = cfg.border-radius;
            border-color = cfg.border-color;
            border-thickness = cfg.border-thickness;
            background-color = cfg.background-color;
            scale-width = cfg.scale-width;
            scale-height = cfg.scale-height;
            preferred-monitor = cfg.preferred-monitor;
            monitor-count = cfg.monitor-count;
            shortcut-search = cfg.shortcut-search;
            secondary-shortcut-search = cfg.secondary-shortcut-search;
            popup-at-cursor-monitor = cfg.popup-at-cursor-monitor;
            blur-background = cfg.blur-background;
            blur-sigma = cfg.blur-sigma;
            blur-brightness = cfg.blur-brightness;
            font-size = cfg.font-size;
            entry-font-size = cfg.entry-font-size;
            text-color = cfg.text-color;
            show-panel-icon = cfg.show-panel-icon;
            unit-converter = cfg.unit-converter;
            currency-converter = cfg.currency-converter;
          };
        };
      }
    ];
  };
}
