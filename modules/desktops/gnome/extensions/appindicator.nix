{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.appindicator;

  mkGVariantString = v: "'${v}'";

  serializeCustomIcons =
    icons:
    if icons == [ ] then
      "@a(sss) []"
    else
      let
        serializeTuple =
          tuple:
          if length tuple != 3 then
            throw "Custom icon tuple must have exactly 3 strings: [ id icon path ]"
          else
            "(${concatStringsSep ", " (map mkGVariantString tuple)})";

        serializedList = map serializeTuple icons;
      in
      "[${concatStringsSep ", " serializedList}]";

in
{
  meta = {
    description = ''
      System tray icon support for the GNOME top bar

      This module installs and configures the **AppIndicator and KStatusNotifierItem Support** extension for GNOME. It re-enables the system tray, allowing applications to 
      display icons and menus in the top bar.

      **Features:**
      - Restores legacy tray icon support.
      - Customizable icon appearance (saturation, brightness, opacity).
      - Configurable tray positioning.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.appindicator = {
    enable = mkEnableOption "AppIndicator GNOME extension configuration";

    legacy-tray-enabled = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable legacy tray icon support

        Whether to support older application status icons in the top bar.
      '';
    };

    icon-saturation = mkOption {
      type = types.float;
      default = 0.0;
      description = ''
        Visual saturation of tray icons

        Adjustment level for the color saturation of displayed icons.
      '';
    };

    icon-brightness = mkOption {
      type = types.float;
      default = 0.0;
      description = ''
        Visual brightness of tray icons

        Adjustment level for the brightness of displayed icons.
      '';
    };

    icon-contrast = mkOption {
      type = types.float;
      default = 0.0;
      description = ''
        Visual contrast of tray icons

        Adjustment level for the contrast of displayed icons.
      '';
    };

    icon-opacity = mkOption {
      type = types.int;
      default = 240;
      description = ''
        Alpha transparency of tray icons

        Opacity level from 0 to 255 for icons in the top bar.
      '';
    };

    icon-size = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Fixed size for tray icons

        Icon size in pixels. A value of 0 triggers automatic sizing.
      '';
    };

    icon-spacing = mkOption {
      type = types.int;
      default = 12;
      description = ''
        Horizontal spacing between icons

        Pixel distance between individual status icons within the tray area.
      '';
    };

    tray-pos = mkOption {
      type = types.str;
      default = "right";
      description = ''
        Vertical alignment in the panel

        Panel box position for the tray icons (e.g., 'left', 'right').
      '';
    };

    tray-order = mkOption {
      type = types.int;
      default = 1;
      description = ''
        Ordering index in the panel

        Relative order for placement among other panel items.
      '';
    };

    custom-icons = mkOption {
      type = types.listOf (types.listOf types.str);
      default = [ ];
      description = ''
        Custom icon overrides

        List of [id, icon, path] tuples to manually override application icons.
      '';
      example = [
        [
          "skype"
          "skype-icon"
          "/path/to/icon.png"
        ]
      ];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.appindicator ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/appindicator" = {
            legacy-tray-enabled = cfg.legacy-tray-enabled;
            icon-saturation = cfg.icon-saturation;
            icon-brightness = cfg.icon-brightness;
            icon-contrast = cfg.icon-contrast;
            icon-opacity = cfg.icon-opacity;
            icon-size = cfg.icon-size;
            icon-spacing = cfg.icon-spacing;
            tray-pos = cfg.tray-pos;
            tray-order = cfg.tray-order;
          };
        };
      }
    ];

    systemd.user.services.appindicator-setup = {
      description = "Apply AppIndicator specific configuration";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/appindicator/custom-icons ${escapeShellArg (serializeCustomIcons cfg.custom-icons)}
      '';
    };
  };
}
