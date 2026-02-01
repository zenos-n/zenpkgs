{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.dash-to-panel;

  # --- Serializer Logic for a{s*} ---
  mkGVariantString = v: "'${v}'";
  mkGVariantInt = v: toString v;
  mkGVariantDouble =
    v:
    let
      s = toString v;
    in
    if builtins.match ".*\\..*" s == null then "${s}.0" else s;

  # Generic Map Serializer
  serializeMap =
    valFormatter: mapAttrs:
    if mapAttrs == { } then
      "@a{s*} {}" # Generic placeholder, specific type set by usage context
    else
      let
        pairs = mapAttrsToList (k: v: "${mkGVariantString k}: ${valFormatter v}") mapAttrs;
      in
      "{${concatStringsSep ", " pairs}}";

  # Specific Serializers
  serializeMapStrDouble = serializeMap mkGVariantDouble;
  serializeMapStrInt = serializeMap mkGVariantInt;
  serializeMapStrUint = serializeMap (v: "uint32 ${toString v}");

in
{
  meta = {
    description = "Configures the Dash to Panel GNOME extension";
    longDescription = ''
      This module installs and configures the **Dash to Panel** extension for GNOME.
      It combines the Dash and the Top Bar into a single panel, similar to Windows 10/11 or KDE Plasma.

      **Features:**
      - Integrated taskbar and system tray.
      - Highly configurable positioning and sizing.
      - Window previews and indicators.
      - Extensive customization for transparency and styling.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.dash-to-panel = {
    enable = mkEnableOption "Dash to Panel GNOME extension configuration";

    # --- Positioning ---
    positioning = {
      panel-position = mkOption {
        type = types.enum [
          "BOTTOM"
          "TOP"
          "LEFT"
          "RIGHT"
        ];
        default = "BOTTOM";
        description = "Panel position on the screen";
      };

      panel-size = mkOption {
        type = types.int;
        default = 48;
        description = "Panel thickness in pixels";
      };

      panel-lengths = mkOption {
        type = types.str;
        default = "{}";
        description = "Panel lengths (JSON string)";
      };

      panel-sizes = mkOption {
        type = types.str;
        default = "{}";
        description = "Panel sizes (JSON string)";
      };
    };

    # --- Style & Appearance ---
    style = {
      appicon-margin = mkOption {
        type = types.int;
        default = 8;
        description = "App icon margin";
      };

      appicon-padding = mkOption {
        type = types.int;
        default = 4;
        description = "App icon padding";
      };

      dot-position = mkOption {
        type = types.enum [
          "BOTTOM"
          "TOP"
        ];
        default = "BOTTOM";
        description = "Running indicator dot position";
      };

      dot-style-focused = mkOption {
        type = types.enum [
          "METRO"
          "DOTS"
          "SQUARES"
          "DASHES"
          "SEGMENTED"
          "SOLID"
          "CILIORA"
        ];
        default = "METRO";
        description = "Focused running indicator style";
      };

      dot-style-unfocused = mkOption {
        type = types.enum [
          "METRO"
          "DOTS"
          "SQUARES"
          "DASHES"
          "SEGMENTED"
          "SOLID"
          "CILIORA"
        ];
        default = "METRO";
        description = "Unfocused running indicator style";
      };

      transparency = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable custom transparency settings";
        };
        opacity = mkOption {
          type = types.float;
          default = 0.4;
          description = "Panel opacity (0.0 - 1.0)";
        };
        color = mkOption {
          type = types.str;
          default = "#000000";
          description = "Panel background color";
        };
        dynamic = mkOption {
          type = types.bool;
          default = false;
          description = "Enable dynamic opacity";
        };
      };
    };

    # --- Behavior ---
    behavior = {
      isolate-workspaces = mkOption {
        type = types.bool;
        default = false;
        description = "Show only apps from the current workspace";
      };

      isolate-monitors = mkOption {
        type = types.bool;
        default = false;
        description = "Show only apps from the current monitor";
      };

      group-apps = mkOption {
        type = types.bool;
        default = true;
        description = "Group applications";
      };

      click-action = mkOption {
        type = types.str;
        default = "CYCLE-MIN";
        description = "Action when clicking a running app";
      };

      scroll-panel-action = mkOption {
        type = types.str;
        default = "SWITCH_WORKSPACE";
        description = "Action when scrolling on the panel";
      };

      show-window-previews = mkOption {
        type = types.bool;
        default = true;
        description = "Show window previews on hover";
      };
    };

    # --- Intellihide ---
    intellihide = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Intellihide";
      };

      behavior = mkOption {
        type = types.enum [
          "ALL_WINDOWS"
          "FOCUSED_WINDOWS"
          "MAXIMIZED_WINDOWS"
        ];
        default = "FOCUSED_WINDOWS";
        description = "Intellihide behavior mode";
      };

      animation-time = mkOption {
        type = types.int;
        default = 200;
        description = "Animation duration in ms";
      };
    };

    # --- Animations (Advanced) ---
    animations = {
      appicon-hover = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Animate app icon hover";
        };
        convexity = mkOption {
          type = types.attrsOf types.float;
          default = {
            "RIPPLE" = 2.0;
            "PLANK" = 1.0;
          };
          description = "Animation convexity map";
        };
        duration = mkOption {
          type = types.attrsOf types.int;
          default = {
            "SIMPLE" = 160;
            "RIPPLE" = 130;
            "PLANK" = 100;
          };
          description = "Animation duration map";
        };
        extent = mkOption {
          type = types.attrsOf types.int;
          default = {
            "RIPPLE" = 4;
            "PLANK" = 4;
          };
          description = "Animation extent map";
        };
        rotation = mkOption {
          type = types.attrsOf types.int;
          default = {
            "SIMPLE" = 0;
            "RIPPLE" = 10;
            "PLANK" = 0;
          };
          description = "Animation rotation map";
        };
        travel = mkOption {
          type = types.attrsOf types.float;
          default = {
            "SIMPLE" = 0.30;
            "RIPPLE" = 0.40;
            "PLANK" = 0.0;
          };
          description = "Animation travel map";
        };
        zoom = mkOption {
          type = types.attrsOf types.float;
          default = {
            "SIMPLE" = 1.0;
            "RIPPLE" = 1.25;
            "PLANK" = 2.0;
          };
          description = "Animation zoom map";
        };
      };
    };

    # --- Unexposed / Detailed Options (Mapped Flatly) ---
    # These options are kept flat to match the provided structure but can be accessed directly.
    # Users can set these if specific fine-tuning is needed.
    extraSettings = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra settings to pass directly to dconf (keys must match schema)";
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.dash-to-panel ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/dash-to-panel" = {
            # Positioning
            panel-position = cfg.positioning.panel-position;
            panel-size = cfg.positioning.panel-size;
            panel-lengths = cfg.positioning.panel-lengths;
            panel-sizes = cfg.positioning.panel-sizes;

            # Style
            appicon-margin = cfg.style.appicon-margin;
            appicon-padding = cfg.style.appicon-padding;
            dot-position = cfg.style.dot-position;
            dot-style-focused = cfg.style.dot-style-focused;
            dot-style-unfocused = cfg.style.dot-style-unfocused;
            trans-use-custom-opacity = cfg.style.transparency.enable;
            trans-panel-opacity = cfg.style.transparency.opacity;
            trans-bg-color = cfg.style.transparency.color;
            trans-use-dynamic-opacity = cfg.style.transparency.dynamic;

            # Behavior
            isolate-workspaces = cfg.behavior.isolate-workspaces;
            isolate-monitors = cfg.behavior.isolate-monitors;
            group-apps = cfg.behavior.group-apps;
            click-action = cfg.behavior.click-action;
            scroll-panel-action = cfg.behavior.scroll-panel-action;
            show-window-previews = cfg.behavior.show-window-previews;

            # Intellihide
            intellihide = cfg.intellihide.enable;
            intellihide-behaviour = cfg.intellihide.behavior;
            intellihide-animation-time = cfg.intellihide.animation-time;

            # Animations
            animate-appicon-hover = cfg.animations.appicon-hover.enable;

            # Defaults for other common keys
            desktop-line-use-custom-color = false;
            focus-highlight = true;
            stockgs-keep-dash = false;
            show-apps-icon-file = "";
            animate-app-switch = true;
            animate-window-launch = true;
          }
          // cfg.extraSettings;
        };
      }
    ];

    # Complex Types requiring GVariant serialization via systemd oneshot
    systemd.user.services.dash-to-panel-complex-config = {
      description = "Apply Dash to Panel complex configuration";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-convexity ${escapeShellArg (serializeMapStrDouble cfg.animations.appicon-hover.convexity)}
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-duration ${escapeShellArg (serializeMapStrUint cfg.animations.appicon-hover.duration)}
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-extent ${escapeShellArg (serializeMapStrInt cfg.animations.appicon-hover.extent)}
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-rotation ${escapeShellArg (serializeMapStrInt cfg.animations.appicon-hover.rotation)}
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-travel ${escapeShellArg (serializeMapStrDouble cfg.animations.appicon-hover.travel)}
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/dash-to-panel/animate-appicon-hover-animation-zoom ${escapeShellArg (serializeMapStrDouble cfg.animations.appicon-hover.zoom)}
      '';
    };
  };
}
