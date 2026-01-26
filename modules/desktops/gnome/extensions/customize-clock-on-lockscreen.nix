{
  pkgs,
  lib,
  ...
}:

with lib;

let
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
  cfg = config.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen;
  settings = options.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen;

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

in
{
  options.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen = {
    enable = mkEnableOption "Customize Clock on Lockscreen GNOME extension configuration";

    # --- General Configuration ---
    command = {
      enable = mkBool true "Enable command output.";
      text = mkStr "whoami" "Custom command to execute";
      font = {
        color = mkOption {
          type = types.either (types.listOf types.float) types.str;
          default = [
            1.0
            1.0
            1.0
            1.0
          ];
          description = "Text color for the command output. Either an RGBA tuple of floats or a hex string";
        };
        size = mkInt 48 "";
        family = mkStr "default" "Font family for the command output.";
        weight = mkStr "default" "Font weight for the command output.";
        style = mkStr "default" "Font style for the command output.";
      };
    };
    date = {
      enable = mkBool true "Enable date display.";
      text = mkStr "" "Custom date format (GLib DateTime format)";
      font = {
        color = mkOption {
          type = types.either (types.listOf types.float) types.str;
          default = [
            1.0
            1.0
            1.0
            1.0
          ];
          description = "Text color for the date output. Either an RGBA tuple of floats or a hex string";
        };
        size = mkInt 20 "";
        family = mkStr "default" "Font family for the date.";
        weight = mkStr "default" "Font weight for the date.";
        style = mkStr "default" "Font style for the date.";
      };

    };
    time = {
      enable = mkBool true "Enable time display.";
      text = mkStr "" "Custom time format (GLib DateTime format)";
      clock-style = mkOption {
        type = types.enum [
          "digital"
          "analog"
          "led"
        ];
        default = "digital";
        description = "Clock style";
      };
      font = {
        color = mkOption {
          type = types.either (types.listOf types.float) types.str;
          default = [
            1.0
            1.0
            1.0
            1.0
          ];
          description = "Text color for the time. Either an RGBA tuple of floats or a hex string";
        };
        size = mkInt 96 "";
        family = mkStr "default" "Font family for the time.";
        weight = mkStr "default" "Font weight for the time.";
        style = mkStr "default" "Font style for the time.";
      };

    };
    hint = {
      enable = mkBool true "Enable hint.";
      font = {
        color = mkOption {
          type = types.either (types.listOf types.float) types.str;
          default = [
            1.0
            1.0
            1.0
            1.0
          ];
          description = "Text color for the hint. Either an RGBA tuple of floats or a hex string";
        };
        size = mkInt 20 "";
        family = mkStr "default" "Font family for the hint.";
        weight = mkStr "default" "Font weight for the hint.";
        style = mkStr "default" "Font style for the hint.";
      };
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.customize-clock-on-lockscreen ];
    color = {
      date = mkVariant "[${concatMapStringsSep ", " serializeFloat settings.date.font.color}]";
      time = mkVariant "[${concatMapStringsSep ", " serializeFloat settings.time.font.color}]";
      hint = mkVariant "[${concatMapStringsSep ", " serializeFloat settings.hint.font.color}]";
      command = mkVariant "[${concatMapStringsSep ", " serializeFloat settings.command.font.color}]";
    };

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/customize-clock-on-lockscreen" = {
            # Toggles
            remove-command-output = !settings.command.enable;
            remove-time = !settings.time.enable;
            remove-date = !settings.date.enable;
            remove-hint = !settings.hint.enable;

            # General
            command = settings.command.text;
            custom-time-text = settings.time.text;
            custom-date-text = settings.date.text;
            clock-style = settings.time.clock-style;

            # Command Output
            command-output-font-color = color.command;
            command-output-font-size = settings.command.font.size;
            command-output-font-family = settings.command.font.family;
            command-output-font-weight = settings.command.font.weight;
            command-output-font-style = settings.command.font.style;

            # Time
            time-font-color = color.time;
            time-font-size = settings.time.font.size;
            time-font-family = settings.time.font.family;
            time-font-weight = settings.time.font.weight;
            time-font-style = settings.time.font.style;

            # Date
            date-font-color = color.date;
            date-font-size = settings.date-font-size;
            date-font-family = settings.date.font.family;
            date-font-weight = settings.date.font.weight;
            date-font-style = settings.date.font.style;

            # Hint
            hint-font-color = color.hint;
            hint-font-size = settings.hint.font.size;
            hint-font-family = settings.hint.font.family;
            hint-font-weight = settings.hint.font.weight;
            hint-font-style = settings.hint.font.style;
          };
        };
      }
    ];
  };
}
