{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.boot.loader.zenboot;

  zenbootPkg = pkgs.system.zenboot.override {
    inherit (cfg)
      resolution
      scannedDevices
      extraIncludedFiles
      extraConfig
      timeout
      use_nvram
      enable_mouse
      maxGenrations
      osIcon
      ;

    espMountPoint = config.boot.loader.efi.efiSysMountPoint;
    profileDir = "/nix/var/nix/profiles/system";
  };
in
{
  options.boot.loader.zenboot = {
    enable = mkEnableOption "ZenBoot (ZenOS Bootloader)";

    osIcon = mkOption {
      type = types.enum [
        "zenos"
        "freebsd"
        "usb"
        "unknown"
        "android"
        "arch"
        "windows"
        "mac"
      ];
      default = "zenos";
      description = "Icon name for the OS in the boot menu.";
    };

    resolution = mkOption {
      type = types.str;
      default = "max";
      description = "Screen resolution for rEFInd (e.g., '1920 1080' or 'max').";
    };

    timeout = mkOption {
      type = types.int;
      default = 5;
      description = "Boot menu timeout in seconds.";
    };

    maxGenrations = mkOption {
      type = types.int;
      default = 10;
      description = "Number of generations to include in the boot menu.";
    };

    use_nvram = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to write variables to NVRAM (efibootmgr).";
    };

    enable_mouse = mkOption {
      type = types.bool;
      default = true;
      description = "Enable mouse support in the boot menu.";
    };

    scannedDevices = mkOption {
      type = types.listOf types.enum [
        "internal"
        "external"
        "optical"
        "netboot"
        "hdbios"
        "biosexternal"
        "cd"
        "manual"
        "firmware"
      ];
      default = [
        "external"
        "optical"
        "manual"
      ];
      description = "Comma-separated list of device types to scan (passed to 'scanfor').";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration lines appended to refind.conf.";
    };

    extraIncludedFiles = mkOption {
      type = types.nullOr (types.attrsOf types.path);
      default = null;
      description = "Attribute set of extra config files to include.";
    };
  };

  config = mkIf cfg.enable {
    # 1. Disable conflicting loaders
    boot.loader.grub.enable = mkDefault false;
    boot.loader.systemd-boot.enable = mkDefault false;

    # 2. Safety Checks
    assertions = [
      {
        assertion = config.boot.loader.efi.canTouchEfiVariables || !cfg.use_nvram;
        message = "ZenBoot: 'use_nvram' requires 'boot.loader.efi.canTouchEfiVariables' to be true.";
      }
    ];

    # 3. Install the package
    # This ensures the binary wrapper is available in the system path
    environment.systemPackages = [ zenbootPkg ];

    # 4. Activation Script
    # This executes the python setup logic on every 'nixos-rebuild switch'
    system.activationScripts.zenboot = ''
      echo " [ZenBoot] Updating bootloader configuration..."
      ${zenbootPkg}/bin/zenboot-setup
    '';
  };
}
