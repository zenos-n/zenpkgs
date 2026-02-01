{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.space-bar;

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
    description = "Configures the Space Bar GNOME extension";
    longDescription = ''
      This module installs and configures the **Space Bar** extension for GNOME.
      It replaces the Activities button with a highly configurable workspace indicator
      reminiscent of i3/sway status bars.

      **Features:**
      - i3-like workspace indicator.
      - Extensive customization for active, inactive, and empty workspaces.
      - Custom labels and scroll wheel navigation.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.space-bar = {
    enable = mkEnableOption "Space Bar GNOME extension configuration";

    # --- State ---
    state = {
      version = mkOption {
        type = types.int;
        default = 0;
        description = "Version state";
      };
      workspace-names-map = mkOption {
        type = types.str;
        default = "{}";
        description = "Workspace names map (JSON string)";
      };
    };

    # --- Behavior ---
    behavior = {
      indicator-style = mkOption {
        type = types.enum [
          "workspaces-bar"
          "status-icon"
        ];
        default = "workspaces-bar";
        description = "Indicator style";
      };

      position = mkOption {
        type = types.enum [
          "left"
          "center"
          "right"
        ];
        default = "left";
        description = "Position in top panel";
      };

      position-index = mkOption {
        type = types.int;
        default = 1;
        description = "Position index";
      };

      system-workspace-indicator = mkOption {
        type = types.bool;
        default = false;
        description = "Use system workspace indicator";
      };

      always-show-numbers = mkOption {
        type = types.bool;
        default = false;
        description = "Always show numbers";
      };

      show-empty-workspaces = mkOption {
        type = types.bool;
        default = true;
        description = "Show empty workspaces";
      };

      toggle-overview = mkOption {
        type = types.bool;
        default = true;
        description = "Toggle overview on click";
      };

      smart-workspace-names = mkOption {
        type = types.bool;
        default = false;
        description = "Enable smart workspace names";
      };

      reevaluate-smart-workspace-names = mkOption {
        type = types.bool;
        default = true;
        description = "Reevaluate smart workspace names";
      };

      labels = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable custom labels";
        };
        enable-in-menu = mkOption {
          type = types.bool;
          default = false;
          description = "Enable custom labels in menu";
        };
        named = mkOption {
          type = types.str;
          default = "{{name}}";
          description = "Custom label format for named workspaces";
        };
        unnamed = mkOption {
          type = types.str;
          default = "Workspace {{number}}";
          description = "Custom label format for unnamed workspaces";
        };
      };

      scroll-wheel = {
        action = mkOption {
          type = types.enum [
            "panel"
            "disabled"
          ];
          default = "panel";
          description = "Switch workspaces with scroll wheel";
        };
        debounce = mkOption {
          type = types.bool;
          default = true;
          description = "Debounce scroll wheel";
        };
        debounce-time = mkOption {
          type = types.int;
          default = 200;
          description = "Scroll wheel debounce time (ms)";
        };
        vertical = mkOption {
          type = types.str;
          default = "normal";
          description = "Vertical scroll wheel behavior";
        };
        horizontal = mkOption {
          type = types.str;
          default = "disabled";
          description = "Horizontal scroll wheel behavior";
        };
        wrap-around = mkOption {
          type = types.bool;
          default = false;
          description = "Scroll wheel wrap around";
        };
      };
    };

    # --- Appearance ---
    appearance = {
      bar-padding = mkOption {
        type = types.int;
        default = 12;
        description = "Workspaces bar padding";
      };

      workspace-margin = mkOption {
        type = types.int;
        default = 4;
        description = "Workspace margin";
      };

      # Grouped Active/Inactive/Empty settings for cleaner config
      workspaces = {
        active = {
          background-color = mkOption {
            type = types.str;
            default = "rgba(255,255,255,0.3)";
            description = "Background color";
          };
          text-color = mkOption {
            type = types.str;
            default = "rgba(255,255,255,1)";
            description = "Text color";
          };
          border-color = mkOption {
            type = types.str;
            default = "rgba(0,0,0,0)";
            description = "Border color";
          };
          border-width = mkOption {
            type = types.int;
            default = 0;
            description = "Border width";
          };
          border-radius = mkOption {
            type = types.int;
            default = 4;
            description = "Border radius";
          };
          font-weight = mkOption {
            type = types.str;
            default = "700";
            description = "Font weight";
          };
          font-size = mkOption {
            type = types.int;
            default = -1;
            description = "Font size";
          };
          font-size-user = mkOption {
            type = types.int;
            default = 11;
            description = "User font size override";
          };
          font-size-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable font size override";
          };
          padding-h = mkOption {
            type = types.int;
            default = 8;
            description = "Horizontal padding";
          };
          padding-v = mkOption {
            type = types.int;
            default = 3;
            description = "Vertical padding";
          };
        };

        inactive = {
          background-color = mkOption {
            type = types.str;
            default = "rgba(0,0,0,0)";
            description = "Background color";
          };
          text-color = mkOption {
            type = types.str;
            default = "rgba(255,255,255,1)";
            description = "Text color";
          };
          text-color-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom text color";
          };
          border-color = mkOption {
            type = types.str;
            default = "rgba(0,0,0,0)";
            description = "Border color";
          };
          border-width = mkOption {
            type = types.int;
            default = 0;
            description = "Border width";
          };
          border-width-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom border width";
          };
          border-radius = mkOption {
            type = types.int;
            default = 4;
            description = "Border radius";
          };
          border-radius-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom border radius";
          };
          font-weight = mkOption {
            type = types.str;
            default = "700";
            description = "Font weight";
          };
          font-weight-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom font weight";
          };
          font-size = mkOption {
            type = types.int;
            default = -1;
            description = "Font size";
          };
          font-size-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom font size";
          };
          padding-h = mkOption {
            type = types.int;
            default = 8;
            description = "Horizontal padding";
          };
          padding-h-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom horizontal padding";
          };
          padding-v = mkOption {
            type = types.int;
            default = 3;
            description = "Vertical padding";
          };
          padding-v-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom vertical padding";
          };
        };

        empty = {
          background-color = mkOption {
            type = types.str;
            default = "rgba(0,0,0,0)";
            description = "Background color";
          };
          text-color = mkOption {
            type = types.str;
            default = "rgba(255,255,255,0.5)";
            description = "Text color";
          };
          border-color = mkOption {
            type = types.str;
            default = "rgba(0,0,0,0)";
            description = "Border color";
          };
          border-width = mkOption {
            type = types.int;
            default = 0;
            description = "Border width";
          };
          border-width-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom border width";
          };
          border-radius = mkOption {
            type = types.int;
            default = 4;
            description = "Border radius";
          };
          border-radius-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom border radius";
          };
          font-weight = mkOption {
            type = types.str;
            default = "700";
            description = "Font weight";
          };
          font-weight-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom font weight";
          };
          font-size = mkOption {
            type = types.int;
            default = -1;
            description = "Font size";
          };
          font-size-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom font size";
          };
          padding-h = mkOption {
            type = types.int;
            default = 8;
            description = "Horizontal padding";
          };
          padding-h-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom horizontal padding";
          };
          padding-v = mkOption {
            type = types.int;
            default = 3;
            description = "Vertical padding";
          };
          padding-v-active = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom vertical padding";
          };
        };
      };

      styles = {
        application = mkOption {
          type = types.str;
          default = "";
          description = "Application styles";
        };
        custom = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Enable custom styles";
          };
          failed = mkOption {
            type = types.bool;
            default = false;
            description = "Custom styles failed status";
          };
          css = mkOption {
            type = types.str;
            default = "";
            description = "Custom styles CSS";
          };
        };
      };
    };

    # --- Shortcuts ---
    shortcuts = {
      enable-activate = mkOption {
        type = types.bool;
        default = true;
        description = "Enable activate workspace shortcuts";
      };
      enable-move-to = mkOption {
        type = types.bool;
        default = false;
        description = "Enable move to workspace shortcuts";
      };
      back-and-forth = mkOption {
        type = types.bool;
        default = false;
        description = "Enable back and forth switching";
      };

      open-menu = mkKeybindOption [ "<Super>W" ] "Open workspaces bar menu";
      activate-previous = mkKeybindOption [ "<Super>grave" ] "Activate previous workspace";
      activate-empty = mkKeybindOption [ "<Super>n" ] "Switch to empty workspace";
      move-left = mkKeybindOption [ "<Control><Alt><Super>Left" ] "Move workspace left";
      move-right = mkKeybindOption [ "<Control><Alt><Super>Right" ] "Move workspace right";

      # Explicitly defining workspaces 1-10 to match extension behavior
      activate-1 = mkKeybindOption [ "<Super>1" ] "Activate workspace 1";
      activate-2 = mkKeybindOption [ "<Super>2" ] "Activate workspace 2";
      activate-3 = mkKeybindOption [ "<Super>3" ] "Activate workspace 3";
      activate-4 = mkKeybindOption [ "<Super>4" ] "Activate workspace 4";
      activate-5 = mkKeybindOption [ "<Super>5" ] "Activate workspace 5";
      activate-6 = mkKeybindOption [ "<Super>6" ] "Activate workspace 6";
      activate-7 = mkKeybindOption [ "<Super>7" ] "Activate workspace 7";
      activate-8 = mkKeybindOption [ "<Super>8" ] "Activate workspace 8";
      activate-9 = mkKeybindOption [ "<Super>9" ] "Activate workspace 9";
      activate-10 = mkKeybindOption [ "<Super>0" ] "Activate workspace 10";
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.space-bar ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/space-bar/state" = {
            version = cfg.state.version;
            workspace-names-map = cfg.state.workspace-names-map;
          };

          "org/gnome/shell/extensions/space-bar/behavior" = {
            indicator-style = cfg.behavior.indicator-style;
            enable-custom-label = cfg.behavior.labels.enable;
            enable-custom-label-in-menu = cfg.behavior.labels.enable-in-menu;
            custom-label-named = cfg.behavior.labels.named;
            custom-label-unnamed = cfg.behavior.labels.unnamed;
            position = cfg.behavior.position;
            system-workspace-indicator = cfg.behavior.system-workspace-indicator;
            position-index = cfg.behavior.position-index;
            always-show-numbers = cfg.behavior.always-show-numbers;
            show-empty-workspaces = cfg.behavior.show-empty-workspaces;
            toggle-overview = cfg.behavior.toggle-overview;
            scroll-wheel = cfg.behavior.scroll-wheel.action;
            scroll-wheel-debounce = cfg.behavior.scroll-wheel.debounce;
            scroll-wheel-debounce-time = cfg.behavior.scroll-wheel.debounce-time;
            scroll-wheel-vertical = cfg.behavior.scroll-wheel.vertical;
            scroll-wheel-horizontal = cfg.behavior.scroll-wheel.horizontal;
            scroll-wheel-wrap-around = cfg.behavior.scroll-wheel.wrap-around;
            smart-workspace-names = cfg.behavior.smart-workspace-names;
            reevaluate-smart-workspace-names = cfg.behavior.reevaluate-smart-workspace-names;
          };

          "org/gnome/shell/extensions/space-bar/appearance" = {
            workspaces-bar-padding = cfg.appearance.bar-padding;
            workspace-margin = cfg.appearance.workspace-margin;

            # Active
            active-workspace-background-color = cfg.appearance.workspaces.active.background-color;
            active-workspace-text-color = cfg.appearance.workspaces.active.text-color;
            active-workspace-border-color = cfg.appearance.workspaces.active.border-color;
            active-workspace-font-size = cfg.appearance.workspaces.active.font-size;
            active-workspace-font-size-user = cfg.appearance.workspaces.active.font-size-user;
            active-workspace-font-size-active = cfg.appearance.workspaces.active.font-size-active;
            active-workspace-font-weight = cfg.appearance.workspaces.active.font-weight;
            active-workspace-border-radius = cfg.appearance.workspaces.active.border-radius;
            active-workspace-border-width = cfg.appearance.workspaces.active.border-width;
            active-workspace-padding-h = cfg.appearance.workspaces.active.padding-h;
            active-workspace-padding-v = cfg.appearance.workspaces.active.padding-v;

            # Inactive
            inactive-workspace-background-color = cfg.appearance.workspaces.inactive.background-color;
            inactive-workspace-text-color = cfg.appearance.workspaces.inactive.text-color;
            inactive-workspace-border-color = cfg.appearance.workspaces.inactive.border-color;
            inactive-workspace-text-color-active = cfg.appearance.workspaces.inactive.text-color-active;
            inactive-workspace-font-size = cfg.appearance.workspaces.inactive.font-size;
            inactive-workspace-font-size-active = cfg.appearance.workspaces.inactive.font-size-active;
            inactive-workspace-font-weight = cfg.appearance.workspaces.inactive.font-weight;
            inactive-workspace-font-weight-active = cfg.appearance.workspaces.inactive.font-weight-active;
            inactive-workspace-border-radius = cfg.appearance.workspaces.inactive.border-radius;
            inactive-workspace-border-width = cfg.appearance.workspaces.inactive.border-width;
            inactive-workspace-border-width-active = cfg.appearance.workspaces.inactive.border-width-active;
            inactive-workspace-border-radius-active = cfg.appearance.workspaces.inactive.border-radius-active;
            inactive-workspace-padding-h = cfg.appearance.workspaces.inactive.padding-h;
            inactive-workspace-padding-h-active = cfg.appearance.workspaces.inactive.padding-h-active;
            inactive-workspace-padding-v = cfg.appearance.workspaces.inactive.padding-v;
            inactive-workspace-padding-v-active = cfg.appearance.workspaces.inactive.padding-v-active;

            # Empty
            empty-workspace-background-color = cfg.appearance.workspaces.empty.background-color;
            empty-workspace-text-color = cfg.appearance.workspaces.empty.text-color;
            empty-workspace-border-color = cfg.appearance.workspaces.empty.border-color;
            empty-workspace-font-size = cfg.appearance.workspaces.empty.font-size;
            empty-workspace-font-size-active = cfg.appearance.workspaces.empty.font-size-active;
            empty-workspace-font-weight = cfg.appearance.workspaces.empty.font-weight;
            empty-workspace-font-weight-active = cfg.appearance.workspaces.empty.font-weight-active;
            empty-workspace-border-radius = cfg.appearance.workspaces.empty.border-radius;
            empty-workspace-border-width = cfg.appearance.workspaces.empty.border-width;
            empty-workspace-border-width-active = cfg.appearance.workspaces.empty.border-width-active;
            empty-workspace-border-radius-active = cfg.appearance.workspaces.empty.border-radius-active;
            empty-workspace-padding-h = cfg.appearance.workspaces.empty.padding-h;
            empty-workspace-padding-h-active = cfg.appearance.workspaces.empty.padding-h-active;
            empty-workspace-padding-v = cfg.appearance.workspaces.empty.padding-v;
            empty-workspace-padding-v-active = cfg.appearance.workspaces.empty.padding-v-active;

            application-styles = cfg.appearance.styles.application;
            custom-styles-enabled = cfg.appearance.styles.custom.enable;
            custom-styles-failed = cfg.appearance.styles.custom.failed;
            custom-styles = cfg.appearance.styles.custom.css;
          };

          "org/gnome/shell/extensions/space-bar/shortcuts" = {
            enable-activate-workspace-shortcuts = cfg.shortcuts.enable-activate;
            back-and-forth = cfg.shortcuts.back-and-forth;
            enable-move-to-workspace-shortcuts = cfg.shortcuts.enable-move-to;
            move-workspace-left = cfg.shortcuts.move-left;
            move-workspace-right = cfg.shortcuts.move-right;
            activate-previous-key = cfg.shortcuts.activate-previous;
            activate-empty-key = cfg.shortcuts.activate-empty;
            open-menu = cfg.shortcuts.open-menu;
            activate-1-key = cfg.shortcuts.activate-1;
            activate-2-key = cfg.shortcuts.activate-2;
            activate-3-key = cfg.shortcuts.activate-3;
            activate-4-key = cfg.shortcuts.activate-4;
            activate-5-key = cfg.shortcuts.activate-5;
            activate-6-key = cfg.shortcuts.activate-6;
            activate-7-key = cfg.shortcuts.activate-7;
            activate-8-key = cfg.shortcuts.activate-8;
            activate-9-key = cfg.shortcuts.activate-9;
            activate-10-key = cfg.shortcuts.activate-10;
          };
        };
      }
    ];
  };
}
