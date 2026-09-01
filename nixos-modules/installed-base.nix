{
  config,
  lib,
  ...
}:

let
  napalmLicense =
    lib.licenses.napalm or {
      shortName = "napalm";
      fullName = "NAPALM: The Non-Aggression Principle Anti-License Mandate 2.0";
      url = "https://github.com/negative-zero-inft/nap-license";
      free = false;
      redistributable = true;
      copyleft = true;
    };
in
{
  # imports = [ ./popcorn-cache.nix ];

  options.zenos.system.installedBase._meta = lib.mkOption {
    internal = true;
    default = {
      description = ''
        Provides the reusable ZenOS installed-system baseline

        Supplies conservative defaults shared by both direct final installs and
        temporary OOBE installs. Branding remains owned by the ZenPkgs interface.
      '';
      license = napalmLicense;
      maintainers = lib.optional (lib.maintainers ? doromiert) lib.maintainers.doromiert;
      platforms = lib.platforms.linux;
    };
  };

  config = {
    nixpkgs.config = lib.mkDefault { allowUnfree = true; };

    users.mutableUsers = lib.mkDefault false;

    zenos.system.release.stateVersion = lib.mkDefault "26.05";

    nix.settings.experimental-features = lib.mkDefault [
      "nix-command"
      "flakes"
    ];

    networking.networkmanager.enable = lib.mkDefault true;

    security = {
      rtkit.enable = lib.mkDefault true;
      sudo.wheelNeedsPassword = lib.mkDefault false;
    };

    services.pipewire = {
      enable = lib.mkDefault true;
      alsa.enable = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
    };

    programs.dconf.enable = lib.mkDefault true;
    hardware.enableRedistributableFirmware = lib.mkDefault true;

    boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

    services.displayManager = lib.mkIf config.zenos.desktops.gnome.enable {
      autoLogin = {
        enable = lib.mkForce false;
        user = lib.mkForce null;
      };
      gdm.enable = lib.mkDefault true;
      defaultSession = lib.mkDefault "gnome";
    };
  };
}
