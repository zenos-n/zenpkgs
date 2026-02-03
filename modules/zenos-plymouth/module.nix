{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.system.boot.plymouth.theme.zenos;

  plymouthTheme = pkgs.zenos.plymouth.override {
    distroName = cfg.distroName;
    releaseVersion = cfg.releaseVersion;
    deviceName = cfg.deviceName;
    icon = cfg.icon;
    color = cfg.color;
  };
in
{
  meta = {
    description = ''
      ZenOS Plymouth boot animation and splash screen configuration

      This module manages the **Plymouth** boot splash screen for ZenOS. 
      It allows for deep customization of the boot experience, including 
      the displayed distribution name, version strings, device-specific 
      icons, and the glow effect color.

      ### Features
      - **Custom Branding:** Set your own OS name and version string.
      - **Device Identity:** Choose from various hardware icons (laptop, desktop, etc.).
      - **Theming:** Customize the glow effect hex color.
      - **Kernel Integration:** Automatically adds 'quiet' and 'splash' parameters.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.system.boot.plymouth.theme.zenos = {
    enable = lib.mkEnableOption "ZenOS Plymouth boot animation";

    distroName = lib.mkOption {
      type = lib.types.str;
      default = "ZenOS";
      description = ''
        Operating system name display

        The primary text label shown below the hostname on the boot screen.
      '';
    };

    releaseVersion = lib.mkOption {
      type = lib.types.str;
      default = "1.0N";
      description = "The version or release string displayed alongside the OS name";
    };

    deviceName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "The device identifier or hostname shown on the boot screen";
    };

    icon = lib.mkOption {
      type = lib.types.enum [
        "negzero"
        "zenos"
        "tablet"
        "laptop"
        "desktop"
        "server"
        "smartphone"
        "zerobox"
        "tv"
      ];
      default = "negzero";
      description = "The hardware or brand icon displayed in the center of the screen";
    };

    color = lib.mkOption {
      type = lib.types.str;
      default = "C532FF";
      description = ''
        Animated glow effect color

        The hex color code (without #) used for the breathing glow effect 
        surrounding the primary icon.
      '';
      example = "FF5555";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      theme = "zenos";
      themePackages = [ plymouthTheme ];
    };
  };
}
