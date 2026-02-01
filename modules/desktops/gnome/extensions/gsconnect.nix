{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.forge;

  # --- Keybinding Serialization Logic ---

  # Maps "super" -> "<Super>", etc.
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

  # Transforms ["super" "q"] -> ["<Super>q"] for dconf
  serializeKeybind = list: [ (concatMapStrings formatPart list) ];

  # Helper for keybinding options
  mkKeybindOption =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = "${description} (Define as list of keys, e.g. [ \"super\" \"q\" ])";
    };

in
{
  meta = {
    description = "Configures the Forge GNOME extension";
    longDescription = ''
      This module installs and configures the **Forge** extension for GNOME.
      Forge transforms the GNOME Shell into a tiling window manager, offering automatic
      tiling, window gaps, and extensive keyboard shortcuts for window management.

      **Features:**
      - Automatic tiling and stacking.
      - Customizable window gaps and borders.
      - Extensive keyboard shortcuts for moving, resizing, and focusing windows.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.forge = {
    enable = mkEnableOption "Forge GNOME extension configuration";

    # --- Appearance ---
    appearance = {
      borders = {
        focus = {
          toggle = mkOption {
            type = types.bool;
            default = true;
            description = "Show window border on focused window";
          };
          size = mkOption {
            type = types.int;
            default = 3;
            description = "The focused border's current thickness";
          };
          color = mkOption {
            type = types.str;
            default = "rgba(236, 94, 94, 1)";
            description = "The focused border's current color";
          };
        };
        split = {
          toggle = mkOption {
            type = types.bool;
            default = true;
            description = "Show split direction border on focused window";
          };
          color = mkOption {
            type = types.str;
            default = "rgba(255, 246, 108, 1)";
            description = "The focused border's current color";
          };
        };
      };

      gaps = {
        size = mkOption {
          type = types.int;
          default = 4;
          description = "The size of the gap between windows in the workarea";
        };
        increment = mkOption {
          type = types.int;
          default = 1;
          description = "The size increment of the gaps (size-increment * gap-size)";
        };
        hide-on-single = mkOption {
          type = types.bool;
          default = false;
          description = "Hide gap when single window toggle";
        };
      };

      decorations = {
        tabs = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to show the tab decoration or not";
        };
        preview-hint = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to show preview hint during Drag and Drop";
        };
      };
    };

    # --- Tiling Behavior ---
    tiling = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Tiling mode enabled";
      };

      primary-mode = mkOption {
        type = types.enum [
          "tiling"
          "stacking"
        ];
        default = "tiling";
        description = "Primary layout mode";
      };

      stacked = mkOption {
        type = types.bool;
        default = true;
        description = "Stacked tiling mode enabled";
      };

      tabbed = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Tabbed tiling mode enabled";
        };
        auto-exit = mkOption {
          type = types.bool;
          default = true;
          description = "Exit tabbed tiling mode when only a single tab remains";
        };
      };

      auto-split = mkOption {
        type = types.bool;
        default = true;
        description = "Enable auto split or quarter-tiling based on smaller side";
      };

      workspace-skip = mkOption {
        type = types.str;
        default = "";
        description = "Skips tiling on the provided workspace indices";
      };
    };

    # --- Interaction & Windows ---
    interaction = {
      mouse = {
        move-pointer-focus = mkOption {
          type = types.bool;
          default = false;
          description = "Move the pointer when focusing or swapping via keyboard";
        };
        focus-on-hover = mkOption {
          type = types.bool;
          default = false;
          description = "Focus switches to the window under the pointer";
        };
      };

      dnd-center-layout = mkOption {
        type = types.enum [
          "tabbed"
          "stacked"
        ];
        default = "tabbed";
        description = "Default center layout when dragging/dropping";
      };

      float-always-on-top = mkOption {
        type = types.bool;
        default = true;
        description = "Floating windows toggle always-on-top";
      };

      resize-amount = mkOption {
        type = types.int;
        default = 15;
        description = "The window resize increment/decrement in pixels";
      };
    };

    # --- General / System ---
    general = {
      quick-settings = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Forge quick settings toggle in system menu";
      };

      logging = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable logging";
        };
        level = mkOption {
          type = types.int;
          default = 0;
          description = "Log level (0=OFF, 1=FATAL... 7=ALL)";
        };
      };

      css = {
        updated = mkOption {
          type = types.str;
          default = "";
          description = "Timestamp when css is last updated";
        };
        last-update = mkOption {
          type = types.int;
          default = 1;
          description = "CSS Last Update version";
        };
      };
    };

    # --- Keybindings ---
    keybindings = {
      focus-border-toggle = mkKeybindOption [ "super" "x" ] "Toggle the focused window's border";

      window-gap-size-increase = mkKeybindOption [ "ctrl" "super" "plus" ] "Increase gap size";
      window-gap-size-decrease = mkKeybindOption [ "ctrl" "super" "minus" ] "Decrease gap size";

      con-split-layout-toggle = mkKeybindOption [ "super" "g" ] "Toggle split layout";
      con-split-horizontal = mkKeybindOption [ "super" "z" ] "Split container horizontally";
      con-split-vertical = mkKeybindOption [ "super" "v" ] "Split container vertically";

      con-stacked-layout-toggle = mkKeybindOption [ "shift" "super" "s" ] "Toggle stacked layout";
      con-tabbed-layout-toggle = mkKeybindOption [ "shift" "super" "t" ] "Toggle tabbed layout";
      con-tabbed-showtab-decoration-toggle = mkKeybindOption [ "ctrl" "alt" "y" ] "Toggle tab decoration";

      window-swap-left = mkKeybindOption [ "ctrl" "super" "h" ] "Swap window left";
      window-swap-down = mkKeybindOption [ "ctrl" "super" "j" ] "Swap window down";
      window-swap-up = mkKeybindOption [ "ctrl" "super" "k" ] "Swap window up";
      window-swap-right = mkKeybindOption [ "ctrl" "super" "l" ] "Swap window right";

      window-move-left = mkKeybindOption [ "shift" "super" "h" ] "Move window left";
      window-move-down = mkKeybindOption [ "shift" "super" "j" ] "Move window down";
      window-move-up = mkKeybindOption [ "shift" "super" "k" ] "Move window up";
      window-move-right = mkKeybindOption [ "shift" "super" "l" ] "Move window right";

      window-focus-left = mkKeybindOption [ "super" "h" ] "Focus window left";
      window-focus-down = mkKeybindOption [ "super" "j" ] "Focus window down";
      window-focus-up = mkKeybindOption [ "super" "k" ] "Focus window up";
      window-focus-right = mkKeybindOption [ "super" "l" ] "Focus window right";

      window-toggle-float = mkKeybindOption [ "super" "c" ] "Toggle window float";
      window-toggle-always-float = mkKeybindOption [ "shift" "super" "c" ] "Toggle always float";

      workspace-active-tile-toggle = mkKeybindOption [
        "shift"
        "super"
        "w"
      ] "Toggle active workspace tiling";

      prefs-open = mkKeybindOption [ "super" "period" ] "Open preferences";
      prefs-tiling-toggle = mkKeybindOption [ "super" "w" ] "Toggle tiling mode";

      mod-mask-mouse-tile = mkOption {
        type = types.enum [
          "Super"
          "Ctrl"
          "Shift"
          "Alt"
          "None"
        ];
        default = "None";
        description = "Mod mask for mouse tiling";
      };

      window-swap-last-active = mkKeybindOption [ "super" "return" ] "Swap last active window";

      window-snap-one-third-right = mkKeybindOption [ "ctrl" "alt" "g" ] "Snap 1/3 right";
      window-snap-two-third-right = mkKeybindOption [ "ctrl" "alt" "t" ] "Snap 2/3 right";
      window-snap-one-third-left = mkKeybindOption [ "ctrl" "alt" "d" ] "Snap 1/3 left";
      window-snap-two-third-left = mkKeybindOption [ "ctrl" "alt" "e" ] "Snap 2/3 left";
      window-snap-center = mkKeybindOption [ "ctrl" "alt" "c" ] "Snap center";

      window-resize-left-increase = mkKeybindOption [ "ctrl" "super" "y" ] "Resize left increase";
      window-resize-left-decrease = mkKeybindOption [ "ctrl" "shift" "super" "o" ] "Resize left decrease";
      window-resize-bottom-increase = mkKeybindOption [ "ctrl" "super" "u" ] "Resize bottom increase";
      window-resize-bottom-decrease = mkKeybindOption [
        "ctrl"
        "shift"
        "super"
        "i"
      ] "Resize bottom decrease";
      window-resize-top-increase = mkKeybindOption [ "ctrl" "super" "i" ] "Resize top increase";
      window-resize-top-decrease = mkKeybindOption [ "ctrl" "shift" "super" "u" ] "Resize top decrease";
      window-resize-right-increase = mkKeybindOption [ "ctrl" "super" "o" ] "Resize right increase";
      window-resize-right-decrease = mkKeybindOption [
        "ctrl"
        "shift"
        "super"
        "y"
      ] "Resize right decrease";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.forge ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          # Main Settings
          "org/gnome/shell/extensions/forge" = {
            # Appearance
            focus-border-toggle = cfg.appearance.borders.focus.toggle;
            focus-border-size = mkUint32 cfg.appearance.borders.focus.size;
            focus-border-color = cfg.appearance.borders.focus.color;
            split-border-toggle = cfg.appearance.borders.split.toggle;
            split-border-color = cfg.appearance.borders.split.color;
            window-gap-size = mkUint32 cfg.appearance.gaps.size;
            window-gap-size-increment = mkUint32 cfg.appearance.gaps.increment;
            window-gap-hidden-on-single = cfg.appearance.gaps.hide-on-single;
            showtab-decoration-enabled = cfg.appearance.decorations.tabs;
            preview-hint-enabled = cfg.appearance.decorations.preview-hint;

            # Tiling
            tiling-mode-enabled = cfg.tiling.enable;
            primary-layout-mode = cfg.tiling.primary-mode;
            stacked-tiling-mode-enabled = cfg.tiling.stacked;
            tabbed-tiling-mode-enabled = cfg.tiling.tabbed.enable;
            auto-exit-tabbed = cfg.tiling.tabbed.auto-exit;
            auto-split-enabled = cfg.tiling.auto-split;
            workspace-skip-tile = cfg.tiling.workspace-skip;

            # Interaction
            move-pointer-focus-enabled = cfg.interaction.mouse.move-pointer-focus;
            focus-on-hover-enabled = cfg.interaction.mouse.focus-on-hover;
            dnd-center-layout = cfg.interaction.dnd-center-layout;
            float-always-on-top-enabled = cfg.interaction.float-always-on-top;
            resize-amount = mkUint32 cfg.interaction.resize-amount;

            # General
            quick-settings-enabled = cfg.general.quick-settings;
            logging-enabled = cfg.general.logging.enable;
            log-level = mkUint32 cfg.general.logging.level;
            css-updated = cfg.general.css.updated;
            css-last-update = mkUint32 cfg.general.css.last-update;
          };

          # Keybindings
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

            # String setting, not keybind
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
