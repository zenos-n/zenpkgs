{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.lockscreen-extension;

  mkProfileOptions = i: {
    "primary-color-${toString i}" = mkOption {
      type = types.str;
      default = "red";
      description = "Primary gradient color for profile ${toString i}";
    };
    "secondary-color-${toString i}" = mkOption {
      type = types.str;
      default = "orange";
      description = "Secondary gradient color for profile ${toString i}";
    };
    "gradient-direction-${toString i}" = mkOption {
      type = types.str;
      default = "none";
      description = "Vector for the color gradient transition (none, vertical, horizontal)";
    };
    "background-image-path-${toString i}" = mkOption {
      type = types.str;
      default = "none";
      description = "Full filesystem path to the lockscreen background image";
    };
    "background-size-${toString i}" = mkOption {
      type = types.str;
      default = "cover";
      description = "CSS scaling logic for the background (cover, contain)";
    };
    "blur-radius-${toString i}" = mkOption {
      type = types.int;
      default = 0;
      description = "Intensity of the gaussian blur effect (0-100)";
    };
    "blur-brightness-${toString i}" = mkOption {
      type = types.float;
      default = 0.65;
      description = "Luminance multiplier for the blurred background (0.0-1.0)";
    };
    "user-background-${toString i}" = mkOption {
      type = types.bool;
      default = true;
      description = "Permit use of current user wallpaper in this profile";
    };
  };

in
{
  meta = {
    description = ''
      Advanced lock screen background customization for GNOME

      This module installs and configures the **Lockscreen Extension** for GNOME.
      It allows customization of the lock screen background, including blurring,
      brightness, and color gradients for multiple profiles.

      **Features:**
      - Configure up to 4 distinct visual profiles.
      - Customize background images, blur, and brightness.
      - Set gradient colors and directions.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.lockscreen-extension = {
    enable = mkEnableOption "Lockscreen Extension configuration";

    hide-lockscreen-extension-button = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Suppress extension controls on lockscreen

        Whether to hide the profile selection button from the 
        active lockscreen interface.
      '';
    };

    backgrounds-folder-path = mkOption {
      type = types.str;
      default = "";
      description = ''
        Custom image source directory

        Specifies an additional path to scan for potential 
        lockscreen background images.
      '';
    };

    local-share-backgrounds-folder-path = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Scan user backgrounds directory

        Whether to include images found in ~/.local/share/backgrounds.
      '';
    };

    usr-local-share-backgrounds-folder-path = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Scan system local backgrounds

        Whether to include images found in /usr/local/share/backgrounds.
      '';
    };

    usr-share-backgrounds-folder-path = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Scan system global backgrounds

        Whether to include images found in /usr/share/backgrounds.
      '';
    };

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

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.lockscreen-extension ];
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/shell/extensions/lockscreen-extension" = {
          hide-lockscreen-extension-button = cfg.hide-lockscreen-extension-button;
          backgrounds-folder-path = cfg.backgrounds-folder-path;
          local-share-backgrounds-folder-path = cfg.local-share-backgrounds-folder-path;
          usr-local-share-backgrounds-folder-path = cfg.usr-local-share-backgrounds-folder-path;
          usr-share-backgrounds-folder-path = cfg.usr-share-backgrounds-folder-path;
          primary-color-1 = cfg.primary-color-1;
          secondary-color-1 = cfg.secondary-color-1;
          gradient-direction-1 = cfg.gradient-direction-1;
          background-image-path-1 = cfg.background-image-path-1;
          background-size-1 = cfg.background-size-1;
          blur-radius-1 = cfg.blur-radius-1;
          blur-brightness-1 = cfg.blur-brightness-1;
          user-background-1 = cfg.user-background-1;
          primary-color-2 = cfg.primary-color-2;
          secondary-color-2 = cfg.secondary-color-2;
          gradient-direction-2 = cfg.gradient-direction-2;
          background-image-path-2 = cfg.background-image-path-2;
          background-size-2 = cfg.background-size-2;
          blur-radius-2 = cfg.blur-radius-2;
          blur-brightness-2 = cfg.blur-brightness-2;
          user-background-2 = cfg.user-background-2;
          primary-color-3 = cfg.primary-color-3;
          secondary-color-3 = cfg.secondary-color-3;
          gradient-direction-3 = cfg.gradient-direction-3;
          background-image-path-3 = cfg.background-image-path-3;
          background-size-3 = cfg.background-size-3;
          blur-radius-3 = cfg.blur-radius-3;
          blur-brightness-3 = cfg.blur-brightness-3;
          user-background-3 = cfg.user-background-3;
          primary-color-4 = cfg.primary-color-4;
          secondary-color-4 = cfg.secondary-color-4;
          gradient-direction-4 = cfg.gradient-direction-4;
          background-image-path-4 = cfg.background-image-path-4;
          background-size-4 = cfg.background-size-4;
          blur-radius-4 = cfg.blur-radius-4;
          blur-brightness-4 = cfg.blur-brightness-4;
          user-background-4 = cfg.user-background-4;
        };
      }
    ];
  };
}
