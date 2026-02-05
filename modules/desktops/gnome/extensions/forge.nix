{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.forge;

  formatPart =
    part:
    let
      lower = toLower part;
    in
    if lower == "super" then
      "<Super>"
    else if lower == "ctrl" || lower == "control" then
      "<Ctrl>"
    else if lower == "alt" then
      "<Alt>"
    else if lower == "shift" then
      "<Shift>"
    else
      part;

  serializeKeybind = list: [ (concatMapStrings formatPart list) ];

  mkKeybindOption =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = ''
        ${description}

        Define as a list of keys, e.g., [ "super" "q" ]. 
        Supported modifiers: super, ctrl, alt, shift.
      '';
    };

  hexToDecMap = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
    "A" = 10;
    "B" = 11;
    "C" = 12;
    "D" = 13;
    "E" = 14;
    "F" = 15;
  };

  hexCharToInt = c: if builtins.hasAttr c hexToDecMap then hexToDecMap.${c} else 0;
  parseHexByte =
    s: (hexCharToInt (builtins.substring 0 1 s) * 16) + (hexCharToInt (builtins.substring 1 1 s));
  serializeFloat =
    f:
    let
      s = toString f;
    in
    if builtins.match ".*\\..*" s != null then s else "${s}.0";

  toRgbaString =
    val:
    if builtins.isString val && (builtins.substring 0 1 val == "#") then
      let
        hex = lib.removePrefix "#" val;
        r = toString (parseHexByte (substring 0 2 hex));
        g = toString (parseHexByte (substring 2 2 hex));
        b = toString (parseHexByte (substring 4 2 hex));
        a =
          if (builtins.stringLength hex) == 8 then
            serializeFloat ((parseHexByte (substring 6 2 hex)) / 255.0)
          else
            "1.0";
      in
      "rgba(${r}, ${g}, ${b}, ${a})"
    else
      val;

  meta = {
    description = ''
      Tiling window management for GNOME Shell

      This module installs and configures the **Forge** extension for GNOME.
      Forge transforms the GNOME Shell into a tiling window manager, offering automatic
      tiling, window gaps, and extensive keyboard shortcuts.

      **Features:**
      - Automatic tiling and stacking.
      - Customizable window gaps and borders.
      - Extensive keyboard shortcuts for moving, resizing, and focusing windows.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.forge = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Forge GNOME extension configuration";

    appearance = {
      borders = {
        focus = {
          toggle = mkOption {
            type = types.bool;
            default = true;
            description = "Display border on focused window";
          };
          size = mkOption {
            type = types.int;
            default = 3;
            description = "Focused window border pixel thickness";
          };
          color = mkOption {
            type = types.str;
            default = "rgba(236, 94, 94, 1)";
            description = "CSS color for focused border";
          };
        };
        split = {
          toggle = mkOption {
            type = types.bool;
            default = true;
            description = "Display split direction indicator";
          };
          color = mkOption {
            type = types.str;
            default = "rgba(255, 246, 108, 1)";
            description = "CSS color for split indicator";
          };
        };
      };
      gaps = {
        size = mkOption {
          type = types.int;
          default = 4;
          description = "Base gap size between tiled windows";
        };
        increment = mkOption {
          type = types.int;
          default = 1;
          description = "Multiplier for gap size adjustments";
        };
        hide-on-single = mkOption {
          type = types.bool;
          default = false;
          description = "Suppress gaps for single windows";
        };
      };
      decorations = {
        tabs = mkOption {
          type = types.bool;
          default = true;
          description = "Display tab decorations for stacked windows";
        };
        preview-hint = mkOption {
          type = types.bool;
          default = true;
          description = "Display preview area during drag-and-drop";
        };
      };
    };

    tiling = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Global tiling mode master switch";
      };
      primary-mode = mkOption {
        type = types.enum [
          "tiling"
          "stacking"
        ];
        default = "tiling";
        description = "Default layout strategy for new windows";
      };
      stacked = mkOption {
        type = types.bool;
        default = true;
        description = "Enable stacked layout capabilities";
      };
      tabbed = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable tabbed layout capabilities";
        };
        auto-exit = mkOption {
          type = types.bool;
          default = true;
          description = "Automatically exit tabbed mode for single windows";
        };
      };
      auto-split = mkOption {
        type = types.bool;
        default = true;
        description = "Automatically select split axis based on window dimensions";
      };
      workspace-skip = mkOption {
        type = types.str;
        default = "";
        description = "Indices of workspaces to exclude from tiling";
      };
    };

    interaction = {
      mouse = {
        move-pointer-focus = mkOption {
          type = types.bool;
          default = false;
          description = "Sync pointer location with keyboard focus changes";
        };
        focus-on-hover = mkOption {
          type = types.bool;
          default = false;
          description = "Follow-mouse focus policy";
        };
      };
      dnd-center-layout = mkOption {
        type = types.enum [
          "tabbed"
          "stacked"
        ];
        default = "tabbed";
        description = "Layout used for drops into window center";
      };
      float-always-on-top = mkOption {
        type = types.bool;
        default = true;
        description = "Keep floating windows above tiled ones";
      };
      resize-amount = mkOption {
        type = types.int;
        default = 15;
        description = "Pixel increment for window resizing operations";
      };
    };

    general = {
      quick-settings = mkOption {
        type = types.bool;
        default = true;
        description = "Add Forge toggle to system quick settings";
      };
      logging = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable extension event logging";
        };
        level = mkOption {
          type = types.int;
          default = 0;
          description = "Verbosity level for extension logs";
        };
      };
      css = {
        updated = mkOption {
          type = types.str;
          default = "";
          description = "Timestamp of the last CSS injection";
        };
        last-update = mkOption {
          type = types.int;
          default = 1;
          description = "Internal CSS schema version";
        };
      };
    };

    keybindings = {
      focus-border-toggle = mkKeybindOption [ "super" "x" ] "Shortcut to toggle focused window border";
      window-gap-size-increase = mkKeybindOption [
        "ctrl"
        "super"
        "plus"
      ] "Shortcut to increase window gaps";
      window-gap-size-decrease = mkKeybindOption [
        "ctrl"
        "super"
        "minus"
      ] "Shortcut to decrease window gaps";
      con-split-layout-toggle = mkKeybindOption [ "super" "g" ] "Shortcut to toggle split orientation";
      con-split-horizontal = mkKeybindOption [ "super" "z" ] "Shortcut to force horizontal split";
      con-split-vertical = mkKeybindOption [ "super" "v" ] "Shortcut to force vertical split";
      con-stacked-layout-toggle = mkKeybindOption [
        "shift"
        "super"
        "s"
      ] "Shortcut to toggle stacked layout";
      con-tabbed-layout-toggle = mkKeybindOption [
        "shift"
        "super"
        "t"
      ] "Shortcut to toggle tabbed layout";
      con-tabbed-showtab-decoration-toggle = mkKeybindOption [
        "ctrl"
        "alt"
        "y"
      ] "Shortcut to toggle tab decorations";
      window-swap-left = mkKeybindOption [
        "ctrl"
        "super"
        "h"
      ] "Shortcut to swap window with left neighbor";
      window-swap-down = mkKeybindOption [
        "ctrl"
        "super"
        "j"
      ] "Shortcut to swap window with lower neighbor";
      window-swap-up = mkKeybindOption [
        "ctrl"
        "super"
        "k"
      ] "Shortcut to swap window with upper neighbor";
      window-swap-right = mkKeybindOption [
        "ctrl"
        "super"
        "l"
      ] "Shortcut to swap window with right neighbor";
      window-move-left = mkKeybindOption [ "shift" "super" "h" ] "Shortcut to move window left";
      window-move-down = mkKeybindOption [ "shift" "super" "j" ] "Shortcut to move window down";
      window-move-up = mkKeybindOption [ "shift" "super" "k" ] "Shortcut to move window up";
      window-move-right = mkKeybindOption [ "shift" "super" "l" ] "Shortcut to move window right";
      window-focus-left = mkKeybindOption [ "super" "h" ] "Shortcut to focus left neighbor";
      window-focus-down = mkKeybindOption [ "super" "j" ] "Shortcut to focus lower neighbor";
      window-focus-up = mkKeybindOption [ "super" "k" ] "Shortcut to focus upper neighbor";
      window-focus-right = mkKeybindOption [ "super" "l" ] "Shortcut to focus right neighbor";
      window-toggle-float = mkKeybindOption [
        "super"
        "c"
      ] "Shortcut to toggle floating for active window";
      window-toggle-always-float = mkKeybindOption [
        "shift"
        "super"
        "c"
      ] "Shortcut to force permanent float for app";
      workspace-active-tile-toggle = mkKeybindOption [
        "shift"
        "super"
        "w"
      ] "Shortcut to toggle tiling for current desktop";
      prefs-open = mkKeybindOption [ "super" "period" ] "Shortcut to open Forge preferences";
      prefs-tiling-toggle = mkKeybindOption [ "super" "w" ] "Shortcut to toggle tiling mode";
      mod-mask-mouse-tile = mkOption {
        type = types.enum [
          "Super"
          "Ctrl"
          "Shift"
          "Alt"
          "None"
        ];
        default = "None";
        description = "Modifier key for mouse-based tiling operations";
      };
      window-swap-last-active = mkKeybindOption [
        "super"
        "return"
      ] "Shortcut to swap with previously active window";
      window-snap-one-third-right = mkKeybindOption [
        "ctrl"
        "alt"
        "g"
      ] "Snap active window to 1/3 right";
      window-snap-two-third-right = mkKeybindOption [
        "ctrl"
        "alt"
        "t"
      ] "Snap active window to 2/3 right";
      window-snap-one-third-left = mkKeybindOption [ "ctrl" "alt" "d" ] "Snap active window to 1/3 left";
      window-snap-two-third-left = mkKeybindOption [ "ctrl" "alt" "e" ] "Snap active window to 2/3 left";
      window-snap-center = mkKeybindOption [ "ctrl" "alt" "c" ] "Snap active window to center";
      window-resize-left-increase = mkKeybindOption [ "ctrl" "super" "y" ] "Resize window leftwards";
      window-resize-left-decrease = mkKeybindOption [
        "ctrl"
        "shift"
        "super"
        "o"
      ] "Shrink window from left";
      window-resize-bottom-increase = mkKeybindOption [ "ctrl" "super" "u" ] "Resize window downwards";
      window-resize-bottom-decrease = mkKeybindOption [
        "ctrl"
        "shift"
        "super"
        "i"
      ] "Shrink window from bottom";
      window-resize-top-increase = mkKeybindOption [ "ctrl" "super" "i" ] "Resize window upwards";
      window-resize-top-decrease = mkKeybindOption [
        "ctrl"
        "shift"
        "super"
        "u"
      ] "Shrink window from top";
      window-resize-right-increase = mkKeybindOption [ "ctrl" "super" "o" ] "Resize window rightwards";
      window-resize-right-decrease = mkKeybindOption [
        "ctrl"
        "shift"
        "super"
        "y"
      ] "Shrink window from right";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.forge ];
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/forge" = {
            focus-border-toggle = cfg.appearance.borders.focus.toggle;
            focus-border-size = mkUint32 cfg.appearance.borders.focus.size;
            focus-border-color = toRgbaString cfg.appearance.borders.focus.color;
            split-border-toggle = cfg.appearance.borders.split.toggle;
            split-border-color = toRgbaString cfg.appearance.borders.split.color;
            window-gap-size = mkUint32 cfg.appearance.gaps.size;
            window-gap-size-increment = mkUint32 cfg.appearance.gaps.increment;
            window-gap-hidden-on-single = cfg.appearance.gaps.hide-on-single;
            showtab-decoration-enabled = cfg.appearance.decorations.tabs;
            preview-hint-enabled = cfg.appearance.decorations.preview-hint;
            tiling-mode-enabled = cfg.tiling.enable;
            primary-layout-mode = cfg.tiling.primary-mode;
            stacked-tiling-mode-enabled = cfg.tiling.stacked;
            tabbed-tiling-mode-enabled = cfg.tiling.tabbed.enable;
            auto-exit-tabbed = cfg.tiling.tabbed.auto-exit;
            auto-split-enabled = cfg.tiling.auto-split;
            workspace-skip-tile = cfg.tiling.workspace-skip;
            move-pointer-focus-enabled = cfg.interaction.mouse.move-pointer-focus;
            focus-on-hover-enabled = cfg.interaction.mouse.focus-on-hover;
            dnd-center-layout = cfg.interaction.dnd-center-layout;
            float-always-on-top-enabled = cfg.interaction.float-always-on-top;
            resize-amount = mkUint32 cfg.interaction.resize-amount;
            quick-settings-enabled = cfg.general.quick-settings;
            logging-enabled = cfg.general.logging.enable;
            log-level = mkUint32 cfg.general.logging.level;
            css-updated = cfg.general.css.updated;
            css-last-update = mkUint32 cfg.general.css.last-update;
          };
          "org/gnome/shell/extensions/forge/keybindings" = {
            focus-border-toggle = serializeKeybind cfg.keybindings.focus-border-toggle;
            window-gap-size-increase = serializeKeybind cfg.keybindings.window-gap-size-increase;
            window-gap-size-decrease = serializeKeybind cfg.keybindings.window-gap-size-decrease;
            con-split-layout-toggle = serializeKeybind cfg.keybindings.con-split-layout-toggle;
            con-split-horizontal = serializeKeybind cfg.keybindings.con-split-horizontal;
            con-split-vertical = serializeKeybind cfg.keybindings.con-split-vertical;
            con-stacked-layout-toggle = serializeKeybind cfg.keybindings.con-stacked-layout-toggle;
            con-tabbed-layout-toggle = serializeKeybind cfg.keybindings.con-tabbed-layout-toggle;
            con-tabbed-showtab-decoration-toggle = serializeKeybind cfg.keybindings.con-tabbed-showtab-decoration-toggle;
            window-swap-left = serializeKeybind cfg.keybindings.window-swap-left;
            window-swap-down = serializeKeybind cfg.keybindings.window-swap-down;
            window-swap-up = serializeKeybind cfg.keybindings.window-swap-up;
            window-swap-right = serializeKeybind cfg.keybindings.window-swap-right;
            window-move-left = serializeKeybind cfg.keybindings.window-move-left;
            window-move-down = serializeKeybind cfg.keybindings.window-move-down;
            window-move-up = serializeKeybind cfg.keybindings.window-move-up;
            window-move-right = serializeKeybind cfg.keybindings.window-move-right;
            window-focus-left = serializeKeybind cfg.keybindings.window-focus-left;
            window-focus-down = serializeKeybind cfg.keybindings.window-focus-down;
            window-focus-up = serializeKeybind cfg.keybindings.window-focus-up;
            window-focus-right = serializeKeybind cfg.keybindings.window-focus-right;
            window-toggle-float = serializeKeybind cfg.keybindings.window-toggle-float;
            window-toggle-always-float = serializeKeybind cfg.keybindings.window-toggle-always-float;
            workspace-active-tile-toggle = serializeKeybind cfg.keybindings.workspace-active-tile-toggle;
            prefs-open = serializeKeybind cfg.keybindings.prefs-open;
            prefs-tiling-toggle = serializeKeybind cfg.keybindings.prefs-tiling-toggle;
            mod-mask-mouse-tile = cfg.keybindings.mod-mask-mouse-tile;
            window-swap-last-active = serializeKeybind cfg.keybindings.window-swap-last-active;
            window-snap-one-third-right = serializeKeybind cfg.keybindings.window-snap-one-third-right;
            window-snap-two-third-right = serializeKeybind cfg.keybindings.window-snap-two-third-right;
            window-snap-one-third-left = serializeKeybind cfg.keybindings.window-snap-one-third-left;
            window-snap-two-third-left = serializeKeybind cfg.keybindings.window-snap-two-third-left;
            window-snap-center = serializeKeybind cfg.keybindings.window-snap-center;
            window-resize-left-increase = serializeKeybind cfg.keybindings.window-resize-left-increase;
            window-resize-left-decrease = serializeKeybind cfg.keybindings.window-resize-left-decrease;
            window-resize-bottom-increase = serializeKeybind cfg.keybindings.window-resize-bottom-increase;
            window-resize-bottom-decrease = serializeKeybind cfg.keybindings.window-resize-bottom-decrease;
            window-resize-top-increase = serializeKeybind cfg.keybindings.window-resize-top-increase;
            window-resize-top-decrease = serializeKeybind cfg.keybindings.window-resize-top-decrease;
            window-resize-right-increase = serializeKeybind cfg.keybindings.window-resize-right-increase;
            window-resize-right-decrease = serializeKeybind cfg.keybindings.window-resize-right-decrease;
          };
        };
      }
    ];
  };
}
