{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.dash-to-panel;

  mkGVariantString = v: "'${v}'";
  mkGVariantDouble =
    v:
    let
      s = toString v;
    in
    if builtins.match ".*\\..*" s == null then "${s}.0" else s;

  serializeMap =
    valFormatter: mapAttrs:
    if mapAttrs == { } then
      "@a{s*} {}"
    else
      let
        pairs = mapAttrsToList (k: v: "${mkGVariantString k}: ${valFormatter v}") mapAttrs;
      in
      "{${concatStringsSep ", " pairs}}";

  serializeMapStrDouble = serializeMap mkGVariantDouble;
  serializeMapStrUint = serializeMap (v: "uint32 ${toString v}");
  serializeMapStrInt = serializeMap toString;

  meta = {
    description = ''
      Combined taskbar and panel interface for GNOME Shell

      This module installs and configures the **Dash to Panel** extension for GNOME.
      It combines the Dash and the Top Bar into a single panel, similar to 
      Windows or KDE Plasma.

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
in
{

  options.zenos.desktops.gnome.extensions.dash-to-panel = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Dash to Panel GNOME extension configuration";

    positioning = {
      panel-position = mkOption {
        type = types.enum [
          "BOTTOM"
          "TOP"
          "LEFT"
          "RIGHT"
        ];
        default = "BOTTOM";
        description = "Anchor edge for the consolidated panel";
      };
      panel-size = mkOption {
        type = types.int;
        default = 48;
        description = "Consolidated panel thickness in pixels";
      };
      panel-lengths = mkOption {
        type = types.str;
        default = "{}";
        description = "Per-monitor panel lengths (JSON)";
      };
      panel-sizes = mkOption {
        type = types.str;
        default = "{}";
        description = "Per-monitor panel thicknesses (JSON)";
      };
    };

    style = {
      appicon-margin = mkOption {
        type = types.int;
        default = 8;
        description = "Pixel margin around application icons";
      };
      appicon-padding = mkOption {
        type = types.int;
        default = 4;
        description = "Internal padding for application icons";
      };
      dot-position = mkOption {
        type = types.enum [
          "BOTTOM"
          "TOP"
        ];
        default = "BOTTOM";
        description = "Placement of the active window marker";
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
        description = "Visual style of the focused app marker";
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
        description = "Visual style of unfocused app markers";
      };
      transparency = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable shell theme transparency overrides";
        };
        opacity = mkOption {
          type = types.float;
          default = 0.4;
          description = "Fixed panel alpha transparency (0.0-1.0)";
        };
        color = mkOption {
          type = types.str;
          default = "#000000";
          description = "Custom panel background color (Hex)";
        };
        dynamic = mkOption {
          type = types.bool;
          default = false;
          description = "Adjust opacity based on window proximity";
        };
      };
    };

    behavior = {
      isolate-workspaces = mkOption {
        type = types.bool;
        default = false;
        description = "Filter items by current desktop";
      };
      isolate-monitors = mkOption {
        type = types.bool;
        default = false;
        description = "Filter items by hardware monitor";
      };
      group-apps = mkOption {
        type = types.bool;
        default = true;
        description = "Unify multiple windows under one icon";
      };
      click-action = mkOption {
        type = types.str;
        default = "CYCLE-MIN";
        description = "Primary interaction button behavior";
      };
      scroll-panel-action = mkOption {
        type = types.str;
        default = "SWITCH_WORKSPACE";
        description = "Mouse scroll wheel behavior on the panel";
      };
      show-window-previews = mkOption {
        type = types.bool;
        default = true;
        description = "Show live thumbnails on icon hover";
      };
    };

    intellihide = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Hide panel when obstructed by windows";
      };
      behavior = mkOption {
        type = types.enum [
          "ALL_WINDOWS"
          "FOCUSED_WINDOWS"
          "MAXIMIZED_WINDOWS"
        ];
        default = "FOCUSED_WINDOWS";
        description = "Hiding trigger policy";
      };
      animation-time = mkOption {
        type = types.int;
        default = 200;
        description = "Visual transition time in milliseconds";
      };
    };

    animations = {
      appicon-hover = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable mouse hover animations for icons";
        };
        convexity = mkOption {
          type = types.attrsOf types.float;
          default = {
            "RIPPLE" = 2.0;
            "PLANK" = 1.0;
          };
          description = "Deformation curvature map";
        };
        duration = mkOption {
          type = types.attrsOf types.int;
          default = {
            "SIMPLE" = 160;
            "RIPPLE" = 130;
            "PLANK" = 100;
          };
          description = "Animation speed map";
        };
        extent = mkOption {
          type = types.attrsOf types.int;
          default = {
            "RIPPLE" = 4;
            "PLANK" = 4;
          };
          description = "Animation spread map";
        };
        rotation = mkOption {
          type = types.attrsOf types.int;
          default = {
            "SIMPLE" = 0;
            "RIPPLE" = 10;
            "PLANK" = 0;
          };
          description = "Icon rotation map";
        };
        travel = mkOption {
          type = types.attrsOf types.float;
          default = {
            "SIMPLE" = 0.30;
            "RIPPLE" = 0.40;
            "PLANK" = 0.0;
          };
          description = "Translation distance map";
        };
        zoom = mkOption {
          type = types.attrsOf types.float;
          default = {
            "SIMPLE" = 1.0;
            "RIPPLE" = 1.25;
            "PLANK" = 2.0;
          };
          description = "Scale factor map";
        };
      };
    };

    extraSettings = mkOption {
      type = types.attrs;
      default = { };
      description = "Direct schema-key overrides for dconf";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.dash-to-panel ];
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/shell/extensions/dash-to-panel" = {
          panel-position = cfg.positioning.panel-position;
          panel-size = cfg.positioning.panel-size;
          panel-lengths = cfg.positioning.panel-lengths;
          panel-sizes = cfg.positioning.panel-sizes;
          appicon-margin = cfg.style.appicon-margin;
          appicon-padding = cfg.style.appicon-padding;
          dot-position = cfg.style.dot-position;
          dot-style-focused = cfg.style.dot-style-focused;
          dot-style-unfocused = cfg.style.dot-style-unfocused;
          trans-use-custom-opacity = cfg.style.transparency.enable;
          trans-panel-opacity = cfg.style.transparency.opacity;
          trans-bg-color = cfg.style.transparency.color;
          trans-use-dynamic-opacity = cfg.style.transparency.dynamic;
          isolate-workspaces = cfg.behavior.isolate-workspaces;
          isolate-monitors = cfg.behavior.isolate-monitors;
          group-apps = cfg.behavior.group-apps;
          click-action = cfg.behavior.click-action;
          scroll-panel-action = cfg.behavior.scroll-panel-action;
          show-window-previews = cfg.behavior.show-window-previews;
          intellihide = cfg.intellihide.enable;
          intellihide-behaviour = cfg.intellihide.behavior;
          intellihide-animation-time = cfg.intellihide.animation-time;
          animate-appicon-hover = cfg.animations.appicon-hover.enable;
          desktop-line-use-custom-color = false;
          animate-app-switch = true;
        }
        // cfg.extraSettings;
      }
    ];

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
