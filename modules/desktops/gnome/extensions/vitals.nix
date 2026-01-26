{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.vitals;

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

  mkOptionStrList =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.vitals = {
    enable = mkEnableOption "Vitals GNOME extension configuration";

    hot-sensors = mkOptionStrList [
      "_memory_usage_"
      "_system_load_1m_"
      "__network-rx_max__"
    ] "List of sensors to be shown in the panel.";
    update-time = mkInt 5 "Seconds between updates.";
    position-in-panel = mkInt 2 "Position in panel (0: left, 1: center, 2: right).";
    use-higher-precision = mkBool false "Show one extra digit after decimal.";
    alphabetize = mkBool true "Display sensors in alphabetical order.";
    hide-zeros = mkBool false "Hide data from sensors that are invalid.";
    show-temperature = mkBool true "Display temperature of various components.";
    unit = mkInt 0 "Temperature unit (0: centigrade, 1: fahrenheit).";
    show-voltage = mkBool true "Display voltage of various components.";
    show-fan = mkBool true "Display fan rotation per minute.";
    show-memory = mkBool true "Display memory information.";
    show-processor = mkBool true "Display processor information.";
    show-system = mkBool true "Display system information.";
    show-storage = mkBool true "Display storage information.";
    show-network = mkBool true "Display network information.";
    include-public-ip = mkBool true "Display public IP address of internet connection.";
    network-speed-format = mkInt 0 "Network speed format (0: bits, 1: bytes).";
    storage-path = mkStr "/" "Storage path for monitoring.";
    show-battery = mkBool false "Monitor battery health.";
    memory-measurement = mkInt 1 "Memory measurement (0: gigabyte, 1: gibibyte).";
    storage-measurement = mkInt 1 "Storage measurement (0: gigabyte, 1: gibibyte).";
    battery-slot = mkInt 0 "Which numerical battery slot should vitals monitor.";
    fixed-widths = mkBool true "Use fixed widths in top bar.";
    hide-icons = mkBool false "Hide icons in top bar.";
    menu-centered = mkBool false "Make the menu centered.";
    monitor-cmd = mkStr "gnome-system-monitor" "System Monitor command.";
    include-static-info = mkBool false "Include processor static information.";
    show-gpu = mkBool false "Monitor GPU (requires nvidia-smi).";
    include-static-gpu-info = mkBool false "Include GPU static information.";
    icon-style = mkInt 0 "Icon style (0: original, 1: updated).";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.vitals ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/vitals" = {
            hot-sensors = cfg.hot-sensors;
            update-time = cfg.update-time;
            position-in-panel = cfg.position-in-panel;
            use-higher-precision = cfg.use-higher-precision;
            alphabetize = cfg.alphabetize;
            hide-zeros = cfg.hide-zeros;
            show-temperature = cfg.show-temperature;
            unit = cfg.unit;
            show-voltage = cfg.show-voltage;
            show-fan = cfg.show-fan;
            show-memory = cfg.show-memory;
            show-processor = cfg.show-processor;
            show-system = cfg.show-system;
            show-storage = cfg.show-storage;
            show-network = cfg.show-network;
            include-public-ip = cfg.include-public-ip;
            network-speed-format = cfg.network-speed-format;
            storage-path = cfg.storage-path;
            show-battery = cfg.show-battery;
            memory-measurement = cfg.memory-measurement;
            storage-measurement = cfg.storage-measurement;
            battery-slot = cfg.battery-slot;
            fixed-widths = cfg.fixed-widths;
            hide-icons = cfg.hide-icons;
            menu-centered = cfg.menu-centered;
            monitor-cmd = cfg.monitor-cmd;
            include-static-info = cfg.include-static-info;
            show-gpu = cfg.show-gpu;
            include-static-gpu-info = cfg.include-static-gpu-info;
            icon-style = cfg.icon-style;
          };
        };
      }
    ];
  };
}
