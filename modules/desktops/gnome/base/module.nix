{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome;

  # Safely extract UUIDs. Assumes your extension packages have the 'extensionUuid' attribute.
  # If using standard nixpkgs extensions, you might need a helper to lookup UUIDs or manually specify them.
  # This logic preserves your current reliance on the attribute being present.
  getUuid =
    pkg:
    if (builtins.hasAttr "extensionUuid" pkg) then
      pkg.extensionUuid
    else
      (builtins.trace "Warning: Extension ${pkg.name} missing extensionUuid" null);
  extensionUuids = builtins.filter (x: x != null) (map getUuid cfg.extensions);
in
{
  meta = {
    description = "Configures the GNOME desktop environment for ZenOS";
    longDescription = ''
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

  options.zenos.desktops.gnome = {
    enable = mkEnableOption "Gnome Desktop Base Module";

    extensions = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "List of GNOME extensions to install and enable automatically.";
      example = literalExpression "[ pkgs.gnomeExtensions.appindicator ]";
    };

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
      description = "Accent color for GNOME desktop.";
    };

    defaultDarkMode = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable dark mode by default.";
    };

    fileIndexing.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Tracker file indexing.";
    };

    dockItems = mkOption {
      type = types.listOf types.str;
      default = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Terminal.desktop"
        "kitty.desktop"
      ];
      description = "Default dock favorites.";
    };

    extraPackages.enable = mkEnableOption "installation of extra curated GNOME apps";

    excludeGnomeConsole = mkOption {
      type = types.bool;
      default = false;
      description = "Disable gnome-console.";
    };

    # New option for gaming/high-refresh monitors
    variableRefreshRate = mkOption {
      type = types.bool;
      default = true;
      description = "Enable VRR (Variable Refresh Rate) in Mutter.";
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
        # Note: Explicit path setting removed; relying on system path is cleaner in modern NixOS
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav
        gst_all_1.gst-vaapi
      ]
      ++ cfg.extensions # Install the extensions defined in options
      ++ mkIf services.flatpak.enable [ warehouse ]
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

    # 2. Flatpak Configuration
    services.flatpak.packages = mkIf services.flatpak.enable (
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
        yelp # Help viewer, rarely used
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
            clock-show-weekday = true; # Useful default
            show-battery-percentage = true;
          };

          "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat"; # Better for gaming consistency
          };

          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = extensionUuids;
            favorite-apps = cfg.dockItems;
          };

          "org/gnome/desktop/wm/preferences" = {
            edge-tiling = false; # Tiling usually handled by extensions (Pop Shell/Forge)
            action-double-click-titlebar = "toggle-maximize";
            button-layout = "appmenu:minimize,maximize,close"; # Ensure buttons exist
          };

          "org/gnome/mutter" = {
            edge-tiling = false;
            center-new-windows = true; # Prefer centering
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

    # 6. Optional: Udev rules for controllers if this is a gaming rig
    services.udev.packages = [ pkgs.gnome-settings-daemon ];
  };
}
