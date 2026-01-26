{
  lib,
  pkgs,
  ...
}:

with lib;

let
  allPackages = config.environment.systemPackages;

  installedExtensions = builtins.filter (pkg: pkg ? extensionUuid) allPackages;

  allExts = builtins.map (pkg: pkg.extensionUuid) installedExtensions;
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
    defaultDarkMode.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable dark mode for all users by default";
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
    extraPackages.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to include additional non-critical curated gnome apps";
    };
    excludeGnomeConsole = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to disable the gnome console. Useful when you want to use your own custom console.";
    };
  };

  config = mkIf cfg.enable {
    environment.variables = {
      GST_PLUGIN_PATH = "/run/current-system/sw/lib/gstreamer-1.0/";
    };
    environment.systemPackages =
      with pkgs;
      [
        pipewire
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav # Essential for common formats like .mp4/.mkv
        gst_all_1.gst-vaapi

        gnome-tweaks
        gnome-extension-manager
        wl-clipboard
        dconf-editor
        resources

        pika-backup
      ]
      ++ mkIf services.flatpak.enable [
        warehouse
      ]
      ++ mkIf cfg.extraPackages.enable [
        icon-library
        letterpress
        biblioteca
        dialect
        raider
        wike
        curtail
        czkawka
        hieroglyphic
        switcheroo
        rnote
        helvum
      ];

    services.flatpak.packages =
      mkIf services.flatpak.enable [
        "com.github.tchx84.Flatseal"
      ]
      ++ mkIf cfg.extraPackages.enable [
        "studio.planetpeanut.Bobby"
      ];

    gnome.excludePackages = (
      with pkgs;
      [
        gnome-software
        gnome-photos
        gnome-tour
        gedit
        cheese
        gnome-music
        gnome-maps
        epiphany
        gnome-contacts
        gnome-weather
      ]
      ++ mkIf cfg.disableGnomeConsole [
        gnome-console
      ]
    );
    programs.dconf.enable = true;
    programs.dconf.settings.profiles.user.databases = {
      "org/gnome/desktop/notifications" = {
        show-in-lock-screen = false;
      };

      "org/gnome/desktop/interface" = {
        accent-color = cfg.defaultAccentColor;
        color-scheme = (if cfg.defaultDarkMode then "prefer-dark" else "prefer-light");
        enable-hot-corners = mkDefault false;
        gtk-enable-primary-paste = mkForce false; # when you middle click, you're pasting FASCISM
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = allExts;

        favorite-apps = mkDefault cfg.dockItems;
      };

      "org/gnome/desktop/wm/preferences" = {
        edge-tiling = mkDefault false;
        action-double-click-titlebar = "toggle-maximize";
      };

      "org/gnome/mutter" = {
        edge-tiling = mkDefault false;
        center-new-windows = mkDefault false;
        auto-maximize = false;
        experimental-features = [
          "scale-monitor-framebuffer"
          "xwayland-native-scaling"
        ];
      };

    };
  };
}
