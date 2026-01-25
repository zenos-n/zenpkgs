{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.astra-monitor;

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

  mkStr =
    default: description:
    mkOption {
      type = types.str;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.astra-monitor = {
    enable = mkEnableOption "Astra Monitor GNOME extension configuration";

    # --- Appearance ---
    position-in-panel = mkStr "right" "Panel box position (left, center, right).";
    theme-style = mkStr "dark" "Theme style (dark, light).";
    shell-bar-position = mkStr "top" "Shell bar position (top, bottom, left, right).";
    margin-left = mkInt 8 "Left margin.";
    margin-right = mkInt 8 "Right margin.";

    # --- Sensors & Units ---
    temperature-unit = mkStr "celsius" "Temperature unit (celsius, fahrenheit).";
    use-higher-precision = mkBool false "Use higher precision for sensors.";
    sensors-update-time = mkInt 1 "Sensors update time (seconds).";

    # --- Resources ---
    memory-used = mkStr "active" "Memory usage calculation method.";
    storage-used = mkStr "used-total" "Storage usage calculation method.";
    network-speed = mkStr "bits" "Network speed unit.";

    # --- Features ---
    experimental-features = mkStr "" "Enable experimental features.";

    # --- Deprecated / Legacy Keys (Preserved for compatibility) ---
    processor-menu-gpu = mkStr "\"\"" "Show GPU usage (deprecated).";
    processor-menu-gpu-color = mkStr "rgba(29,172,214,1.0)" "GPU Bars Color (deprecated).";
    headers-height = mkInt 30 "Headers height (deprecated).";

    # --- Tooltips ---
    sensors-header-tooltip-sensor5-short-name = mkStr "" "Sensor 5 Tooltip Short Name.";
    sensors-header-tooltip-sensor5-digits = mkInt (-1) "Sensor 5 Tooltip Digits.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.astra-monitor ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/astra-monitor" = {
            position-in-panel = cfg.position-in-panel;
            theme-style = cfg.theme-style;
            shell-bar-position = cfg.shell-bar-position;
            margin-left = cfg.margin-left;
            margin-right = cfg.margin-right;
            temperature-unit = cfg.temperature-unit;
            use-higher-precision = cfg.use-higher-precision;
            sensors-update-time = cfg.sensors-update-time;
            memory-used = cfg.memory-used;
            storage-used = cfg.storage-used;
            network-speed = cfg.network-speed;
            experimental-features = cfg.experimental-features;

            # Legacy
            processor-menu-gpu = cfg.processor-menu-gpu;
            processor-menu-gpu-color = cfg.processor-menu-gpu-color;
            headers-height = cfg.headers-height;

            sensors-header-tooltip-sensor5-short-name = cfg.sensors-header-tooltip-sensor5-short-name;
            sensors-header-tooltip-sensor5-digits = cfg.sensors-header-tooltip-sensor5-digits;
          };
        };
      }
    ];
  };
}
