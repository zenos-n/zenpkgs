# Evaluated inside the ZenOS VM against real pinned NixOS modules.
{ nixpkgsPath, bundlePath, runtimePath, zenfsRuntimePath }:
let
  pkgs = import nixpkgsPath { system = "x86_64-linux"; };
  inherit (pkgs) lib;
  runtime = import runtimePath { inherit lib; };
  bundle = builtins.fromJSON (builtins.readFile bundlePath);
  packages = { legacy = pkgs; system.zenfs = pkgs.hello; };
  evaluate = extra: (import (nixpkgsPath + "/nixos/lib/eval-config.nix") {
    system = "x86_64-linux";
    modules = [
      (runtime.moduleFromBundle { inherit bundle; packageTree = packages; })
      (import zenfsRuntimePath { managedUsers = {}; includeBootAlias = false; package = pkgs.hello; })
      {
        nixpkgs.overlays = [ (_: _: { zenos = packages; }) ];
        services.desktopManager.gnome.enable = true;
        powerManagement.enable = true;
        zenos.system.zenfs.enable = true;
        system.stateVersion = "26.05";
      }
      extra
    ];
  }).config;
  baseline = evaluate {};
  disabled = evaluate {
    zenos.system = {
      packaging = { flatpak = false; appImage = false; runAppImagesDirectly = false; };
      security.desktopAuthorization = false;
      audio.enable = false;
      power.batteryInformation = false;
      storage = { removableDrives = false; networkShares = false; };
    };
  };
  sessionChoices = evaluate {
    zenos.system = {
      fonts = {
        packages = [ pkgs.noto-fonts ];
        smoothEdges = false; alignToPixels = false;
        allowBitmapFonts = true; userPreferences = false;
        sansSerifFamilies = [ "Noto Sans" ]; serifFamilies = [ "Noto Serif" ];
        monospaceFamilies = [ "Noto Sans Mono" ]; emojiFamilies = [ "Noto Color Emoji" ];
        pixelAlignmentStrength = "full"; screenSubpixelLayout = "rgb";
      };
      locale = {
        numberFormat = "pl_PL.UTF-8"; dateTimeFormat = "en_GB.UTF-8";
        currencyFormat = "pl_PL.UTF-8"; paperFormat = "en_GB.UTF-8";
        measurementFormat = "en_GB.UTF-8"; sortingLanguage = "pl_PL.UTF-8";
      };
      networking = {
        publishComputerName = true; publishAddresses = true;
        allowDiscoveryThroughFirewall = false;
        hideWifiIdentityWhileScanning = false;
        wifiDeviceIdentity = "stable-ssid"; wiredDeviceIdentity = "random";
      };
      security = {
        remoteLoginPorts = [ 2222 ]; remoteKeyboardInteractiveLogin = false;
        administratorPassword = false;
        saveApplicationPasswords = false; rememberSshKeys = false;
        smartCards = true; allowRemoteLoginThroughFirewall = false;
      };
      hardware = { colorCalibration = false; locationServices = false; };
      sharing = {
        onlineAccounts = false; personalFiles = false; mediaLibrary = false;
        remoteDesktop = false; networkMediaPlayers = false;
      };
      diagnostics = {
        logStorage = "memory"; logRetentionDays = 7;
        diskLogLimitMebibytes = 512; memoryLogLimitMebibytes = 64;
        logRateWindowSeconds = 10; logMessagesPerWindow = 1000;
      };
      power = {
        allowSuspend = false; allowHibernate = false;
        allowHybridSleep = false; allowSuspendThenHibernate = true;
        hibernateAfterSuspendSeconds = 7200;
        externalPowerLidCloseAction = "ignore"; suspendButtonAction = "lock";
        hibernateButtonAction = "suspend";
      };
    };
  };
  invalidRetention = evaluate { zenos.system.diagnostics.logRetentionDays = -1; };
  manualAppImages = evaluate {
    zenos.system.packaging = { appImage = true; runAppImagesDirectly = false; };
  };
