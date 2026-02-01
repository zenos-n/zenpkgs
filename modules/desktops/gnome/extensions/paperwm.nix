{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.paperwm;

  # Helper for keybinding options
  mkKeybindOption =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

in
{
  meta = {
    description = "Configures the PaperWM GNOME extension";
    longDescription = ''
      This module installs and configures the **PaperWM** extension for GNOME.
      PaperWM implements a scrollable tiling window manager, inspired by 10/GUI concepts.
      It arranges windows in a horizontal ribbon, allowing for efficient navigation and management.

      **Features:**
      - Scrollable tiling layout.
      - Extensive keyboard navigation.
      - Touchpad gesture support.
      - Customizable appearance (margins, borders, minimap).
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.paperwm = {
    enable = mkEnableOption "PaperWM GNOME extension configuration";

    # --- Layout ---
    layout = {
      margins = {
        horizontal = mkOption {
          type = types.int;
          default = 20;
          description = "Minimum margin from windows left and right edge";
        };
        vertical = mkOption {
          type = types.int;
          default = 20;
          description = "Minimum margin from windows top edge";
        };
        bottom = mkOption {
          type = types.int;
          default = 20;
          description = "Minimum margin from windows bottom edge";
        };
      };

      gap = mkOption {
        type = types.int;
        default = 20;
        description = "Minimum gap between windows";
      };

      maximize = {
        width-percent = mkOption {
          type = types.float;
          default = 1.00;
          description = "Percent width for horizontal maximize";
        };
        within-tiling = mkOption {
          type = types.bool;
          default = true;
          description = "Maximize within tiling margins";
        };
      };

      cycle-steps = {
        width = mkOption {
          type = types.listOf types.float;
          default = [
            0.38195
            0.5
            0.61804
          ];
          description = "Cycle width steps";
        };
        height = mkOption {
          type = types.listOf types.float;
          default = [
            0.38195
            0.5
            0.61804
          ];
          description = "Cycle height steps";
        };
      };
    };

    # --- Appearance ---
    appearance = {
      borders = {
        size = mkOption {
          type = types.int;
          default = 10;
          description = "Selected window border size (px)";
        };
        radius-top = mkOption {
          type = types.int;
          default = 12;
          description = "Selected window border top radius (px)";
        };
        radius-bottom = mkOption {
          type = types.int;
          default = 0;
          description = "Selected window border bottom radius (px)";
        };
      };

      minimap = {
        scale = mkOption {
          type = types.float;
          default = 0.15;
          description = "Scale of minimap tiles";
        };
        shade-opacity = mkOption {
          type = types.int;
          default = 160;
          description = "Opacity of non-selected windows in minimap";
        };
      };

      workspace-colors = mkOption {
        type = types.listOf types.str;
        default = [
          "#314E6C"
          "#565248"
          "#445632"
        ];
        description = "Workspace colors";
      };

      use-default-background = mkOption {
        type = types.bool;
        default = true;
        description = "Use default GNOME background";
      };
    };

    # --- Behavior ---
    behavior = {
      open-window-position = mkOption {
        type = types.enum [
          "Right"
          "Left"
          "Start"
          "End"
        ];
        default = "Right";
        description = "New window position";
      };

      animation-time = mkOption {
        type = types.float;
        default = 0.25;
        description = "Animation duration (s)";
      };

      drift-speed = mkOption {
        type = types.int;
        default = 2;
        description = "Drift speed (px/ms)";
      };

      winprops = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Array of winprops JSON objects";
      };
    };

    # --- Top Bar ---
    topbar = {
      show-on-workspaces = mkOption {
        type = types.bool;
        default = true;
        description = "Show top bar on workspaces by default";
      };

      disable-styling = mkOption {
        type = types.bool;
        default = false;
        description = "Disable PaperWM topbar styling";
      };

      mouse-scroll-enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable scroll on topbar to switch windows";
      };

      indicators = {
        workspace = mkOption {
          type = types.bool;
          default = true;
          description = "Show workspace indicator in topbar";
        };
        position = mkOption {
          type = types.bool;
          default = true;
          description = "Show window position bar in topbar";
        };
        focus-mode = mkOption {
          type = types.bool;
          default = true;
          description = "Show focus mode icon in topbar";
        };
        open-position = mkOption {
          type = types.bool;
          default = true;
          description = "Show open position icon in topbar";
        };
      };
    };

    # --- Previews ---
    previews = {
      edge = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable tiling edge window previews";
        };
        scale = mkOption {
          type = types.float;
          default = 0.15;
          description = "Scale of edge previews";
        };
        click-enable = mkOption {
          type = types.bool;
          default = true;
          description = "Activate edge preview with click";
        };
        timeout = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Activate edge preview with timeout";
          };
          delay = mkOption {
            type = types.int;
            default = 800;
            description = "Timeout (ms) for edge preview";
          };
          continual = mkOption {
            type = types.bool;
            default = false;
            description = "Continual activation at edge";
          };
        };
      };

      switcher-scale = mkOption {
        type = types.float;
        default = 0.15;
        description = "Scale of window switch previews";
      };

      overview = {
        only-scratch = mkOption {
          type = types.bool;
          default = false;
          description = "Limit overview to scratch windows";
        };
        disable-scratch = mkOption {
          type = types.bool;
          default = false;
          description = "Don't show scratch windows in overview";
        };
      };
    };

    # --- Gestures ---
    gestures = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable touchpad gestures";
      };

      fingers = {
        horizontal = mkOption {
          type = types.int;
          default = 3;
          description = "Fingers for horizontal swipe";
        };
        workspace = mkOption {
          type = types.int;
          default = 3;
          description = "Fingers for workspace switching";
        };
      };

      swipe = {
        sensitivity = mkOption {
          type = types.listOf types.float;
          default = [
            2.0
            2.0
          ];
          description = "Swipe sensitivity [x, y]";
        };
        friction = mkOption {
          type = types.listOf types.float;
          default = [
            0.3
            0.1
          ];
          description = "Swipe friction [x, y]";
        };
      };
    };

    # --- Keybindings ---
    keybindings = {
      new-window = mkKeybindOption [
        "<Super>Return"
        "<Super>n"
      ] "Open new window";
      live-alt-tab = mkKeybindOption [
        "<Super>Tab"
        "<Alt>Tab"
      ] "Switch to prev active window";
      live-alt-tab-backward = mkKeybindOption [
        "<Super><Shift>Tab"
        "<Alt><Shift>Tab"
      ] "Switch to prev active window (backward)";
      previous-workspace = mkKeybindOption [ "<Super>Above_Tab" ] "Switch to prev workspace";
      switch-monitor-right = mkKeybindOption [ "<Super><Shift>Right" ] "Switch to right monitor";
      switch-monitor-left = mkKeybindOption [ "<Super><Shift>Left" ] "Switch to left monitor";
      move-right = mkKeybindOption [
        "<Super><Ctrl>period"
        "<Super><Shift>period"
        "<Super><Ctrl>Right"
      ] "Move window right";
      move-left = mkKeybindOption [
        "<Super><Ctrl>comma"
        "<Super><Shift>comma"
        "<Super><Ctrl>Left"
      ] "Move window left";
      move-up = mkKeybindOption [ "<Super><Ctrl>Up" ] "Move window up";
      move-down = mkKeybindOption [ "<Super><Ctrl>Down" ] "Move window down";
      close-window = mkKeybindOption [ "<Super>BackSpace" ] "Close active window";
      toggle-maximize-width = mkKeybindOption [ "<Super>f" ] "Maximize width";
      paper-toggle-fullscreen = mkKeybindOption [ "<Super><shift>f" ] "Toggle fullscreen";
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.paperwm ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/paperwm" = {
            # Layout
            horizontal-margin = cfg.layout.margins.horizontal;
            vertical-margin = cfg.layout.margins.vertical;
            vertical-margin-bottom = cfg.layout.margins.bottom;
            window-gap = cfg.layout.gap;
            maximize-width-percent = cfg.layout.maximize.width-percent;
            maximize-within-tiling = cfg.layout.maximize.within-tiling;
            cycle-width-steps = cfg.layout.cycle-steps.width;
            cycle-height-steps = cfg.layout.cycle-steps.height;

            # Appearance
            selection-border-size = cfg.appearance.borders.size;
            selection-border-radius-top = cfg.appearance.borders.radius-top;
            selection-border-radius-bottom = cfg.appearance.borders.radius-bottom;
            minimap-scale = cfg.appearance.minimap.scale;
            minimap-shade-opacity = cfg.appearance.minimap.shade-opacity;
            workspace-colors = cfg.appearance.workspace-colors;
            use-default-background = cfg.appearance.use-default-background;

            # Behavior
            open-window-position =
              let
                map = {
                  "Right" = 0;
                  "Left" = 1;
                  "Start" = 2;
                  "End" = 3;
                };
              in
              map.${cfg.behavior.open-window-position};
            animation-time = cfg.behavior.animation-time;
            drift-speed = cfg.behavior.drift-speed;
            winprops = cfg.behavior.winprops;

            # Top Bar
            default-show-top-bar = cfg.topbar.show-on-workspaces;
            disable-topbar-styling = cfg.topbar.disable-styling;
            topbar-mouse-scroll-enable = cfg.topbar.mouse-scroll-enable;
            show-workspace-indicator = cfg.topbar.indicators.workspace;
            show-window-position-bar = cfg.topbar.indicators.position;
            show-focus-mode-icon = cfg.topbar.indicators.focus-mode;
            show-open-position-icon = cfg.topbar.indicators.open-position;

            # Previews
            edge-preview-enable = cfg.previews.edge.enable;
            edge-preview-scale = cfg.previews.edge.scale;
            edge-preview-click-enable = cfg.previews.edge.click-enable;
            edge-preview-timeout-enable = cfg.previews.edge.timeout.enable;
            edge-preview-timeout = cfg.previews.edge.timeout.delay;
            edge-preview-timeout-continual = cfg.previews.edge.timeout.continual;
            window-switcher-preview-scale = cfg.previews.switcher-scale;
            only-scratch-in-overview = cfg.previews.overview.only-scratch;
            disable-scratch-in-overview = cfg.previews.overview.disable-scratch;

            # Gestures
            gesture-enabled = cfg.gestures.enable;
            gesture-horizontal-fingers = cfg.gestures.fingers.horizontal;
            gesture-workspace-fingers = cfg.gestures.fingers.workspace;
            swipe-sensitivity = cfg.gestures.swipe.sensitivity;
            swipe-friction = cfg.gestures.swipe.friction;
          };

          "org/gnome/shell/extensions/paperwm/keybindings" = {
            new-window = cfg.keybindings.new-window;
            live-alt-tab = cfg.keybindings.live-alt-tab;
            live-alt-tab-backward = cfg.keybindings.live-alt-tab-backward;
            previous-workspace = cfg.keybindings.previous-workspace;
            switch-monitor-right = cfg.keybindings.switch-monitor-right;
            switch-monitor-left = cfg.keybindings.switch-monitor-left;
            move-right = cfg.keybindings.move-right;
            move-left = cfg.keybindings.move-left;
            move-up = cfg.keybindings.move-up;
            move-down = cfg.keybindings.move-down;
            close-window = cfg.keybindings.close-window;
            toggle-maximize-width = cfg.keybindings.toggle-maximize-width;
            paper-toggle-fullscreen = cfg.keybindings.paper-toggle-fullscreen;
          };
        };
      }
    ];
  };
}
