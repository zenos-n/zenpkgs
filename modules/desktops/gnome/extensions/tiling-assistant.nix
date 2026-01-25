{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.tiling-assistant;

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

  # --- GVariant Serializer for a{sv} (overridden-settings) ---
  mkVariant = v: "<${v}>";
  mkString = v: "'${v}'";
  mkUint32 = v: "uint32 ${toString v}";

  serializeFloat =
    v:
    let
      s = toString v;
    in
    if builtins.match ".*\\..*" s == null then "${s}.0" else s;

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
                toString v # Schema uses 'i' mostly, check if 'u' needed
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
  options.zenos.desktops.gnome.extensions.tiling-assistant = {
    enable = mkEnableOption "Tiling Assistant GNOME extension configuration";

    # --- General ---
    enable-tiling-popup = mkBool true "Enable tiling popup.";
    tiling-popup-all-workspace = mkBool false "Popup on all workspaces.";
    enable-raise-tile-group = mkBool true "Raise tile group.";
    tilegroups-in-app-switcher = mkBool false "Show tilegroups in app switcher.";
    dynamic-keybinding-behavior = mkInt 0 "Dynamic keybinding behavior.";
    focus-hint = mkInt 0 "Focus hint type.";
    focus-hint-color = mkStr "" "Focus hint color.";
    focus-hint-outline-border-radius = mkInt 8 "Outline border radius.";
    focus-hint-outline-size = mkInt 8 "Outline size.";
    focus-hint-outline-style = mkInt 0 "Outline style (0: solid, 1: border).";

    # --- Gaps ---
    window-gap = mkInt 0 "Window gap.";
    single-screen-gap = mkInt 0 "Single screen gap.";
    screen-top-gap = mkInt 0 "Screen top gap.";
    screen-left-gap = mkInt 0 "Screen left gap.";
    screen-right-gap = mkInt 0 "Screen right gap.";
    screen-bottom-gap = mkInt 0 "Screen bottom gap.";
    maximize-with-gap = mkBool false "Maximize with gap.";
    monitor-switch-grace-period = mkBool true "Monitor switch grace period.";

    # --- Keybindings ---
    toggle-tiling-popup = mkOptionStrList [ ] "Toggle tiling popup.";
    tile-edit-mode = mkOptionStrList [ ] "Tile edit mode.";
    auto-tile = mkOptionStrList [ ] "Auto tile.";
    toggle-always-on-top = mkOptionStrList [ ] "Toggle always on top.";
    tile-maximize = mkOptionStrList [ "<Super>Up" "<Super>KP_5" ] "Tile maximize.";
    restore-window = mkOptionStrList [ "<Super>Down" ] "Restore window.";
    tile-top-half = mkOptionStrList [ "<Super>KP_8" ] "Tile top half.";
    tile-bottom-half = mkOptionStrList [ "<Super>KP_2" ] "Tile bottom half.";
    tile-left-half = mkOptionStrList [ "<Super>Left" "<Super>KP_4" ] "Tile left half.";
    tile-right-half = mkOptionStrList [ "<Super>Right" "<Super>KP_6" ] "Tile right half.";
    tile-topleft-quarter = mkOptionStrList [ "<Super>KP_7" ] "Tile top-left.";
    tile-topright-quarter = mkOptionStrList [ "<Super>KP_9" ] "Tile top-right.";
    tile-bottomleft-quarter = mkOptionStrList [ "<Super>KP_1" ] "Tile bottom-left.";
    tile-bottomright-quarter = mkOptionStrList [ "<Super>KP_3" ] "Tile bottom-right.";

    # --- Advanced / Hidden ---
    enable-advanced-experimental-features = mkBool false "Enable experimental features.";
    enable-tile-animations = mkBool true "Enable tile animations.";
    enable-untile-animations = mkBool true "Enable untile animations.";
    disable-tile-groups = mkBool false "Disable tile groups.";
    default-move-mode = mkInt 0 "Default move mode.";
    low-performance-move-mode = mkBool false "Low performance move mode.";
    adapt-edge-tiling-to-favorite-layout = mkBool false "Adapt edge tiling to favorite layout.";

    # --- Overridden Settings (Complex a{sv}) ---
    overridden-settings = mkOption {
      type = types.attrsOf (
        types.oneOf [
          types.bool
          types.int
          types.str
        ]
      );
      default = { };
      description = "Map of overridden settings (private key).";
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.tiling-assistant ];

    # Standard Types
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

    # Complex Type (overridden-settings) via systemd
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
