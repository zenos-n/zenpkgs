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
    description = ''
      Merges the GNOME Dash into the top panel

      This module installs and configures the **Dash In Panel** extension for GNOME.
      It merges the Dash into the Top Bar, saving vertical screen space and 
      providing quick access to applications and indicators.

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
        description = "Vertical pixel height for the consolidated top panel";
      };

      icon-size = mkOption {
        type = types.int;
        default = 20;
        description = "Pixel dimensions for application icons in the panel";
      };

      button-margin = mkOption {
        type = types.int;
        default = 2;
        description = "Pixel spacing around application launch buttons";
      };

      move-clock-right = mkOption {
        type = types.bool;
        default = true;
        description = "Shift the clock and date menu to the right side of the panel";
      };

      center-dash = mkOption {
        type = types.bool;
        default = false;
        description = "Center the taskbar/dash elements within the top panel";
      };
    };

    behavior = {
      show-overview-on-startup = mkOption {
        type = types.bool;
        default = false;
        description = "Automatically enter activity overview when logging in";
      };

      show-dash-in-overview = mkOption {
        type = types.bool;
        default = false;
        description = "Maintain panel-dash visibility when in overview mode";
      };

      scroll-on-panel = mkOption {
        type = types.bool;
        default = true;
        description = "Switch virtual workspaces by scrolling on the top panel";
      };

      minimize-on-click = mkOption {
        type = types.bool;
        default = true;
        description = "Hide the focused window when its icon is clicked";
      };

      cycle-windows = mkOption {
        type = types.bool;
        default = true;
        description = "Switch between open windows of the same app on icon click";
      };
    };

    visibility = {
      activities-button = mkOption {
        type = types.bool;
        default = false;
        description = "Display the 'Activities' label in the top bar";
      };

      app-grid-button = mkOption {
        type = types.bool;
        default = true;
        description = "Display the 'Show Applications' grid button in the panel";
      };

      app-label-on-hover = mkOption {
        type = types.bool;
        default = true;
        description = "Show application name tooltips when hovering over icons";
      };

      only-running-apps = mkOption {
        type = types.bool;
        default = false;
        description = "Hide pinned favorites and only show active windows";
      };
    };

    indicators = {
      use-dominant-color = mkOption {
        type = types.bool;
        default = true;
        description = "Color running dots based on the application's primary icon color";
      };

      dim-on-inactive-workspace = mkOption {
        type = types.bool;
        default = false;
        description = "Fade the running indicator for apps not on the current desktop";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.dash-in-panel ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/dash-in-panel" = {
            panel-height = cfg.layout.panel-height;
            icon-size = cfg.layout.icon-size;
            button-margin = cfg.layout.button-margin;
            move-date = cfg.layout.move-clock-right;
            center-dash = cfg.layout.center-dash;
            show-overview = cfg.behavior.show-overview-on-startup;
            show-dash = cfg.behavior.show-dash-in-overview;
            scroll-panel = cfg.behavior.scroll-on-panel;
            click-changed = cfg.behavior.minimize-on-click;
            cycle-windows = cfg.behavior.cycle-windows;
            show-activities = cfg.visibility.activities-button;
            show-apps = cfg.visibility.app-grid-button;
            show-label = cfg.visibility.app-label-on-hover;
            show-running = cfg.visibility.only-running-apps;
            colored-dot = cfg.indicators.use-dominant-color;
            dim-dot = cfg.indicators.dim-on-inactive-workspace;
          };
        };
      }
    ];
  };
}
