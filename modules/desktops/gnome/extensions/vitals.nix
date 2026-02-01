{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.vitals;

in
{
  meta = {
    description = "Configures the Vitals GNOME extension";
    longDescription = ''
      This module installs and configures the **Vitals** extension for GNOME.
      Vitals provides a glimpse into your computer's temperature, voltage, fan speed, memory usage,
      processor load, system resources, network speed and storage stats.

      **Features:**
      - Customizable sensors in the top bar.
      - Detailed system monitoring dropdown.
      - Support for CPU, Memory, Storage, Network, and more.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.vitals = {
    enable = mkEnableOption "Vitals GNOME extension configuration";

    # --- Sensors & Data ---
    sensors = {
      hot-list = mkOption {
        type = types.listOf types.str;
        default = [
          "_memory_usage_"
          "_system_load_1m_"
          "__network-rx_max__"
        ];
        description = "List of sensors to be shown directly in the panel";
      };

      update-time = mkOption {
        type = types.int;
        default = 5;
        description = "Seconds between updates";
      };

      hide-zeros = mkOption {
        type = types.bool;
        default = false;
        description = "Hide data from sensors that are invalid or zero";
      };

      include-static-info = mkOption {
        type = types.bool;
        default = false;
        description = "Include processor static information";
      };
    };

    # --- Display / Appearance ---
    display = {
      position-in-panel = mkOption {
        type = types.int;
        default = 2;
        description = "Position in panel (0: left, 1: center, 2: right)";
      };

      icon-style = mkOption {
        type = types.int;
        default = 0;
        description = "Icon style (0: original, 1: updated)";
      };

      fixed-widths = mkOption {
        type = types.bool;
        default = true;
        description = "Use fixed widths in top bar to prevent jitter";
      };

      hide-icons = mkOption {
        type = types.bool;
        default = false;
        description = "Hide icons in top bar";
      };

      menu-centered = mkOption {
        type = types.bool;
        default = false;
        description = "Make the dropdown menu centered";
      };

      alphabetize = mkOption {
        type = types.bool;
        default = true;
        description = "Display sensors in alphabetical order in the menu";
      };

      use-higher-precision = mkOption {
        type = types.bool;
        default = false;
        description = "Show one extra digit after decimal";
      };

      unit = mkOption {
        type = types.int;
        default = 0;
        description = "Temperature unit (0: centigrade, 1: fahrenheit)";
      };
    };

    # --- Categories ---
    show = {
      temperature = mkOption {
        type = types.bool;
        default = true;
        description = "Display temperature of various components";
      };
      voltage = mkOption {
        type = types.bool;
        default = true;
        description = "Display voltage of various components";
      };
      fan = mkOption {
        type = types.bool;
        default = true;
        description = "Display fan rotation per minute";
      };
      memory = mkOption {
        type = types.bool;
        default = true;
        description = "Display memory information";
      };
      processor = mkOption {
        type = types.bool;
        default = true;
        description = "Display processor information";
      };
      system = mkOption {
        type = types.bool;
        default = true;
        description = "Display system information";
      };
      storage = mkOption {
        type = types.bool;
        default = true;
        description = "Display storage information";
      };
      network = mkOption {
        type = types.bool;
        default = true;
        description = "Display network information";
      };
      battery = mkOption {
        type = types.bool;
        default = false;
        description = "Monitor battery health";
      };
      gpu = mkOption {
        type = types.bool;
        default = false;
        description = "Monitor GPU (requires nvidia-smi)";
      };
    };

    # --- Specific Settings ---
    network = {
      speed-format = mkOption {
        type = types.int;
        default = 0;
        description = "Network speed format (0: bits, 1: bytes)";
      };
      include-public-ip = mkOption {
        type = types.bool;
        default = true;
        description = "Display public IP address of internet connection";
      };
    };

    storage = {
      path = mkOption {
        type = types.str;
        default = "/";
        description = "Storage path for monitoring";
      };
      measurement = mkOption {
        type = types.int;
        default = 1;
        description = "Storage measurement unit (0: gigabyte, 1: gibibyte)";
      };
    };

    memory = {
      measurement = mkOption {
        type = types.int;
        default = 1;
        description = "Memory measurement unit (0: gigabyte, 1: gibibyte)";
      };
    };

    battery = {
      slot = mkOption {
        type = types.int;
        default = 0;
        description = "Which numerical battery slot should vitals monitor";
      };
    };

    gpu = {
      include-static-info = mkOption {
        type = types.bool;
        default = false;
        description = "Include GPU static information";
      };
    };

    # --- System Integration ---
    system = {
      monitor-cmd = mkOption {
        type = types.str;
        default = "gnome-system-monitor";
        description = "Command to launch System Monitor";
      };
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.vitals ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/vitals" = {
            # Sensors & Data
            hot-sensors = cfg.sensors.hot-list;
            update-time = cfg.sensors.update-time;
            hide-zeros = cfg.sensors.hide-zeros;
            include-static-info = cfg.sensors.include-static-info;

            # Display
            position-in-panel = cfg.display.position-in-panel;
            icon-style = cfg.display.icon-style;
            fixed-widths = cfg.display.fixed-widths;
            hide-icons = cfg.display.hide-icons;
            menu-centered = cfg.display.menu-centered;
            alphabetize = cfg.display.alphabetize;
            use-higher-precision = cfg.display.use-higher-precision;
            unit = cfg.display.unit;

            # Categories
            show-temperature = cfg.show.temperature;
            show-voltage = cfg.show.voltage;
            show-fan = cfg.show.fan;
            show-memory = cfg.show.memory;
            show-processor = cfg.show.processor;
            show-system = cfg.show.system;
            show-storage = cfg.show.storage;
            show-network = cfg.show.network;
            show-battery = cfg.show.battery;
            show-gpu = cfg.show.gpu;

            # Specifics
            network-speed-format = cfg.network.speed-format;
            include-public-ip = cfg.network.include-public-ip;
            storage-path = cfg.storage.path;
            storage-measurement = cfg.storage.measurement;
            memory-measurement = cfg.memory.measurement;
            battery-slot = cfg.battery.slot;
            include-static-gpu-info = cfg.gpu.include-static-info;

            # System
            monitor-cmd = cfg.system.monitor-cmd;
          };
        };
      }
    ];
  };
}
