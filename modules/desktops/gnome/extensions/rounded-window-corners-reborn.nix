{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.rounded-window-corners-reborn;

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
      borderColor = mkOption {
        type = types.listOf types.float;
        default = [
          0.5
          0.5
          0.5
          1.0
        ];
        description = "Border color (RGBA tuple).";
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
