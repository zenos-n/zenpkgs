{
  config,
  lib,
  pkgs,
  ...
}:

# ZenOS Option Map (System)
# Location: legacy/nixos.nix
{
  meta = {
    description = "Maps ZenOS system options to legacy NixOS options";
    longDescription = ''
      Translates high-level ZenOS configuration switches (like `zen.boot`)
      into standard `nixos` option definitions.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zen = {
    boot.loader = lib.mkOption {
      type = lib.types.enum [
        "grub"
        "systemd-boot"
      ];
      default = "systemd-boot";
      description = "High-level bootloader selection";
    };
  };

  config.legacy = lib.mkIf (config.zen.boot.loader == "systemd-boot") {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