in
{
  sleepAvailabilityChoices = with sessionChoices.systemd.sleep.settings.Sleep;
    !AllowSuspend && !AllowHibernation && !AllowHybridSleep
    && AllowSuspendThenHibernate && HibernateDelaySec == "7200s";
  diagnosticStorageChoices = with sessionChoices.services.journald;
    storage == "volatile" && rateLimitInterval == "10s" && rateLimitBurst == 1000
    && lib.hasInfix "MaxRetentionSec=7day" extraConfig
    && lib.hasInfix "SystemMaxUse=512M" extraConfig
    && lib.hasInfix "RuntimeMaxUse=64M" extraConfig;
  negativeLogRetentionIsRejected = builtins.any
    (a: a.message == "system.diagnostics.logRetentionDays must be nonnegative." && !a.assertion)
    invalidRetention.assertions;
  sharingServicesCanBeDisabled = with sessionChoices.services;
    !gnome.gnome-online-accounts.enable && !gnome.gnome-user-share.enable
    && !gnome.rygel.enable && !gnome.gnome-remote-desktop.enable && !dleyna.enable;
  discoveryPublicationChoices = with sessionChoices.services.avahi;
    publish.enable && publish.addresses && !openFirewall;
  remoteAndAdminAuthenticationChoices = sessionChoices.services.openssh.ports == [ 2222 ]
    && !sessionChoices.services.openssh.settings.KbdInteractiveAuthentication
    && !sessionChoices.security.sudo.wheelNeedsPassword;
  fontPackagesAreInstalled = builtins.elem pkgs.noto-fonts sessionChoices.fonts.packages;
  fontChoicesReachRendering = with sessionChoices.fonts.fontconfig;
    !antialias && !hinting.enable && allowBitmaps && !includeUserConf
    && hinting.style == "full" && subpixel.rgba == "rgb"
    && defaultFonts.sansSerif == [ "Noto Sans" ]
    && defaultFonts.serif == [ "Noto Serif" ]
    && defaultFonts.monospace == [ "Noto Sans Mono" ]
    && defaultFonts.emoji == [ "Noto Color Emoji" ];
  regionalFormatsReachLocale = sessionChoices.i18n.extraLocaleSettings == {
    LC_NUMERIC = "pl_PL.UTF-8"; LC_TIME = "en_GB.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8"; LC_PAPER = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8"; LC_COLLATE = "pl_PL.UTF-8";
  };
  networkIdentityChoices = with sessionChoices.networking.networkmanager;
    !wifi.scanRandMacAddress && wifi.macAddress == "stable-ssid"
    && ethernet.macAddress == "random";
  sessionServiceChoices = !sessionChoices.services.gnome.gnome-keyring.enable
    && !sessionChoices.services.gnome.gcr-ssh-agent.enable
    && sessionChoices.services.pcscd.enable
    && !sessionChoices.services.openssh.openFirewall
    && !sessionChoices.services.colord.enable && !sessionChoices.services.geoclue2.enable;
  powerButtonChoices = with sessionChoices.services.logind.settings.Login;
    HandleLidSwitchExternalPower == "ignore" && HandleSuspendKey == "lock"
    && HandleHibernateKey == "suspend";
  nullPreservesDesktopDefaults = baseline.security.polkit.enable
    && baseline.services.upower.enable && baseline.services.udisks2.enable
    && baseline.services.gvfs.enable;
  nullPreservesPackagingDefaults = baseline.services.flatpak.enable
    && baseline.programs.appimage.enable && baseline.programs.appimage.binfmt;
  explicitFalseOverridesDesktop = !disabled.services.pipewire.enable
    && !disabled.security.polkit.enable
    && !disabled.services.upower.enable && !disabled.services.udisks2.enable
    && !disabled.services.gvfs.enable;
  explicitFalseDisablesPackaging = !disabled.services.flatpak.enable
    && !disabled.programs.appimage.enable && !disabled.programs.appimage.binfmt;
  disabledFlatpakHasNoPolicyServices = !(disabled.systemd.services ? zenos-flatpak-policy)
    && !(disabled.systemd.user.services ? zenos-flatpak-policy);
  disabledFlatpakHasNoExports = !(disabled.environment.sessionVariables ? ZENOS_FLATPAK_REMOTE)
    && !(builtins.elem "$HOME/.private/Packages/flatpak/exports" disabled.environment.profiles);
  manualAppImagesRemainAvailable = manualAppImages.programs.appimage.enable
    && !manualAppImages.programs.appimage.binfmt;
}
