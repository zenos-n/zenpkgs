{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.zenos.plymouth;

  plymouthTheme = pkgs.zenos-plymouth.override {
    distroName = cfg.distroName;
    releaseVersion = cfg.releaseVersion;
    deviceName = cfg.deviceName;
    icon = cfg.icon;
    color = cfg.color;
  };
in
{
  options.zenos.plymouth = {
    enable = lib.mkEnableOption "ZenOS Plymouth boot animation";
    kernelParams.enable = lib.mkEnableOption "Add quiet and splash to kernel parameters.";

    distroName = lib.mkOption {
      type = lib.types.str;
      default = "ZenOS";
      description = "The OS name displayed on the splash screen.";
    };

    releaseVersion = lib.mkOption {
      type = lib.types.str;
      default = "1.0N";
      description = "The version string displayed below the OS name.";
    };

    deviceName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "The device identifier.";
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
      description = "The device icon displayed on the splash screen.";
    };

    color = lib.mkOption {
      type = lib.types.str;
      default = "C532FF";
      description = "Hex color code for the glow effect (without #).";
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
