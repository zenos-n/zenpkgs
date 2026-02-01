{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.rounded-window-corners-reborn;

  # --- Hex Color Parsing Helpers ---
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

  # Main converter: Hex String -> [ R G B A ] (Floats 0.0 - 1.0)
  parseHexColor =
    s:
    let
      hex = lib.removePrefix "#" s;
      len = builtins.stringLength hex;
      norm = v: v / 255.0;
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

  # --- Serialization Logic ---
  mkVariant = v: "<${v}>";
  mkString = v: "'${v}'";
  mkUint32 = v: "uint32 ${toString v}";

  serializeFloat =
    v:
    let
      s = toString v;
    in
    if builtins.match ".*\\..*" s == null then "${s}.0" else s;

  serializeGlobalSettings =
    settings:
    let
      paddingStr =
        let
          pairs = mapAttrsToList (k: v: "${mkString k}: ${mkVariant (mkUint32 v)}") settings.padding;
        in
        mkVariant "{${concatStringsSep ", " pairs}}";

      keepStr =
        let
          pairs = mapAttrsToList (
            k: v: "${mkString k}: ${mkVariant (if v then "true" else "false")}"
          ) settings.keepRoundedCorners;
        in
        mkVariant "{${concatStringsSep ", " pairs}}";

      colorStr = mkVariant "[${concatMapStringsSep ", " serializeFloat settings.borderColor}]";

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

  # --- Submodules ---
  paddingSubmodule = types.submodule {
    options = {
      left = mkOption {
        type = types.int;
        default = 1;
        description = "Left padding";
      };
      right = mkOption {
        type = types.int;
        default = 1;
        description = "Right padding";
      };
      top = mkOption {
        type = types.int;
        default = 1;
        description = "Top padding";
      };
      bottom = mkOption {
        type = types.int;
        default = 1;
        description = "Bottom padding";
      };
    };
  };

  keepRoundedSubmodule = types.submodule {
    options = {
      maximized = mkOption {
        type = types.bool;
        default = false;
        description = "Keep rounded corners when maximized";
      };
      fullscreen = mkOption {
        type = types.bool;
        default = false;
        description = "Keep rounded corners when fullscreen";
      };
    };
  };

  globalSettingsSubmodule = types.submodule {
    options = {
      enabled = mkOption {
        type = types.bool;
        default = true;
        description = "Enable rounded corners";
      };
      borderRadius = mkOption {
        type = types.int;
        default = 12;
        description = "Border radius";
      };
      smoothing = mkOption {
        type = types.int;
        default = 0;
        description = "Corner smoothing";
      };
      borderColor = mkOption {
        type = types.either (types.listOf types.float) types.str;
        default = [
          0.5
          0.5
          0.5
          1.0
        ];
        description = "Border color (Hex string or list of floats)";
        apply = v: if builtins.isString v then parseHexColor v else v;
      };
      padding = mkOption {
        type = paddingSubmodule;
        default = { };
        description = "Padding settings";
      };
      keepRoundedCorners = mkOption {
        type = keepRoundedSubmodule;
        default = { };
        description = "Keep rounded corners settings";
      };
    };
  };

  shadowSubmodule = types.submodule {
    options = {
      horizontalOffset = mkOption {
        type = types.int;
        default = 0;
        description = "Horizontal offset";
      };
      verticalOffset = mkOption {
        type = types.int;
        default = 4;
        description = "Vertical offset";
      };
      blurOffset = mkOption {
        type = types.int;
        default = 28;
        description = "Blur offset";
      };
      spreadRadius = mkOption {
        type = types.int;
        default = 4;
        description = "Spread radius";
      };
      opacity = mkOption {
        type = types.int;
        default = 60;
        description = "Shadow opacity (0-100)";
      };
    };
  };

in
{
  meta = {
    description = "Configures the Rounded Window Corners Reborn GNOME extension";
    longDescription = ''
      This module installs and configures the **Rounded Window Corners Reborn** extension for GNOME.
      It adds rounded corners to all windows, simulating a more modern UI aesthetic, with options for
      shadows, borders, and per-app customization.

      **Features:**
      - Adds rounded corners to windows.
      - Configurable border radius, color, and padding.
      - Custom shadow settings for focused and unfocused windows.
      - Blacklist for specific applications.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.rounded-window-corners-reborn = {
    enable = mkEnableOption "Rounded Window Corners Reborn configuration";

    # --- Global Settings ---
    settings = mkOption {
      type = globalSettingsSubmodule;
      default = { };
      description = "Global settings for all windows";
    };

    custom-settings = mkOption {
      type = types.attrsOf globalSettingsSubmodule;
      default = { };
      description = "Custom settings per WM_CLASS";
    };

    # --- Shadows ---
    shadows = {
      focused = mkOption {
        type = shadowSubmodule;
        default = { };
        description = "Shadow settings for focused windows";
      };

      unfocused = mkOption {
        type = shadowSubmodule;
        default = {
          horizontalOffset = 0;
          verticalOffset = 2;
          blurOffset = 12;
          spreadRadius = -1;
          opacity = 65;
        };
        description = "Shadow settings for unfocused windows";
      };
    };

    # --- Exclusions ---
    exclusions = {
      blacklist = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of WM_CLASS instances to skip";
      };

      skip-libadwaita = mkOption {
        type = types.bool;
        default = true;
        description = "Skip Libadwaita applications";
      };

      skip-libhandy = mkOption {
        type = types.bool;
        default = false;
        description = "Skip LibHandy applications";
      };
    };

    # --- General ---
    general = {
      border-width = mkOption {
        type = types.int;
        default = 0;
        description = "Border width";
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Enable debug mode";
      };

      tweak-kitty = mkOption {
        type = types.bool;
        default = false;
        description = "Tweak for Kitty terminal";
      };

      preferences-entry = mkOption {
        type = types.bool;
        default = false;
        description = "Enable preferences entry";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.rounded-window-corners-reborn ];

    # Standard settings (Simple types and a{si})
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
            settings-version = mkUint32 0; # Forced to 0 as per schema default
            blacklist = cfg.exclusions.blacklist;
            skip-libadwaita-app = cfg.exclusions.skip-libadwaita;
            skip-libhandy-app = cfg.exclusions.skip-libhandy;
            border-width = cfg.general.border-width;
            focused-shadow = cfg.shadows.focused;
            unfocused-shadow = cfg.shadows.unfocused;
            debug-mode = cfg.general.debug;
            tweak-kitty-terminal = cfg.general.tweak-kitty;
            enable-preferences-entry = cfg.general.preferences-entry;
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
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/rounded-window-corners-reborn/global-rounded-corner-settings ${escapeShellArg (serializeGlobalSettings cfg.settings)}

        # Serialize custom settings (dictionary of a{sv})
        ${
          let
            customStr =
              if cfg.custom-settings == { } then
                "{}"
              else
                "{${
                  concatStringsSep ", " (
                    mapAttrsToList (k: v: "${mkString k}: ${mkVariant (serializeGlobalSettings v)}") cfg.custom-settings
                  )
                }}";
          in
          "${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/rounded-window-corners-reborn/custom-rounded-corner-settings ${escapeShellArg customStr}"
        }
      '';
    };
  };
}
