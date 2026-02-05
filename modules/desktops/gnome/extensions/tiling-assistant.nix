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

  meta = {
    description = ''
      Advanced window snapping and tiling features for GNOME

      This module installs and configures **Tiling Assistant**, which brings advanced 
      window management features to GNOME Shell, similar to Windows' "Snap Assist".

      **Features:**
      - Snap Layouts: Easily tile windows into halves, quarters, or custom layouts.
      - Tiling Grouping: Move or resize tiled windows as a cohesive unit.
      - Screen Edge Tiling: Drag windows to edges to trigger specific snap patterns.
      - Window Previews: See thumbnails of tiled windows for quick selection.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.tiling-assistant = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Tiling Assistant GNOME extension configuration";

    enable-tiling-popup = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Show snapping helper popup

        Whether to display the window picker helper when a window is 
        snapped to a screen edge.
      '';
    };

    active-window-hint = mkOption {
      type = types.int;
      default = 1;
      description = ''
        Visual indicator for focused window

        Configures the style of the border drawn around the active 
        window (0: Disabled, 1: Outer, 2: Inner).
      '';
    };

    window-gap = mkOption {
      type = types.int;
      default = 10;
      description = "Pixel spacing between tiled application windows";
    };

    single-screen-gap = mkOption {
      type = types.int;
      default = 10;
      description = "Pixel spacing between a single tiled window and the screen edges";
    };

    overridden-settings = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        Manual GSettings overrides

        Dictionary of internal extension keys to be forced via GVariant 
        dictionary injection.
      '';
    };

    tile-top-half = mkOption {
      type = types.listOf types.str;
      default = [ "<Super>Up" ];
      description = "Shortcut to snap window to top half";
    };
    tile-bottom-half = mkOption {
      type = types.listOf types.str;
      default = [ "<Super>Down" ];
      description = "Shortcut to snap window to bottom half";
    };
    tile-left-half = mkOption {
      type = types.listOf types.str;
      default = [ "<Super>Left" ];
      description = "Shortcut to snap window to left half";
    };
    tile-right-half = mkOption {
      type = types.listOf types.str;
      default = [ "<Super>Right" ];
      description = "Shortcut to snap window to right half";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.tiling-assistant ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/tiling-assistant" = {
            enable-tiling-popup = cfg.enable-tiling-popup;
            active-window-hint = cfg.active-window-hint;
            window-gap = cfg.window-gap;
            single-screen-gap = cfg.single-screen-gap;
            tile-top-half = cfg.tile-top-half;
            tile-bottom-half = cfg.tile-bottom-half;
            tile-left-half = cfg.tile-left-half;
            tile-right-half = cfg.tile-right-half;
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
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/tiling-assistant/overridden-settings "${escapeShellArg (serializeSettings cfg.overridden-settings)}"
      '';
    };
  };
}
