{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.just-perfection;

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

in
{
  options.zenos.desktops.gnome.extensions.just-perfection = {
    enable = mkEnableOption "Just Perfection GNOME extension configuration";

    # --- Visibility ---
    panel = mkBool true "Panel Visibility Status.";
    panel-in-overview = mkBool false "Panel in Overview Visibility Status.";
    background-menu = mkBool true "Background Menu Status.";
    search = mkBool true "Search Box Visibility Status.";
    workspace = mkBool true "Workspace Switcher Visibility Status.";
    dash = mkBool true "Dash Visibility Status.";
    osd = mkBool true "OSD Visibility Status.";
    workspace-popup = mkBool true "Workspace Popup Visibility Status.";
    theme = mkBool false "Theme Status.";
    activities-button = mkBool true "Activities Button Visibility Status.";
    clock-menu = mkBool true "Clock Menu Visibility Status.";
    panel-notification-icon = mkBool true "Panel Notification Icon Visibility Status.";
    keyboard-layout = mkBool true "Keyboard Layout Visibility Status.";
    accessibility-menu = mkBool true "Accessibility Menu Visibility Status.";
    quick-settings = mkBool true "Quick Settings Visibility Status.";
    power-icon = mkBool true "Power Icon Visibility Status.";
    window-picker-icon = mkBool true "Window Picker Icon Visiblity.";
    show-apps-button = mkBool true "Show Apps Button Visiblity Status.";
    workspaces-in-app-grid = mkBool true "Workspaces Visiblity in App Grid Status.";
    workspace-switcher-should-show = mkBool false "Always Show Workspace Switcher Status.";
    window-preview-caption = mkBool true "Window Preview Caption Status.";
    window-preview-close-button = mkBool true "Window Preview Close Button Status.";
    ripple-box = mkBool true "Ripple Box Status.";
    world-clock = mkBool true "World Clock Visibility Status.";
    weather = mkBool true "Weather Visibility Status.";
    events-button = mkBool true "Events Button Visibility Status.";
    calendar = mkBool true "Calendar Visibility Status.";
    dash-separator = mkBool true "Dash Separator Visibility Status.";
    window-menu = mkBool true "Window Menu Status.";
    window-menu-take-screenshot-button = mkBool true "Window Menu Take Screenshot Button Visibility Status.";
    screen-sharing-indicator = mkBool true "Screen Sharing Indicator Visibility Status.";
    screen-recording-indicator = mkBool true "Screen Recording Indicator Visibility Status.";
    dash-app-running = mkBool true "Dash app running dot visibility status.";
    quick-settings-dark-mode = mkBool true "Dark Mode Toggle Button Visibility Status.";
    quick-settings-night-light = mkBool true "Night Light Toggle Button Visibility Status.";
    quick-settings-do-not-disturb = mkBool true "Do Not Disturb Toggle Button Visibility Status.";
    quick-settings-backlight = mkBool true "Backlight Toggle Button Visibility Status.";
    quick-settings-airplane-mode = mkBool true "Airplane Mode Toggle Button Visibility Status.";

    # --- Behavior ---
    type-to-search = mkBool true "Type to Search Behavior.";
    window-demands-attention-focus = mkBool false "Window Demands Attention Focus Status.";
    window-maximized-on-create = mkBool false "Window Maximized on Create Status.";
    workspace-wrap-around = mkBool false "Workspace Wrap Around Status.";
    double-super-to-appgrid = mkBool true "Double Supper To App Grid Status.";
    overlay-key = mkBool true "Overlay Key to Overview Status.";
    switcher-popup-delay = mkBool true "Removes the delay for all switcher popups.";
    workspace-peek = mkBool true "Workspace Peek Status.";
    accent-color-icon = mkBool false "Use Accent for Icons.";
    workspace-thumbnail-to-main-view = mkBool false "Workspace Thumbnail Click to Main View.";
    invert-calendar-column-items = mkBool false "Invert Calendar Column Items.";

    # --- Dimensions & Positioning ---
    panel-corner-size = mkInt 0 "Panel Corner Size (0=theme, 1=no border, 2-61=size).";
    workspace-switcher-size = mkInt 0 "Workspace Switcher Size in percent (0=default).";
    top-panel-position = mkInt 0 "Top Panel Position Status (0-1).";
    clock-menu-position = mkInt 0 "Clock Menu Position (0=center, 1=right, 2=left).";
    clock-menu-position-offset = mkInt 0 "Clock Menu Position Offset (0-20).";
    animation = mkInt 1 "Animation Speed (0=disabled, 1=default, 2-6=speed).";
    dash-icon-size = mkInt 0 "Dash Icon Size (0=default).";
    startup-status = mkInt 1 "Startup Status (0=desktop, 1=overview).";
    notification-banner-position = mkInt 1 "Notification Banner Position (0-5).";
    panel-size = mkInt 0 "Panel Size (0=theme, 1-64=pixels).";
    panel-button-padding-size = mkInt 0 "Panel Button Padding Size (0=theme, 1=none, 2-61=size).";
    panel-indicator-padding-size = mkInt 0 "Panel Indicator Padding Size (0=theme, 1=none, 2-61=size).";
    workspace-background-corner-size = mkInt 0 "Workspace Background Corner Size (0=default, 1=none, 2-61=radius).";
    panel-icon-size = mkInt 0 "Panel Icon Size (0=theme, 1-60=size).";
    looking-glass-width = mkInt 0 "Looking Glass Width % (0=default).";
    looking-glass-height = mkInt 0 "Looking Glass Height % (0=default).";
    osd-position = mkInt 0 "OSD Position Status (0-9).";
    alt-tab-window-preview-size = mkInt 0 "Alt Tab Window Preview Size (0=default).";
    alt-tab-small-icon-size = mkInt 0 "Alt Tab Small Icon Size (0=default).";
    alt-tab-icon-size = mkInt 0 "Alt Tab Icon Size (0=default).";
    controls-manager-spacing-size = mkInt 0 "Controls manager spacing Size (0=default).";
    max-displayed-search-results = mkInt 0 "Max Displayed Search Results (0=default).";
    support-notifier-type = mkInt 1 "Support Notifier Type (0=Never, 1=New Releases).";
    support-notifier-showed-version = mkInt 0 "The Last Version The Support Notifier Showed Up.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.just-perfection ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/just-perfection" = {
            # Visibility
            panel = cfg.panel;
            panel-in-overview = cfg.panel-in-overview;
            background-menu = cfg.background-menu;
            search = cfg.search;
            workspace = cfg.workspace;
            dash = cfg.dash;
            osd = cfg.osd;
            workspace-popup = cfg.workspace-popup;
            theme = cfg.theme;
            activities-button = cfg.activities-button;
            clock-menu = cfg.clock-menu;
            panel-notification-icon = cfg.panel-notification-icon;
            keyboard-layout = cfg.keyboard-layout;
            accessibility-menu = cfg.accessibility-menu;
            quick-settings = cfg.quick-settings;
            power-icon = cfg.power-icon;
            window-picker-icon = cfg.window-picker-icon;
            show-apps-button = cfg.show-apps-button;
            workspaces-in-app-grid = cfg.workspaces-in-app-grid;
            workspace-switcher-should-show = cfg.workspace-switcher-should-show;
            window-preview-caption = cfg.window-preview-caption;
            window-preview-close-button = cfg.window-preview-close-button;
            ripple-box = cfg.ripple-box;
            world-clock = cfg.world-clock;
            weather = cfg.weather;
            events-button = cfg.events-button;
            calendar = cfg.calendar;
            dash-separator = cfg.dash-separator;
            window-menu = cfg.window-menu;
            window-menu-take-screenshot-button = cfg.window-menu-take-screenshot-button;
            screen-sharing-indicator = cfg.screen-sharing-indicator;
            screen-recording-indicator = cfg.screen-recording-indicator;
            dash-app-running = cfg.dash-app-running;
            quick-settings-dark-mode = cfg.quick-settings-dark-mode;
            quick-settings-night-light = cfg.quick-settings-night-light;
            quick-settings-do-not-disturb = cfg.quick-settings-do-not-disturb;
            quick-settings-backlight = cfg.quick-settings-backlight;
            quick-settings-airplane-mode = cfg.quick-settings-airplane-mode;

            # Behavior
            type-to-search = cfg.type-to-search;
            window-demands-attention-focus = cfg.window-demands-attention-focus;
            window-maximized-on-create = cfg.window-maximized-on-create;
            workspace-wrap-around = cfg.workspace-wrap-around;
            double-super-to-appgrid = cfg.double-super-to-appgrid;
            overlay-key = cfg.overlay-key;
            switcher-popup-delay = cfg.switcher-popup-delay;
            workspace-peek = cfg.workspace-peek;
            accent-color-icon = cfg.accent-color-icon;
            workspace-thumbnail-to-main-view = cfg.workspace-thumbnail-to-main-view;
            invert-calendar-column-items = cfg.invert-calendar-column-items;

            # Dimensions & Positioning
            panel-corner-size = cfg.panel-corner-size;
            workspace-switcher-size = cfg.workspace-switcher-size;
            top-panel-position = cfg.top-panel-position;
            clock-menu-position = cfg.clock-menu-position;
            clock-menu-position-offset = cfg.clock-menu-position-offset;
            animation = cfg.animation;
            dash-icon-size = cfg.dash-icon-size;
            startup-status = cfg.startup-status;
            notification-banner-position = cfg.notification-banner-position;
            panel-size = cfg.panel-size;
            panel-button-padding-size = cfg.panel-button-padding-size;
            panel-indicator-padding-size = cfg.panel-indicator-padding-size;
            workspace-background-corner-size = cfg.workspace-background-corner-size;
            panel-icon-size = cfg.panel-icon-size;
            looking-glass-width = cfg.looking-glass-width;
            looking-glass-height = cfg.looking-glass-height;
            osd-position = cfg.osd-position;
            alt-tab-window-preview-size = cfg.alt-tab-window-preview-size;
            alt-tab-small-icon-size = cfg.alt-tab-small-icon-size;
            alt-tab-icon-size = cfg.alt-tab-icon-size;
            controls-manager-spacing-size = cfg.controls-manager-spacing-size;
            max-displayed-search-results = cfg.max-displayed-search-results;
            support-notifier-type = cfg.support-notifier-type;
            support-notifier-showed-version = cfg.support-notifier-showed-version;
          };
        };
      }
    ];
  };
}
