{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.space-bar;

  mkKeybindOption =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

  meta = {
    description = ''
      An i3-style workspace bar for GNOME Shell

      This module installs and configures the **Space Bar** extension for GNOME.
      It replaces the Activities button with a highly configurable workspace 
      indicator reminiscent of i3/sway status bars.

      **Features:**
      - i3-like workspace indicator.
      - Extensive customization for active, inactive, and empty workspaces.
      - Custom labels and scroll wheel navigation.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.space-bar = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Space Bar GNOME extension configuration";

    state = {
      version = mkOption {
        type = types.int;
        default = 0;
        description = "Internal version tracker for settings migrations";
      };
      workspace-names-map = mkOption {
        type = types.str;
        default = "{}";
        description = ''
          Custom workspace name dictionary

          JSON string mapping workspace indices to human-readable labels 
          (e.g., '{"1": "Web", "2": "Dev"}').
        '';
      };
    };

    behavior = {
      smart-workspace-names = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Automatic workspace naming

          Whether the extension should attempt to name workspaces based 
          on the focused application.
        '';
      };

      always-show-numbers = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Force numerical labels

          Whether to always display the workspace index number even if a 
          custom name is assigned.
        '';
      };

      scroll-wheel = mkOption {
        type = types.enum [
          "disabled"
          "panel"
          "bar"
        ];
        default = "panel";
        description = ''
          Workspace scrolling behavior

          Determines where mouse scrolling triggers a workspace switch 
          (e.g., anywhere on the panel or only on the workspace bar).
        '';
      };
    };

    appearance = {
      position = mkOption {
        type = types.enum [
          "left"
          "center"
          "right"
        ];
        default = "left";
        description = "Horizontal placement of the workspace bar in the GNOME panel";
      };

      styles = {
        application = mkOption {
          type = types.enum [
            "none"
            "icon"
            "name"
            "both"
          ];
          default = "none";
          description = "Visual representation of open apps within the workspace tags";
        };
        custom = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Activate CSS style overrides";
          };
          css = mkOption {
            type = types.lines;
            default = "";
            description = "Custom CSS injected into the workspace bar UI";
          };
          failed = mkOption {
            type = types.bool;
            default = false;
            description = "Internal flag indicating CSS parsing errors";
          };
        };
      };
    };

    shortcuts = {
      enable-activate = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Super+Num shortcuts to switch workspaces";
      };
      enable-move-to = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Shift+Super+Num shortcuts to move windows";
      };
      back-and-forth = mkOption {
        type = types.bool;
        default = false;
        description = "Toggle to previous workspace if current index is requested";
      };
      move-left = mkKeybindOption [ "<Super><Alt>Left" ] "Shortcut to shift workspace focus leftward";
      move-right = mkKeybindOption [ "<Super><Alt>Right" ] "Shortcut to shift workspace focus rightward";
      activate-previous = mkKeybindOption [
        "<Super>Escape"
      ] "Shortcut to return to the last active workspace";
      activate-empty = mkKeybindOption [ ] "Shortcut to switch focus to the first empty workspace";
      open-menu = mkKeybindOption [ ] "Shortcut to reveal the Space Bar settings menu";
      activate-1 = mkKeybindOption [ "<Super>1" ] "Shortcut to focus workspace 1";
      activate-2 = mkKeybindOption [ "<Super>2" ] "Shortcut to focus workspace 2";
      activate-3 = mkKeybindOption [ "<Super>3" ] "Shortcut to focus workspace 3";
      activate-4 = mkKeybindOption [ "<Super>4" ] "Shortcut to focus workspace 4";
      activate-5 = mkKeybindOption [ "<Super>5" ] "Shortcut to focus workspace 5";
      activate-6 = mkKeybindOption [ "<Super>6" ] "Shortcut to focus workspace 6";
      activate-7 = mkKeybindOption [ "<Super>7" ] "Shortcut to focus workspace 7";
      activate-8 = mkKeybindOption [ "<Super>8" ] "Shortcut to focus workspace 8";
      activate-9 = mkKeybindOption [ "<Super>9" ] "Shortcut to focus workspace 9";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.space-bar ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/space-bar/state" = {
            inherit (cfg.state) version workspace-names-map;
          };

          "org/gnome/shell/extensions/space-bar/behavior" = {
            smart-workspace-names = cfg.behavior.smart-workspace-names;
            always-show-numbers = cfg.behavior.always-show-numbers;
            scroll-wheel = cfg.behavior.scroll-wheel;
          };

          "org/gnome/shell/extensions/space-bar/appearance" = {
            position = cfg.appearance.position;
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
          };
        };
      }
    ];
  };
}
