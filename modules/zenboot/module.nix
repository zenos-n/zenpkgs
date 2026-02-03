{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.system.boot.loader.zenboot;

  brandingCfg =
    config.zenos.branding or {
      prettyName = null;
      icon = null;
    };
  finalDeviceName =
    if brandingCfg.prettyName != null then brandingCfg.prettyName else config.networking.hostName;
  finalIcon = if brandingCfg.icon != null then brandingCfg.icon else "negzero";

  zenbootPkg = pkgs.zenos.zenboot.override {
    inherit (cfg)
      resolution
      scannedDevices
      extraIncludedFiles
      extraConfig
      timeout
      use_nvram
      enable_mouse
      maxGenerations
      osIcon
      ;

    espMountPoint = config.zenos.system.boot.loader.efi.efiSysMountPoint;
    profileDir = "/nix/var/nix/profiles/system";
  };

  zenosPlymouthPkg = pkgs.zenos.theming.system.zenos-plymouth.override {
    distroName = cfg.distroName;
    releaseVersion = config.system.nixos.label;
    deviceName = finalDeviceName;
    icon = finalIcon;
    color = cfg.plymouth.color;
  };
in
{
  meta = {
    description = ''
      ZenOS Bootloader (ZenBoot) configuration module

      Configures ZenBoot, the primary bootloader management system for ZenOS. 
      It handles the generation of EFI entries, Plymouth integration, and 
      system profile versioning.

      ### Key Features
      - Automatic generation of UEFI boot entries.
      - Integrated mouse support in the boot menu.
      - Deep integration with the system branding engine.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.system.boot.loader.zenboot = {
    enable = lib.mkEnableOption "the ZenBoot bootloader manager";

    resolution = lib.mkOption {
      type = lib.types.str;
      default = "1920x1080";
      description = ''
        Boot menu screen resolution

        Sets the resolution for the UEFI frame buffer during boot. 
        Format: WIDTHxHEIGHT.
      '';
    };

    scannedDevices = lib.mkOption {
      type = lib.types.str;
      default = "internal,external,optical";
      description = ''
        Boot device discovery list

        Comma-separated list of device types to scan for bootable partitions 
        (passed to the internal 'scanfor' command).
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Arbitrary bootloader configuration lines

        Text content to be appended directly to the generated bootloader 
        configuration file.
      '';
    };

    extraIncludedFiles = lib.mkOption {
      type = lib.types.nullOr (lib.types.attrsOf lib.types.path);
      default = null;
      description = ''
        Supplementary configuration file attributes

        Attribute set of extra configuration files to be linked and 
        included by the primary boot configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.grub.enable = lib.mkDefault false;
    boot.loader.systemd-boot.enable = lib.mkDefault false;

    assertions = [
      {
        assertion = config.boot.loader.efi.canTouchEfiVariables || !cfg.use_nvram;
        message = "ZenBoot: 'use_nvram' requires 'boot.loader.efi.canTouchEfiVariables' to be true.";
      }
    ];

    environment.systemPackages = [ zenbootPkg ];

    system.activationScripts.zenboot = ''
      echo " [ZenBoot] Updating bootloader configuration..."
      ${zenbootPkg}/bin/zenboot-setup
    '';
  };
}
