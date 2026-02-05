{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.system.boot.loader.zenboot;

  # Resolve branding variables from zenos.branding if available, otherwise fallback
  brandingCfg =
    config.zenos.branding or {
      prettyName = null;
      icon = null;
    };
  finalDeviceName =
    if brandingCfg.prettyName != null then brandingCfg.prettyName else config.networking.hostName;
  finalIcon = if brandingCfg.icon != null then brandingCfg.icon else "negzero";

  # Assuming the package is available as pkgs.zenos.zenboot
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

  # Assuming the theme package is available
  zenosPlymouthPkg = pkgs.zenos.theming.system.zenos-plymouth.override {
    distroName = cfg.distroName;
    releaseVersion = config.system.nixos.label;
    deviceName = finalDeviceName;
    icon = finalIcon;
    color = cfg.plymouth.color;
  };
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
in
{

  options.zenos.system.boot.loader.zenboot = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = lib.mkEnableOption "ZenBoot (ZenOS Bootloader)";

    plymouth = {
      enable = lib.mkEnableOption "ZenOS Plymouth theme";
      color = lib.mkOption {
        type = lib.types.strMatching "[0-9a-fA-F]{6}";
        default = "C532FF";
        description = "Hex color code for the boot animation glow (without #)";
      };
    };

    osIcon = lib.mkOption {
      type = lib.types.enum [
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
      description = "Icon name for the OS in the boot menu";
    };

    distroName = lib.mkOption {
      type = lib.types.str;
      default = "ZenOS";
      description = "The name of the distribution";
    };

    resolution = lib.mkOption {
      type = lib.types.str;
      default = "max";
      description = "Screen resolution for rEFInd (e.g., '1920 1080' or 'max')";
    };

    timeout = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "Boot menu timeout in seconds";
    };

    maxGenerations = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "Number of generations to include in the boot menu";
    };

    use_nvram = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to write variables to NVRAM (efibootmgr)";
    };

    enable_mouse = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable mouse support in the boot menu";
    };

    scannedDevices = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "internal"
          "external"
          "optical"
          "netboot"
          "hdbios"
          "biosexternal"
          "cd"
          "manual"
          "firmware"
        ]
      );
      default = [
        "external"
        "optical"
        "manual"
      ];
      description = "Comma-separated list of device types to scan (passed to 'scanfor')";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra configuration lines appended to refind.conf";
    };

    extraIncludedFiles = lib.mkOption {
      type = lib.types.nullOr (lib.types.attrsOf lib.types.path);
      default = null;
      description = "Attribute set of extra config files to include";
    };
  };

  config = lib.mkIf cfg.enable {
    # 1. Disable conflicting loaders
    boot.loader.grub.enable = lib.mkDefault false;
    boot.loader.systemd-boot.enable = lib.mkDefault false;

    # 2. Safety Checks
    assertions = [
      {
        assertion = config.zenos.system.boot.loader.efi.canTouchEfiVariables || !cfg.use_nvram;
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
    boot.plymouth = lib.mkIf cfg.plymouth.enable {
      enable = true;
      theme = "zenos";
      themePackages = [ zenosPlymouthPkg ];
    };
  };
}
