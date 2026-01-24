{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.hm.gvariant)
    mkTuple
    mkUint32
    ;
  cfg = config.zenos.desktops.gnome.tweaks.zenosExtensions;
  extensions =
    (with pkgs.gnomeExtensions; [
      user-themes
      app-hider
      hide-minimized
      hide-cursor
      burn-my-windows
      compiz-windows-effect
      compiz-alike-magic-lamp-effect
      rounded-window-corners-reborn
      blur-my-shell

      alphabetical-app-grid
      category-sorted-app-grid
      coverflow-alt-tab
      hide-top-bar
      mouse-tail
      window-is-ready-remover

      date-menu-formatter

      gsconnect
      clipboard-indicator
      notification-timeout
    ])
    ++ (with pkgs.desktops.gnome.extensions; [
      forge
      zenlink-indicator
    ]);
in
{
  options.zenos.desktops.gnome.tweaks.zenosExtensions = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable installation of curated ZenOS GNOME extensions.";
        };
        excludedExtensions = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "List of curated ZenOS GNOME extensions to exclude from installation.";
        };
        extensionConfig.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Default ZenOS extension settings.";
        };
      };
    };
    default = true;
    description = "Install the curated ZenOS GNOME extension set.";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = lib.filter (ext: !(lib.elem ext cfg.excludedExtensions)) (
      map (ext: ext) extensions
    );

    systemd.user.services.dconf-complex-apply = lib.mkIf cfg.extensionConfig.enable {
      Unit = {
        Description = "Apply complex dconf settings from raw files";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "apply-dconf-complex" ''
          ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/blur-my-shell/pipelines ${lib.strings.escapeShellArg (builtins.readFile ./resources/bms_settings.txt)}

          ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/rounded-window-corners-reborn/global-rounded-corner-settings ${lib.strings.escapeShellArg (builtins.readFile ./resources/rwcr_settings.txt)}
        ''}";
      };
    };

    environment.etc."burn-my-windows/profiles/zenos.conf" = lib.mkIf cfg.extensionConfig.enable {
      source = lib.readFile ./resources/bmw.conf;
    };

    programs.dconf.settings = lib.mkIf cfg.extensionConfig.enable {
      "org/gnome/shell/extensions/date-menu-formatter" = {
        pattern = "dd.MM  HH:mm";
        formatter = "01_luxon";
        text-align = "center";
        font-size = pkgs.lib.gvariant.mkInt32 9;
        update-level = pkgs.lib.gvariant.mkInt32 1;
      };

      # --- Alphabetical App Grid ---
      "org/gnome/shell/extensions/alphabetical-app-grid" = {
        folder-order-position = "end";
      };

      # --- App Hider ---
      "org/gnome/shell/extensions/app-hider" = {
        # vesktop is hidden because zenos makes a custom .desktop for it
        hidden-apps = [ "vesktop.desktop" ];
      };

      # --- Blur My Shell ---
      "org/gnome/shell/extensions/blur-my-shell" = {
        settings-version = 2;
        # pipelines handled by systemd service above
      };

      "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
        brightness = 0.59999999999999998;
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
        blur = true;
        brightness = 0.59999999999999998;
        pipeline = "pipeline_default_rounded";
        sigma = 30;
        static-blur = true;
        style-dash-to-dock = 0;
      };

      "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/overview" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        blur = false;
        brightness = 0.59999999999999998;
        pipeline = "pipeline_default";
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/window-list" = {
        brightness = 0.59999999999999998;
        sigma = 30;
      };

      # --- Burn My Windows ---
      "org/gnome/shell/extensions/burn-my-windows" = {
        active-profile = "/etc/burn-my-windows/profiles/zenos.conf";
        last-extension-version = 47;
        last-prefs-version = 47;
        prefs-open-count = 2;
      };

      # --- Compiz Windows Effect ---
      "org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect" = {
        friction = 4.9000000000000004;
        last-version = 29;
        mass = 50.0;
        resize-effect = true;
        speedup-factor-divider = 4.7000000000000002;
        spring-k = 2.2000000000000002;
      };

      # --- Coverflow Alt-Tab ---
      "org/gnome/shell/extensions/coverflowalttab" = {
        desaturate-factor = 0.0;
        icon-style = "Classic";
        switcher-background-color = mkTuple [
          1.0
          1.0
          1.0
        ];
        use-glitch-effect = false;
      };

      # --- Forge ---
      "org/gnome/shell/extensions/forge" = {
        css-last-update = mkUint32 37;
        dnd-center-layout = "swap";
        float-always-on-top-enabled = false;
        focus-border-toggle = false;
        quick-settings-enabled = false;
        split-border-toggle = false;
        stacked-tiling-mode-enabled = false;
        tabbed-tiling-mode-enabled = false;
        window-gap-size = mkUint32 4;
      };

      "org/gnome/shell/extensions/gsconnect/preferences" = {
        window-maximized = false;
        window-size = mkTuple [
          945
          478
        ];
      };

      # --- Hide Top Bar ---
      "org/gnome/shell/extensions/hidetopbar" = {
        enable-intellihide = false;
        mouse-sensitive = true;
        mouse-sensitive-fullscreen-window = false;
      };

      # --- Notification Timeout ---
      "org/gnome/shell/extensions/notification-timeout" = {
        timeout = 2000;
      };

      # --- Rounded Window Corners Reborn ---
      "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
        border-width = 1;
        settings-version = mkUint32 7;
      };

      # ======================================== #
      # CONFIGS FOR EXTS NOT INCLUDED BY DEFAULT #
      # ======================================== #
      # they may have been excluded for performance, stability or other reasons
      # but their configs are provided here for user convenience

      # --- Rounded Corners ---
      "org/gnome/shell/extensions/lennart-k/rounded_corners" = {
        corner-radius = 24;
      };
      # --- Media Controls ---
      "org/gnome/shell/extensions/mediacontrols" = {
        extension-index = mkUint32 1;
        extension-position = "Left";
        show-control-icons = false;
      };
      # --- Quick Settings Tweaks ---
      "org/gnome/shell/extensions/quick-settings-tweaks" = {
        datemenu-hide-left-box = false;
        media-gradient-enabled = false;
        media-progress-enabled = false;
        menu-animation-enabled = true;
        notifications-enabled = false;
        overlay-menu-enabled = true;
      };
      # --- Tweaks System Menu ---
      "org/gnome/shell/extensions/tweaks-system-menu" = {
        applications = [
          "org.gnome.tweaks.desktop"
          "com.mattjakeman.ExtensionManager.desktop"
        ];
      };
      # --- Panel Corners ---
      "org/gnome/shell/extensions/panel-corners" = {
        panel-corner-radius = 22;
        screen-corner-radius = 22;
      };
    };
  };
}
