# Internal lowering support for the public system.installed-base module.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  enabled = config.zenos.system.installed-base.enable;
  oobe = config.zenos.system.oobeMode;
  users = lib.filterAttrs (_: user: user.enable && user.isNormalUser) config.users.users;
  hooks = import ../../installer-boot.nix {
    inherit pkgs lib;
    bootPackage = pkgs.zenos.theming.system.zenos-plymouth.override {
      distroName = "ZenOS";
      releaseVersion = "1.0.0Nb";
      deviceName = config.networking.hostName;
    };
    refindInstaller = pkgs.zenos.system.zenos-refind-installer;
    refindTheme = pkgs.zenos.theming.system.zenos-refind-theme;
  };
  zenfs = import ../../zenfs-runtime.nix {
    managedUsers = lib.mapAttrs (_: user: { inherit (user) home group; }) users;
    includeBootAlias = true;
  };
in
{
  config = lib.mkMerge [
    { zenos.system.zenfs.enable = lib.mkDefault enabled; }
    (lib.mkIf enabled (
      lib.mkMerge [
        (zenfs { inherit config lib pkgs; }).config
        hooks.common
        (hooks.installed { inherit config; })
        {
          services.openssh = lib.mkIf (!oobe) {
            enable = true;
            openFirewall = true;
            settings = {
              KbdInteractiveAuthentication = false;
              PasswordAuthentication = true;
              PermitEmptyPasswords = false;
              PermitRootLogin = "no";
            };
          };
          users.users.root.hashedPassword = lib.mkDefault "!";
          system.nixos = {
            distroId = lib.mkDefault "zenos";
            distroName = lib.mkDefault "ZenOS";
            version = "1.0.0Nb";
            versionSuffix = "";
            vendorId = lib.mkDefault "zenos";
            vendorName = lib.mkDefault "ZenOS";
            extraOSReleaseArgs.LOGO = "zenos";
          };
          xdg.portal.extraPortals = lib.optionals (
            !config.services.desktopManager.gnome.enable && !config.services.desktopManager.plasma6.enable
          ) [ pkgs.xdg-desktop-portal-gtk ];
          time.timeZone = lib.mkDefault "UTC";
          i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
          console.keyMap = lib.mkDefault "us";
          hardware.graphics.enable = true;
          services.pipewire.alsa.support32Bit = true;
          services.fwupd.enable = true;
          services.fstrim.enable = true;
          services.qemuGuest.enable = true;
          zramSwap.enable = true;
          nix.settings.auto-optimise-store = true;
          nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 14d";
          };
          environment.systemPackages = [
            pkgs.nixos-rebuild
            pkgs.zenos.programs.zenos-rebuild
          ];
          environment.sessionVariables = {
            XDG_CONFIG_HOME = "$HOME/.private/Config";
            XDG_DATA_HOME = "$HOME/.private/Packages";
            XDG_CACHE_HOME = "$HOME/.private/Live";
            XDG_STATE_HOME = "$HOME/.private/State";
          };
          fonts = {
            packages = [
              pkgs.zenos.apps.fonts.atkinson-hyperlegible
              pkgs.nerd-fonts.atkynson-mono
              pkgs.zenos.apps.fonts.inter
              pkgs.zenos.theming.fonts.zero.regular
              pkgs.zenos.theming.fonts.zero.mono-thin
            ];
            fontconfig.defaultFonts = {
              sansSerif = lib.mkDefault [ "Atkinson Hyperlegible" ];
              monospace = lib.mkDefault [ "AtkynsonMono NF" ];
            };
          };
          home-manager = {
            useGlobalPkgs = lib.mkForce true;
            useUserPackages = lib.mkForce false;
            users = lib.mapAttrs (_: user: {
              home = {
                stateVersion = lib.mkDefault "26.05";
                username = lib.mkDefault user.name;
                homeDirectory = lib.mkDefault user.home;
              };
              xdg = {
                enable = true;
                configHome = "${user.home}/.private/Config";
                dataHome = "${user.home}/.private/Packages";
                cacheHome = "${user.home}/.private/Live";
                stateHome = "${user.home}/.private/State";
              };
            }) users;
          };
          systemd.tmpfiles.rules = [ "d /etc/ZenOS 0755 root root -" ];
        }
      ]
    ))
  ];
}
