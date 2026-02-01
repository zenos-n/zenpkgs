{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.appindicator;

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

  # --- Serializer Logic for a(sss) ---
  # Type: Array of Tuples (String, String, String)
  # Nix Input: List of Lists of Strings (e.g. [ [ "id" "icon" "path" ] ])
  # GVariant Output: [('id', 'icon', 'path'), ...]

  mkGVariantString = v: "'${v}'";

  serializeCustomIcons =
    icons:
    if icons == [ ] then
      "@a(sss) []"
    else
      let
        # Helper to ensure tuple has exactly 3 elements
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
    description = "Configures the AppIndicator GNOME extension";
    longDescription = ''
      This module installs and configures the **AppIndicator and KStatusNotifierItem Support** extension for GNOME.
      It re-enables the system tray, allowing applications to display icons and menus in the top bar.

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

    legacy-tray-enabled = mkBool true "Enable legacy tray icons support";

    icon-saturation = mkDouble 0.0 "Icon saturation";
    icon-brightness = mkDouble 0.0 "Icon brightness";
    icon-contrast = mkDouble 0.0 "Icon contrast";

    icon-opacity = mkInt 240 "Icon opacity";
    icon-size = mkInt 0 "Icon size in pixels (0 = auto)";
    icon-spacing = mkInt 12 "Icon spacing within the tray";

    tray-pos = mkStr "right" "Position in tray (left/right)";
    tray-order = mkInt 1 "Order in tray";

    custom-icons = mkOption {
      type = types.listOf (types.listOf types.str);
      default = [ ];
      description = "Custom icons as list of [id, icon, path] tuples";
      example = [
        [
          "skype"
          "skype-icon"
          "/path/to/icon.png"
        ]
      ];
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.appindicator ];

    # Standard types mapped directly
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

    # Complex type (a(sss)) handled by systemd service
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
