{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.dash-to-dock;

in
{
  meta = {
    description = "Configures the Dash to Dock GNOME extension";
    longDescription = ''
      This module installs and configures the **Dash to Dock** extension for GNOME.
      It transforms the dash into a highly configurable dock that can be placed on
      any edge of the screen, with intelligent hiding and extensive appearance options.

      **Features:**
      - Configurable position, size, and visibility behavior.
      - Intelligent hiding (intellihide) to dodge windows.
      - Custom click actions and scroll behaviors.
      - Extensive styling options (transparency, running indicators).
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.dash-to-dock = {
    enable = mkEnableOption "Dash to Dock GNOME extension configuration";

    # --- Layout & Position ---
    layout = {
      position = mkOption {
        type = types.enum [
          "BOTTOM"
          "TOP"
          "LEFT"
          "RIGHT"
        ];
        default = "BOTTOM";
        description = "Dock position on the screen";
      };

      monitor = {
        preferred = mkOption {
          type = types.int;
          default = -2;
          description = "Preferred monitor index (-2 for primary)";
        };
        connector = mkOption {
          type = types.str;
          default = "primary";
          description = "Preferred monitor connector";
        };
        multi-monitor = mkOption {
          type = types.bool;
          default = false;
          description = "Show dock on all monitors";
        };
      };

      height = {
        fraction = mkOption {
          type = types.float;
          default = 0.90;
          description = "Dock max height/width fraction (0.0 - 1.0)";
        };
        extend = mkOption {
          type = types.bool;
          default = false;
          description = "Extend dock container to screen edges (panel mode)";
        };
      };

      icons = {
        size = mkOption {
          type = types.int;
          default = 48;
          description = "Maximum dash icon size in pixels";
        };
        fixed = mkOption {
          type = types.bool;
          default = false;
          description = "Fixed icon size (do not shrink)";
        };
        center = mkOption {
          type = types.bool;
          default = false;
          description = "Always center icons when extended";
        };
      };
    };

    # --- Appearance ---
    appearance = {
      theme = {
        apply-custom = mkOption {
          type = types.bool;
          default = false;
          description = "Apply custom theme customizations";
        };
        shrink = mkOption {
          type = types.bool;
          default = false;
          description = "Shrink the dock to minimum width";
        };
        glossy = mkOption {
          type = types.bool;
          default = true;
          description = "Apply glossy effect";
        };
        straight-corner = mkOption {
          type = types.bool;
          default = false;
          description = "Force straight corners";
        };
      };

      background = {
        color = mkOption {
          type = types.str;
          default = "#ffffff";
          description = "Custom dock background color (Hex)";
        };
        custom-color = mkOption {
          type = types.bool;
          default = false;
          description = "Enable custom background color";
        };
        opacity = mkOption {
          type = types.float;
          default = 0.8;
          description = "Background opacity";
        };
        transparency-mode = mkOption {
          type = types.enum [
            "DEFAULT"
            "FIXED"
            "DYNAMIC"
            "ADAPTIVE"
          ];
          default = "DEFAULT";
          description = "Transparency mode";
        };
        customize-alphas = mkOption {
          type = types.bool;
          default = false;
          description = "Manually set min/max opacity values";
        };
        min-alpha = mkOption {
          type = types.float;
          default = 0.2;
          description = "Minimum opacity";
        };
        max-alpha = mkOption {
          type = types.float;
          default = 0.8;
          description = "Maximum opacity";
        };
      };

      running-indicator = {
        style = mkOption {
          type = types.enum [
            "DEFAULT"
            "DOTS"
            "DASHES"
            "SOLID"
            "CILIORA"
            "METRO"
          ];
          default = "DEFAULT";
          description = "Style of the running application indicator";
        };
        dominant-color = mkOption {
          type = types.bool;
          default = false;
          description = "Use dominant color from app icon for indicator";
        };
        custom-dots = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Customize running dots appearance";
          };
          color = mkOption {
            type = types.str;
            default = "#ffffff";
            description = "Running dots color";
          };
          border-color = mkOption {
            type = types.str;
            default = "#ffffff";
            description = "Running dots border color";
          };
          border-width = mkOption {
            type = types.int;
            default = 0;
            description = "Running dots border width";
          };
        };
      };

      unity-backlit = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Unity-like backlit items";
      };
    };

    # --- Behavior & Visibility ---
    behavior = {
      visibility = {
        autohide = mkOption {
          type = types.bool;
          default = true;
          description = "Hide dock when not in use (shown on mouse over)";
        };
        manualhide = mkOption {
          type = types.bool;
          default = false;
          description = "Dock is explicitly hidden via shortcut";
        };
        fixed = mkOption {
          type = types.bool;
          default = false;
          description = "Dock is always visible";
        };
        intellihide = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Dock intelligently dodges overlapping windows";
          };
          mode = mkOption {
            type = types.enum [
              "FOCUS_APPLICATION_WINDOWS"
              "ALL_WINDOWS"
              "MAXIMIZED_WINDOWS"
            ];
            default = "FOCUS_APPLICATION_WINDOWS";
            description = "Intellihide behavior mode";
          };
        };
        fullscreen-autohide = mkOption {
          type = types.bool;
          default = false;
          description = "Enable autohide even in fullscreen";
        };
        urgent-notify = mkOption {
          type = types.bool;
          default = true;
          description = "Show dock when an application has an urgent notification";
        };
      };

      timing = {
        animation-time = mkOption {
          type = types.float;
          default = 0.2;
          description = "Animation duration";
        };
        show-delay = mkOption {
          type = types.float;
          default = 0.25;
          description = "Delay before showing the dock";
        };
        hide-delay = mkOption {
          type = types.float;
          default = 0.20;
          description = "Delay before hiding the dock";
        };
      };

      pressure = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Require pressure at edge to show dash";
        };
        threshold = mkOption {
          type = types.float;
          default = 100.0;
          description = "Pressure threshold value";
        };
      };

      actions = {
        click = mkOption {
          type = types.str;
          default = "cycle-windows";
          description = "Action when clicking a running app";
        };
        shift-click = mkOption {
          type = types.str;
          default = "minimize";
          description = "Action when Shift+clicking an app";
        };
        middle-click = mkOption {
          type = types.str;
          default = "launch";
          description = "Action when Middle-clicking an app";
        };
        shift-middle-click = mkOption {
          type = types.str;
          default = "launch";
          description = "Action when Shift+Middle-clicking an app";
        };
        scroll = mkOption {
          type = types.str;
          default = "do-nothing";
          description = "Action when scrolling on an app icon";
        };
      };

      scrolling = {
        switch-workspace = mkOption {
          type = types.bool;
          default = true;
          description = "Switch workspace by scrolling on the dock";
        };
      };

      minimize-shift = mkOption {
        type = types.bool;
        default = true;
        description = "Minimize on Shift+Click";
      };

      isolate = {
        workspaces = mkOption {
          type = types.bool;
          default = false;
          description = "Show only apps from the current workspace";
        };
        monitors = mkOption {
          type = types.bool;
          default = false;
          description = "Show only apps from the current monitor";
        };
        locations = mkOption {
          type = types.bool;
          default = true;
          description = "Isolate volumes/trash windows";
        };
      };
    };

    # --- Content ---
    content = {
      show-favorites = mkOption {
        type = types.bool;
        default = true;
        description = "Show favorite applications";
      };
      show-running = mkOption {
        type = types.bool;
        default = true;
        description = "Show running applications";
      };
      show-trash = mkOption {
        type = types.bool;
        default = true;
        description = "Show trash can";
      };
      show-mounts = mkOption {
        type = types.bool;
        default = true;
        description = "Show mounted volumes";
      };
      show-mounts-network = mkOption {
        type = types.bool;
        default = false;
        description = "Show network mounts";
      };
      show-mounts-only-mounted = mkOption {
        type = types.bool;
        default = true;
        description = "Only show volumes that are currently mounted";
      };
      show-windows-preview = mkOption {
        type = types.bool;
        default = true;
        description = "Show preview of open windows on hover/click";
      };
      apps-button = {
        show = mkOption {
          type = types.bool;
          default = true;
          description = "Show the 'Show Applications' button";
        };
        at-top = mkOption {
          type = types.bool;
          default = false;
          description = "Position the apps button at the beginning of the dock";
        };
        always-in-edge = mkOption {
          type = types.bool;
          default = true;
          description = "Keep apps button at the screen edge";
        };
      };
    };

    # --- Shortcuts ---
    shortcuts = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Super+Number hotkeys";
      };
      show-dock = mkOption {
        type = types.bool;
        default = true;
        description = "Show dock when hotkeys are pressed";
      };
      overlay = mkOption {
        type = types.bool;
        default = true;
        description = "Show hotkeys overlay on numbers";
      };
      timeout = mkOption {
        type = types.float;
        default = 2.0;
        description = "Shortcut overlay timeout";
      };
      toggle-shortcut = mkOption {
        type = types.listOf types.str;
        default = [ "<Super>q" ];
        description = "Shortcut to toggle the dock visibility";
      };
    };

    # --- Misc ---
    disable-overview-on-startup = mkOption {
      type = types.bool;
      default = false;
      description = "Do not show overview on startup";
    };

    bolt-support = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Bolt extensions compatibility";
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.dash-to-dock ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/dash-to-dock" = {
            # Layout
            dock-position = cfg.layout.position;
            preferred-monitor = cfg.layout.monitor.preferred;
            preferred-monitor-by-connector = cfg.layout.monitor.connector;
            multi-monitor = cfg.layout.monitor.multi-monitor;
            height-fraction = cfg.layout.height.fraction;
            extend-height = cfg.layout.height.extend;
            dash-max-icon-size = cfg.layout.icons.size;
            icon-size-fixed = cfg.layout.icons.fixed;
            always-center-icons = cfg.layout.icons.center;

            # Appearance
            apply-custom-theme = cfg.appearance.theme.apply-custom;
            custom-theme-shrink = cfg.appearance.theme.shrink;
            apply-glossy-effect = cfg.appearance.theme.glossy;
            force-straight-corner = cfg.appearance.theme.straight-corner;
            unity-backlit-items = cfg.appearance.unity-backlit;

            background-color = cfg.appearance.background.color;
            custom-background-color = cfg.appearance.background.custom-color;
            background-opacity = cfg.appearance.background.opacity;
            transparency-mode = cfg.appearance.background.transparency-mode;
            customize-alphas = cfg.appearance.background.customize-alphas;
            min-alpha = cfg.appearance.background.min-alpha;
            max-alpha = cfg.appearance.background.max-alpha;

            running-indicator-style = cfg.appearance.running-indicator.style;
            running-indicator-dominant-color = cfg.appearance.running-indicator.dominant-color;
            custom-theme-customize-running-dots = cfg.appearance.running-indicator.custom-dots.enable;
            custom-theme-running-dots-color = cfg.appearance.running-indicator.custom-dots.color;
            custom-theme-running-dots-border-color = cfg.appearance.running-indicator.custom-dots.border-color;
            custom-theme-running-dots-border-width = cfg.appearance.running-indicator.custom-dots.border-width;

            # Behavior & Visibility
            autohide = cfg.behavior.visibility.autohide;
            manualhide = cfg.behavior.visibility.manualhide;
            dock-fixed = cfg.behavior.visibility.fixed;
            intellihide = cfg.behavior.visibility.intellihide.enable;
            intellihide-mode = cfg.behavior.visibility.intellihide.mode;
            autohide-in-fullscreen = cfg.behavior.visibility.fullscreen-autohide;
            show-dock-urgent-notify = cfg.behavior.visibility.urgent-notify;

            animation-time = cfg.behavior.timing.animation-time;
            show-delay = cfg.behavior.timing.show-delay;
            hide-delay = cfg.behavior.timing.hide-delay;

            require-pressure-to-show = cfg.behavior.pressure.enable;
            pressure-threshold = cfg.behavior.pressure.threshold;

            click-action = cfg.behavior.actions.click;
            shift-click-action = cfg.behavior.actions.shift-click;
            middle-click-action = cfg.behavior.actions.middle-click;
            shift-middle-click-action = cfg.behavior.actions.shift-middle-click;
            scroll-action = cfg.behavior.actions.scroll;

            scroll-switch-workspace = cfg.behavior.scrolling.switch-workspace;
            minimize-shift = cfg.behavior.minimize-shift;

            isolate-workspaces = cfg.behavior.isolate.workspaces;
            isolate-monitors = cfg.behavior.isolate.monitors;
            isolate-locations = cfg.behavior.isolate.locations;

            # Content
            show-favorites = cfg.content.show-favorites;
            show-running = cfg.content.show-running;
            show-trash = cfg.content.show-trash;
            show-mounts = cfg.content.show-mounts;
            show-mounts-network = cfg.content.show-mounts-network;
            show-mounts-only-mounted = cfg.content.show-mounts-only-mounted;
            show-windows-preview = cfg.content.show-windows-preview;
            show-show-apps-button = cfg.content.apps-button.show;
            show-apps-at-top = cfg.content.apps-button.at-top;
            show-apps-always-in-the-edge = cfg.content.apps-button.always-in-edge;

            # Shortcuts
            hot-keys = cfg.shortcuts.enable;
            hotkeys-show-dock = cfg.shortcuts.show-dock;
            hotkeys-overlay = cfg.shortcuts.overlay;
            shortcut-timeout = cfg.shortcuts.timeout;
            shortcut = cfg.shortcuts.toggle-shortcut;
            shortcut-text =
              if (length cfg.shortcuts.toggle-shortcut) > 0 then (head cfg.shortcuts.toggle-shortcut) else "";

            # Misc
            disable-overview-on-startup = cfg.disable-overview-on-startup;
            bolt-support = cfg.bolt-support;

            # Defaults for unexposed options (from original file)
            preview-size-scale = 0.0;
            workspace-agnostic-urgent-windows = true;
            dance-urgent-applications = true;
            scroll-to-focused-application = true;
            default-windows-preview-to-open = false;
            activate-single-window = true;
            hide-tooltip = false;
            show-icons-emblems = true;
            show-icons-notifications-counter = true;
            application-counter-overrides-notifications = true;
          };
        };
      }
    ];
  };
}
