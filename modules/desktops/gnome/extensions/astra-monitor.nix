{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.astra-monitor;

  meta = {
    description = ''
      Customizable system resource monitor for the GNOME panel

      This module installs and configures the **Astra Monitor** extension for GNOME.
      It provides a customizable panel for monitoring system resources like CPU, 
      GPU, memory, storage, and network usage.

      **Features:**
      - Customizable layout and theme.
      - Support for various sensors and units.
      - Detailed resource usage metrics.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.astra-monitor = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Astra Monitor GNOME extension configuration";

    position-in-panel = mkOption {
      type = types.str;
      default = "right";
      description = ''
        Panel box position

        Placement of the monitor in the GNOME panel (left, center, right).
      '';
    };

    theme-style = mkOption {
      type = types.str;
      default = "dark";
      description = ''
        Interface theme style

        The visual theme for the monitor dropdown (dark, light).
      '';
    };

    shell-bar-position = mkOption {
      type = types.str;
      default = "top";
      description = ''
        Panel orientation

        Shell bar position (top, bottom, left, right).
      '';
    };

    margin-left = mkOption {
      type = types.int;
      default = 8;
      description = ''
        Left horizontal margin

        Pixel spacing on the left side of the panel item.
      '';
    };

    margin-right = mkOption {
      type = types.int;
      default = 8;
      description = ''
        Right horizontal margin

        Pixel spacing on the right side of the panel item.
      '';
    };

    temperature-unit = mkOption {
      type = types.str;
      default = "celsius";
      description = ''
        Unit for temperature display

        Unit used for thermal sensors (celsius, fahrenheit).
      '';
    };

    use-higher-precision = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable high precision sensor readings

        Whether to show more decimal places for sensor values.
      '';
    };

    sensors-update-time = mkOption {
      type = types.int;
      default = 1;
      description = ''
        Refresh interval for sensors

        Time in seconds between resource usage updates.
      '';
    };

    memory-used = mkOption {
      type = types.str;
      default = "active";
      description = ''
        Memory calculation method

        Logic used to determine 'used' memory (active, etc.).
      '';
    };

    storage-used = mkOption {
      type = types.str;
      default = "used-total";
      description = ''
        Storage usage calculation

        Logic used to determine disk space consumption.
      '';
    };

    network-speed = mkOption {
      type = types.str;
      default = "bits";
      description = ''
        Network speed unit

        Unit for bandwidth throughput (bits, bytes).
      '';
    };

    experimental-features = mkOption {
      type = types.str;
      default = "";
      description = ''
        Experimental extension flags

        Enable internal experimental features by passing flag strings.
      '';
    };

    processor-menu-gpu = mkOption {
      type = types.str;
      default = "\"\"";
      description = ''
        GPU visibility toggle (Legacy)

        Deprecated setting for showing GPU usage in the menu.
      '';
    };

    processor-menu-gpu-color = mkOption {
      type = types.str;
      default = "rgba(29,172,214,1.0)";
      description = ''
        GPU usage bar color (Legacy)

        Color used for GPU monitoring bars.
      '';
    };

    headers-height = mkOption {
      type = types.int;
      default = 30;
      description = ''
        Menu header height (Legacy)

        Visual height of the dropdown menu headers.
      '';
    };

    sensors-header-tooltip-sensor5-short-name = mkOption {
      type = types.str;
      default = "";
      description = ''
        Tooltip name for sensor 5

        Custom label for the fifth sensor in tooltips.
      '';
    };

    sensors-header-tooltip-sensor5-digits = mkOption {
      type = types.int;
      default = -1;
      description = ''
        Decimal precision for sensor 5

        Number of digits to show for the fifth sensor tooltip.
      '';
    };
  };

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
