{
  lib,
  pkgs,
  ...
}:

with lib;

let
in
{
  options.zenos.desktops.gnome = {
    enable = mkEnableOption "Gnome Desktop Base Module";

    defaultAccentColor = mkOption {
      type = types.enum [
        "blue"
        "teal"
        "purple"
        "red"
        "orange"
        "yellow"
        "green"
        "pink"
        "grey"
      ];
      default = "purple";
      description = "Accent color for GNOME desktop. Can be overridden by users.";
    };
    fileIndexing.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable file indexing and search functionality via Tracker. Disabling this may improve performance on low-end systems.";
    };
    dockItems = mkOption {
      type = types.listOf types.str;
      default = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Terminal.desktop"
        "kitty.desktop"
      ];
      description = "List of applications to add to the GNOME dock for all users by default.";
    };
  };

  config = mkIf cfg.enable {
    # 1. Disable conflicting loaders
    boot.loader.grub.enable = mkDefault false;
    boot.loader.systemd-boot.enable = mkDefault false;

    environment.systemPackages = with pkgs; [

    ];

    # 4. Activation Script
    # This executes the python setup logic on every 'nixos-rebuild switch'
    system.activationScripts.zenboot = ''
      echo " [ZenBoot] Updating bootloader configuration..."
      ${zenbootPkg}/bin/zenboot-setup
    '';
  };
}
