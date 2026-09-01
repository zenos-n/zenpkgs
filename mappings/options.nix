[
  {
    id = "system.release.state-version";
    target = [
      "zenos"
      "system"
      "release"
      "stateVersion"
    ];
    legacyPath = [
      "system"
      "stateVersion"
    ];
  }
  {
    id = "system.branding.distro-name";
    target = [
      "zenos"
      "system"
      "branding"
      "distroName"
    ];
    legacyPath = [
      "system"
      "nixos"
      "distroName"
    ];
  }
  {
    id = "system.branding.distro-id";
    target = [
      "zenos"
      "system"
      "branding"
      "distroId"
    ];
    legacyPath = [
      "system"
      "nixos"
      "distroId"
    ];
  }
  {
    id = "system.localization.locale";
    target = [
      "zenos"
      "system"
      "localization"
      "locale"
    ];
    legacyPath = [
      "i18n"
      "defaultLocale"
    ];
  }
  {
    id = "system.localization.time-zone";
    target = [
      "zenos"
      "system"
      "localization"
      "timeZone"
    ];
    legacyPath = [
      "time"
      "timeZone"
    ];
  }
  {
    id = "system.network.host-name";
    target = [
      "zenos"
      "system"
      "network"
      "hostName"
    ];
    legacyPath = [
      "networking"
      "hostName"
    ];
  }
  {
    id = "system.network.manager";
    target = [
      "zenos"
      "system"
      "network"
      "networkManager"
    ];
    legacyPath = [
      "networking"
      "networkmanager"
      "enable"
    ];
  }
  {
    id = "system.software.packages";
    target = [
      "zenos"
      "system"
      "software"
      "packages"
    ];
    legacyPath = [
      "environment"
      "systemPackages"
    ];
  }
  {
    id = "system.keyboard.layout";
    target = [
      "zenos"
      "system"
      "keyboard"
      "layout"
    ];
    legacyPath = [
      "services"
      "xserver"
      "xkb"
      "layout"
    ];
  }
  {
    id = "system.keyboard.variant";
    target = [
      "zenos"
      "system"
      "keyboard"
      "variant"
    ];
    legacyPath = [
      "services"
      "xserver"
      "xkb"
      "variant"
    ];
  }
  {
    id = "system.keyboard.model";
    target = [
      "zenos"
      "system"
      "keyboard"
      "model"
    ];
    legacyPath = [
      "services"
      "xserver"
      "xkb"
      "model"
    ];
  }
  {
    id = "desktop.gnome.enable";
    target = [
      "zenos"
      "desktops"
      "gnome"
      "enable"
    ];
    legacyPath = [
      "services"
      "desktopManager"
      "gnome"
      "enable"
    ];
  }
  {
    id = "desktop.plasma.enable";
    target = [
      "zenos"
      "desktops"
      "plasma"
      "enable"
    ];
    legacyPath = [
      "services"
      "desktopManager"
      "plasma6"
      "enable"
    ];
  }
  {
    id = "desktop.xfce.enable";
    target = [
      "zenos"
      "desktops"
      "xfce"
      "enable"
    ];
    legacyPath = [
      "services"
      "xserver"
      "desktopManager"
      "xfce"
      "enable"
    ];
  }
  {
    id = "desktop.cinnamon.enable";
    target = [
      "zenos"
      "desktops"
      "cinnamon"
      "enable"
    ];
    legacyPath = [
      "services"
      "xserver"
      "desktopManager"
      "cinnamon"
      "enable"
    ];
  }
  {
    id = "desktop.budgie.enable";
    target = [
      "zenos"
      "desktops"
      "budgie"
      "enable"
    ];
    legacyPath = [
      "services"
      "xserver"
      "desktopManager"
      "budgie"
      "enable"
    ];
  }
  {
    id = "desktop.mate.enable";
    target = [
      "zenos"
      "desktops"
      "mate"
      "enable"
    ];
    legacyPath = [
      "services"
      "xserver"
      "desktopManager"
      "mate"
      "enable"
    ];
  }
  {
    id = "system.boot.systemd-boot";
    target = [
      "zenos"
      "system"
      "boot"
      "systemdBoot"
    ];
    legacyPath = [
      "boot"
      "loader"
      "systemd-boot"
      "enable"
    ];
  }
]
