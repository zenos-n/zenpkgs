{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.astra-monitor;

in
{
  meta = {
    description = "Configures the Astra Monitor GNOME extension";
    longDescription = ''
      This module installs and configures the **Astra Monitor** extension for GNOME.
      It provides a customizable panel for monitoring system resources like CPU, GPU, memory, storage, and network usage.

      **Features:**
      - Customizable layout and theme.
      - Support for various sensors and units.
      - Detailed resource usage metrics.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.astra-monitor = {
    enable = mkEnableOption "Astra Monitor GNOME extension configuration";

    # --- Appearance ---
    position-in-panel = mkOption {
      type = types.str;
      default = "right";
      description = "Panel box position (left, center, right)";
    };

    theme-style = mkOption {
      type = types.str;
      default = "dark";
      description = "Theme style (dark, light)";
    };

    shell-bar-position = mkOption {
      type = types.str;
      default = "top";
      description = "Shell bar position (top, bottom, left, right)";
    };

    margin-left = mkOption {
      type = types.int;
      default = 8;
      description = "Left margin";
    };

    margin-right = mkOption {
      type = types.int;
      default = 8;
      description = "Right margin";
    };

    # --- Sensors & Units ---
    temperature-unit = mkOption {
      type = types.str;
      default = "celsius";
      description = "Temperature unit (celsius, fahrenheit)";
    };

    use-higher-precision = mkOption {
      type = types.bool;
      default = false;
      description = "Use higher precision for sensors";
    };

    sensors-update-time = mkOption {
      type = types.int;
      default = 1;
      description = "Sensors update time (seconds)";
    };

    # --- Resources ---
    memory-used = mkOption {
      type = types.str;
      default = "active";
      description = "Memory usage calculation method";
    };

    storage-used = mkOption {
      type = types.str;
      default = "used-total";
      description = "Storage usage calculation method";
    };

    network-speed = mkOption {
      type = types.str;
      default = "bits";
      description = "Network speed unit";
    };

    # --- Features ---
    experimental-features = mkOption {
      type = types.str;
      default = "";
      description = "Enable experimental features";
    };

    # --- Deprecated / Legacy Keys (Preserved for compatibility) ---
    processor-menu-gpu = mkOption {
      type = types.str;
      default = "\"\"";
      description = "Show GPU usage (deprecated)";
    };

    processor-menu-gpu-color = mkOption {
      type = types.str;
      default = "rgba(29,172,214,1.0)";
      description = "GPU Bars Color (deprecated)";
    };

    headers-height = mkOption {
      type = types.int;
      default = 30;
      description = "Headers height (deprecated)";
    };

    # --- Tooltips ---
    sensors-header-tooltip-sensor5-short-name = mkOption {
      type = types.str;
      default = "";
      description = "Sensor 5 Tooltip Short Name";
    };

    sensors-header-tooltip-sensor5-digits = mkOption {
      type = types.int;
      default = -1;
      description = "Sensor 5 Tooltip Digits";
    };
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
