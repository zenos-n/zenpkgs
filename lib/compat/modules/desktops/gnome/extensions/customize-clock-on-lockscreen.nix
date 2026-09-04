{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen;

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
  parseHexByte =
    s:
    (if builtins.hasAttr (substring 0 1 s) hexToDecMap then hexToDecMap.${substring 0 1 s} else 0) * 16
    + (if builtins.hasAttr (substring 1 1 s) hexToDecMap then hexToDecMap.${substring 1 1 s} else 0);
  serializeFloat =
    f:
    let
      s = toString f;
    in
    if builtins.match ".*\\..*" s != null then s else "${s}.0";

  toRgbaString =
    val:
    if builtins.isString val && (substring 0 1 val == "#") then
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

  mkFontOptions =
    { defaultSize, defaultColor }:
    {
      color = mkOption {
        type = types.str;
        default = defaultColor;
        description = "CSS color (Hex or RGBA)";
      };
      size = mkOption {
        type = types.int;
        default = defaultSize;
        description = "Font size in points (20-96)";
      };
      family = mkOption {
        type = types.str;
        default = "Default";
        description = "Font family name";
      };
      weight = mkOption {
        type = types.str;
        default = "Default";
        description = "Typography weight";
      };
      style = mkOption {
        type = types.str;
        default = "Default";
        description = "Typography style";
      };
    };

  meta = {
    description = ''
      Fine-grained typography control for the GNOME lock screen

      This module installs and configures the **Customize Clock on Lockscreen** extension for GNOME. It allows extensive customization of the clock, 
      date, and hint text on the lock screen.

      **Features:**
      - Run custom commands to display text (e.g., `whoami`).
      - Customize clock style (Digital, Analog, LED).
      - Adjust fonts and colors for all elements.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Customize Clock on Lockscreen GNOME extension configuration";

    command = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Display output from a custom shell command";
      };
      text = mkOption {
        type = types.str;
        default = "whoami";
        description = "Shell command to execute for output display";
      };
      font = mkFontOptions {
        defaultSize = 48;
        defaultColor = "rgba(255, 244, 177, 1.0)";
      };
    };

    time = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Show the lock screen clock";
      };
      text = mkOption {
        type = types.str;
        default = "";
        description = "Custom strftime format pattern";
      };
      style = mkOption {
        type = types.enum [
          "digital"
          "analog"
          "led"
        ];
        default = "digital";
        description = "Clock face rendering style";
      };
      font = mkFontOptions {
        defaultSize = 96;
        defaultColor = "rgba(160, 230, 163, 1.0)";
      };
    };

    date = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Show the lock screen date";
      };
      text = mkOption {
        type = types.str;
        default = "";
        description = "Custom date format pattern";
      };
      font = mkFontOptions {
        defaultSize = 28;
        defaultColor = "rgba(242, 92, 84, 1.0)";
      };
    };

    hint = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Show the 'swipe up to unlock' hint";
      };
      font = mkFontOptions {
        defaultSize = 20;
        defaultColor = "rgba(212, 237, 138, 1.0)";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.customize-clock-on-lock-screen ];
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/shell/extensions/customize-clock-on-lockscreen" = {
          remove-command-output = !cfg.command.enable;
          remove-time = !cfg.time.enable;
          remove-date = !cfg.date.enable;
          remove-hint = !cfg.hint.enable;
          command = cfg.command.text;
          custom-time-text = cfg.time.text;
          custom-date-text = cfg.date.text;
          clock-style = cfg.time.style;
          command-output-font-color = toRgbaString cfg.command.font.color;
          command-output-font-size = lib.gvariant.mkInt32 cfg.command.font.size;
          command-output-font-family = cfg.command.font.family;
          command-output-font-weight = cfg.command.font.weight;
          command-output-font-style = cfg.command.font.style;
          time-font-color = toRgbaString cfg.time.font.color;
          time-font-size = lib.gvariant.mkInt32 cfg.time.font.size;
          time-font-family = cfg.time.font.family;
          time-font-weight = cfg.time.font.weight;
          time-font-style = cfg.time.font.style;
          date-font-color = toRgbaString cfg.date.font.color;
          date-font-size = lib.gvariant.mkInt32 cfg.date.font.size;
          date-font-family = cfg.date.font.family;
          date-font-weight = cfg.date.font.weight;
          date-font-style = cfg.date.font.style;
          hint-font-color = toRgbaString cfg.hint.font.color;
          hint-font-size = lib.gvariant.mkInt32 cfg.hint.font.size;
          hint-font-family = cfg.hint.font.family;
          hint-font-weight = cfg.hint.font.weight;
          hint-font-style = cfg.hint.font.style;
        };
      }
    ];
  };
}
