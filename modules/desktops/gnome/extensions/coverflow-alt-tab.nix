{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.coverflow-alt-tab;

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

  hexCharToInt =
    c: if builtins.hasAttr c hexToDecMap then hexToDecMap.${c} else throw "Invalid hex character: ${c}";

  parseHexByte =
    s: (hexCharToInt (builtins.substring 0 1 s) * 16) + (hexCharToInt (builtins.substring 1 1 s));

  parseHexColor =
    s:
    let
      hex = lib.removePrefix "#" s;
      len = builtins.stringLength hex;
      norm = v: v / 255.0;
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
      throw "Invalid hex color: '${s}'. Must be 6 or 8 chars.";

  serializeFloat =
    v:
    let
      s = toString v;
    in
    if builtins.match ".*\\..*" s == null then "${s}.0" else s;

  listToTupleStr =
    l: "(${serializeFloat (elemAt l 0)},${serializeFloat (elemAt l 1)},${serializeFloat (elemAt l 2)})";

in
{
  meta = {
    description = ''
      3D window switcher with Coverflow and Timeline effects

      This module installs and configures the **Coverflow Alt-Tab** extension for GNOME.
      It replaces the standard Alt-Tab switcher with a visually rich Coverflow 
      or Timeline 3D effect.

      **Features:**
      - 3D Coverflow or Timeline switcher styles.
      - Highly configurable animations, dimming, and scaling.
      - Support for custom tint and background colors.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.coverflow-alt-tab = {
    enable = mkEnableOption "Coverflow Alt-Tab GNOME extension configuration";

    hide-panel = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Hide top bar during transition

        Whether to temporarily suppress the GNOME panel visibility when 
        the switcher is active.
      '';
    };

    enforce-primary-monitor = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Force primary monitor display

        Always render the 3D switcher on the primary display regardless 
        of active window location.
      '';
    };

    animation-time = mkOption {
      type = types.float;
      default = 0.2;
      description = ''
        Transition duration in milliseconds

        Determines the speed of window movements during the Alt-Tab cycle.
      '';
    };

    dim-factor = mkOption {
      type = types.float;
      default = 1.0;
      description = ''
        Background dimming intensity

        Opacity level applied to the desktop background when switching windows.
      '';
    };

    position = mkOption {
      type = types.enum [
        "Top"
        "Bottom"
      ];
      default = "Bottom";
      description = "Vertical alignment of the icon and window title";
    };

    offset = mkOption {
      type = types.int;
      default = 0;
      description = "Custom vertical offset for the switcher interface";
    };

    icon-style = mkOption {
      type = types.enum [
        "Classic"
        "Overlay"
        "Attached"
      ];
      default = "Classic";
      description = "Visual representation style for application icons";
    };

    overlay-icon-opacity = mkOption {
      type = types.float;
      default = 1.0;
      description = "Alpha transparency of the overlayed application icon";
    };

    overlay-icon-size = mkOption {
      type = types.float;
      default = 128.0;
      description = "Pixel size for the application icon inside the switcher";
    };

    switcher-style = mkOption {
      type = types.enum [
        "Coverflow"
        "Timeline"
      ];
      default = "Coverflow";
      description = "3D visual algorithm used to arrange window previews";
    };

    easing-function = mkOption {
      type = types.str;
      default = "ease-out-cubic";
      description = "Mathematical curve used for animation smoothing";
    };

    current-workspace-only = mkOption {
      type = types.enum [
        "current"
        "all"
        "all-currentfirst"
      ];
      default = "current";
      description = ''
        Filter windows by workspace

        Determines whether windows from other virtual desktops are 
        included in the list.
      '';
    };

    switch-per-monitor = mkOption {
      type = types.bool;
      default = false;
      description = "Restricts the switcher to windows on the active monitor";
    };

    icon-has-shadow = mkOption {
      type = types.bool;
      default = false;
      description = "Render drop shadows behind application icons";
    };

    randomize-animation-times = mkOption {
      type = types.bool;
      default = false;
      description = "Apply slight variations to individual window movements";
    };

    preview-to-monitor-ratio = mkOption {
      type = types.float;
      default = 0.5;
      description = "Maximum size of window previews relative to monitor dimensions";
    };

    preview-scaling-factor = mkOption {
      type = types.float;
      default = 0.8;
      description = "Scale factor applied to off-center preview windows";
    };

    coverflow-window-angle = mkOption {
      type = types.float;
      default = 90.0;
      description = "Rotation angle for side-windows in Coverflow mode";
    };

    coverflow-window-offset-width = mkOption {
      type = types.float;
      default = 50.0;
      description = "Horizontal distance from the center for side-windows";
    };

    bind-to-switch-applications = mkOption {
      type = types.bool;
      default = true;
      description = "Override the default application switcher keybinding";
    };

    bind-to-switch-windows = mkOption {
      type = types.bool;
      default = true;
      description = "Override the default window switcher keybinding";
    };

    highlight-mouse-over = mkOption {
      type = types.bool;
      default = false;
      description = "Apply a visual glow when the cursor hovers over a preview";
    };

    highlight-use-theme-color = mkOption {
      type = types.bool;
      default = true;
      description = "Inherit the system accent color for the highlight effect";
    };

    raise-mouse-over = mkOption {
      type = types.bool;
      default = true;
      description = "Bring the hovered window preview to the foreground";
    };

    perspective-correction-method = mkOption {
      type = types.str;
      default = "Move Camera";
      description = "Method for adjusting view for multi-monitor setups";
    };

    desaturate-factor = mkOption {
      type = types.float;
      default = 0.0;
      description = "Color saturation reduction for background elements";
    };

    blur-radius = mkOption {
      type = types.float;
      default = 0.0;
      description = "Gaussian blur radius applied to elements behind the switcher";
    };

    switcher-looping-method = mkOption {
      type = types.enum [
        "Flip Stack"
        "Carousel"
      ];
      default = "Flip Stack";
      description = "Behavior when reaching the end of the window list";
    };

    switch-application-behaves-like-switch-windows = mkOption {
      type = types.bool;
      default = false;
      description = "Unify application and window switching logic";
    };

    use-tint = mkOption {
      type = types.bool;
      default = true;
      description = "Apply a semi-transparent color overlay to the background";
    };

    tint-color = mkOption {
      type = types.str;
      default = "(0.0,0.0,0.0)";
      description = "Overlay tint color (GVariant tuple)";
    };

    switcher-background-color = mkOption {
      type = types.str;
      default = "(0.0,0.0,0.0)";
      description = "Color used for the 3D stage background";
    };

    tint-blend = mkOption {
      type = types.float;
      default = 0.0;
      description = "Blending strength between original background and tint";
    };

    tint-use-theme-color = mkOption {
      type = types.bool;
      default = true;
      description = "Use system accent color as the background tint";
    };

    use-glitch-effect = mkOption {
      type = types.bool;
      default = false;
      description = "Apply a visual noise/glitch filter to the background";
    };

    invert-swipes = mkOption {
      type = types.bool;
      default = false;
      description = "Reverse the logic of touch/scroll gestures";
    };

    highlight-color = mkOption {
      type = types.str;
      default = "(1.0,1.0,1.0)";
      description = "Custom color for the active window highlight";
    };

    coverflow-switch-windows = mkOption {
      type = types.listOf types.str;
      default = [ "" ];
      description = "Primary forward shortcut";
    };
    coverflow-switch-windows-backward = mkOption {
      type = types.listOf types.str;
      default = [ "" ];
      description = "Primary backward shortcut";
    };
    coverflow-switch-applications = mkOption {
      type = types.listOf types.str;
      default = [ "" ];
      description = "Application forward shortcut";
    };
    coverflow-switch-applications-backward = mkOption {
      type = types.listOf types.str;
      default = [ "" ];
      description = "Application backward shortcut";
    };

    prefs-default-width = mkOption {
      type = types.float;
      default = 700.0;
      description = "Preferences window width";
    };
    prefs-default-height = mkOption {
      type = types.float;
      default = 600.0;
      description = "Preferences window height";
    };
    verbose-logging = mkOption {
      type = types.bool;
      default = false;
      description = "Enable detailed debug output";
    };
    icon-add-remove-effects = mkOption {
      type = types.str;
      default = "Fade Only";
      description = "Icon entry/exit animation style";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.coverflow-alt-tab ];
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/shell/extensions/coverflowalttab" = {
          inherit (cfg)
            hide-panel
            enforce-primary-monitor
            animation-time
            dim-factor
            position
            offset
            icon-style
            overlay-icon-opacity
            overlay-icon-size
            switcher-style
            easing-function
            current-workspace-only
            switch-per-monitor
            icon-has-shadow
            randomize-animation-times
            preview-to-monitor-ratio
            preview-scaling-factor
            coverflow-window-angle
            coverflow-window-offset-width
            bind-to-switch-applications
            bind-to-switch-windows
            highlight-mouse-over
            highlight-use-theme-color
            raise-mouse-over
            perspective-correction-method
            desaturate-factor
            blur-radius
            switcher-looping-method
            switch-application-behaves-like-switch-windows
            use-tint
            tint-color
            switcher-background-color
            tint-blend
            tint-use-theme-color
            use-glitch-effect
            invert-swipes
            highlight-color
            coverflow-switch-windows
            coverflow-switch-windows-backward
            coverflow-switch-applications
            coverflow-switch-applications-backward
            prefs-default-width
            prefs-default-height
            verbose-logging
            icon-add-remove-effects
            ;
          shortcut-text =
            if (length cfg.coverflow-switch-applications) > 0 then
              (head cfg.coverflow-switch-applications)
            else
              "";
          preview-size-scale = 0.0;
          workspace-agnostic-urgent-windows = true;
        };
      }
    ];
  };
}
