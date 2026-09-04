{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.paperwm;

  mkKeybindOption =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

  meta = {
    description = ''
      Scrollable tiling window manager for GNOME Shell

      This module installs and configures the **PaperWM** extension for GNOME.
      PaperWM implements a scrollable tiling window manager, inspired by 10/GUI concepts.
      It arranges windows in a horizontal ribbon, allowing for efficient navigation 
      and management.

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
in
{

  options.zenos.desktops.gnome.extensions.paperwm = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "PaperWM GNOME extension configuration";

    layout = {
      margins = {
        horizontal = mkOption {
          type = types.int;
          default = 20;
          description = ''
            Minimum horizontal window margin

            The base pixel distance between windows and the left/right screen edges.
          '';
        };
        vertical = mkOption {
          type = types.int;
          default = 20;
          description = ''
            Minimum vertical window margin

            The base pixel distance between windows and the top/bottom screen edges.
          '';
        };
      };

      window-gap = mkOption {
        type = types.int;
        default = 10;
        description = ''
          Pixel spacing between tiled windows

          Determines the distance between adjacent window actors in the 
          horizontal ribbon.
        '';
      };

      selection-border-size = mkOption {
        type = types.int;
        default = 4;
        description = ''
          Selection indicator border width

          Pixel thickness of the border drawn around the currently focused window.
        '';
      };

      show-minimap = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Display the navigation minimap

          Whether to render the miniature overview of the window ribbon 
          at the bottom of the screen.
        '';
      };
    };

    behavior = {
      focus-follows-mouse = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable focus-follows-mouse policy

          When enabled, window focus automatically shifts to the actor beneath 
          the mouse cursor.
        '';
      };

      cycle-on-edge = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Loop navigation at ribbon edges

          If enabled, navigating past the last window in a ribbon will loop back 
          to the first window.
        '';
      };

      use-default-overview = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Use standard GNOME overview

          Disables PaperWM's specialized overview and uses the default 
          GNOME Shell activities view instead.
        '';
      };
    };

    previews = {
      switcher-scale = mkOption {
        type = types.float;
        default = 0.5;
        description = ''
          Scale factor for window switcher thumbnails

          Determines the size of previews in the Alt-Tab and overview 
          interfaces relative to screen size.
        '';
      };
      overview = {
        only-scratch = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Only show scratchpad windows in overview

            Filters the overview to only display windows that have been 
            moved to the scratchpad area.
          '';
        };
        disable-scratch = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Hide scratchpad windows in overview

            Completely hides windows in the scratchpad area when entering 
            the activities overview.
          '';
        };
      };
    };

    gestures = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable touchpad gesture support

          Activates custom touchpad swipe gestures for navigating and 
          manipulating the window ribbon.
        '';
      };
      fingers = {
        horizontal = mkOption {
          type = types.int;
          default = 3;
          description = "Number of fingers for horizontal ribbon scrolling";
        };
        workspace = mkOption {
          type = types.int;
          default = 4;
          description = "Number of fingers for switching virtual workspaces";
        };
      };
      swipe = {
        sensitivity = mkOption {
          type = types.float;
          default = 1.0;
          description = "Responsiveness multiplier for touch input";
        };
        friction = mkOption {
          type = types.float;
          default = 1.0;
          description = "Resistance factor for swipe physics simulation";
        };
      };
    };

    keybindings = {
      new-window = mkKeybindOption [ "<Super>Return" ] "Shortcut to launch a new terminal window";
      live-alt-tab = mkKeybindOption [
        "<Super>Tab"
      ] "Shortcut to cycle through windows in the current ribbon";
      live-alt-tab-backward = mkKeybindOption [
        "<Shift><Super>Tab"
      ] "Shortcut to cycle backward through windows";
      previous-workspace = mkKeybindOption [
        "<Super>Escape"
      ] "Shortcut to return to the last used workspace";
      switch-monitor-right = mkKeybindOption [
        "<Super>u"
      ] "Shortcut to move focus to the monitor on the right";
      switch-monitor-left = mkKeybindOption [
        "<Super>i"
      ] "Shortcut to move focus to the monitor on the left";
      move-right = mkKeybindOption [ "<Shift><Super>l" ] "Shortcut to move focused window to the right";
      move-left = mkKeybindOption [ "<Shift><Super>h" ] "Shortcut to move focused window to the left";
      move-up = mkKeybindOption [ "<Shift><Super>k" ] "Shortcut to move focused window upward (stacking)";
      move-down = mkKeybindOption [
        "<Shift><Super>j"
      ] "Shortcut to move focused window downward (stacking)";
      close-window = mkKeybindOption [ "<Super>q" ] "Shortcut to close the active application window";
      toggle-maximize-width = mkKeybindOption [
        "<Super>f"
      ] "Shortcut to toggle window between current width and full ribbon width";
      paper-toggle-fullscreen = mkKeybindOption [
        "<Shift><Super>f"
      ] "Shortcut to toggle window between ribbon and full screen";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.paperwm ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/paperwm" = {
            window-gap = cfg.layout.window-gap;
            horizontal-margin = cfg.layout.margins.horizontal;
            vertical-margin = cfg.layout.margins.vertical;
            selection-border-size = cfg.layout.selection-border-size;
            show-minimap = cfg.layout.show-minimap;
            focus-follows-mouse = cfg.behavior.focus-follows-mouse;
            cycle-on-edge = cfg.behavior.cycle-on-edge;
            use-default-overview = cfg.behavior.use-default-overview;
            window-switcher-preview-scale = cfg.previews.switcher-scale;
            only-scratch-in-overview = cfg.previews.overview.only-scratch;
            disable-scratch-in-overview = cfg.previews.overview.disable-scratch;
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
