{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.rounded-window-corners-reborn;

  # --- Hex Color Parsing Helpers ---

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

  # --- Helpers ---
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

  # Helper for uint32 options (conceptually int for the user, but serialized differently)
  mkUint =
    default: description:
    mkOption {
      type = types.int;
      default = default;
      description = description;
    };

  mkFloat =
    default: description:
    mkOption {
      type = types.float;
      default = default;
      description = description;
    };

  # --- Submodules for Structured Settings ---

  paddingSubmodule = types.submodule {
    options = {
      left = mkUint 1 "Left padding.";
      right = mkUint 1 "Right padding.";
      top = mkUint 1 "Top padding.";
      bottom = mkUint 1 "Bottom padding.";
    };
  };

  keepRoundedSubmodule = types.submodule {
    options = {
      maximized = mkBool false "Keep rounded corners when maximized.";
      fullscreen = mkBool false "Keep rounded corners when fullscreen.";
    };
  };

  shadowSubmodule = types.submodule {
    options = {
      horizontalOffset = mkInt 0 "Horizontal offset.";
      verticalOffset = mkInt 4 "Vertical offset.";
      blurOffset = mkInt 28 "Blur offset.";
      spreadRadius = mkInt 4 "Spread radius.";
      opacity = mkInt 60 "Shadow opacity (0-100).";
    };
  };

  globalSettingsSubmodule = types.submodule {
    options = {
      padding = mkOption {
        type = paddingSubmodule;
        default = { };
        description = "Padding settings.";
      };
      keepRoundedCorners = mkOption {
        type = keepRoundedSubmodule;
        default = { };
        description = "Keep rounded corners settings.";
      };
      borderRadius = mkUint 12 "Border radius.";
      smoothing = mkUint 0 "Smoothing.";

      # MODIFIED: Accepts List<Float> OR String (Hex)
      borderColor = mkOption {
        type = types.either (types.listOf types.float) types.str;
        default = [
          0.5
          0.5
          0.5
          1.0
        ];
        description = "Border color. Accepts either an RGBA tuple of floats (0.0-1.0) or a Hex string ('#FF0000' / '#FF000088').";
        # The apply function automatically converts hex strings to the required float list
        apply = v: if builtins.isString v then parseHexColor v else v;
      };

      enabled = mkBool true "Enable rounded corners.";
    };
  };

  # --- GVariant Serialization Logic ---

  # Helper to wrap a value in <...>
  mkVariant = v: "<${v}>";
  # Helper to wrap in '...'
  mkString = v: "'${v}'";
  # Explicit uint32 serializer
  mkUint32 = v: "uint32 ${toString v}";

  # Force floats to have decimal points
  serializeFloat =
    v:
    let
      s = toString v;
    in
    if builtins.match ".*\\..*" s == null then "${s}.0" else s;

  # Serializer for the 'global-rounded-corner-settings' complex type
  serializeGlobalSettings =
    settings:
    let
      # Padding: <{'left': <uint32 1>, ...}>
      paddingStr =
        let
          pairs = mapAttrsToList (k: v: "${mkString k}: ${mkVariant (mkUint32 v)}") settings.padding;
        in
        mkVariant "{${concatStringsSep ", " pairs}}";

      # KeepRounded: <{'maximized': <false>, ...}>
      keepStr =
        let
          pairs = mapAttrsToList (
            k: v: "${mkString k}: ${mkVariant (if v then "true" else "false")}"
          ) settings.keepRoundedCorners;
        in
        mkVariant "{${concatStringsSep ", " pairs}}";

      # BorderColor: <[0.5, 0.5, 0.5, 1.0]>
      # Note: settings.borderColor is guaranteed to be a list of floats here due to the 'apply' in mkOption
      colorStr = mkVariant "[${concatMapStringsSep ", " serializeFloat settings.borderColor}]";

      # Construct the main dictionary
      mainDict = {
        padding = paddingStr;
        keepRoundedCorners = keepStr;
        borderRadius = mkVariant (mkUint32 settings.borderRadius);
        smoothing = mkVariant (mkUint32 settings.smoothing);
        borderColor = colorStr;
        enabled = mkVariant (if settings.enabled then "true" else "false");
      };

      finalPairs = mapAttrsToList (k: v: "${mkString k}: ${v}") mainDict;
    in
    "{${concatStringsSep ", " finalPairs}}";

in
{
  options.zenos.desktops.gnome.extensions.rounded-window-corners-reborn = {
    enable = mkEnableOption "Rounded Window Corners Reborn configuration";

    blacklist = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of WM_CLASS instances to skip.";
    };

    skip-libadwaita-app = mkBool true "Skip Libadwaita applications.";
    skip-libhandy-app = mkBool false "Skip LibHandy applications.";
    border-width = mkInt 0 "Border width.";

    global-rounded-corner-settings = mkOption {
      type = globalSettingsSubmodule;
      default = { };
      description = "Global settings for all windows.";
    };

    custom-rounded-corner-settings = mkOption {
      type = types.attrsOf globalSettingsSubmodule;
      default = { };
      description = "Custom settings per WM_CLASS.";
    };

    focused-shadow = mkOption {
      type = shadowSubmodule;
      default = { };
      description = "Shadow settings for focused windows.";
    };

    unfocused-shadow = mkOption {
      type = shadowSubmodule;
      default = {
        horizontalOffset = 0;
        verticalOffset = 2;
        blurOffset = 12;
        spreadRadius = -1;
        opacity = 65;
      };
      description = "Shadow settings for unfocused windows.";
    };

    debug-mode = mkBool false "Enable debug mode.";
    tweak-kitty-terminal = mkBool false "Tweak for Kitty terminal.";
    enable-preferences-entry = mkBool false "Enable preferences entry.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.rounded-window-corners-reborn ];

    # Standard settings (Simple types and a{si})
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
            settings-version = mkUint32 0; # Forced to 0 as per schema default
            blacklist = cfg.blacklist;
            skip-libadwaita-app = cfg.skip-libadwaita-app;
            skip-libhandy-app = cfg.skip-libhandy-app;
            border-width = cfg.border-width;
            focused-shadow = cfg.focused-shadow; # a{si} handles nicely
            unfocused-shadow = cfg.unfocused-shadow;
            debug-mode = cfg.debug-mode;
            tweak-kitty-terminal = cfg.tweak-kitty-terminal;
            enable-preferences-entry = cfg.enable-preferences-entry;
          };
        };
      }
    ];

    # Imperative write for a{sv} complex types
    systemd.user.services.rounded-window-corners-settings = {
      description = "Apply Rounded Window Corners complex configuration";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/rounded-window-corners-reborn/global-rounded-corner-settings ${escapeShellArg (serializeGlobalSettings cfg.global-rounded-corner-settings)}

        # Serialize custom settings (dictionary of a{sv})
        # This serializes the outer dictionary, then reuses serializeGlobalSettings for values
        ${
          let
            customStr =
              if cfg.custom-rounded-corner-settings == { } then
                "{}"
              else
                "{${
                  concatStringsSep ", " (
                    mapAttrsToList (
                      k: v: "${mkString k}: ${mkVariant (serializeGlobalSettings v)}"
                    ) cfg.custom-rounded-corner-settings
                  )
                }}";
          in
          "${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/rounded-window-corners-reborn/custom-rounded-corner-settings ${escapeShellArg customStr}"
        }
      '';
    };
  };
}
