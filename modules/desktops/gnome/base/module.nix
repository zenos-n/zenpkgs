{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome;

  meta = {
    description = ''
      Configures the GNOME desktop environment for ZenOS

      This module provides a comprehensive GNOME configuration tailored for ZenOS.
      It handles the installation of core GNOME packages, audio/video plugins (GStreamer),
      and manages default settings via dconf.

      **Key Features:**
      - Automatic extension management via UUID injection
      - Integrated variable refresh rate (VRR) support for gaming
      - Optional curated app suite and bloat removal
      - System-wide dark mode and accent color enforcement

      Integrates with `services.flatpak` and standard NixOS desktop managers.
    '';
    license = lib.licenses.napl;
    maintainers = with lib.maintainers; [ doromiert ];
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome = {
    _meta = mkOption {
      internal = true;
      default = meta;
    };
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
      description = ''
        Primary accent color for the interface

        Sets the system-wide accent color for GNOME components and supported
        GTK4 applications.
      '';
    };

    defaultDarkMode = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable system-wide dark mode

        Whether to prefer the dark color scheme by default across the desktop
        environment and applications.
      '';
    };

    fileIndexing = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable Tracker file indexing

          Controls the background indexing services for file search and 
          metadata extraction.
        '';
      };
    };

    dockItems = mkOption {
      type = types.listOf types.str;
      default = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Terminal.desktop"
        "kitty.desktop"
      ];
      description = ''
        Default favorite applications in the dock

        List of .desktop file identifiers to be pinned to the GNOME Dash
        by default.
      '';
    };

    extraPackages = {
      enable = mkEnableOption "installation of extra curated GNOME apps";
    };

    excludeGnomeConsole = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Remove the default GNOME Console

        When enabled, the modern GNOME Console (kgx) is added to the 
        exclusion list for the environment.
      '';
    };

    variableRefreshRate = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable Variable Refresh Rate support

        Activates experimental VRR support in Mutter for compatible high-refresh
        rate gaming monitors.
      '';
    };
  };

  config = mkIf cfg.enable {
    # 1. System Packages & Environment
    environment.systemPackages =
      with pkgs;
      [
        # Core Utils
        wl-clipboard
        dconf-editor
        gnome-tweaks
        gnome-extension-manager
        resources
        pika-backup

        # Multimedia (GStreamer)
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav
        gst_all_1.gst-vaapi
      ]
      ++ cfg.extensions
      ++ mkIf (config.services.flatpak.enable or false) [ pkgs.warehouse ]
      ++ mkIf cfg.extraPackages.enable (
        with pkgs;
        [
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
        ]
      );

    # 2. Flatpak Configuration
    services.flatpak.packages = mkIf (config.services.flatpak.enable or false) (
      [ "com.github.tchx84.Flatseal" ]
      ++ (optionals cfg.extraPackages.enable [ "studio.planetpeanut.Bobby" ])
    );

    # 3. Bloat Removal
    environment.gnome.excludePackages =
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
        yelp
        gnome-clocks
      ]
      ++ (optional cfg.excludeGnomeConsole pkgs.gnome-console);

    # 4. Tracker Configuration
    services.gnome.tracker-miners.enable = cfg.fileIndexing.enable;
    services.gnome.tracker.enable = cfg.fileIndexing.enable;

    # 5. DConf Configuration
    programs.dconf.enable = true;
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/notifications" = {
            show-in-lock-screen = false;
          };

          "org/gnome/desktop/interface" = {
            accent-color = cfg.defaultAccentColor;
            color-scheme = if cfg.defaultDarkMode then "prefer-dark" else "prefer-light";
            enable-hot-corners = false;
            gtk-enable-primary-paste = false;
            clock-show-weekday = true;
            show-battery-percentage = true;
          };

          "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat";
          };

          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = extensionUuids;
            favorite-apps = cfg.dockItems;
          };

          "org/gnome/desktop/wm/preferences" = {
            edge-tiling = false;
            action-double-click-titlebar = "toggle-maximize";
            button-layout = "appmenu:minimize,maximize,close";
          };

          "org/gnome/mutter" = {
            edge-tiling = false;
            center-new-windows = true;
            dynamic-workspaces = true;
            experimental-features = [
              "scale-monitor-framebuffer"
              "xwayland-native-scaling"
            ]
            ++ (optional cfg.variableRefreshRate "variable-refresh-rate");
          };
        };
      }
    ];

    services.udev.packages = [ pkgs.gnome-settings-daemon ];
  };
}
