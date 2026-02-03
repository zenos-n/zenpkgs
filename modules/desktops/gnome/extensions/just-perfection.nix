{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.just-perfection;

in
{
  meta = {
    description = ''
      Universal GNOME Shell customization utility

      This module installs and configures the **Just Perfection** extension for GNOME.
      It is a comprehensive "all-in-one" utility to customize GNOME Shell, allowing you to
      tweak visibility of UI elements, adjust panel sizes, and change core behaviors.

      **Features:**
      - Extensive visibility controls for almost every shell element.
      - Behavior tweaks (window focus, workspace wrapping).
      - Positioning and sizing customizations.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.just-perfection = {
    enable = mkEnableOption "Just Perfection GNOME extension configuration";

    visibility = {
      panel = mkOption {
        type = types.bool;
        default = true;
        description = "Master visibility switch for the top panel";
      };
      panel-in-overview = mkOption {
        type = types.bool;
        default = false;
        description = "Toggle panel visibility while in the activities overview";
      };
      dash = mkOption {
        type = types.bool;
        default = true;
        description = "Master visibility switch for the GNOME dash";
      };
      dash-separator = mkOption {
        type = types.bool;
        default = true;
        description = "Show or hide the separator between favorites and running apps";
      };
      dash-app-running = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle visibility of the dots under running applications";
      };
      search = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle visibility of the search box in overview";
      };
      workspace = mkOption {
        type = types.bool;
        default = true;
        description = "Master visibility for the workspace switcher";
      };
      workspace-popup = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the workspace indicator popup on desktop switch";
      };
      workspaces-in-app-grid = mkOption {
        type = types.bool;
        default = true;
        description = "Show or hide workspace thumbnails in the application grid";
      };
      background-menu = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the desktop right-click background menu";
      };
      osd = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle On-Screen Display (Volume, Brightness popups)";
      };
      activities-button = mkOption {
        type = types.bool;
        default = true;
        description = "Show or hide the 'Activities' label button";
      };
      clock-menu = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the central clock and date menu";
      };
      keyboard-layout = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the input source/keyboard layout panel menu";
      };
      accessibility-menu = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the accessibility features panel menu";
      };
      power-icon = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the system status and power icon";
      };
      panel-notification-icon = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the notifications indicator in the panel";
      };
      window-picker-icon = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle icons on window previews in overview";
      };
      show-apps-button = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the 'Show Applications' grid button";
      };
      theme = mkOption {
        type = types.bool;
        default = false;
        description = "Enable advanced theme override visibility";
      };
      quick-settings = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the entire GNOME Quick Settings menu";
      };
      world-clock = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle world clock visibility in the date menu";
      };
      weather = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle weather info visibility in the date menu";
      };
      calendar = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the calendar view in the date menu";
      };
      events-button = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the events section in the date menu";
      };
      ripple-box = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the visual ripple effect when hitting hot corners";
      };
      window-menu = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the right-click menu on window titlebars";
      };
      window-menu-take-screenshot-button = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle the screenshot button within the window menu";
      };
      window-preview-caption = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle application names on window previews";
      };
      window-preview-close-button = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle close buttons on window previews";
      };
      screen-sharing-indicator = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle visibility of the screen sharing status icon";
      };
      screen-recording-indicator = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle visibility of the screen recording status icon";
      };
    };

    quick-settings = {
      dark-mode = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle Dark Mode switch visibility";
      };
      night-light = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle Night Light switch visibility";
      };
      do-not-disturb = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle Do Not Disturb switch visibility";
      };
      backlight = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle display brightness slider visibility";
      };
      airplane-mode = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle Airplane Mode switch visibility";
      };
    };

    behavior = {
      workspace-switcher-always-show = mkOption {
        type = types.bool;
        default = false;
        description = "Force persistent visibility of the workspace list";
      };
      workspace-wrap-around = mkOption {
        type = types.bool;
        default = false;
        description = "Allow workspace switching to loop from last to first";
      };
      workspace-peek = mkOption {
        type = types.bool;
        default = true;
        description = "Enable horizontal workspace peeking in overview";
      };
      workspace-thumbnail-to-main-view = mkOption {
        type = types.bool;
        default = false;
        description = "Switch to main view immediately on thumbnail click";
      };
      window-demands-attention-focus = mkOption {
        type = types.bool;
        default = false;
        description = "Automatically focus windows requesting user attention";
      };
      window-maximized-on-create = mkOption {
        type = types.bool;
        default = false;
        description = "Automatically maximize newly opened application windows";
      };
      type-to-search = mkOption {
        type = types.bool;
        default = true;
        description = "Enable immediate search indexing on overview keystrokes";
      };
      double-super-to-appgrid = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle app grid on double Super key press";
      };
      overlay-key = mkOption {
        type = types.bool;
        default = true;
        description = "Use the Super key as the primary overview shortcut";
      };
      switcher-popup-delay = mkOption {
        type = types.bool;
        default = true;
        description = "Enable or disable delays for Alt-Tab popups";
      };
      invert-calendar-column-items = mkOption {
        type = types.bool;
        default = false;
        description = "Invert the sorting order of calendar columns";
      };
    };

    appearance = {
      accent-color-icon = mkOption {
        type = types.bool;
        default = false;
        description = "Apply system accent color to shell icons";
      };
      panel-size = mkOption {
        type = types.int;
        default = 0;
        description = "Custom vertical height for the top bar (0 for default)";
      };
      panel-icon-size = mkOption {
        type = types.int;
        default = 0;
        description = "Custom pixel size for panel icons (0 for default)";
      };
      panel-button-padding-size = mkOption {
        type = types.int;
        default = 0;
        description = "Custom horizontal padding for panel buttons";
      };
      panel-indicator-padding-size = mkOption {
        type = types.int;
        default = 0;
        description = "Custom horizontal padding for panel indicators";
      };
      panel-corner-size = mkOption {
        type = types.int;
        default = 0;
        description = "Custom corner radius for the top bar";
      };
      dash-icon-size = mkOption {
        type = types.int;
        default = 0;
        description = "Custom pixel size for dash icons (0 for default)";
      };
      workspace-switcher-size = mkOption {
        type = types.int;
        default = 0;
        description = "Width percentage for the workspace switcher (0 for default)";
      };
      workspace-background-corner-size = mkOption {
        type = types.int;
        default = 0;
        description = "Corner radius for workspace background containers";
      };
      looking-glass-width = mkOption {
        type = types.int;
        default = 0;
        description = "Width percentage for the Looking Glass debug tool";
      };
      looking-glass-height = mkOption {
        type = types.int;
        default = 0;
        description = "Height percentage for the Looking Glass debug tool";
      };
      alt-tab-window-preview-size = mkOption {
        type = types.int;
        default = 0;
        description = "Custom size for Alt-Tab window previews";
      };
      alt-tab-icon-size = mkOption {
        type = types.int;
        default = 0;
        description = "Custom size for Alt-Tab application icons";
      };
      alt-tab-small-icon-size = mkOption {
        type = types.int;
        default = 0;
        description = "Custom size for Alt-Tab secondary icons";
      };
      controls-manager-spacing-size = mkOption {
        type = types.int;
        default = 0;
        description = "Custom spacing for internal controls containers";
      };
      max-displayed-search-results = mkOption {
        type = types.int;
        default = 0;
        description = "Cap the number of search results shown in overview";
      };
    };

    positioning = {
      top-panel-position = mkOption {
        type = types.int;
        default = 0;
        description = "Anchor position for the main panel (0: Top, 1: Bottom)";
      };
      clock-menu-position = mkOption {
        type = types.int;
        default = 0;
        description = "Panel alignment for the clock (0: Center, 1: Right, 2: Left)";
      };
      clock-menu-position-offset = mkOption {
        type = types.int;
        default = 0;
        description = "Numerical offset for clock positioning";
      };
      notification-banner-position = mkOption {
        type = types.int;
        default = 1;
        description = "Display corner for notification banners (0-5)";
      };
      osd-position = mkOption {
        type = types.int;
        default = 0;
        description = "Anchor location for system popups (0-9)";
      };
    };

    general = {
      startup-status = mkOption {
        type = types.int;
        default = 1;
        description = "Initial state after login (0: Desktop, 1: Overview)";
      };
      animation = mkOption {
        type = types.int;
        default = 1;
        description = "Global animation speed scaling (0: Disabled, 1: Default)";
      };
      support-notifier-type = mkOption {
        type = types.int;
        default = 1;
        description = "Frequency of extension update notifications";
      };
      support-notifier-showed-version = mkOption {
        type = types.int;
        default = 0;
        description = "Internal tracker for last notified version";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.just-perfection ];
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/shell/extensions/just-perfection" = {
          inherit (cfg.visibility)
            panel
            background-menu
            search
            workspace
            dash
            osd
            theme
            calendar
            events-button
            screen-sharing-indicator
            screen-recording-indicator
            world-clock
            weather
            ;
          panel-in-overview = cfg.visibility.panel-in-overview;
          workspace-popup = cfg.visibility.workspace-popup;
          activities-button = cfg.visibility.activities-button;
          clock-menu = cfg.visibility.clock-menu;
          panel-notification-icon = cfg.visibility.panel-notification-icon;
          keyboard-layout = cfg.visibility.keyboard-layout;
          accessibility-menu = cfg.visibility.accessibility-menu;
          quick-settings = cfg.visibility.quick-settings;
          power-icon = cfg.visibility.power-icon;
          window-picker-icon = cfg.visibility.window-picker-icon;
          show-apps-button = cfg.visibility.show-apps-button;
          workspaces-in-app-grid = cfg.visibility.workspaces-in-app-grid;
          workspace-switcher-should-show = cfg.behavior.workspace-switcher-always-show;
          window-preview-caption = cfg.visibility.window-preview-caption;
          window-preview-close-button = cfg.visibility.window-preview-close-button;
          ripple-box = cfg.visibility.ripple-box;
          dash-separator = cfg.visibility.dash-separator;
          window-menu = cfg.visibility.window-menu;
          window-menu-take-screenshot-button = cfg.visibility.window-menu-take-screenshot-button;
          dash-app-running = cfg.visibility.dash-app-running;
          quick-settings-dark-mode = cfg.quick-settings.dark-mode;
          quick-settings-night-light = cfg.quick-settings.night-light;
          quick-settings-do-not-disturb = cfg.quick-settings.do-not-disturb;
          quick-settings-backlight = cfg.quick-settings.backlight;
          quick-settings-airplane-mode = cfg.quick-settings.airplane-mode;
          inherit (cfg.behavior)
            type-to-search
            window-demands-attention-focus
            window-maximized-on-create
            workspace-wrap-around
            double-super-to-appgrid
            overlay-key
            switcher-popup-delay
            workspace-peek
            accent-color-icon
            workspace-thumbnail-to-main-view
            invert-calendar-column-items
            ;
          inherit (cfg.appearance)
            panel-corner-size
            workspace-switcher-size
            dash-icon-size
            panel-size
            panel-button-padding-size
            panel-indicator-padding-size
            workspace-background-corner-size
            panel-icon-size
            looking-glass-width
            looking-glass-height
            alt-tab-window-preview-size
            alt-tab-small-icon-size
            alt-tab-icon-size
            controls-manager-spacing-size
            max-displayed-search-results
            ;
          inherit (cfg.positioning)
            top-panel-position
            clock-menu-position
            clock-menu-position-offset
            notification-banner-position
            osd-position
            ;
          inherit (cfg.general)
            animation
            startup-status
            support-notifier-type
            support-notifier-showed-version
            ;
        };
      }
    ];
  };
}
