# Evaluate only in the dedicated acceptance VM; does not boot or mutate an ESP.
{ pkgs, bootPackage, refindInstaller, refindTheme }:
let
  lib = pkgs.lib;
  hooks = import ../lib/installer-boot.nix {
    inherit pkgs bootPackage refindInstaller refindTheme;
  };
  evaluate =
    modules:
    (import (pkgs.path + "/nixos/lib/eval-config.nix") {
      inherit pkgs modules;
      system = pkgs.stdenv.hostPlatform.system;
    }).config;
  installed = evaluate [
    hooks.common
    hooks.installed
    {
      system.stateVersion = "26.05";
      fileSystems."/" = {
        device = "/dev/disk/by-label/zenos";
        fsType = "ext4";
      };
      fileSystems."/boot" = {
        device = "/dev/disk/by-label/ESP";
        fsType = "vfat";
      };
    }
  ];
  iso = evaluate [
    (pkgs.path + "/nixos/modules/installer/cd-dvd/iso-image.nix")
    hooks.common
    hooks.iso
    { system.stateVersion = "26.05"; }
  ];
in
assert builtins.all (entry: entry.assertion) installed.assertions;
assert installed.boot.plymouth.enable && installed.boot.plymouth.theme == "zenos";
assert installed.boot.loader.timeout == 0;
assert !installed.boot.loader.efi.canTouchEfiVariables;
assert !installed.boot.loader.grub.enable;
assert installed.boot.loader.systemd-boot.enable;
assert lib.hasInfix "share/refind/refind_x64.efi" installed.boot.loader.systemd-boot.extraInstallCommands;
assert lib.hasInfix "cp -Lrf --no-preserve=mode"
  installed.boot.loader.systemd-boot.extraInstallCommands;
assert lib.hasInfix "zenos-sync-refind-generations"
  installed.boot.loader.systemd-boot.extraInstallCommands;
assert lib.hasInfix "/boot/EFI/BOOT/BOOTX64.EFI"
  installed.boot.loader.systemd-boot.extraInstallCommands;
assert !(installed.system.activationScripts ? zenboot);
assert !installed.services.openssh.enable;
assert !installed.networking.networkmanager.enable;
assert !installed.hardware.bluetooth.enable;
assert iso.boot.plymouth.theme == "zenos";
assert iso.isoImage.grubTheme == "${bootPackage.boot}/share/zenos/boot/grub";
assert lib.hasInfix "MENU RESOLUTION 800 600" iso.isoImage.syslinuxTheme;
assert lib.hasInfix "#FFC532FF" iso.isoImage.syslinuxTheme;
{
  passed = true;
  releaseVersion = bootPackage.releaseVersion;
  plymouth = "${bootPackage}/share/plymouth/themes/zenos";
  grubTheme = iso.isoImage.grubTheme;
}
