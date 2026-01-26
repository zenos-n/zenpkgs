{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.forge;

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

  mkUint =
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

  # --- Special Keybinding Helper ---
  # Allows user to define keys as [ "super" "q" ] instead of ["<Super>q"]
  mkKeybind =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = "${description} (Define as list of keys, e.g. [ \"super\" \"q\" ])";
    };

  # Transformation logic: [ "super" "shift" "q" ] -> [ "<Super><Shift>q" ]
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

in
{
  options.zenos.desktops.gnome.extensions.forge = {
    enable = mkEnableOption "Forge GNOME extension configuration";

    # --- Main Settings (org.gnome.shell.extensions.forge) ---

    focus-border-toggle = mkBool true "Show window border on focused window.";

    focus-border-size = mkUint 3 "The focused border's current thickness.";

    focus-border-color = mkStr "rgba(236, 94, 94, 1)" "The focused border's current color.";

    split-border-toggle = mkBool true "Show split direction border on focused window.";

    split-border-color = mkStr "rgba(255, 246, 108, 1)" "The focused border's current color.";

    window-gap-size = mkUint 4 "The size of the gap between windows in the workarea.";

    resize-amount = mkUint 15 "The window resize increment/decrement in pixels.";

    window-gap-size-increment = mkUint 1 "The size increment of the gaps. size-increment * gap-size.";

    window-gap-hidden-on-single = mkBool false "Hide gap when single window toggle.";

    primary-layout-mode = mkStr "tiling" "Layout modes: stacking, tiling.";

    tiling-mode-enabled = mkBool true "Tiling mode on/off.";

    quick-settings-enabled = mkBool true "Forge quick settings toggle.";

    workspace-skip-tile = mkStr "" "Skips tiling on the provided workspace indices.";

    stacked-tiling-mode-enabled = mkBool true "Stacked tiling mode on/off.";

    tabbed-tiling-mode-enabled = mkBool true "Tabbed tiling mode on/off.";

    log-level = mkUint 0 "Log level (0=OFF, 1=FATAL... 7=ALL).";

    logging-enabled = mkBool false "Enable logging.";

    css-updated = mkStr "" "Timestamp when css is last updated.";

    css-last-update = mkUint 1 "CSS Last Update.";

    dnd-center-layout = mkStr "tabbed" "Default center layout when dragging/dropping (tabbed, stacked).";

    move-pointer-focus-enabled = mkBool false "Move the pointer when focusing or swapping via kbd.";

    focus-on-hover-enabled = mkBool false "Focus switches to the window under the pointer.";

    float-always-on-top-enabled = mkBool true "Floating windows toggle always-on-top.";

    auto-exit-tabbed = mkBool true "Exit tabbed tiling mode when only a single tab remains.";

    auto-split-enabled = mkBool true "Enable auto split or quarter-tiling based based on smaller side.";

    preview-hint-enabled = mkBool true "Whether to show preview hint DND.";

    showtab-decoration-enabled = mkBool true "Whether to show the tab decoration or not.";

    # --- Keybindings (org.gnome.shell.extensions.forge.keybindings) ---

    keybindings = {
      focus-border-toggle = mkKeybind [ "super" "x" ] "Toggle the focused window's border.";

      window-gap-size-increase = mkKeybind [ "ctrl" "super" "plus" ] "Increase gap size.";

      window-gap-size-decrease = mkKeybind [ "ctrl" "super" "minus" ] "Decrease gap size.";

      con-split-layout-toggle = mkKeybind [ "super" "g" ] "Toggle split layout.";

      con-split-horizontal = mkKeybind [ "super" "z" ] "Split container horizontally.";

      con-split-vertical = mkKeybind [ "super" "v" ] "Split container vertically.";

      con-stacked-layout-toggle = mkKeybind [ "shift" "super" "s" ] "Toggle stacked layout.";

      con-tabbed-layout-toggle = mkKeybind [ "shift" "super" "t" ] "Toggle tabbed layout.";

      con-tabbed-showtab-decoration-toggle = mkKeybind [ "ctrl" "alt" "y" ] "Toggle tab decoration.";

      window-swap-left = mkKeybind [ "ctrl" "super" "h" ] "Swap window left.";

      window-swap-down = mkKeybind [ "ctrl" "super" "j" ] "Swap window down.";

      window-swap-up = mkKeybind [ "ctrl" "super" "k" ] "Swap window up.";

      window-swap-right = mkKeybind [ "ctrl" "super" "l" ] "Swap window right.";

      window-move-left = mkKeybind [ "shift" "super" "h" ] "Move window left.";

      window-move-down = mkKeybind [ "shift" "super" "j" ] "Move window down.";

      window-move-up = mkKeybind [ "shift" "super" "k" ] "Move window up.";

      window-move-right = mkKeybind [ "shift" "super" "l" ] "Move window right.";

      window-focus-left = mkKeybind [ "super" "h" ] "Focus window left.";

      window-focus-down = mkKeybind [ "super" "j" ] "Focus window down.";

      window-focus-up = mkKeybind [ "super" "k" ] "Focus window up.";

      window-focus-right = mkKeybind [ "super" "l" ] "Focus window right.";

      window-toggle-float = mkKeybind [ "super" "c" ] "Toggle window float.";

      window-toggle-always-float = mkKeybind [ "shift" "super" "c" ] "Toggle always float.";

      workspace-active-tile-toggle = mkKeybind [ "shift" "super" "w" ] "Toggle active workspace tiling.";

      prefs-open = mkKeybind [ "super" "period" ] "Open preferences.";

      prefs-tiling-toggle = mkKeybind [ "super" "w" ] "Toggle tiling mode.";

      # Not a keybind list, but a string setting in the keybindings schema
      mod-mask-mouse-tile = mkStr "None" "Mod mask for mouse tiling (Super, Ctrl, Shift, Alt, None).";

      window-swap-last-active = mkKeybind [ "super" "return" ] "Swap last active window.";

      window-snap-one-third-right = mkKeybind [ "ctrl" "alt" "g" ] "Snap 1/3 right.";

      window-snap-two-third-right = mkKeybind [ "ctrl" "alt" "t" ] "Snap 2/3 right.";

      window-snap-one-third-left = mkKeybind [ "ctrl" "alt" "d" ] "Snap 1/3 left.";

      window-snap-two-third-left = mkKeybind [ "ctrl" "alt" "e" ] "Snap 2/3 left.";

      window-snap-center = mkKeybind [ "ctrl" "alt" "c" ] "Snap center.";

      window-resize-left-increase = mkKeybind [ "ctrl" "super" "y" ] "Resize left increase.";

      window-resize-left-decrease = mkKeybind [ "ctrl" "shift" "super" "o" ] "Resize left decrease.";

      window-resize-bottom-increase = mkKeybind [ "ctrl" "super" "u" ] "Resize bottom increase.";

      window-resize-bottom-decrease = mkKeybind [ "ctrl" "shift" "super" "i" ] "Resize bottom decrease.";

      window-resize-top-increase = mkKeybind [ "ctrl" "super" "i" ] "Resize top increase.";

      window-resize-top-decrease = mkKeybind [ "ctrl" "shift" "super" "u" ] "Resize top decrease.";

      window-resize-right-increase = mkKeybind [ "ctrl" "super" "o" ] "Resize right increase.";

      window-resize-right-decrease = mkKeybind [ "ctrl" "shift" "super" "y" ] "Resize right decrease.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.forge ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          # Main Settings
          "org/gnome/shell/extensions/forge" = {
            focus-border-toggle = cfg.focus-border-toggle;
            focus-border-size = mkUint32 cfg.focus-border-size;
            focus-border-color = cfg.focus-border-color;
            split-border-toggle = cfg.split-border-toggle;
            split-border-color = cfg.split-border-color;
            window-gap-size = mkUint32 cfg.window-gap-size;
            resize-amount = mkUint32 cfg.resize-amount;
            window-gap-size-increment = mkUint32 cfg.window-gap-size-increment;
            window-gap-hidden-on-single = cfg.window-gap-hidden-on-single;
            primary-layout-mode = cfg.primary-layout-mode;
            tiling-mode-enabled = cfg.tiling-mode-enabled;
            quick-settings-enabled = cfg.quick-settings-enabled;
            workspace-skip-tile = cfg.workspace-skip-tile;
            stacked-tiling-mode-enabled = cfg.stacked-tiling-mode-enabled;
            tabbed-tiling-mode-enabled = cfg.tabbed-tiling-mode-enabled;
            log-level = mkUint32 cfg.log-level;
            logging-enabled = cfg.logging-enabled;
            css-updated = cfg.css-updated;
            css-last-update = mkUint32 cfg.css-last-update;
            dnd-center-layout = cfg.dnd-center-layout;
            move-pointer-focus-enabled = cfg.move-pointer-focus-enabled;
            focus-on-hover-enabled = cfg.focus-on-hover-enabled;
            float-always-on-top-enabled = cfg.float-always-on-top-enabled;
            auto-exit-tabbed = cfg.auto-exit-tabbed;
            auto-split-enabled = cfg.auto-split-enabled;
            preview-hint-enabled = cfg.preview-hint-enabled;
            showtab-decoration-enabled = cfg.showtab-decoration-enabled;
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
