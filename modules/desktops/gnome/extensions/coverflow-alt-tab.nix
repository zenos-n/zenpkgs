{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.coverflow-alt-tab;

  # --- Hex Color Parsing Helpers ---

  # Mapping hex chars to integers
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

  # Parse a single hex character
  hexCharToInt =
    c: if builtins.hasAttr c hexToDecMap then hexToDecMap.${c} else throw "Invalid hex character: ${c}";

  # Parse a 2-character hex byte (e.g., "FF" -> 255)
  parseHexByte =
    s: (hexCharToInt (builtins.substring 0 1 s) * 16) + (hexCharToInt (builtins.substring 1 1 s));

  # Main converter: Hex String -> [ R G B A ] (Floats 0.0 - 1.0)
  parseHexColor =
    s:
    let
      hex = lib.removePrefix "#" s;
      len = builtins.stringLength hex;
      norm = v: v / 255.0; # Normalize 0-255 to 0.0-1.0
    in
    if len == 6 then
      [
        (norm (parseHexByte (builtins.substring 0 2 hex)))
        (norm (parseHexByte (builtins.substring 2 2 hex)))
        (norm (parseHexByte (builtins.substring 4 2 hex)))
        1.0
      ]
    else if len == 8 then
      [
        (norm (parseHexByte (builtins.substring 0 2 hex)))
        (norm (parseHexByte (builtins.substring 2 2 hex)))
        (norm (parseHexByte (builtins.substring 4 2 hex)))
        (norm (parseHexByte (builtins.substring 6 2 hex)))
      ]
    else
      throw "Invalid hex color: '${s}'. Must be 6 (RRGGBB) or 8 (RRGGBBAA) characters.";

  # Force floats to have decimal points (required for GVariant doubles)
  serializeFloat =
    v:
    let
      s = toString v;
    in
    if builtins.match ".*\\..*" s == null then "${s}.0" else s;

  # Convert a list of 3+ floats to a GVariant tuple string "(r, g, b)"
  listToTupleStr =
    l: "(${serializeFloat (elemAt l 0)},${serializeFloat (elemAt l 1)},${serializeFloat (elemAt l 2)})";

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

  mkStrList =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

  # Helper for (ddd) tuples - Supports Hex String, List of Floats, or raw tuple String
  mkColorOption =
    default: description:
    mkOption {
      type = types.either types.str (types.listOf types.float);
      default = default;
      description =
        description
        + " Accepts Hex ('#RRGGBB'), List of Floats ([0.0 0.0 0.0]), or GVariant Tuple String ('(0.0,0.0,0.0)').";
      apply =
        v:
        if builtins.isList v then
          listToTupleStr v
        else if (builtins.isString v && lib.hasPrefix "#" v) then
          listToTupleStr (parseHexColor v)
        else
          v;
    };

in
{
  options.zenos.desktops.gnome.extensions.coverflow-alt-tab = {
    enable = mkEnableOption "Coverflow Alt-Tab GNOME extension configuration";

    # --- Schema Options ---

    hide-panel = mkBool true "Hide the panel when showing coverflow.";

    enforce-primary-monitor = mkBool false "Always show the switcher on the primary monitor.";

    animation-time = mkDouble 0.2 "The duration of coverflow animations in ms.";

    dim-factor = mkDouble 1.0 "Dim factor for background.";

    position = mkStr "Bottom" "Position of icon and window title (Top, Bottom).";

    offset = mkInt 0 "Set a vertical offset.";

    icon-style = mkStr "Classic" "Icon style (Classic, Overlay, Attached).";

    overlay-icon-opacity = mkDouble 1.0 "The opacity of the overlay icon.";

    overlay-icon-size = mkDouble 128.0 "The icon size in pixels.";

    switcher-style = mkStr "Coverflow" "Switcher style (Coverflow, Timeline).";

    easing-function = mkStr "ease-out-cubic" "Easing function used in animations.";

    current-workspace-only = mkStr "current" "Show windows from current workspace only (current, all, all-currentfirst).";

    switch-per-monitor = mkBool false "Per monitor window switch.";

    icon-has-shadow = mkBool false "Icon has shadow switch.";

    randomize-animation-times = mkBool false "Randomize animation times switch.";

    preview-to-monitor-ratio = mkDouble 0.5 "The maximum ratio of the preview dimensions with the monitor dimensions.";

    preview-scaling-factor = mkDouble 0.8 "Scales the previews as they spread out to the sides.";

    coverflow-window-angle = mkDouble 90.0 "In Coverflow switcher, angle of off-center windows.";

    coverflow-window-offset-width = mkDouble 50.0 "In Coverflow switcher, distance from center of off-center windows.";

    bind-to-switch-applications = mkBool true "Bind to 'switch-applications' keybinding.";

    bind-to-switch-windows = mkBool true "Bind to 'switch-windows' keybinding.";

    highlight-mouse-over = mkBool false "Highlight window under mouse.";

    highlight-use-theme-color = mkBool true "Use theme color for highlight.";

    raise-mouse-over = mkBool true "Raise window under mouse.";

    perspective-correction-method = mkStr "Move Camera" "Method to correct off-center monitor perspective.";

    desaturate-factor = mkDouble 0.0 "Amount to Desaturate the Background Application Switcher.";

    blur-radius = mkDouble 0.0 "Radius of Blur Applied to the Background Application Switcher.";

    switcher-looping-method = mkStr "Flip Stack" "How the windows cycle through the coverflow (Flip Stack, Carousel).";

    switch-application-behaves-like-switch-windows = mkBool false "The application-switcher keybinding action behaves the same as the window-switcher.";

    use-tint = mkBool true "Whether to Use a Tint Color on the Background Application Switcher.";

    tint-color = mkColorOption "(0.0,0.0,0.0)" "Tint Color.";

    switcher-background-color = mkColorOption "(0.0,0.0,0.0)" "Switcher Background Color.";

    tint-blend = mkDouble 0.0 "Amount to Blend Tint Color.";

    tint-use-theme-color = mkBool true "Use theme color for tint.";

    use-glitch-effect = mkBool false "Use a 'glitch effect' on the background application switcher.";

    invert-swipes = mkBool false "Invert System Scroll Direction Setting.";

    highlight-color = mkColorOption "(1.0,1.0,1.0)" "Highlight Color.";

    coverflow-switch-windows = mkStrList [ "" ] "Switch Windows Keyboard Shortcut.";

    coverflow-switch-windows-backward = mkStrList [ "" ] "Switch Windows Backward Keyboard Shortcut.";

    coverflow-switch-applications = mkStrList [ "" ] "Switch Applications Keyboard Shortcut.";

    coverflow-switch-applications-backward = mkStrList [
      ""
    ] "Switch Applications Backward Keyboard Shortcut.";

    prefs-default-width = mkDouble 700.0 "Default width for the preferences window.";

    prefs-default-height = mkDouble 600.0 "Default height for the preferences window.";

    verbose-logging = mkBool false "Whether to log lots of messages or not.";

    icon-add-remove-effects = mkStr "Fade Only" "Whether to fade, scale, or both fade and scale icons in and out.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.coverflow-alt-tab ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/coverflowalttab" = {
            hide-panel = cfg.hide-panel;
            enforce-primary-monitor = cfg.enforce-primary-monitor;
            animation-time = cfg.animation-time;
            dim-factor = cfg.dim-factor;
            position = cfg.position;
            offset = cfg.offset;
            icon-style = cfg.icon-style;
            overlay-icon-opacity = cfg.overlay-icon-opacity;
            overlay-icon-size = cfg.overlay-icon-size;
            switcher-style = cfg.switcher-style;
            easing-function = cfg.easing-function;
            current-workspace-only = cfg.current-workspace-only;
            switch-per-monitor = cfg.switch-per-monitor;
            icon-has-shadow = cfg.icon-has-shadow;
            randomize-animation-times = cfg.randomize-animation-times;
            preview-to-monitor-ratio = cfg.preview-to-monitor-ratio;
            preview-scaling-factor = cfg.preview-scaling-factor;
            coverflow-window-angle = cfg.coverflow-window-angle;
            coverflow-window-offset-width = cfg.coverflow-window-offset-width;
            bind-to-switch-applications = cfg.bind-to-switch-applications;
            bind-to-switch-windows = cfg.bind-to-switch-windows;
            highlight-mouse-over = cfg.highlight-mouse-over;
            highlight-use-theme-color = cfg.highlight-use-theme-color;
            raise-mouse-over = cfg.raise-mouse-over;
            perspective-correction-method = cfg.perspective-correction-method;
            desaturate-factor = cfg.desaturate-factor;
            blur-radius = cfg.blur-radius;
            switcher-looping-method = cfg.switcher-looping-method;
            switch-application-behaves-like-switch-windows = cfg.switch-application-behaves-like-switch-windows;
            use-tint = cfg.use-tint;
            tint-color = cfg.tint-color;
            switcher-background-color = cfg.switcher-background-color;
            tint-blend = cfg.tint-blend;
            tint-use-theme-color = cfg.tint-use-theme-color;
            use-glitch-effect = cfg.use-glitch-effect;
            invert-swipes = cfg.invert-swipes;
            highlight-color = cfg.highlight-color;
            coverflow-switch-windows = cfg.coverflow-switch-windows;
            coverflow-switch-windows-backward = cfg.coverflow-switch-windows-backward;
            coverflow-switch-applications = cfg.coverflow-switch-applications;
            coverflow-switch-applications-backward = cfg.coverflow-switch-applications-backward;
            prefs-default-width = cfg.prefs-default-width;
            prefs-default-height = cfg.prefs-default-height;
            verbose-logging = cfg.verbose-logging;
            icon-add-remove-effects = cfg.icon-add-remove-effects;
          };
        };
      }
    ];
  };
}
