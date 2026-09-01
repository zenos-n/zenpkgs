let
  package =
    {
      id,
      category,
      source ? id,
      displayName ? id,
      summary ? "Curated ${displayName} package for ZenOS",
      support ? "curated",
      status ? "active",
      tags ? [ ],
    }:
    {
      inherit id status;
      target = [
        "apps"
        category
        id
      ];
      sourcePath =
        if status == "active" then (if builtins.isList source then source else [ source ]) else null;
      aliases =
        if status == "active" then
          [
            [
              "catalog"
              id
            ]
          ]
        else
          [ ];
      meta = {
        inherit
          displayName
          summary
          support
          tags
          ;
        category = category;
      };
    };

  tool =
    id: category: source:
    package {
      inherit id category source;
      support = "core";
      tags = [ "system" ];
    };
in
{
  schemaVersion = 1;
  packages = [
    (package {
      id = "firefox";
      category = "browsers";
      displayName = "Mozilla Firefox";
      tags = [
        "browser"
        "desktop"
      ];
    })
    (package {
      id = "librewolf";
      category = "browsers";
    })
    (package {
      id = "zen-browser";
      category = "browsers";
      status = "unavailable";
    })
    (package {
      id = "helium-browser";
      category = "browsers";
      status = "unavailable";
    })
    (package {
      id = "ungoogled-chromium";
      category = "browsers";
    })
    (package {
      id = "brave-browser";
      category = "browsers";
      source = "brave";
      displayName = "Brave";
    })
    (package {
      id = "epiphany";
      category = "browsers";
    })
    (package {
      id = "tor-browser";
      category = "browsers";
    })

    (package {
      id = "steam";
      category = "gaming";
    })
    (package {
      id = "heroic";
      category = "gaming";
    })
    (package {
      id = "lutris";
      category = "gaming";
    })
    (package {
      id = "bottles";
      category = "gaming";
    })
    (package {
      id = "prism-launcher";
      category = "gaming";
      source = "prismlauncher";
    })
    (package {
      id = "retroarch";
      category = "gaming";
    })

    (package {
      id = "vscode";
      category = "development";
    })
    (package {
      id = "zed";
      category = "development";
      source = "zed-editor";
    })
    (package {
      id = "gnome-builder";
      category = "development";
    })
    (package {
      id = "neovim";
      category = "development";
    })
    (package {
      id = "helix";
      category = "development";
    })
    (package {
      id = "gitg";
      category = "development";
    })
    (package {
      id = "github-cli";
      category = "development";
      source = "gh";
    })
    (package {
      id = "docker";
      category = "development";
    })
    (package {
      id = "jetbrains-toolbox";
      category = "development";
    })

    (package {
      id = "nautilus";
      category = "system";
    })
    (package {
      id = "nautilus-python";
      category = "system";
    })
    (package {
      id = "gnome-console";
      category = "system";
    })
    (package {
      id = "gnome-system-monitor";
      category = "system";
    })
    (package {
      id = "gnome-control-center";
      category = "system";
    })
    (package {
      id = "gnome-extensions-app";
      category = "system";
      source = "gnome-extension-manager";
    })
    (package {
      id = "gnome-tweaks";
      category = "system";
    })
    (package {
      id = "kitty";
      category = "system";
    })
    (package {
      id = "btop";
      category = "system";
    })
    (package {
      id = "fish";
      category = "system";
    })
    (package {
      id = "zsh";
      category = "system";
    })
    (package {
      id = "ncurses";
      category = "system";
    })
    (package {
      id = "eza";
      category = "system";
    })

    (package {
      id = "flatseal";
      category = "utilities";
      status = "unavailable";
    })
    (package {
      id = "pika-backup";
      category = "utilities";
    })
    (package {
      id = "metadata-cleaner";
      category = "utilities";
    })
    (package {
      id = "curtail";
      category = "utilities";
    })
    (package {
      id = "gnome-boxes";
      category = "utilities";
    })
    (package {
      id = "file-roller";
      category = "utilities";
    })
    (package {
      id = "impression";
      category = "utilities";
    })
    (package {
      id = "cipher";
      category = "utilities";
      source = "decoder";
    })
    (package {
      id = "resources";
      category = "utilities";
    })
    (package {
      id = "mission-center";
      category = "utilities";
    })

    (package {
      id = "libreoffice";
      category = "office";
    })
    (package {
      id = "onlyoffice";
      category = "office";
      source = "onlyoffice-desktopeditors";
    })
    (package {
      id = "thunderbird";
      category = "office";
    })
    (package {
      id = "obsidian";
      category = "office";
    })
    (package {
      id = "apostrophe";
      category = "office";
    })
    (package {
      id = "foliate";
      category = "office";
    })
    (package {
      id = "papers";
      category = "office";
    })

    (package {
      id = "virt-manager";
      category = "advanced";
    })
    (package {
      id = "podman-desktop";
      category = "advanced";
    })
    (package {
      id = "wireshark";
      category = "advanced";
    })
    (package {
      id = "gparted";
      category = "advanced";
    })
    (package {
      id = "keepassxc";
      category = "advanced";
    })
    (package {
      id = "bitwarden";
      category = "advanced";
      source = "bitwarden-desktop";
    })
    (package {
      id = "cockpit";
      category = "advanced";
    })
    (package {
      id = "ventoy";
      category = "advanced";
      status = "unavailable";
    })
    (package {
      id = "nmap";
      category = "advanced";
    })

    (tool "git" "development-tools" "git")
    (tool "nano" "development-tools" "nano")
    (tool "openssl" "security-tools" "openssl")
    (tool "gparted-live" "recovery" "gparted")
    (tool "gnome-console-live" "recovery" "gnome-console")
    (tool "atkinson-hyperlegible" "fonts" "atkinson-hyperlegible")
    (tool "atkinson-hyperlegible-mono" "fonts" [
      "nerd-fonts"
      "atkynson-mono"
    ])
    (tool "inter" "fonts" "inter")
    (tool "google-dot" "cursors" "google-cursor")
    (tool "adw-gtk3" "themes" "adw-gtk3")
    (tool "user-themes" "gnome-extensions" [
      "gnomeExtensions"
      "user-themes"
    ])
    (tool "app-hider" "gnome-extensions" [
      "gnomeExtensions"
      "app-hider"
    ])
    (tool "hide-minimized" "gnome-extensions" [
      "gnomeExtensions"
      "hide-minimized"
    ])
    (tool "hide-cursor" "gnome-extensions" [
      "gnomeExtensions"
      "hide-cursor"
    ])
    (tool "burn-my-windows" "gnome-extensions" [
      "gnomeExtensions"
      "burn-my-windows"
    ])
    (tool "compiz-windows-effect" "gnome-extensions" [
      "gnomeExtensions"
      "compiz-windows-effect"
    ])
    (tool "compiz-alike-magic-lamp-effect" "gnome-extensions" [
      "gnomeExtensions"
      "compiz-alike-magic-lamp-effect"
    ])
    (tool "rounded-window-corners-reborn" "gnome-extensions" [
      "gnomeExtensions"
      "rounded-window-corners-reborn"
    ])
    (tool "alphabetical-app-grid" "gnome-extensions" [
      "gnomeExtensions"
      "alphabetical-app-grid"
    ])
    (tool "category-sorted-app-grid" "gnome-extensions" [
      "gnomeExtensions"
      "category-sorted-app-grid"
    ])
    (tool "coverflow-alt-tab" "gnome-extensions" [
      "gnomeExtensions"
      "coverflow-alt-tab"
    ])
    (tool "hide-top-bar" "gnome-extensions" [
      "gnomeExtensions"
      "hide-top-bar"
    ])
    (tool "mouse-tail" "gnome-extensions" [
      "gnomeExtensions"
      "mouse-tail"
    ])
    (tool "window-is-ready-remover" "gnome-extensions" [
      "gnomeExtensions"
      "window-is-ready-remover"
    ])
    (tool "date-menu-formatter" "gnome-extensions" [
      "gnomeExtensions"
      "date-menu-formatter"
    ])
    (tool "gsconnect" "gnome-extensions" [
      "gnomeExtensions"
      "gsconnect"
    ])
    (tool "clipboard-indicator" "gnome-extensions" [
      "gnomeExtensions"
      "clipboard-indicator"
    ])
    (tool "notification-timeout" "gnome-extensions" [
      "gnomeExtensions"
      "notification-timeout"
    ])
    (tool "gnome-disks" "recovery" "gnome-disk-utility")
    (tool "testdisk" "recovery" "testdisk")
    (tool "ddrescue" "recovery" "ddrescue")
    (tool "smartmontools" "recovery" "smartmontools")
    (tool "nvme-cli" "recovery" "nvme-cli")
    (tool "parted" "recovery" "parted")
    (tool "gptfdisk" "recovery" "gptfdisk")
    (tool "util-linux" "recovery" "util-linux")
    (tool "e2fsprogs" "recovery" "e2fsprogs")
    (tool "btrfs-progs" "recovery" "btrfs-progs")
    (tool "xfsprogs" "recovery" "xfsprogs")
    (tool "f2fs-tools" "recovery" "f2fs-tools")
    (tool "dosfstools" "recovery" "dosfstools")
    (tool "exfatprogs" "recovery" "exfatprogs")
    (tool "ntfs3g" "recovery" "ntfs3g")
    (tool "lvm2" "recovery" "lvm2")
    (tool "cryptsetup" "recovery" "cryptsetup")
    (tool "mdadm" "recovery" "mdadm")
    (tool "efibootmgr" "recovery" "efibootmgr")
    (tool "mokutil" "recovery" "mokutil")
    (tool "rsync" "recovery" "rsync")
    (tool "curl" "recovery" "curl")
    (tool "wget" "recovery" "wget")
    (tool "openssh" "recovery" "openssh")
    (tool "iproute2" "recovery" "iproute2")
    (tool "iputils" "recovery" "iputils")
    (package {
      id = "dnsutils";
      category = "recovery";
      source = [
        "bind"
        "dnsutils"
      ];
      support = "core";
      tags = [
        "network"
        "recovery"
      ];
    })
    (tool "pciutils" "recovery" "pciutils")
    (tool "usbutils" "recovery" "usbutils")
    (tool "dmidecode" "recovery" "dmidecode")
    (tool "lshw" "recovery" "lshw")
    (tool "jq" "recovery" "jq")
    (tool "less" "recovery" "less")
    (tool "tar" "recovery" "gnutar")
    (tool "zip" "recovery" "zip")
    (tool "unzip" "recovery" "unzip")
    (tool "zstd" "recovery" "zstd")
    (tool "squashfs-tools" "recovery" "squashfsTools")
    (tool "arch-install-scripts" "recovery" "arch-install-scripts")
    (tool "nixos-install-tools" "recovery" "nixos-install-tools")
  ];
}
