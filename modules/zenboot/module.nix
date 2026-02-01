{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.boot.loader.zenboot;

  # Resolve branding variables from zenos.branding if available, otherwise fallback
  brandingCfg = config.zenos.branding;
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
      maxGenrations
      osIcon
      ;

    espMountPoint = config.boot.loader.efi.efiSysMountPoint;
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
    description = "Configures the ZenOS Bootloader (ZenBoot) and Boot Animation";
    longDescription = ''
      ZenBoot is a wrapper around rEFInd, customized for ZenOS. 
      This module also handles the Plymouth boot animation integration.

      > **Warning:** Modifies bootloader configurations. Ensure `boot.loader.efi.canTouchEfiVariables` matches the `use_nvram` setting.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.boot.loader.zenboot = {
    enable = mkEnableOption "ZenBoot (ZenOS Bootloader)";

    plymouth = {
      enable = mkEnableOption "ZenOS Plymouth theme";
      color = mkOption {
        type = types.strMatching "[0-9a-fA-F]{6}";
        default = "C532FF";
        description = "Hex color code for the boot animation glow (without #).";
      };
    };

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

    distroName = mkOption {
      type = types.str;
      default = "ZenOS";
      description = "The name of the distribution";
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

    # 5. Plymouth Integration
    boot.plymouth = mkIf cfg.plymouth.enable {
      enable = true;
      theme = "zenos";
      themePackages = [ zenosPlymouthPkg ];
    };
  };
}
