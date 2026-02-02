{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.zenos.desktops.gnome.extensions.tiling-assistant;
  inherit (lib)
    mkIf
    mkOption
    types
    mapAttrsToList
    concatStringsSep
    mkEnableOption
    escapeShellArg
    ;

  # --- GVariant Serializer for a{sv} (overridden-settings) ---
  mkVariant = v: "<${v}>";
  mkString = v: "'${v}'";

  serializeSettings =
    settings:
    if settings == { } then
      "@a{sv} {}"
    else
      let
        pairs = mapAttrsToList (
          k: v:
          "${mkString k}: ${
            mkVariant (
              if builtins.isBool v then
                (if v then "true" else "false")
              else if builtins.isInt v then
                toString v
              else if builtins.isString v then
                mkString v
              else
                throw "Unknown type for Tiling Assistant overridden setting: ${k}"
            )
          }"
        ) settings;
      in
      "{${concatStringsSep ", " pairs}}";

in
{
  meta = {
    description = "Configures the Tiling Assistant GNOME extension for advanced window snapping";
    longDescription = ''
      This module installs and configures **Tiling Assistant**, which brings advanced 
      window management features to GNOME Shell, similar to Windows' "Snap Assist".

      ### Features
      - **Snap Layouts:** Easily tile windows into halves, quarters, or custom layouts.
      - **Tiling Popup:** Automatically suggest windows to tile alongside the current one.
      - **Window Gaps:** Add customizable spacing between windows and screen edges.
      - **Tile Groups:** Manage groups of tiled windows as a single unit.
      - **Keybindings:** Extensive shortcuts for tiling and resizing windows.

      Integrates with `zenos.desktops.gnome` and respects system-wide theming.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.tiling-assistant = {
    enable = mkEnableOption "Tiling Assistant GNOME extension configuration";

    # --- General ---
    enable-tiling-popup = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the popup that suggests windows to tile alongside the current one";
    };

    tiling-popup-all-workspace = mkOption {
      type = types.bool;
      default = false;
      description = "Show the tiling popup on all workspaces instead of just the active one";
    };

    enable-raise-tile-group = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically raise all windows in a tile group when one is focused";
    };

    tilegroups-in-app-switcher = mkOption {
      type = types.bool;
      default = false;
      description = "Show tile groups as single entries in the Alt-Tab application switcher";
    };

    dynamic-keybinding-behavior = mkOption {
      type = types.int;
      default = 0;
      description = "Dynamic keybinding behavior mode (0-3)";
    };

    focus-hint = mkOption {
      type = types.int;
      default = 0;
      description = "The type of focus hint to display (0: disabled, 1: outline, 2: background)";
    };

    focus-hint-color = mkOption {
      type = types.str;
      default = "";
      description = "The CSS color string for the focus hint";
    };

    focus-hint-outline-border-radius = mkOption {
      type = types.int;
      default = 8;
      description = "The border radius of the focus hint outline in pixels";
    };

    focus-hint-outline-size = mkOption {
      type = types.int;
      default = 8;
      description = "The size/thickness of the focus hint outline in pixels";
    };

    focus-hint-outline-style = mkOption {
      type = types.int;
      default = 0;
      description = "The style of the outline (0: solid, 1: border)";
    };

    # --- Gaps ---
    window-gap = mkOption {
      type = types.int;
      default = 0;
      description = "The gap between tiled windows in pixels";
    };

    single-screen-gap = mkOption {
      type = types.int;
      default = 0;
      description = "The gap applied when only a single window is tiled";
    };

    screen-top-gap = mkOption {
      type = types.int;
      default = 0;
      description = "The gap between windows and the top of the screen";
    };

    screen-left-gap = mkOption {
      type = types.int;
      default = 0;
      description = "The gap between windows and the left side of the screen";
    };

    screen-right-gap = mkOption {
      type = types.int;
      default = 0;
      description = "The gap between windows and the right side of the screen";
    };

    screen-bottom-gap = mkOption {
      type = types.int;
      default = 0;
      description = "The gap between windows and the bottom of the screen";
    };

    maximize-with-gap = mkOption {
      type = types.bool;
      default = false;
      description = "Apply window gaps even when a window is maximized";
    };

    monitor-switch-grace-period = mkOption {
      type = types.bool;
      default = true;
      description = "Enable a grace period when moving windows between monitors to prevent accidental tiling";
    };

    # --- Keybindings ---
    toggle-tiling-popup = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Keybindings to manually toggle the tiling popup";
    };

    tile-edit-mode = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Keybindings to enter tile edit mode";
    };

    auto-tile = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Keybindings to automatically tile the active window";
    };

    toggle-always-on-top = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Keybindings to toggle the 'always on top' state for the active window";
    };

    tile-maximize = mkOption {
      type = types.listOf types.str;
      default = [
        "<Super>Up"
        "<Super>KP_5"
      ];
      description = "Keybindings to maximize the window within the tiling grid";
    };

    restore-window = mkOption {
      type = types.listOf types.str;
      default = [ "<Super>Down" ];
      description = "Keybindings to restore a tiled window to its original size";
    };

    tile-top-half = mkOption {
      type = types.listOf types.str;
      default = [ "<Super>KP_8" ];
      description = "Keybindings to tile window to the top half";
    };

    tile-bottom-half = mkOption {
      type = types.listOf types.str;
      default = [ "<Super>KP_2" ];
      description = "Keybindings to tile window to the bottom half";
    };

    tile-left-half = mkOption {
      type = types.listOf types.str;
      default = [
        "<Super>Left"
        "<Super>KP_4"
      ];
      description = "Keybindings to tile window to the left half";
    };

    tile-right-half = mkOption {
      type = types.listOf types.str;
      default = [
        "<Super>Right"
        "<Super>KP_6"
      ];
      description = "Keybindings to tile window to the right half";
    };

    tile-topleft-quarter = mkOption {
      type = types.listOf types.str;
      default = [ "<Super>KP_7" ];
      description = "Keybindings to tile window to the top-left quarter";
    };

    tile-topright-quarter = mkOption {
      type = types.listOf types.str;
      default = [ "<Super>KP_9" ];
      description = "Keybindings to tile window to the top-right quarter";
    };

    tile-bottomleft-quarter = mkOption {
      type = types.listOf types.str;
      default = [ "<Super>KP_1" ];
      description = "Keybindings to tile window to the bottom-left quarter";
    };

    tile-bottomright-quarter = mkOption {
      type = types.listOf types.str;
      default = [ "<Super>KP_3" ];
      description = "Keybindings to tile window to the bottom-right quarter";
    };

    # --- Advanced / Experimental ---
    enable-advanced-experimental-features = mkOption {
      type = types.bool;
      default = false;
      description = "Enable experimental features that may be unstable";
    };

    enable-tile-animations = mkOption {
      type = types.bool;
      default = true;
      description = "Enable animations when tiling windows";
    };

    enable-untile-animations = mkOption {
      type = types.bool;
      default = true;
      description = "Enable animations when restoring tiled windows";
    };

    disable-tile-groups = mkOption {
      type = types.bool;
      default = false;
      description = "Completely disable tile group functionality";
    };

    default-move-mode = mkOption {
      type = types.int;
      default = 0;
      description = "The default behavior when moving windows (0: standard, 1: tiling)";
    };

    low-performance-move-mode = mkOption {
      type = types.bool;
      default = false;
      description = "Use a simplified move mode for better performance on low-end hardware";
    };

    adapt-edge-tiling-to-favorite-layout = mkOption {
      type = types.bool;
      default = false;
      description = "Adapt the edge tiling behavior based on the configured favorite layout";
    };

    overridden-settings = mkOption {
      type = types.attrsOf (
        types.oneOf [
          types.bool
          types.int
          types.str
        ]
      );
      default = { };
      description = "Manual overrides for extension settings stored in the GVariant dictionary";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.tiling-assistant ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/tiling-assistant" = {
            enable-tiling-popup = cfg.enable-tiling-popup;
            tiling-popup-all-workspace = cfg.tiling-popup-all-workspace;
            enable-raise-tile-group = cfg.enable-raise-tile-group;
            tilegroups-in-app-switcher = cfg.tilegroups-in-app-switcher;
            dynamic-keybinding-behavior = cfg.dynamic-keybinding-behavior;
            focus-hint = cfg.focus-hint;
            focus-hint-color = cfg.focus-hint-color;
            focus-hint-outline-border-radius = cfg.focus-hint-outline-border-radius;
            focus-hint-outline-size = cfg.focus-hint-outline-size;
            focus-hint-outline-style = cfg.focus-hint-outline-style;
            window-gap = cfg.window-gap;
            single-screen-gap = cfg.single-screen-gap;
            screen-top-gap = cfg.screen-top-gap;
            screen-left-gap = cfg.screen-left-gap;
            screen-right-gap = cfg.screen-right-gap;
            screen-bottom-gap = cfg.screen-bottom-gap;
            maximize-with-gap = cfg.maximize-with-gap;
            monitor-switch-grace-period = cfg.monitor-switch-grace-period;
            toggle-tiling-popup = cfg.toggle-tiling-popup;
            tile-edit-mode = cfg.tile-edit-mode;
            auto-tile = cfg.auto-tile;
            toggle-always-on-top = cfg.toggle-always-on-top;
            tile-maximize = cfg.tile-maximize;
            restore-window = cfg.restore-window;
            tile-top-half = cfg.tile-top-half;
            tile-bottom-half = cfg.tile-bottom-half;
            tile-left-half = cfg.tile-left-half;
            tile-right-half = cfg.tile-right-half;
            tile-topleft-quarter = cfg.tile-topleft-quarter;
            tile-topright-quarter = cfg.tile-topright-quarter;
            tile-bottomleft-quarter = cfg.tile-bottomleft-quarter;
            tile-bottomright-quarter = cfg.tile-bottomright-quarter;
            enable-advanced-experimental-features = cfg.enable-advanced-experimental-features;
            enable-tile-animations = cfg.enable-tile-animations;
            enable-untile-animations = cfg.enable-untile-animations;
            disable-tile-groups = cfg.disable-tile-groups;
            default-move-mode = cfg.default-move-mode;
            low-performance-move-mode = cfg.low-performance-move-mode;
            adapt-edge-tiling-to-favorite-layout = cfg.adapt-edge-tiling-to-favorite-layout;
          };
        };
      }
    ];

    systemd.user.services.tiling-assistant-overrides = {
      description = "Apply Tiling Assistant overridden settings";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/tiling-assistant/overridden-settings ${escapeShellArg (serializeSettings cfg.overridden-settings)}
      '';
    };
  };
}
