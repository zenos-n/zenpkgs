{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.vitals;

  meta = {
    description = ''
      Real-time system resource monitoring for the top bar

      This module installs and configures the **Vitals** extension for GNOME.
      Vitals provides a glimpse into your computer's temperature, voltage, fan speed, 
      memory usage, processor load, network speed and storage stats.

      **Features:**
      - Highly customizable sensor list in the top bar.
      - Detailed system monitoring dropdown menu.
      - Support for CPU, GPU, Memory, Storage, and Network monitoring.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.vitals = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Vitals GNOME extension configuration";

    sensors = {
      hot-list = mkOption {
        type = types.listOf types.str;
        default = [
          "_memory_usage_"
          "_system_load_1m_"
          "__network-rx_max__"
        ];
        description = ''
          Primary sensors for the panel display

          List of internal sensor identifiers to be rendered directly 
          on the GNOME top bar.
        '';
      };

      update-time = mkOption {
        type = types.int;
        default = 5;
        description = "Interval in seconds between sensor data refreshes";
      };

      hide-zeros = mkOption {
        type = types.bool;
        default = false;
        description = "Hide sensors returning a zero value from the display";
      };

      hide-labels = mkOption {
        type = types.bool;
        default = false;
        description = "Remove text labels from the panel sensors to save space";
      };

      include-static-info = mkOption {
        type = types.bool;
        default = true;
        description = "Display non-volatile hardware metadata in the dropdown";
      };
    };

    display = {
      position-in-panel = mkOption {
        type = types.int;
        default = 0;
        description = "Relative sorting index for the Vitals icon in the panel";
      };

      icon-style = mkOption {
        type = types.int;
        default = 0;
        description = "Visual style for sensor icons (0: Default, 1: Solid)";
      };

      fixed-widths = mkOption {
        type = types.bool;
        default = true;
        description = "Enforce constant pixel width for panel labels to prevent jitter";
      };

      hide-icons = mkOption {
        type = types.bool;
        default = false;
        description = "Display only text values without icons in the top bar";
      };

      menu-centered = mkOption {
        type = types.bool;
        default = false;
        description = "Center the dropdown menu relative to the sensor icon";
      };

      alphabetize = mkOption {
        type = types.bool;
        default = false;
        description = "Sort sensors alphabetically in the dropdown menu";
      };

      use-higher-precision = mkOption {
        type = types.bool;
        default = false;
        description = "Show additional decimal places for sensor readings";
      };

      unit = mkOption {
        type = types.int;
        default = 1;
        description = "Measurement unit system (1: Metric, 2: Imperial)";
      };
    };

    show = {
      temperature = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle temperature monitoring visibility";
      };
      voltage = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle voltage monitoring visibility";
      };
      fan = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle fan speed monitoring visibility";
      };
      memory = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle memory usage monitoring visibility";
      };
      processor = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle CPU load monitoring visibility";
      };
      system = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle system health monitoring visibility";
      };
      storage = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle disk space monitoring visibility";
      };
      network = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle bandwidth monitoring visibility";
      };
      battery = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle battery health monitoring visibility";
      };
      gpu = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle GPU resource monitoring visibility";
      };
    };

    network = {
      speed-format = mkOption {
        type = types.int;
        default = 0;
        description = "Bandwidth unit (0: bits/s, 1: bytes/s)";
      };
      include-public-ip = mkOption {
        type = types.bool;
        default = false;
        description = "Fetch and display the external public IP address";
      };
    };

    storage = {
      path = mkOption {
        type = types.str;
        default = "/";
        description = "Filesystem mount point to monitor for space";
      };
      measurement = mkOption {
        type = types.int;
        default = 0;
        description = "Capacity unit (0: Percent, 1: GB Used, 2: GB Free)";
      };
    };

    memory = {
      measurement = mkOption {
        type = types.int;
        default = 0;
        description = "Usage unit (0: Percent, 1: GB Used, 2: GB Free)";
      };
    };

    battery = {
      slot = mkOption {
        type = types.int;
        default = 0;
        description = "Hardware battery index to monitor";
      };
    };

    gpu = {
      include-static-info = mkOption {
        type = types.bool;
        default = true;
        description = "Display GPU hardware metadata in the dropdown";
      };
    };

    system = {
      monitor-cmd = mkOption {
        type = types.str;
        default = "resources";
        description = "Command to execute when clicking the 'System Monitor' item";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.vitals ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/vitals" = {
            hot-list = cfg.sensors.hot-list;
            update-time = cfg.sensors.update-time;
            hide-zeros = cfg.sensors.hide-zeros;
            hide-labels = cfg.sensors.hide-labels;
            include-static-info = cfg.sensors.include-static-info;
            position-in-panel = cfg.display.position-in-panel;
            icon-style = cfg.display.icon-style;
            fixed-widths = cfg.display.fixed-widths;
            hide-icons = cfg.display.hide-icons;
            menu-centered = cfg.display.menu-centered;
            alphabetize = cfg.display.alphabetize;
            use-higher-precision = cfg.display.use-higher-precision;
            unit = cfg.display.unit;
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
            network-speed-format = cfg.network.speed-format;
            include-public-ip = cfg.network.include-public-ip;
            storage-path = cfg.storage.path;
            storage-measurement = cfg.storage.measurement;
            memory-measurement = cfg.memory.measurement;
            battery-slot = cfg.battery.slot;
            include-static-gpu-info = cfg.gpu.include-static-info;
            monitor-cmd = cfg.system.monitor-cmd;
          };
        };
      }
    ];
  };
}
