{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.search-light;

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

  mkDouble =
    default: description:
    mkOption {
      type = types.float;
      default = default;
      description = description;
    };

  mkStr =
    default: description:
    mkOption {
      type = types.str;
      default = default;
      description = description;
    };

  mkColor =
    default: description:
    mkOption {
      type = types.str;
      default = default;
      description = description;
    };

  mkOptionStrList =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.search-light = {
    enable = mkEnableOption "Search Light GNOME extension configuration";

    border-radius = mkDouble 0.0 "Border radius.";
    border-color = mkColor "(1.0,1.0,1.0,1.0)" "Border color (GVariant tuple).";
    border-thickness = mkInt 0 "Border thickness.";
    background-color = mkColor "(0.0,0.0,0.0,0.25)" "Background color (GVariant tuple).";
    scale-width = mkDouble 0.1 "Scale width.";
    scale-height = mkDouble 0.1 "Scale height.";
    preferred-monitor = mkInt 0 "Preferred monitor index.";
    monitor-count = mkInt 1 "Monitors count.";
    shortcut-search = mkOptionStrList [ ] "Shortcut for search.";
    secondary-shortcut-search = mkOptionStrList [ ] "Secondary shortcut for search.";
    popup-at-cursor-monitor = mkBool false "Popup at cursor monitor.";
    msg-to-pref = mkStr "" "MsgBus to pref.";
    msg-to-ext = mkStr "" "MsgBus to ext.";
    blur-background = mkBool false "Enable background blur.";
    blur-sigma = mkDouble 30.0 "Blur sigma.";
    blur-brightness = mkDouble 0.6 "Blur brightness.";
    font-size = mkInt 0 "Text size.";
    entry-font-size = mkInt 1 "Entry text size.";
    text-color = mkColor "(1.0,1.0,1.0,0.0)" "Text color (GVariant tuple).";
    panel-icon-color = mkColor "(1.0,1.0,1.0,1.0)" "Panel icon color (GVariant tuple).";
    entry-text-color = mkColor "(1.0,1.0,1.0,0.0)" "Entry text color (GVariant tuple).";
    show-panel-icon = mkBool false "Show panel icon.";
    unit-converter = mkBool false "Show unit converter.";
    currency-converter = mkBool false "Show currency converter.";
    window-effect = mkInt 0 "Window effect.";
    window-effect-color = mkColor "(1.0,1.0,1.0,1.0)" "Window effect color (GVariant tuple).";
    use-animations = mkBool true "Use window animations.";
    animation-speed = mkDouble 100.0 "Animation speed.";
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
