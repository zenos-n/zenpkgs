# Internal composition hooks; package implementation and assets remain external.
{
  pkgs,
  bootPackage,
  refindInstaller,
  refindTheme,
  lib ? pkgs.lib,
}:
let
  boot = "${bootPackage.boot}/share/zenos/boot";
in
{
  common = {
    boot = {
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
      plymouth = {
        enable = true;
        theme = "zenos";
        themePackages = [ bootPackage ];
      };
    };
  };

  iso = {
    isoImage = {
      grubTheme = "${boot}/grub";
      efiSplashImage = "${boot}/grub/background.png";
      splashImage = "${boot}/grub/background-bios.png";
      syslinuxTheme = builtins.readFile "${bootPackage.src}/assets/syslinux-theme.cfg";
    };
  };

  installed = { config, ... }: {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
        message = "The restored ZenOS picker currently supports x86_64 UEFI only.";
      }
      {
        assertion = config.boot.loader.systemd-boot.enable
          && !config.boot.loader.grub.enable
          && !config.boot.loader.efi.canTouchEfiVariables;
        message = "The ZenOS picker requires systemd-boot generation files, GRUB disabled, and NVRAM writes disabled.";
      }
      {
        assertion =
          config.boot.loader.efi.efiSysMountPoint == "/boot"
          && (config.fileSystems."/boot".fsType or null) == "vfat";
        message = "The ZenOS picker preserves the installer's FAT ESP mounted at /boot.";
      }
    ];
    boot.loader = {
      timeout = 0;
      grub.enable = lib.mkForce false;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        extraInstallCommands = ''
          export PATH="${lib.makeBinPath [ pkgs.coreutils pkgs.gptfdisk pkgs.gnused pkgs.gnugrep ]}:$PATH"
          # Install the EFI loader directly; refind-install may wait for an
          # NVRAM entry even though this configuration deliberately disables
          # firmware variable writes.
          install -Dm0644 ${pkgs.refind}/share/refind/refind_x64.efi /boot/EFI/refind/refind_x64.efi

          echo "Deploying rEFInd resources..."
          cp -Lrf --no-preserve=mode ${refindTheme}/share/zenos/refind/. /boot/EFI/refind/

          echo "Syncing NixOS generations with rEFInd via Python script..."
          ${refindInstaller}/bin/zenos-sync-refind-generations

          # Firmware fallback launches beside EFI/BOOT, so give it the same
          # unchanged configuration after generation entries have been written.
          install -Dm0644 ${pkgs.refind}/share/refind/refind_x64.efi /boot/EFI/BOOT/BOOTX64.EFI
          cp -Lrf --no-preserve=mode ${refindTheme}/share/zenos/refind/. /boot/EFI/BOOT/
          cp -f /boot/EFI/refind/zenos-entries.conf /boot/EFI/BOOT/zenos-entries.conf
        '';
      };
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/boot";
      };
    };
    environment.systemPackages = [
      pkgs.refind
      pkgs.efibootmgr
      pkgs.python3
      pkgs.gptfdisk
      pkgs.gnused
      refindInstaller
      refindTheme
    ];
  };
}
