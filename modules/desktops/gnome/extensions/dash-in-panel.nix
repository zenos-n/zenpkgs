{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.dash-in-panel;

in
{
  meta = {
    description = "Configures the Dash In Panel GNOME extension";
    longDescription = ''
      This module installs and configures the **Dash In Panel** extension for GNOME.
      It merges the Dash into the Top Bar, saving vertical screen space and providing
      quick access to applications and indicators.

      **Features:**
      - Integrate Dash into the top panel.
      - Customize panel icons, margins, and visibility.
      - Indicators for running applications.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.dash-in-panel = {
    enable = mkEnableOption "Dash In Panel GNOME extension configuration";

    layout = {
      panel-height = mkOption {
        type = types.int;
        default = 32;
        description = "Top panel height in pixels";
      };

      icon-size = mkOption {
        type = types.int;
        default = 20;
        description = "Application icon size in pixels";
      };

      button-margin = mkOption {
        type = types.int;
        default = 2;
        description = "Margin around app buttons";
      };

      move-clock-right = mkOption {
        type = types.bool;
        default = true;
        description = "Move the clock/date menu to the right side of the panel";
      };

      center-dash = mkOption {
        type = types.bool;
        default = false;
        description = "Center the dash elements in the panel";
      };
    };

    behavior = {
      show-overview-on-startup = mkOption {
        type = types.bool;
        default = false;
        description = "Show overview immediately at start-up";
      };

      show-dash-in-overview = mkOption {
        type = types.bool;
        default = false;
        description = "Keep dash visible inside the overview";
      };

      scroll-on-panel = mkOption {
        type = types.bool;
        default = true;
        description = "Change workspace by scrolling on the panel";
      };

      minimize-on-click = mkOption {
        type = types.bool;
        default = true;
        description = "Minimize the focused application when clicking its icon";
      };

      cycle-windows = mkOption {
        type = types.bool;
        default = true;
        description = "Cycle through open windows when clicking the app icon";
      };
    };

    visibility = {
      activities-button = mkOption {
        type = types.bool;
        default = false;
        description = "Show the Activities button";
      };

      app-grid-button = mkOption {
        type = types.bool;
        default = true;
        description = "Show the 'Show Applications' grid button";
      };

      app-label-on-hover = mkOption {
        type = types.bool;
        default = true;
        description = "Show application name label when hovering icons";
      };

      only-running-apps = mkOption {
        type = types.bool;
        default = false;
        description = "Show only running applications (hide favorites)";
      };
    };

    indicators = {
      use-dominant-color = mkOption {
        type = types.bool;
        default = true;
        description = "Use the application's dominant color for the running indicator dot";
      };

      dim-on-inactive-workspace = mkOption {
        type = types.bool;
        default = false;
        description = "Dim the running indicator if the app is not on the active workspace";
      };
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.dash-in-panel ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/dash-in-panel" = {
            # Layout
            panel-height = cfg.layout.panel-height;
            icon-size = cfg.layout.icon-size;
            button-margin = cfg.layout.button-margin;
            move-date = cfg.layout.move-clock-right;
            center-dash = cfg.layout.center-dash;

            # Behavior
            show-overview = cfg.behavior.show-overview-on-startup;
            show-dash = cfg.behavior.show-dash-in-overview;
            scroll-panel = cfg.behavior.scroll-on-panel;
            click-changed = cfg.behavior.minimize-on-click;
            cycle-windows = cfg.behavior.cycle-windows;

            # Visibility
            show-activities = cfg.visibility.activities-button;
            show-apps = cfg.visibility.app-grid-button;
            show-label = cfg.visibility.app-label-on-hover;
            show-running = cfg.visibility.only-running-apps;

            # Indicators
            colored-dot = cfg.indicators.use-dominant-color;
            dim-dot = cfg.indicators.dim-on-inactive-workspace;
          };
        };
      }
    ];
  };
}
