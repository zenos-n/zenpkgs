{
  pkgs,
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.paperwm;

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

  mkOptionFloatList =
    default: description:
    mkOption {
      type = types.listOf types.float;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.paperwm = {
    enable = mkEnableOption "PaperWM GNOME extension configuration";

    # --- Main Settings ---
    horizontal-margin = mkInt 20 "Minimum margin from windows left and right edge.";
    vertical-margin = mkInt 20 "Minimum margin from windows top edge.";
    vertical-margin-bottom = mkInt 20 "Minimum margin from windows bottom edge.";
    window-gap = mkInt 20 "Minimum gap between windows.";
    selection-border-size = mkInt 10 "Selected window border size (px).";
    selection-border-radius-top = mkInt 12 "Selected window border top radius (px).";
    selection-border-radius-bottom = mkInt 0 "Selected window border bottom radius (px).";
    minimap-scale = mkDouble 0.15 "Scale of minimap tiles.";
    minimap-shade-opacity = mkInt 160 "Opacity of non-selected windows in minimap.";

    edge-preview-enable = mkBool true "Enable tiling edge window previews.";
    edge-preview-scale = mkDouble 0.15 "Scale of edge previews.";
    edge-preview-click-enable = mkBool true "Activate edge preview with click.";
    edge-preview-timeout-enable = mkBool false "Activate edge preview with timeout.";
    edge-preview-timeout = mkInt 800 "Timeout (ms) for edge preview.";
    edge-preview-timeout-continual = mkBool false "Continual activation at edge.";
    window-switcher-preview-scale = mkDouble 0.15 "Scale of window switch previews.";

    only-scratch-in-overview = mkBool false "Limit overview to scratch windows.";
    disable-scratch-in-overview = mkBool false "Don't show scratch windows in overview.";

    swipe-sensitivity = mkOptionFloatList [ 2.0 2.0 ] "Swipe sensitivity [x, y].";
    swipe-friction = mkOptionFloatList [ 0.3 0.1 ] "Swipe friction [x, y].";
    cycle-width-steps = mkOptionFloatList [ 0.38195 0.5 0.61804 ] "Cycle width steps.";
    cycle-height-steps = mkOptionFloatList [ 0.38195 0.5 0.61804 ] "Cycle height steps.";

    maximize-width-percent = mkDouble 1.00 "Percent width for horizontal maximize.";
    maximize-within-tiling = mkBool true "Maximize within tiling margins.";

    workspace-colors = mkOptionStrList [ "#314E6C" "#565248" "#445632" ] "Workspace colors.";
    use-default-background = mkBool true "Use default GNOME background.";
    default-show-top-bar = mkBool true "Show top bar on workspaces by default.";

    open-window-position = mkInt 0 "New window position (0:Right, 1:Left, 2:Start, 3:End).";
    disable-topbar-styling = mkBool false "Disable PaperWM topbar styling.";
    show-workspace-indicator = mkBool true "Show workspace indicator in topbar.";
    show-window-position-bar = mkBool true "Show window position bar in topbar.";
    show-focus-mode-icon = mkBool true "Show focus mode icon in topbar.";
    show-open-position-icon = mkBool true "Show open position icon in topbar.";
    topbar-mouse-scroll-enable = mkBool true "Enable scroll on topbar to switch windows.";

    animation-time = mkDouble 0.25 "Animation duration (s).";
    drift-speed = mkInt 2 "Drift speed (px/ms).";

    gesture-enabled = mkBool true "Enable touchpad gestures.";
    gesture-horizontal-fingers = mkInt 3 "Fingers for horizontal swipe.";
    gesture-workspace-fingers = mkInt 3 "Fingers for workspace switching.";

    winprops = mkOptionStrList [ ] "Array of winprops JSON objects.";

    # --- Keybindings Submodule ---
    keybindings = {
      new-window = mkOptionStrList [ "<Super>Return" "<Super>n" ] "Open new window.";
      live-alt-tab = mkOptionStrList [ "<Super>Tab" "<Alt>Tab" ] "Switch to prev active window.";
      live-alt-tab-backward = mkOptionStrList [
        "<Super><Shift>Tab"
        "<Alt><Shift>Tab"
      ] "Switch to prev active window (backward).";
      previous-workspace = mkOptionStrList [ "<Super>Above_Tab" ] "Switch to prev workspace.";
      switch-monitor-right = mkOptionStrList [ "<Super><Shift>Right" ] "Switch to right monitor.";
      switch-monitor-left = mkOptionStrList [ "<Super><Shift>Left" ] "Switch to left monitor.";
      move-right = mkOptionStrList [
        "<Super><Ctrl>period"
        "<Super><Shift>period"
        "<Super><Ctrl>Right"
      ] "Move window right.";
      move-left = mkOptionStrList [
        "<Super><Ctrl>comma"
        "<Super><Shift>comma"
        "<Super><Ctrl>Left"
      ] "Move window left.";
      move-up = mkOptionStrList [ "<Super><Ctrl>Up" ] "Move window up.";
      move-down = mkOptionStrList [ "<Super><Ctrl>Down" ] "Move window down.";
      close-window = mkOptionStrList [ "<Super>BackSpace" ] "Close active window.";
      toggle-maximize-width = mkOptionStrList [ "<Super>f" ] "Maximize width.";
      paper-toggle-fullscreen = mkOptionStrList [ "<Super><shift>f" ] "Toggle fullscreen.";
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.paperwm ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/paperwm" = {
            horizontal-margin = cfg.horizontal-margin;
            vertical-margin = cfg.vertical-margin;
            vertical-margin-bottom = cfg.vertical-margin-bottom;
            window-gap = cfg.window-gap;
            selection-border-size = cfg.selection-border-size;
            selection-border-radius-top = cfg.selection-border-radius-top;
            selection-border-radius-bottom = cfg.selection-border-radius-bottom;
            minimap-scale = cfg.minimap-scale;
            minimap-shade-opacity = cfg.minimap-shade-opacity;
            edge-preview-enable = cfg.edge-preview-enable;
            edge-preview-scale = cfg.edge-preview-scale;
            edge-preview-click-enable = cfg.edge-preview-click-enable;
            edge-preview-timeout-enable = cfg.edge-preview-timeout-enable;
            edge-preview-timeout = cfg.edge-preview-timeout;
            edge-preview-timeout-continual = cfg.edge-preview-timeout-continual;
            window-switcher-preview-scale = cfg.window-switcher-preview-scale;
            only-scratch-in-overview = cfg.only-scratch-in-overview;
            disable-scratch-in-overview = cfg.disable-scratch-in-overview;
            swipe-sensitivity = cfg.swipe-sensitivity;
            swipe-friction = cfg.swipe-friction;
            cycle-width-steps = cfg.cycle-width-steps;
            cycle-height-steps = cfg.cycle-height-steps;
            maximize-width-percent = cfg.maximize-width-percent;
            maximize-within-tiling = cfg.maximize-within-tiling;
            workspace-colors = cfg.workspace-colors;
            use-default-background = cfg.use-default-background;
            default-show-top-bar = cfg.default-show-top-bar;
            open-window-position = cfg.open-window-position;
            disable-topbar-styling = cfg.disable-topbar-styling;
            show-workspace-indicator = cfg.show-workspace-indicator;
            show-window-position-bar = cfg.show-window-position-bar;
            show-focus-mode-icon = cfg.show-focus-mode-icon;
            show-open-position-icon = cfg.show-open-position-icon;
            topbar-mouse-scroll-enable = cfg.topbar-mouse-scroll-enable;
            animation-time = cfg.animation-time;
            drift-speed = cfg.drift-speed;
            gesture-enabled = cfg.gesture-enabled;
            gesture-horizontal-fingers = cfg.gesture-horizontal-fingers;
            gesture-workspace-fingers = cfg.gesture-workspace-fingers;
            winprops = cfg.winprops;
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
