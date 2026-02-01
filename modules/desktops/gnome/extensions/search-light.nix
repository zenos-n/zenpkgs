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
    description = "Configures the Search Light GNOME extension";
    longDescription = ''
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
      description = "Border radius";
    };

    border-color = mkOption {
      type = types.str;
      default = "(1.0,1.0,1.0,1.0)";
      description = "Border color (GVariant tuple)";
    };

    border-thickness = mkOption {
      type = types.int;
      default = 0;
      description = "Border thickness";
    };

    background-color = mkOption {
      type = types.str;
      default = "(0.0,0.0,0.0,0.25)";
      description = "Background color (GVariant tuple)";
    };

    scale-width = mkOption {
      type = types.float;
      default = 0.1;
      description = "Scale width";
    };

    scale-height = mkOption {
      type = types.float;
      default = 0.1;
      description = "Scale height";
    };

    preferred-monitor = mkOption {
      type = types.int;
      default = 0;
      description = "Preferred monitor index";
    };

    monitor-count = mkOption {
      type = types.int;
      default = 1;
      description = "Monitors count";
    };

    shortcut-search = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Shortcut for search";
    };

    secondary-shortcut-search = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Secondary shortcut for search";
    };

    popup-at-cursor-monitor = mkOption {
      type = types.bool;
      default = false;
      description = "Popup at cursor monitor";
    };

    msg-to-pref = mkOption {
      type = types.str;
      default = "";
      description = "MsgBus to pref";
    };

    msg-to-ext = mkOption {
      type = types.str;
      default = "";
      description = "MsgBus to ext";
    };

    blur-background = mkOption {
      type = types.bool;
      default = false;
      description = "Enable background blur";
    };

    blur-sigma = mkOption {
      type = types.float;
      default = 30.0;
      description = "Blur sigma";
    };

    blur-brightness = mkOption {
      type = types.float;
      default = 0.6;
      description = "Blur brightness";
    };

    font-size = mkOption {
      type = types.int;
      default = 0;
      description = "Text size";
    };

    entry-font-size = mkOption {
      type = types.int;
      default = 1;
      description = "Entry text size";
    };

    text-color = mkOption {
      type = types.str;
      default = "(1.0,1.0,1.0,0.0)";
      description = "Text color (GVariant tuple)";
    };

    panel-icon-color = mkOption {
      type = types.str;
      default = "(1.0,1.0,1.0,1.0)";
      description = "Panel icon color (GVariant tuple)";
    };

    entry-text-color = mkOption {
      type = types.str;
      default = "(1.0,1.0,1.0,0.0)";
      description = "Entry text color (GVariant tuple)";
    };

    show-panel-icon = mkOption {
      type = types.bool;
      default = false;
      description = "Show panel icon";
    };

    unit-converter = mkOption {
      type = types.bool;
      default = false;
      description = "Show unit converter";
    };

    currency-converter = mkOption {
      type = types.bool;
      default = false;
      description = "Show currency converter";
    };

    window-effect = mkOption {
      type = types.int;
      default = 0;
      description = "Window effect";
    };

    window-effect-color = mkOption {
      type = types.str;
      default = "(1.0,1.0,1.0,1.0)";
      description = "Window effect color (GVariant tuple)";
    };

    use-animations = mkOption {
      type = types.bool;
      default = true;
      description = "Use window animations";
    };

    animation-speed = mkOption {
      type = types.float;
      default = 100.0;
      description = "Animation speed";
    };
  };

  # --- Implementation ---
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
            msg-to-pref = cfg.msg-to-pref;
            msg-to-ext = cfg.msg-to-ext;
            blur-background = cfg.blur-background;
            blur-sigma = cfg.blur-sigma;
            blur-brightness = cfg.blur-brightness;
            font-size = cfg.font-size;
            entry-font-size = cfg.entry-font-size;
            text-color = cfg.text-color;
            panel-icon-color = cfg.panel-icon-color;
            entry-text-color = cfg.entry-text-color;
            show-panel-icon = cfg.show-panel-icon;
            unit-converter = cfg.unit-converter;
            currency-converter = cfg.currency-converter;
            window-effect = cfg.window-effect;
            window-effect-color = cfg.window-effect-color;
            use-animations = cfg.use-animations;
            animation-speed = cfg.animation-speed;
          };
        };
      }
    ];
  };
}
