{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.hidetopbar;

in
{
  meta = {
    description = "Configures the Hide Top Bar GNOME extension";
    longDescription = ''
      This module installs and configures the **Hide Top Bar** extension for GNOME.
      It automatically hides the top bar to maximize screen space, showing it only
      when the mouse approaches the edge or via keyboard shortcuts.

      **Features:**
      - Intelligent hiding (intellihide) when windows overlap the panel.
      - Configurable mouse sensitivity and pressure barriers.
      - Keyboard shortcuts to toggle visibility.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.hidetopbar = {
    enable = mkEnableOption "Hide Top Bar GNOME extension configuration";

    hot-corner = mkOption {
      type = types.bool;
      default = false;
      description = "Keep hot corner sensitive even when panel is hidden";
    };

    mouse-sensitive = mkOption {
      type = types.bool;
      default = false;
      description = "Show panel when mouse approaches edge of the screen";
    };

    mouse-sensitive-fullscreen-window = mkOption {
      type = types.bool;
      default = true;
      description = "Show panel when mouse approaches edge in fullscreen";
    };

    mouse-triggers-overview = mkOption {
      type = types.bool;
      default = false;
      description = "Show overview when mouse approaches edge (requires mouse-sensitive)";
    };

    keep-round-corners = mkOption {
      type = types.bool;
      default = false;
      description = "Keep round corners on the top when panel is hidden";
    };

    animation-time-overview = mkOption {
      type = types.float;
      default = 0.4;
      description = "Slide in/out animation time for overview";
    };

    animation-time-autohide = mkOption {
      type = types.float;
      default = 0.2;
      description = "Slide in/out animation time for autohide";
    };

    pressure-threshold = mkOption {
      type = types.int;
      default = 100;
      description = "Pressure barrier threshold (pixels)";
    };

    pressure-timeout = mkOption {
      type = types.int;
      default = 1000;
      description = "Pressure barrier timeout (ms)";
    };

    shortcut-keybind = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Keyboard shortcut that triggers the bar to be shown";
    };

    shortcut-delay = mkOption {
      type = types.float;
      default = 1.0;
      description = "Delay before bar rehides automatically after key press (0.0 = unlimited)";
    };

    shortcut-toggles = mkOption {
      type = types.bool;
      default = true;
      description = "Pressing the shortcut again rehides the panel";
    };

    enable-intellihide = mkOption {
      type = types.bool;
      default = true;
      description = "Panel only hides if a window takes the space";
    };

    enable-active-window = mkOption {
      type = types.bool;
      default = true;
      description = "Intellihide only triggers for active window";
    };

    show-in-overview = mkOption {
      type = types.bool;
      default = true;
      description = "Panel is visible in overview";
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.hidetopbar ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/hidetopbar" = {
            hot-corner = cfg.hot-corner;
            mouse-sensitive = cfg.mouse-sensitive;
            mouse-sensitive-fullscreen-window = cfg.mouse-sensitive-fullscreen-window;
            mouse-triggers-overview = cfg.mouse-triggers-overview;
            keep-round-corners = cfg.keep-round-corners;
            animation-time-overview = cfg.animation-time-overview;
            animation-time-autohide = cfg.animation-time-autohide;
            pressure-threshold = cfg.pressure-threshold;
            pressure-timeout = cfg.pressure-timeout;
            shortcut-keybind = cfg.shortcut-keybind;
            shortcut-delay = cfg.shortcut-delay;
            shortcut-toggles = cfg.shortcut-toggles;
            enable-intellihide = cfg.enable-intellihide;
            enable-active-window = cfg.enable-active-window;
            show-in-overview = cfg.show-in-overview;
          };
        };
      }
    ];
  };
}
