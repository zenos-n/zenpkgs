{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.dash-to-dock;

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

  mkDouble =
    default: description:
    mkOption {
      type = types.float;
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
  options.zenos.desktops.gnome.extensions.dash-to-dock = {
    enable = mkEnableOption "Dash to Dock GNOME extension configuration";

    dock-position = mkStr "BOTTOM" "Dock position (BOTTOM/TOP/LEFT/RIGHT).";
    animation-time = mkDouble 0.2 "Animation time.";
    show-delay = mkDouble 0.25 "Show delay.";
    hide-delay = mkDouble 0.20 "Hide delay.";
    disable-overview-on-startup = mkBool false "Do not show overview on startup.";
    custom-background-color = mkBool false "Set custom background color.";
    background-color = mkStr "#ffffff" "Dash background color.";
    transparency-mode = mkStr "DEFAULT" "Transparency mode.";
    running-indicator-style = mkStr "DEFAULT" "Running indicator style.";
    running-indicator-dominant-color = mkBool false "Use dominant color for indicator.";
    customize-alphas = mkBool false "Manually set min/max opacity.";
    min-alpha = mkDouble 0.2 "Min opacity.";
    max-alpha = mkDouble 0.8 "Max opacity.";
    background-opacity = mkDouble 0.8 "Background opacity.";
    manualhide = mkBool false "Dock not shown on desktop.";
    intellihide = mkBool true "Dock dodges windows.";
    intellihide-mode = mkStr "FOCUS_APPLICATION_WINDOWS" "Intellihide mode.";
    autohide = mkBool true "Dock shown on mouse over.";
    require-pressure-to-show = mkBool true "Require pressure to show dash.";
    pressure-threshold = mkDouble 100.0 "Pressure threshold.";
    autohide-in-fullscreen = mkBool false "Enable autohide in fullscreen.";
    show-dock-urgent-notify = mkBool true "Show dock for urgent notifications.";
    dock-fixed = mkBool false "Dock always visible.";
    scroll-switch-workspace = mkBool true "Switch workspace by scrolling.";
    dash-max-icon-size = mkInt 48 "Maximum dash icon size.";
    preview-size-scale = mkDouble 0.0 "Preview size scale.";
    icon-size-fixed = mkBool false "Fixed icon size.";
    apply-custom-theme = mkBool false "Apply custom theme.";
    custom-theme-shrink = mkBool false "Custom theme shrink.";
    custom-theme-customize-running-dots = mkBool false "Customize running dots.";
    custom-theme-running-dots-color = mkStr "#ffffff" "Running dots color.";
    custom-theme-running-dots-border-color = mkStr "#ffffff" "Running dots border color.";
    custom-theme-running-dots-border-width = mkInt 0 "Running dots border width.";
    show-running = mkBool true "Show running apps.";
    isolate-workspaces = mkBool false "Provide workspace isolation.";
    workspace-agnostic-urgent-windows = mkBool true "Show urgent windows on each workspace.";
    isolate-monitors = mkBool false "Provide monitor isolation.";
    scroll-to-focused-application = mkBool true "Scroll to focused application.";
    show-windows-preview = mkBool true "Show preview of open windows.";
    default-windows-preview-to-open = mkBool false "Open windows preview by default.";
    show-favorites = mkBool true "Show favorite apps.";
    show-trash = mkBool true "Show trash can.";
    show-mounts = mkBool true "Show mounted volumes.";
    show-mounts-only-mounted = mkBool true "Only show mounted volumes.";
    show-mounts-network = mkBool false "Show network mounts.";
    isolate-locations = mkBool true "Isolate volumes/trash windows.";
    dance-urgent-applications = mkBool true "Wiggle urgent applications.";
    show-show-apps-button = mkBool true "Show applications button.";
    show-apps-at-top = mkBool false "Show apps button at top.";
    show-apps-always-in-the-edge = mkBool true "Show apps button on edge.";
    bolt-support = mkBool true "Bolt extensions compatibility.";
    height-fraction = mkDouble 0.90 "Dock max height/width fraction.";
    extend-height = mkBool false "Extend dock container.";
    always-center-icons = mkBool false "Center icons when extended.";
    preferred-monitor = mkInt (-2) "Preferred monitor index.";
    preferred-monitor-by-connector = mkStr "primary" "Preferred monitor connector.";
    multi-monitor = mkBool false "Enable multi-monitor docks.";
    minimize-shift = mkBool true "Minimize on shift+click.";
    activate-single-window = mkBool true "Activate only one window.";
    click-action = mkStr "cycle-windows" "Click action.";
    scroll-action = mkStr "do-nothing" "Scroll action.";
    shift-click-action = mkStr "minimize" "Shift+click action.";
    middle-click-action = mkStr "launch" "Middle click action.";
    shift-middle-click-action = mkStr "launch" "Shift+middle click action.";
    hot-keys = mkBool true "Enable Super hotkeys.";
    hotkeys-show-dock = mkBool true "Show dock on hotkeys.";
    shortcut-text = mkStr "<Super>q" "Shortcut text.";
    shortcut = mkOptionStrList [ "<Super>q" ] "Shortcut.";
    shortcut-timeout = mkDouble 2.0 "Shortcut timeout.";
    hotkeys-overlay = mkBool true "Show hotkeys overlay.";

    force-straight-corner = mkBool false "Force straight corners.";
    unity-backlit-items = mkBool false "Unity-like backlit items.";
    apply-glossy-effect = mkBool true "Enable glossy effect.";
    hide-tooltip = mkBool false "Hide application tooltip.";
    show-icons-emblems = mkBool true "Show icons emblems.";
    show-icons-notifications-counter = mkBool true "Show notifications counter.";
    application-counter-overrides-notifications = mkBool true "Application counter overrides notifications.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.dash-to-dock ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/dash-to-dock" = {
            dock-position = cfg.dock-position;
            animation-time = cfg.animation-time;
            show-delay = cfg.show-delay;
            hide-delay = cfg.hide-delay;
            disable-overview-on-startup = cfg.disable-overview-on-startup;
            custom-background-color = cfg.custom-background-color;
            background-color = cfg.background-color;
            transparency-mode = cfg.transparency-mode;
            running-indicator-style = cfg.running-indicator-style;
            running-indicator-dominant-color = cfg.running-indicator-dominant-color;
            customize-alphas = cfg.customize-alphas;
            min-alpha = cfg.min-alpha;
            max-alpha = cfg.max-alpha;
            background-opacity = cfg.background-opacity;
            manualhide = cfg.manualhide;
            intellihide = cfg.intellihide;
            intellihide-mode = cfg.intellihide-mode;
            autohide = cfg.autohide;
            require-pressure-to-show = cfg.require-pressure-to-show;
            pressure-threshold = cfg.pressure-threshold;
            autohide-in-fullscreen = cfg.autohide-in-fullscreen;
            show-dock-urgent-notify = cfg.show-dock-urgent-notify;
            dock-fixed = cfg.dock-fixed;
            scroll-switch-workspace = cfg.scroll-switch-workspace;
            dash-max-icon-size = cfg.dash-max-icon-size;
            preview-size-scale = cfg.preview-size-scale;
            icon-size-fixed = cfg.icon-size-fixed;
            apply-custom-theme = cfg.apply-custom-theme;
            custom-theme-shrink = cfg.custom-theme-shrink;
            custom-theme-customize-running-dots = cfg.custom-theme-customize-running-dots;
            custom-theme-running-dots-color = cfg.custom-theme-running-dots-color;
            custom-theme-running-dots-border-color = cfg.custom-theme-running-dots-border-color;
            custom-theme-running-dots-border-width = cfg.custom-theme-running-dots-border-width;
            show-running = cfg.show-running;
            isolate-workspaces = cfg.isolate-workspaces;
            workspace-agnostic-urgent-windows = cfg.workspace-agnostic-urgent-windows;
            isolate-monitors = cfg.isolate-monitors;
            scroll-to-focused-application = cfg.scroll-to-focused-application;
            show-windows-preview = cfg.show-windows-preview;
            default-windows-preview-to-open = cfg.default-windows-preview-to-open;
            show-favorites = cfg.show-favorites;
            show-trash = cfg.show-trash;
            show-mounts = cfg.show-mounts;
            show-mounts-only-mounted = cfg.show-mounts-only-mounted;
            show-mounts-network = cfg.show-mounts-network;
            isolate-locations = cfg.isolate-locations;
            dance-urgent-applications = cfg.dance-urgent-applications;
            show-show-apps-button = cfg.show-show-apps-button;
            show-apps-at-top = cfg.show-apps-at-top;
            show-apps-always-in-the-edge = cfg.show-apps-always-in-the-edge;
            bolt-support = cfg.bolt-support;
            height-fraction = cfg.height-fraction;
            extend-height = cfg.extend-height;
            always-center-icons = cfg.always-center-icons;
            preferred-monitor = cfg.preferred-monitor;
            preferred-monitor-by-connector = cfg.preferred-monitor-by-connector;
            multi-monitor = cfg.multi-monitor;
            minimize-shift = cfg.minimize-shift;
            activate-single-window = cfg.activate-single-window;
            click-action = cfg.click-action;
            scroll-action = cfg.scroll-action;
            shift-click-action = cfg.shift-click-action;
            middle-click-action = cfg.middle-click-action;
            shift-middle-click-action = cfg.shift-middle-click-action;
            hot-keys = cfg.hot-keys;
            hotkeys-show-dock = cfg.hotkeys-show-dock;
            shortcut-text = cfg.shortcut-text;
            shortcut = cfg.shortcut;
            shortcut-timeout = cfg.shortcut-timeout;
            hotkeys-overlay = cfg.hotkeys-overlay;
            force-straight-corner = cfg.force-straight-corner;
            unity-backlit-items = cfg.unity-backlit-items;
            apply-glossy-effect = cfg.apply-glossy-effect;
            hide-tooltip = cfg.hide-tooltip;
            show-icons-emblems = cfg.show-icons-emblems;
            show-icons-notifications-counter = cfg.show-icons-notifications-counter;
            application-counter-overrides-notifications = cfg.application-counter-overrides-notifications;
          };
        };
      }
    ];
  };
}
