{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen;

  # --- Hex Parsing Logic ---
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
        (norm (parseHexByte (substring 0 2 hex)))
        (norm (parseHexByte (substring 2 2 hex)))
        (norm (parseHexByte (substring 4 2 hex)))
        1.0
      ]
    else if len == 8 then
      [
        (norm (parseHexByte (substring 0 2 hex)))
        (norm (parseHexByte (substring 2 2 hex)))
        (norm (parseHexByte (substring 4 2 hex)))
        (norm (parseHexByte (substring 6 2 hex)))
      ]
    else
      throw "Invalid hex color: '${s}'. Must be 6 (RRGGBB) or 8 (RRGGBBAA) characters.";

  # --- Dconf / GVariant Helpers ---

  # Helper to convert a float to a string with decimal point (required for GVariant)
  serializeFloat =
    f:
    let
      s = toString f;
    in
    if builtins.match ".*\\..*" s != null then s else "${s}.0";

  # Helper to standardise input (Hex String or List) -> List of Floats
  normalizeColor = val: if builtins.isString val then parseHexColor val else val;

  # Generates the GVariant tuple string: "(1.0, 1.0, 1.0, 1.0)"
  mkColorVariant =
    val:
    let
      floats = normalizeColor val;
      serialized = map serializeFloat floats;
    in
    "(${concatStringsSep ", " serialized})";

  # --- Option Generators ---
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

  mkFontOpts = defaultSize: {
    color = mkOption {
      type = types.either (types.listOf types.float) types.str;
      default = [
        1.0
        1.0
        1.0
        1.0
      ];
      description = "Text color (RGBA tuple or Hex String)";
    };
    size = mkInt defaultSize "Font size";
    family = mkStr "default" "Font family";
    weight = mkStr "default" "Font weight";
    style = mkStr "default" "Font style";
  };

in
{
  # 1. Options are now OUTSIDE the 'let' block
  options.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen = {
    enable = mkEnableOption "Customize Clock on Lockscreen GNOME extension configuration";

    command = {
      enable = mkBool true "Enable command output.";
      text = mkStr "whoami" "Custom command to execute";
      font = mkFontOpts 48;
    };

    date = {
      enable = mkBool true "Enable date display.";
      text = mkStr "" "Custom date format (GLib DateTime format)";
      font = mkFontOpts 20;
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
      font = mkFontOpts 96;
    };

    hint = {
      enable = mkBool true "Enable hint.";
      font = mkFontOpts 20;
    };
  };

  # 2. Configuration implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.customize-clock-on-lockscreen ];

    # Using 'programs.dconf.profiles' allows setting system-wide defaults.
    # Note: If you are using Home Manager, use 'home-manager.users.<user>.dconf.settings' instead.
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/customize-clock-on-lockscreen" = {
            use-custom-font = true;

            # Toggles
            remove-command-output = !cfg.command.enable;
            remove-time = !cfg.time.enable;
            remove-date = !cfg.date.enable;
            remove-hint = !cfg.hint.enable;

            # General Text
            command = cfg.command.text;
            custom-time-text = cfg.time.text;
            custom-date-text = cfg.date.text;
            clock-style = cfg.time.clock-style;

            # Command Output Styling
            command-output-font-color = lib.gvariant.mkTuple (normalizeColor cfg.command.font.color);
            command-output-font-size = cfg.command.font.size;
            command-output-font-family = cfg.command.font.family;
            command-output-font-weight = cfg.command.font.weight;
            command-output-font-style = cfg.command.font.style;

            # Time Styling
            time-font-color = lib.gvariant.mkTuple (normalizeColor cfg.time.font.color);
            time-font-size = cfg.time.font.size;
            time-font-family = cfg.time.font.family;
            time-font-weight = cfg.time.font.weight;
            time-font-style = cfg.time.font.style;

            # Date Styling
            date-font-color = lib.gvariant.mkTuple (normalizeColor cfg.date.font.color);
            date-font-size = cfg.date.font.size;
            date-font-family = cfg.date.font.family;
            date-font-weight = cfg.date.font.weight;
            date-font-style = cfg.date.font.style;

            # Hint Styling
            hint-font-color = lib.gvariant.mkTuple (normalizeColor cfg.hint.font.color);
            hint-font-size = cfg.hint.font.size;
            hint-font-family = cfg.hint.font.family;
            hint-font-weight = cfg.hint.font.weight;
            hint-font-style = cfg.hint.font.style;
          };
        };
      }
    ];
  };
}
