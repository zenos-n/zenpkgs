{
  lib,
  pkgs,
  ...
}:

with lib;

let
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
    programs.dconf.settings = {
      "org/gnome/desktop/interface" = {
        accent-color = cfg.defaultAccentColor;
        color-scheme = (if cfg.defaultDarkMode then "prefer-dark" else "prefer-light");
      };
    };
  };
}
