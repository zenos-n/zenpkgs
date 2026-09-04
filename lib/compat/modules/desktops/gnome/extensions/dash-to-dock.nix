{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.dash-to-dock;

  meta = {
    description = ''
      Highly configurable dock interface for GNOME Shell

      This module installs and configures the **Dash to Dock** extension for GNOME.
      It transforms the dash into a highly configurable dock that can be placed 
      on any edge of the screen.

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
in
{

  options.zenos.desktops.gnome.extensions.dash-to-dock = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Dash to Dock GNOME extension configuration";

    layout = {
      position = mkOption {
        type = types.enum [
          "BOTTOM"
          "TOP"
          "LEFT"
          "RIGHT"
        ];
        default = "BOTTOM";
        description = "Screen edge where the dock is anchored";
      };

      monitor = {
        preferred = mkOption {
          type = types.int;
          default = -2;
          description = "Monitor index (-2 for primary)";
        };
        connector = mkOption {
          type = types.str;
          default = "primary";
          description = "Monitor hardware connector ID";
        };
        multi-monitor = mkOption {
          type = types.bool;
          default = false;
          description = "Show dock on all available screens";
        };
      };

      height = {
        fraction = mkOption {
          type = types.float;
          default = 0.90;
          description = "Maximum dock size relative to screen edge";
        };
        extend = mkOption {
          type = types.bool;
          default = false;
          description = "Expand the dock to fill the entire screen edge";
        };
      };

      icons = {
        size = mkOption {
          type = types.int;
          default = 48;
          description = "Target pixel size for application icons";
        };
        fixed = mkOption {
          type = types.bool;
          default = false;
          description = "Prevent the dock from shrinking icons";
        };
        center = mkOption {
          type = types.bool;
          default = false;
          description = "Keep icons centered when in panel mode";
        };
      };
    };

    appearance = {
      theme = {
        apply-custom = mkOption {
          type = types.bool;
          default = false;
          description = "Enable shell theme overrides";
        };
        shrink = mkOption {
          type = types.bool;
          default = false;
          description = "Remove extra padding around the dock";
        };
        glossy = mkOption {
          type = types.bool;
          default = true;
          description = "Apply a visual glossy effect to icons";
        };
        straight-corner = mkOption {
          type = types.bool;
          default = false;
          description = "Disable corner rounding for the dock background";
        };
      };

      background = {
        color = mkOption {
          type = types.str;
          default = "#ffffff";
          description = "Hex color for the dock background";
        };
        custom-color = mkOption {
          type = types.bool;
          default = false;
          description = "Force use of the custom background color";
        };
        opacity = mkOption {
          type = types.float;
          default = 0.8;
          description = "Fixed background alpha transparency";
        };
        transparency-mode = mkOption {
          type = types.enum [
            "DEFAULT"
            "FIXED"
            "DYNAMIC"
            "ADAPTIVE"
          ];
          default = "DEFAULT";
          description = "Alpha blending logic for the dock background";
        };
        customize-alphas = mkOption {
          type = types.bool;
          default = false;
          description = "Manually override min/max opacity levels";
        };
        min-alpha = mkOption {
          type = types.float;
          default = 0.2;
          description = "Minimum opacity when windows are not near";
        };
        max-alpha = mkOption {
          type = types.float;
          default = 0.8;
          description = "Maximum opacity when windows overlap";
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
          description = "Visual style of the active application marker";
        };
        dominant-color = mkOption {
          type = types.bool;
          default = false;
          description = "Inherit indicator color from the app icon";
        };
        custom-dots = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Manual marker color configuration";
          };
          color = mkOption {
            type = types.str;
            default = "#ffffff";
            description = "Marker fill color";
          };
          border-color = mkOption {
            type = types.str;
            default = "#ffffff";
            description = "Marker outline color";
          };
          border-width = mkOption {
            type = types.int;
            default = 0;
            description = "Marker outline pixel thickness";
          };
        };
      };

      unity-backlit = mkOption {
        type = types.bool;
        default = false;
        description = "Glow effects behind active icons";
      };
    };

    behavior = {
      visibility = {
        autohide = mkOption {
          type = types.bool;
          default = true;
          description = "Hide when the cursor is not near the edge";
        };
        manualhide = mkOption {
          type = types.bool;
          default = false;
          description = "Require explicit toggle for visibility";
        };
        fixed = mkOption {
          type = types.bool;
          default = false;
          description = "Always keep the dock visible";
        };
        intellihide = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Avoid overlapping application windows";
          };
          mode = mkOption {
            type = types.enum [
              "FOCUS_APPLICATION_WINDOWS"
              "ALL_WINDOWS"
              "MAXIMIZED_WINDOWS"
            ];
            default = "FOCUS_APPLICATION_WINDOWS";
            description = "Intellihide behavior policy";
          };
        };
        fullscreen-autohide = mkOption {
          type = types.bool;
          default = false;
          description = "Hide the dock for fullscreen media/games";
        };
        urgent-notify = mkOption {
          type = types.bool;
          default = true;
          description = "Show dock when apps request attention";
        };
      };

      timing = {
        animation-time = mkOption {
          type = types.float;
          default = 0.2;
          description = "Visual transition duration";
        };
        show-delay = mkOption {
          type = types.float;
          default = 0.25;
          description = "Pause before revealing the hidden dock";
        };
        hide-delay = mkOption {
          type = types.float;
          default = 0.20;
          description = "Pause before concealing the visible dock";
        };
      };

      pressure = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Require cursor pressure to trigger revealing";
        };
        threshold = mkOption {
          type = types.float;
          default = 100.0;
          description = "Trigger threshold for edge pressure";
        };
      };

      actions = {
        click = mkOption {
          type = types.str;
          default = "cycle-windows";
          description = "Standard click action";
        };
        shift-click = mkOption {
          type = types.str;
          default = "minimize";
          description = "Action for Shift+Click";
        };
        middle-click = mkOption {
          type = types.str;
          default = "launch";
          description = "Action for Middle Click";
        };
        shift-middle-click = mkOption {
          type = types.str;
          default = "launch";
          description = "Action for Shift+Middle Click";
        };
        scroll = mkOption {
          type = types.str;
          default = "do-nothing";
          description = "Action for mouse scroll on icon";
        };
      };

      scrolling = {
        switch-workspace = mkOption {
          type = types.bool;
          default = true;
          description = "Change desktop by scrolling on the dock";
        };
      };

      minimize-shift = mkOption {
        type = types.bool;
        default = true;
        description = "Hide windows when clicking with Shift";
      };

      isolate = {
        workspaces = mkOption {
          type = types.bool;
          default = false;
          description = "Filter apps by current desktop";
        };
        monitors = mkOption {
          type = types.bool;
          default = false;
          description = "Filter apps by hardware display";
        };
        locations = mkOption {
          type = types.bool;
          default = true;
          description = "Separate trash and mount indicators";
        };
      };
    };

    content = {
      show-favorites = mkOption {
        type = types.bool;
        default = true;
        description = "Display pinned applications";
      };
      show-running = mkOption {
        type = types.bool;
        default = true;
        description = "Display active windows";
      };
      show-trash = mkOption {
        type = types.bool;
        default = true;
        description = "Display the trash can icon";
      };
      show-mounts = mkOption {
        type = types.bool;
        default = true;
        description = "Display external storage icons";
      };
      show-mounts-network = mkOption {
        type = types.bool;
        default = false;
        description = "Display remote network shares";
      };
      show-mounts-only-mounted = mkOption {
        type = types.bool;
        default = true;
        description = "Hide unmounted device placeholders";
      };
      show-windows-preview = mkOption {
        type = types.bool;
        default = true;
        description = "Render live thumbnails on interaction";
      };
      apps-button = {
        show = mkOption {
          type = types.bool;
          default = true;
          description = "Display the application grid button";
        };
        at-top = mkOption {
          type = types.bool;
          default = false;
          description = "Anchor apps button to the start of the dock";
        };
        always-in-edge = mkOption {
          type = types.bool;
          default = true;
          description = "Keep apps button fixed to screen corner";
        };
      };
    };

    shortcuts = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Super+Num launch keys";
      };
      show-dock = mkOption {
        type = types.bool;
        default = true;
        description = "Show dock when hotkey is triggered";
      };
      overlay = mkOption {
        type = types.bool;
        default = true;
        description = "Display key numbers over icons";
      };
      timeout = mkOption {
        type = types.float;
        default = 2.0;
        description = "Duration of the numbers overlay";
      };
      toggle-shortcut = mkOption {
        type = types.listOf types.str;
        default = [ "<Super>q" ];
        description = "Shortcut to show/hide dock";
      };
    };

    disable-overview-on-startup = mkOption {
      type = types.bool;
      default = false;
      description = "Skip overview after login";
    };
    bolt-support = mkOption {
      type = types.bool;
      default = true;
      description = "Compatibility for bolt extensions";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.dash-to-dock ];
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/shell/extensions/dash-to-dock" = {
          dock-position = cfg.layout.position;
          preferred-monitor = cfg.layout.monitor.preferred;
          preferred-monitor-by-connector = cfg.layout.monitor.connector;
          multi-monitor = cfg.layout.monitor.multi-monitor;
          height-fraction = cfg.layout.height.fraction;
          extend-height = cfg.layout.height.extend;
          dash-max-icon-size = cfg.layout.icons.size;
          icon-size-fixed = cfg.layout.icons.fixed;
          always-center-icons = cfg.layout.icons.center;
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
          hot-keys = cfg.shortcuts.enable;
          hotkeys-show-dock = cfg.shortcuts.show-dock;
          hotkeys-overlay = cfg.shortcuts.overlay;
          shortcut-timeout = cfg.shortcuts.timeout;
          shortcut = cfg.shortcuts.toggle-shortcut;
          shortcut-text =
            if (length cfg.shortcuts.toggle-shortcut) > 0 then (head cfg.shortcuts.toggle-shortcut) else "";
          disable-overview-on-startup = cfg.disable-overview-on-startup;
          bolt-support = cfg.bolt-support;
        };
      }
    ];
  };
}
