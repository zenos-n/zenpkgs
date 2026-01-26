{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen;

  # --- GVariant & Type Helpers ---
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

  # --- Color Normalization ---
  # The schema expects a string like 'rgba(255, 255, 255, 1.0)'
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

  hexCharToInt = c: if builtins.hasAttr c hexToDecMap then hexToDecMap.${c} else 0;
  parseHexByte =
    s: (hexCharToInt (builtins.substring 0 1 s) * 16) + (hexCharToInt (builtins.substring 1 1 s));

  serializeFloat =
    f:
    let
      s = toString f;
    in
    if builtins.match ".*\\..*" s != null then s else "${s}.0";

  toRgbaString =
    val:
    if builtins.isString val && (builtins.substring 0 1 val == "#") then
      let
        hex = lib.removePrefix "#" val;
        r = toString (parseHexByte (substring 0 2 hex));
        g = toString (parseHexByte (substring 2 2 hex));
        b = toString (parseHexByte (substring 4 2 hex));
        a =
          if (builtins.stringLength hex) == 8 then
            serializeFloat ((parseHexByte (substring 6 2 hex)) / 255.0)
          else
            "1.0";
      in
      "rgba(${r}, ${g}, ${b}, ${a})"
    else
      val;

  # --- Submodule for Font Groups ---
  mkFontOpts =
    { defaultSize, defaultColor }:
    {
      color = mkOption {
        type = types.str;
        default = defaultColor;
        description = "Text color (Hex string like #ffffff or rgba string)";
      };
      size = mkInt defaultSize "Font size (20-96)";
      family = mkStr "Default" "Font family";
      weight = mkStr "Default" "Font weight";
      style = mkStr "Default" "Font style";
    };

in
{
  options.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen = {
    enable = mkEnableOption "Customize Clock on Lockscreen GNOME extension configuration";

    command = {
      enable = mkBool true "Enable custom command output.";
      text = mkStr "whoami" "Command to execute.";
      font = mkFontOpts {
        defaultSize = 48;
        defaultColor = "rgba(255, 244, 177, 1.0)";
      };
    };

    time = {
      enable = mkBool true "Enable time display.";
      text = mkStr "" "Custom clock format (leave empty for default).";
      style = mkOption {
        type = types.enum [
          "digital"
          "analog"
          "led"
        ];
        default = "digital";
        description = "Clock face style.";
      };
      font = mkFontOpts {
        defaultSize = 96;
        defaultColor = "rgba(160, 230, 163, 1.0)";
      };
    };

    date = {
      enable = mkBool true "Enable date display.";
      text = mkStr "" "Custom date format.";
      font = mkFontOpts {
        defaultSize = 28;
        defaultColor = "rgba(242, 92, 84, 1.0)";
      };
    };

    hint = {
      enable = mkBool true "Enable hint text.";
      font = mkFontOpts {
        defaultSize = 20;
        defaultColor = "rgba(212, 237, 138, 1.0)";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.customize-clock-on-lock-screen ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/customize-clock-on-lockscreen" = {
            # Visibility Toggles (Inverted from 'enable' keys)
            remove-command-output = cfg.command.enable == false;
            remove-time = cfg.time.enable == false;
            remove-date = cfg.date.enable == false;
            remove-hint = cfg.hint.enable == false;

            # Content
            command = cfg.command.text;
            custom-time-text = cfg.time.text;
            custom-date-text = cfg.date.text;
            clock-style = cfg.time.style;

            # Command Font
            command-output-font-color = toRgbaString cfg.command.font.color;
            command-output-font-size = lib.gvariant.mkInt32 cfg.command.font.size;
            command-output-font-family = cfg.command.font.family;
            command-output-font-weight = cfg.command.font.weight;
            command-output-font-style = cfg.command.font.style;

            # Time Font
            time-font-color = toRgbaString cfg.time.font.color;
            time-font-size = lib.gvariant.mkInt32 cfg.time.font.size;
            time-font-family = cfg.time.font.family;
            time-font-weight = cfg.time.font.weight;
            time-font-style = cfg.time.font.style;

            # Date Font
            date-font-color = toRgbaString cfg.date.font.color;
            date-font-size = lib.gvariant.mkInt32 cfg.date.font.size;
            date-font-family = cfg.date.font.family;
            date-font-weight = cfg.date.font.weight;
            date-font-style = cfg.date.font.style;

            # Hint Font
            hint-font-color = toRgbaString cfg.hint.font.color;
            hint-font-size = lib.gvariant.mkInt32 cfg.hint.font.size;
            hint-font-family = cfg.hint.font.family;
            hint-font-weight = cfg.hint.font.weight;
            hint-font-style = cfg.hint.font.style;
          };
        };
      }
    ];
  };
}
