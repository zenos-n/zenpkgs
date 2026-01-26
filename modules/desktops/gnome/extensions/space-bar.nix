{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.space-bar;

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
  options.zenos.desktops.gnome.extensions.space-bar = {
    enable = mkEnableOption "Space Bar GNOME extension configuration";

    # --- State ---
    version = mkInt 0 "Version state.";
    workspace-names-map = mkStr "{}" "Workspace names map (JSON string).";

    # --- Behavior ---
    indicator-style = mkStr "workspaces-bar" "Indicator style.";
    enable-custom-label = mkBool false "Enable custom label.";
    enable-custom-label-in-menu = mkBool false "Enable custom label in menu.";
    custom-label-named = mkStr "{{name}}" "Custom label for named workspaces.";
    custom-label-unnamed = mkStr "Workspace {{number}}" "Custom label for unnamed workspaces.";
    position = mkStr "left" "Position in top panel.";
    system-workspace-indicator = mkBool false "Use system workspace indicator.";
    position-index = mkInt 1 "Position index.";
    always-show-numbers = mkBool false "Always show numbers.";
    show-empty-workspaces = mkBool true "Show empty workspaces.";
    toggle-overview = mkBool true "Toggle overview.";
    scroll-wheel = mkStr "panel" "Switch workspaces with scroll wheel.";
    scroll-wheel-debounce = mkBool true "Debounce scroll wheel.";
    scroll-wheel-debounce-time = mkInt 200 "Scroll wheel debounce time.";
    scroll-wheel-vertical = mkStr "normal" "Vertical scroll wheel behavior.";
    scroll-wheel-horizontal = mkStr "disabled" "Horizontal scroll wheel behavior.";
    scroll-wheel-wrap-around = mkBool false "Scroll wheel wrap around.";
    smart-workspace-names = mkBool false "Smart workspace names.";
    reevaluate-smart-workspace-names = mkBool true "Reevaluate smart workspace names.";

    # --- Appearance (General) ---
    workspaces-bar-padding = mkInt 12 "Workspaces bar padding.";
    workspace-margin = mkInt 4 "Workspace margin.";

    # --- Appearance (Active Workspace) ---
    active-workspace-background-color = mkStr "rgba(255,255,255,0.3)" "Active workspace background color.";
    active-workspace-text-color = mkStr "rgba(255,255,255,1)" "Active workspace text color.";
    active-workspace-border-color = mkStr "rgba(0,0,0,0)" "Active workspace border color.";
    active-workspace-font-size = mkInt (-1) "Active workspace font size.";
    active-workspace-font-size-user = mkInt 11 "Active workspace font size (user override).";
    active-workspace-font-size-active = mkBool false "Enable active workspace font size override.";
    active-workspace-font-weight = mkStr "700" "Active workspace font weight.";
    active-workspace-border-radius = mkInt 4 "Active workspace border radius.";
    active-workspace-border-width = mkInt 0 "Active workspace border width.";
    active-workspace-padding-h = mkInt 8 "Active workspace horizontal padding.";
    active-workspace-padding-v = mkInt 3 "Active workspace vertical padding.";

    # --- Appearance (Inactive Workspace) ---
    inactive-workspace-background-color = mkStr "rgba(0,0,0,0)" "Inactive workspace background color.";
    inactive-workspace-text-color = mkStr "rgba(255,255,255,1)" "Inactive workspace text color.";
    inactive-workspace-border-color = mkStr "rgba(0,0,0,0)" "Inactive workspace border color.";
    inactive-workspace-text-color-active = mkBool false "Enable inactive workspace text color.";
    inactive-workspace-font-size = mkInt (-1) "Inactive workspace font size.";
    inactive-workspace-font-size-active = mkBool false "Enable inactive workspace font size.";
    inactive-workspace-font-weight = mkStr "700" "Inactive workspace font weight.";
    inactive-workspace-font-weight-active = mkBool false "Enable inactive workspace font weight.";
    inactive-workspace-border-radius = mkInt 4 "Inactive workspace border radius.";
    inactive-workspace-border-width = mkInt 0 "Inactive workspace border width.";
    inactive-workspace-border-width-active = mkBool false "Enable inactive workspace border width.";
    inactive-workspace-border-radius-active = mkBool false "Enable inactive workspace border radius.";
    inactive-workspace-padding-h = mkInt 8 "Inactive workspace horizontal padding.";
    inactive-workspace-padding-h-active = mkBool false "Enable inactive workspace horizontal padding.";
    inactive-workspace-padding-v = mkInt 3 "Inactive workspace vertical padding.";
    inactive-workspace-padding-v-active = mkBool false "Enable inactive workspace vertical padding.";

    # --- Appearance (Empty Workspace) ---
    empty-workspace-background-color = mkStr "rgba(0,0,0,0)" "Empty workspace background color.";
    empty-workspace-text-color = mkStr "rgba(255,255,255,0.5)" "Empty workspace text color.";
    empty-workspace-border-color = mkStr "rgba(0,0,0,0)" "Empty workspace border color.";
    empty-workspace-font-size = mkInt (-1) "Empty workspace font size.";
    empty-workspace-font-size-active = mkBool false "Enable empty workspace font size.";
    empty-workspace-font-weight = mkStr "700" "Empty workspace font weight.";
    empty-workspace-font-weight-active = mkBool false "Enable empty workspace font weight.";
    empty-workspace-border-radius = mkInt 4 "Empty workspace border radius.";
    empty-workspace-border-width = mkInt 0 "Empty workspace border width.";
    empty-workspace-border-width-active = mkBool false "Enable empty workspace border width.";
    empty-workspace-border-radius-active = mkBool false "Enable empty workspace border radius.";
    empty-workspace-padding-h = mkInt 8 "Empty workspace horizontal padding.";
    empty-workspace-padding-h-active = mkBool false "Enable empty workspace horizontal padding.";
    empty-workspace-padding-v = mkInt 3 "Empty workspace vertical padding.";
    empty-workspace-padding-v-active = mkBool false "Enable empty workspace vertical padding.";

    application-styles = mkStr "" "Application styles.";
    custom-styles-enabled = mkBool false "Enable custom styles.";
    custom-styles-failed = mkBool false "Custom styles failed.";
    custom-styles = mkStr "" "Custom styles CSS.";

    # --- Shortcuts ---
    enable-activate-workspace-shortcuts = mkBool true "Enable activate workspace shortcuts.";
    back-and-forth = mkBool false "Back and forth switching.";
    enable-move-to-workspace-shortcuts = mkBool false "Enable move to workspace shortcuts.";

    move-workspace-left = mkOptionStrList [ "<Control><Alt><Super>Left" ] "Move workspace left.";
    move-workspace-right = mkOptionStrList [ "<Control><Alt><Super>Right" ] "Move workspace right.";
    activate-previous-key = mkOptionStrList [ "<Super>grave" ] "Activate previous workspace.";
    activate-empty-key = mkOptionStrList [ "<Super>n" ] "Switch to empty workspace.";
    open-menu = mkOptionStrList [ "<Super>W" ] "Open workspaces bar menu.";

    activate-1-key = mkOptionStrList [ "<Super>1" ] "Activate workspace 1.";
    activate-2-key = mkOptionStrList [ "<Super>2" ] "Activate workspace 2.";
    activate-3-key = mkOptionStrList [ "<Super>3" ] "Activate workspace 3.";
    activate-4-key = mkOptionStrList [ "<Super>4" ] "Activate workspace 4.";
    activate-5-key = mkOptionStrList [ "<Super>5" ] "Activate workspace 5.";
    activate-6-key = mkOptionStrList [ "<Super>6" ] "Activate workspace 6.";
    activate-7-key = mkOptionStrList [ "<Super>7" ] "Activate workspace 7.";
    activate-8-key = mkOptionStrList [ "<Super>8" ] "Activate workspace 8.";
    activate-9-key = mkOptionStrList [ "<Super>9" ] "Activate workspace 9.";
    activate-10-key = mkOptionStrList [ "<Super>0" ] "Activate workspace 10.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.space-bar ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/space-bar/state" = {
            version = cfg.version;
            workspace-names-map = cfg.workspace-names-map;
          };

          "org/gnome/shell/extensions/space-bar/behavior" = {
            indicator-style = cfg.indicator-style;
            enable-custom-label = cfg.enable-custom-label;
            enable-custom-label-in-menu = cfg.enable-custom-label-in-menu;
            custom-label-named = cfg.custom-label-named;
            custom-label-unnamed = cfg.custom-label-unnamed;
            position = cfg.position;
            system-workspace-indicator = cfg.system-workspace-indicator;
            position-index = cfg.position-index;
            always-show-numbers = cfg.always-show-numbers;
            show-empty-workspaces = cfg.show-empty-workspaces;
            toggle-overview = cfg.toggle-overview;
            scroll-wheel = cfg.scroll-wheel;
            scroll-wheel-debounce = cfg.scroll-wheel-debounce;
            scroll-wheel-debounce-time = cfg.scroll-wheel-debounce-time;
            scroll-wheel-vertical = cfg.scroll-wheel-vertical;
            scroll-wheel-horizontal = cfg.scroll-wheel-horizontal;
            scroll-wheel-wrap-around = cfg.scroll-wheel-wrap-around;
            smart-workspace-names = cfg.smart-workspace-names;
            reevaluate-smart-workspace-names = cfg.reevaluate-smart-workspace-names;
          };

          "org/gnome/shell/extensions/space-bar/appearance" = {
            workspaces-bar-padding = cfg.workspaces-bar-padding;
            workspace-margin = cfg.workspace-margin;
            active-workspace-background-color = cfg.active-workspace-background-color;
            active-workspace-text-color = cfg.active-workspace-text-color;
            active-workspace-border-color = cfg.active-workspace-border-color;
            active-workspace-font-size = cfg.active-workspace-font-size;
            active-workspace-font-size-user = cfg.active-workspace-font-size-user;
            active-workspace-font-size-active = cfg.active-workspace-font-size-active;
            active-workspace-font-weight = cfg.active-workspace-font-weight;
            active-workspace-border-radius = cfg.active-workspace-border-radius;
            active-workspace-border-width = cfg.active-workspace-border-width;
            active-workspace-padding-h = cfg.active-workspace-padding-h;
            active-workspace-padding-v = cfg.active-workspace-padding-v;

            inactive-workspace-background-color = cfg.inactive-workspace-background-color;
            inactive-workspace-text-color = cfg.inactive-workspace-text-color;
            inactive-workspace-border-color = cfg.inactive-workspace-border-color;
            inactive-workspace-text-color-active = cfg.inactive-workspace-text-color-active;
            inactive-workspace-font-size = cfg.inactive-workspace-font-size;
            inactive-workspace-font-size-active = cfg.inactive-workspace-font-size-active;
            inactive-workspace-font-weight = cfg.inactive-workspace-font-weight;
            inactive-workspace-font-weight-active = cfg.inactive-workspace-font-weight-active;
            inactive-workspace-border-radius = cfg.inactive-workspace-border-radius;
            inactive-workspace-border-width = cfg.inactive-workspace-border-width;
            inactive-workspace-border-width-active = cfg.inactive-workspace-border-width-active;
            inactive-workspace-border-radius-active = cfg.inactive-workspace-border-radius-active;
            inactive-workspace-padding-h = cfg.inactive-workspace-padding-h;
            inactive-workspace-padding-h-active = cfg.inactive-workspace-padding-h-active;
            inactive-workspace-padding-v = cfg.inactive-workspace-padding-v;
            inactive-workspace-padding-v-active = cfg.inactive-workspace-padding-v-active;

            empty-workspace-background-color = cfg.empty-workspace-background-color;
            empty-workspace-text-color = cfg.empty-workspace-text-color;
            empty-workspace-border-color = cfg.empty-workspace-border-color;
            empty-workspace-font-size = cfg.empty-workspace-font-size;
            empty-workspace-font-size-active = cfg.empty-workspace-font-size-active;
            empty-workspace-font-weight = cfg.empty-workspace-font-weight;
            empty-workspace-font-weight-active = cfg.empty-workspace-font-weight-active;
            empty-workspace-border-radius = cfg.empty-workspace-border-radius;
            empty-workspace-border-width = cfg.empty-workspace-border-width;
            empty-workspace-border-width-active = cfg.empty-workspace-border-width-active;
            empty-workspace-border-radius-active = cfg.empty-workspace-border-radius-active;
            empty-workspace-padding-h = cfg.empty-workspace-padding-h;
            empty-workspace-padding-h-active = cfg.empty-workspace-padding-h-active;
            empty-workspace-padding-v = cfg.empty-workspace-padding-v;
            empty-workspace-padding-v-active = cfg.empty-workspace-padding-v-active;

            application-styles = cfg.application-styles;
            custom-styles-enabled = cfg.custom-styles-enabled;
            custom-styles-failed = cfg.custom-styles-failed;
            custom-styles = cfg.custom-styles;
          };

          "org/gnome/shell/extensions/space-bar/shortcuts" = {
            enable-activate-workspace-shortcuts = cfg.enable-activate-workspace-shortcuts;
            back-and-forth = cfg.back-and-forth;
            enable-move-to-workspace-shortcuts = cfg.enable-move-to-workspace-shortcuts;
            move-workspace-left = cfg.move-workspace-left;
            move-workspace-right = cfg.move-workspace-right;
            activate-previous-key = cfg.activate-previous-key;
            activate-empty-key = cfg.activate-empty-key;
            open-menu = cfg.open-menu;
            activate-1-key = cfg.activate-1-key;
            activate-2-key = cfg.activate-2-key;
            activate-3-key = cfg.activate-3-key;
            activate-4-key = cfg.activate-4-key;
            activate-5-key = cfg.activate-5-key;
            activate-6-key = cfg.activate-6-key;
            activate-7-key = cfg.activate-7-key;
            activate-8-key = cfg.activate-8-key;
            activate-9-key = cfg.activate-9-key;
            activate-10-key = cfg.activate-10-key;
          };
        };
      }
    ];
  };
}
