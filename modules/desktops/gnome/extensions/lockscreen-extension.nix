{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.lockscreen-extension;

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

  # Helper to generate options for the numbered profiles (1-4) to reduce repetition in this file
  # while keeping the resulting options flat and explicit.
  mkProfileOptions = i: {
    "primary-color-${toString i}" = mkStr "red" "Primary color for profile ${toString i}.";
    "secondary-color-${toString i}" = mkStr "orange" "Secondary color for profile ${toString i}.";
    "gradient-direction-${toString i}" = mkStr "none" "Gradient direction for profile ${toString i}.";
    "background-image-path-${toString i}" =
      mkStr "none" "Background image path for profile ${toString i}.";
    "background-size-${toString i}" =
      mkStr "cover" "Background size (e.g., cover, contain) for profile ${toString i}.";
    "blur-radius-${toString i}" = mkInt 0 "Blur radius (0-100) for profile ${toString i}.";
    "blur-brightness-${toString i}" =
      mkDouble 0.65 "Blur brightness (0.0-1.0) for profile ${toString i}.";
    "user-background-${toString i}" = mkBool true "Use user background for profile ${toString i}.";
  };

in
{
  options.zenos.desktops.gnome.extensions.lockscreen-extension = {
    enable = mkEnableOption "Lockscreen Extension configuration";

    # --- Global Settings ---
    hide-lockscreen-extension-button = mkBool false "Hide the extension button on the lockscreen.";
    backgrounds-folder-path = mkStr "" "Custom path for backgrounds folder.";
    local-share-backgrounds-folder-path = mkBool true "Search in ~/.local/share/backgrounds.";
    usr-local-share-backgrounds-folder-path = mkBool true "Search in /usr/local/share/backgrounds.";
    usr-share-backgrounds-folder-path = mkBool true "Search in /usr/share/backgrounds.";

    # --- Profile 1 ---
    inherit (mkProfileOptions 1)
      primary-color-1
      secondary-color-1
      gradient-direction-1
      background-image-path-1
      background-size-1
      blur-radius-1
      blur-brightness-1
      user-background-1
      ;

    # --- Profile 2 ---
    inherit (mkProfileOptions 2)
      primary-color-2
      secondary-color-2
      gradient-direction-2
      background-image-path-2
      background-size-2
      blur-radius-2
      blur-brightness-2
      user-background-2
      ;

    # --- Profile 3 ---
    inherit (mkProfileOptions 3)
      primary-color-3
      secondary-color-3
      gradient-direction-3
      background-image-path-3
      background-size-3
      blur-radius-3
      blur-brightness-3
      user-background-3
      ;

    # --- Profile 4 ---
    inherit (mkProfileOptions 4)
      primary-color-4
      secondary-color-4
      gradient-direction-4
      background-image-path-4
      background-size-4
      blur-radius-4
      blur-brightness-4
      user-background-4
      ;
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.lockscreen-extension ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/lockscreen-extension" = {
            # Globals
            hide-lockscreen-extension-button = cfg.hide-lockscreen-extension-button;
            backgrounds-folder-path = cfg.backgrounds-folder-path;
            local-share-backgrounds-folder-path = cfg.local-share-backgrounds-folder-path;
            usr-local-share-backgrounds-folder-path = cfg.usr-local-share-backgrounds-folder-path;
            usr-share-backgrounds-folder-path = cfg.usr-share-backgrounds-folder-path;

            # Profile 1
            primary-color-1 = cfg.primary-color-1;
            secondary-color-1 = cfg.secondary-color-1;
            gradient-direction-1 = cfg.gradient-direction-1;
            background-image-path-1 = cfg.background-image-path-1;
            background-size-1 = cfg.background-size-1;
            blur-radius-1 = cfg.blur-radius-1;
            blur-brightness-1 = cfg.blur-brightness-1;
            user-background-1 = cfg.user-background-1;

            # Profile 2
            primary-color-2 = cfg.primary-color-2;
            secondary-color-2 = cfg.secondary-color-2;
            gradient-direction-2 = cfg.gradient-direction-2;
            background-image-path-2 = cfg.background-image-path-2;
            background-size-2 = cfg.background-size-2;
            blur-radius-2 = cfg.blur-radius-2;
            blur-brightness-2 = cfg.blur-brightness-2;
            user-background-2 = cfg.user-background-2;

            # Profile 3
            primary-color-3 = cfg.primary-color-3;
            secondary-color-3 = cfg.secondary-color-3;
            gradient-direction-3 = cfg.gradient-direction-3;
            background-image-path-3 = cfg.background-image-path-3;
            background-size-3 = cfg.background-size-3;
            blur-radius-3 = cfg.blur-radius-3;
            blur-brightness-3 = cfg.blur-brightness-3;
            user-background-3 = cfg.user-background-3;

            # Profile 4
            primary-color-4 = cfg.primary-color-4;
            secondary-color-4 = cfg.secondary-color-4;
            gradient-direction-4 = cfg.gradient-direction-4;
            background-image-path-4 = cfg.background-image-path-4;
            background-size-4 = cfg.background-size-4;
            blur-radius-4 = cfg.blur-radius-4;
            blur-brightness-4 = cfg.blur-brightness-4;
            user-background-4 = cfg.user-background-4;
          };
        };
      }
    ];
  };
}
