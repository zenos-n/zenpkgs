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
    description = "Configures the Just Perfection GNOME extension";
    longDescription = ''
      This module installs and configures the **Just Perfection** extension for GNOME.
      It is a comprehensive "all-in-one" utility to customize GNOME Shell, allowing you to
      tweak visibility of UI elements, adjust panel sizes, change behavior, and more.

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

    # --- Visibility ---
    visibility = {
      panel = mkOption {
        type = types.bool;
        default = true;
        description = "Panel Visibility";
      };
      panel-in-overview = mkOption {
        type = types.bool;
        default = false;
        description = "Panel in Overview Visibility";
      };
      dash = mkOption {
        type = types.bool;
        default = true;
        description = "Dash Visibility";
      };
      dash-separator = mkOption {
        type = types.bool;
        default = true;
        description = "Dash Separator Visibility";
      };
      dash-app-running = mkOption {
        type = types.bool;
        default = true;
        description = "Dash app running dot visibility";
      };
      search = mkOption {
        type = types.bool;
        default = true;
        description = "Search Box Visibility";
      };
      workspace = mkOption {
        type = types.bool;
        default = true;
        description = "Workspace Switcher Visibility";
      };
      workspace-popup = mkOption {
        type = types.bool;
        default = true;
        description = "Workspace Popup Visibility";
      };
      workspaces-in-app-grid = mkOption {
        type = types.bool;
        default = true;
        description = "Workspaces Visibility in App Grid";
      };
      background-menu = mkOption {
        type = types.bool;
        default = true;
        description = "Background Menu Visibility";
      };
      osd = mkOption {
        type = types.bool;
        default = true;
        description = "OSD Visibility";
      };
      activities-button = mkOption {
        type = types.bool;
        default = true;
        description = "Activities Button Visibility";
      };
      clock-menu = mkOption {
        type = types.bool;
        default = true;
        description = "Clock Menu Visibility";
      };
      keyboard-layout = mkOption {
        type = types.bool;
        default = true;
        description = "Keyboard Layout Visibility";
      };
      accessibility-menu = mkOption {
        type = types.bool;
        default = true;
        description = "Accessibility Menu Visibility";
      };
      power-icon = mkOption {
        type = types.bool;
        default = true;
        description = "Power Icon Visibility";
      };
      panel-notification-icon = mkOption {
        type = types.bool;
        default = true;
        description = "Panel Notification Icon Visibility";
      };
      window-picker-icon = mkOption {
        type = types.bool;
        default = true;
        description = "Window Picker Icon Visibility";
      };
      show-apps-button = mkOption {
        type = types.bool;
        default = true;
        description = "Show Apps Button Visibility";
      };
      theme = mkOption {
        type = types.bool;
        default = false;
        description = "Theme Visibility (Internal/Advanced)";
      };
      quick-settings = mkOption {
        type = types.bool;
        default = true;
        description = "Quick Settings Menu Visibility";
      };
      world-clock = mkOption {
        type = types.bool;
        default = true;
        description = "World Clock Visibility";
      };
      weather = mkOption {
        type = types.bool;
        default = true;
        description = "Weather Visibility";
      };
      calendar = mkOption {
        type = types.bool;
        default = true;
        description = "Calendar Visibility";
      };
      events-button = mkOption {
        type = types.bool;
        default = true;
        description = "Events Button Visibility";
      };
      ripple-box = mkOption {
        type = types.bool;
        default = true;
        description = "Ripple Box Visibility (Hot Corner Effect)";
      };
      window-menu = mkOption {
        type = types.bool;
        default = true;
        description = "Window Menu Visibility";
      };
      window-menu-take-screenshot-button = mkOption {
        type = types.bool;
        default = true;
        description = "Window Menu Take Screenshot Button Visibility";
      };
      window-preview-caption = mkOption {
        type = types.bool;
        default = true;
        description = "Window Preview Caption Visibility";
      };
      window-preview-close-button = mkOption {
        type = types.bool;
        default = true;
        description = "Window Preview Close Button Visibility";
      };
      screen-sharing-indicator = mkOption {
        type = types.bool;
        default = true;
        description = "Screen Sharing Indicator Visibility";
      };
      screen-recording-indicator = mkOption {
        type = types.bool;
        default = true;
        description = "Screen Recording Indicator Visibility";
      };
    };

    # --- Quick Settings Toggles ---
    quick-settings = {
      dark-mode = mkOption {
        type = types.bool;
        default = true;
        description = "Dark Mode Toggle Visibility";
      };
      night-light = mkOption {
        type = types.bool;
        default = true;
        description = "Night Light Toggle Visibility";
      };
      do-not-disturb = mkOption {
        type = types.bool;
        default = true;
        description = "Do Not Disturb Toggle Visibility";
      };
      backlight = mkOption {
        type = types.bool;
        default = true;
        description = "Backlight Slider Visibility";
      };
      airplane-mode = mkOption {
        type = types.bool;
        default = true;
        description = "Airplane Mode Toggle Visibility";
      };
    };

    # --- Behavior ---
    behavior = {
      workspace-switcher-always-show = mkOption {
        type = types.bool;
        default = false;
        description = "Always Show Workspace Switcher";
      };
      workspace-wrap-around = mkOption {
        type = types.bool;
        default = false;
        description = "Workspace Wrap Around";
      };
      workspace-peek = mkOption {
        type = types.bool;
        default = true;
        description = "Workspace Peek";
      };
      workspace-thumbnail-to-main-view = mkOption {
        type = types.bool;
        default = false;
        description = "Clicking Workspace Thumbnail switches to Main View";
      };
      window-demands-attention-focus = mkOption {
        type = types.bool;
        default = false;
        description = "Focus windows that demand attention immediately";
      };
      window-maximized-on-create = mkOption {
        type = types.bool;
        default = false;
        description = "Maximize new windows automatically";
      };
      type-to-search = mkOption {
        type = types.bool;
        default = true;
        description = "Type to Search in Overview";
      };
      double-super-to-appgrid = mkOption {
        type = types.bool;
        default = true;
        description = "Double press Super key to open App Grid";
      };
      overlay-key = mkOption {
        type = types.bool;
        default = true;
        description = "Use Overlay Key (Super) to open Overview";
      };
      switcher-popup-delay = mkOption {
        type = types.bool;
        default = true;
        description = "Disable delay for switcher popups (Alt-Tab)";
      };
      invert-calendar-column-items = mkOption {
        type = types.bool;
        default = false;
        description = "Invert Calendar Column Items order";
      };
    };

    # --- Appearance (Sizes & Icons) ---
    appearance = {
      accent-color-icon = mkOption {
        type = types.bool;
        default = false;
        description = "Use Accent Color for Icons";
      };
      panel-size = mkOption {
        type = types.int;
        default = 0;
        description = "Panel Size (0=theme default, 1-64=pixels)";
      };
      panel-icon-size = mkOption {
        type = types.int;
        default = 0;
        description = "Panel Icon Size (0=theme default, 1-60=pixels)";
      };
      panel-button-padding-size = mkOption {
        type = types.int;
        default = 0;
        description = "Panel Button Padding Size (0=theme, 1=none, 2-61=pixels)";
      };
      panel-indicator-padding-size = mkOption {
        type = types.int;
        default = 0;
        description = "Panel Indicator Padding Size (0=theme, 1=none, 2-61=pixels)";
      };
      panel-corner-size = mkOption {
        type = types.int;
        default = 0;
        description = "Panel Corner Size (0=theme, 1=no border, 2-61=radius)";
      };
      dash-icon-size = mkOption {
        type = types.int;
        default = 0;
        description = "Dash Icon Size (0=default)";
      };
      workspace-switcher-size = mkOption {
        type = types.int;
        default = 0;
        description = "Workspace Switcher Width % (0=default)";
      };
      workspace-background-corner-size = mkOption {
        type = types.int;
        default = 0;
        description = "Workspace Background Corner Size (0=default, 1=none, 2-61=radius)";
      };
      looking-glass-width = mkOption {
        type = types.int;
        default = 0;
        description = "Looking Glass Width % (0=default)";
      };
      looking-glass-height = mkOption {
        type = types.int;
        default = 0;
        description = "Looking Glass Height % (0=default)";
      };
      alt-tab-window-preview-size = mkOption {
        type = types.int;
        default = 0;
        description = "Alt Tab Window Preview Size (0=default)";
      };
      alt-tab-icon-size = mkOption {
        type = types.int;
        default = 0;
        description = "Alt Tab Icon Size (0=default)";
      };
      alt-tab-small-icon-size = mkOption {
        type = types.int;
        default = 0;
        description = "Alt Tab Small Icon Size (0=default)";
      };
      controls-manager-spacing-size = mkOption {
        type = types.int;
        default = 0;
        description = "Controls Manager Spacing Size (0=default)";
      };
      max-displayed-search-results = mkOption {
        type = types.int;
        default = 0;
        description = "Max Displayed Search Results (0=default)";
      };
    };

    # --- Positioning ---
    positioning = {
      top-panel-position = mkOption {
        type = types.int;
        default = 0;
        description = "Top Panel Position (0=Top, 1=Bottom)";
      };
      clock-menu-position = mkOption {
        type = types.int;
        default = 0;
        description = "Clock Menu Position (0=Center, 1=Right, 2=Left)";
      };
      clock-menu-position-offset = mkOption {
        type = types.int;
        default = 0;
        description = "Clock Menu Position Offset (0-20)";
      };
      notification-banner-position = mkOption {
        type = types.int;
        default = 1;
        description = "Notification Banner Position (0-5, 1=Top Center)";
      };
      osd-position = mkOption {
        type = types.int;
        default = 0;
        description = "OSD Position (0-9)";
      };
    };

    # --- General ---
    general = {
      startup-status = mkOption {
        type = types.int;
        default = 1;
        description = "Startup State (0=Desktop, 1=Overview)";
      };
      animation = mkOption {
        type = types.int;
        default = 1;
        description = "Animation Speed (0=Disabled, 1=Default, 2=Fast, 3=Faster, 4=Fastest, 5=Slow, 6=Slower)";
      };
      support-notifier-type = mkOption {
        type = types.int;
        default = 1;
        description = "Support Notifier Type (0=Never, 1=New Releases)";
      };
      support-notifier-showed-version = mkOption {
        type = types.int;
        default = 0;
        description = "Last Version Support Notifier Showed";
      };
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.just-perfection ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/just-perfection" = {
            # Visibility
            panel = cfg.visibility.panel;
            panel-in-overview = cfg.visibility.panel-in-overview;
            background-menu = cfg.visibility.background-menu;
            search = cfg.visibility.search;
            workspace = cfg.visibility.workspace;
            dash = cfg.visibility.dash;
            osd = cfg.visibility.osd;
            workspace-popup = cfg.visibility.workspace-popup;
            theme = cfg.visibility.theme;
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
            world-clock = cfg.visibility.world-clock;
            weather = cfg.visibility.weather;
            events-button = cfg.visibility.events-button;
            calendar = cfg.visibility.calendar;
            dash-separator = cfg.visibility.dash-separator;
            window-menu = cfg.visibility.window-menu;
            window-menu-take-screenshot-button = cfg.visibility.window-menu-take-screenshot-button;
            screen-sharing-indicator = cfg.visibility.screen-sharing-indicator;
            screen-recording-indicator = cfg.visibility.screen-recording-indicator;
            dash-app-running = cfg.visibility.dash-app-running;

            # Quick Settings
            quick-settings-dark-mode = cfg.quick-settings.dark-mode;
            quick-settings-night-light = cfg.quick-settings.night-light;
            quick-settings-do-not-disturb = cfg.quick-settings.do-not-disturb;
            quick-settings-backlight = cfg.quick-settings.backlight;
            quick-settings-airplane-mode = cfg.quick-settings.airplane-mode;

            # Behavior
            type-to-search = cfg.behavior.type-to-search;
            window-demands-attention-focus = cfg.behavior.window-demands-attention-focus;
            window-maximized-on-create = cfg.behavior.window-maximized-on-create;
            workspace-wrap-around = cfg.behavior.workspace-wrap-around;
            double-super-to-appgrid = cfg.behavior.double-super-to-appgrid;
            overlay-key = cfg.behavior.overlay-key;
            switcher-popup-delay = cfg.behavior.switcher-popup-delay;
            workspace-peek = cfg.behavior.workspace-peek;
            accent-color-icon = cfg.appearance.accent-color-icon;
            workspace-thumbnail-to-main-view = cfg.behavior.workspace-thumbnail-to-main-view;
            invert-calendar-column-items = cfg.behavior.invert-calendar-column-items;

            # Dimensions & Positioning
            panel-corner-size = cfg.appearance.panel-corner-size;
            workspace-switcher-size = cfg.appearance.workspace-switcher-size;
            top-panel-position = cfg.positioning.top-panel-position;
            clock-menu-position = cfg.positioning.clock-menu-position;
            clock-menu-position-offset = cfg.positioning.clock-menu-position-offset;
            animation = cfg.general.animation;
            dash-icon-size = cfg.appearance.dash-icon-size;
            startup-status = cfg.general.startup-status;
            notification-banner-position = cfg.positioning.notification-banner-position;
            panel-size = cfg.appearance.panel-size;
            panel-button-padding-size = cfg.appearance.panel-button-padding-size;
            panel-indicator-padding-size = cfg.appearance.panel-indicator-padding-size;
            workspace-background-corner-size = cfg.appearance.workspace-background-corner-size;
            panel-icon-size = cfg.appearance.panel-icon-size;
            looking-glass-width = cfg.appearance.looking-glass-width;
            looking-glass-height = cfg.appearance.looking-glass-height;
            osd-position = cfg.positioning.osd-position;
            alt-tab-window-preview-size = cfg.appearance.alt-tab-window-preview-size;
            alt-tab-small-icon-size = cfg.appearance.alt-tab-small-icon-size;
            alt-tab-icon-size = cfg.appearance.alt-tab-icon-size;
            controls-manager-spacing-size = cfg.appearance.controls-manager-spacing-size;
            max-displayed-search-results = cfg.appearance.max-displayed-search-results;
            support-notifier-type = cfg.general.support-notifier-type;
            support-notifier-showed-version = cfg.general.support-notifier-showed-version;
          };
        };
      }
    ];
  };
}
