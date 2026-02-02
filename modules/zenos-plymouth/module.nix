{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.system.boot.plymouth.theme.zenos;

  # Reference the Plymouth theme package from the ZenOS package set
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
    description = "Configures the ZenOS Plymouth boot animation and splash screen";
    longDescription = ''
      This module manages the **Plymouth** boot splash screen for ZenOS. 
      It allows for deep customization of the boot experience, including the 
      displayed distribution name, version strings, device-specific icons, 
      and the glow effect color.

      ### Features
      - **Custom Branding:** Set your own OS name and version string.
      - **Device Identity:** Choose from various hardware icons (laptop, desktop, smartphone, etc.).
      - **Theming:** Customize the glow effect hex color.
      - **Kernel Integration:** Optionally adds `quiet` and `splash` to boot parameters.

      Integrates with the `boot.plymouth` NixOS subsystem.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.system.boot.plymouth.theme.zenos = {
    enable = lib.mkEnableOption "ZenOS Plymouth boot animation";

    kernelParams = {
      enable = lib.mkEnableOption "automatic addition of 'quiet' and 'splash' to kernel parameters";
    };

    distroName = lib.mkOption {
      type = lib.types.str;
      default = "ZenOS";
      description = "The operating system name displayed prominently on the splash screen";
    };

    releaseVersion = lib.mkOption {
      type = lib.types.str;
      default = "1.0N";
      description = "The version or release string displayed below the OS name";
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
      description = "The hardware or brand icon displayed in the center of the splash screen";
    };

    color = lib.mkOption {
      type = lib.types.str;
      default = "C532FF";
      description = "The hex color code (without #) used for the animated glow effect";
      example = "FF5555";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      theme = "zenos";
      themePackages = [ plymouthTheme ];
    };

    boot.kernelParams = lib.mkIf cfg.kernelParams.enable [
      "quiet"
      "splash"
    ];
  };
}
