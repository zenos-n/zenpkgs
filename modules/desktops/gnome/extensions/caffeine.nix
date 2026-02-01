{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.caffeine;

in
{
  meta = {
    description = "Configures the Caffeine GNOME extension";
    longDescription = ''
      This module installs and configures the **Caffeine** extension for GNOME.
      It allows users to temporarily disable the screensaver and auto-suspend modes.

      **Features:**
      - Quick settings toggle.
      - Automatic activation for fullscreen apps or specific running applications.
      - Configurable timer and duration settings.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.caffeine = {
    enable = mkEnableOption "Caffeine GNOME extension configuration";

    inhibit-apps = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of applications to inhibit (desktop file names)";
    };

    user-enabled = mkOption {
      type = types.bool;
      default = false;
      description = "Store caffeine user state";
    };

    duration-timer-list = mkOption {
      type = types.listOf types.int;
      default = [
        900
        1800
        3600
      ];
      description = "List of duration timer values (seconds)";
    };

    use-custom-duration = mkOption {
      type = types.bool;
      default = false;
      description = "Use custom duration values for the timer";
    };

    countdown-timer = mkOption {
      type = types.int;
      default = 0;
      description = "Time (seconds) for the timer countdown";
    };

    duration-timer = mkOption {
      type = types.int;
      default = 2;
      description = "Index of duration range for the timer";
    };

    restore-state = mkOption {
      type = types.bool;
      default = false;
      description = "Restore caffeine state";
    };

    show-indicator = mkOption {
      type = types.str;
      default = "only-active";
      description = "Show indicator: 'only-active', 'always', or 'never'";
    };

    show-notifications = mkOption {
      type = types.bool;
      default = true;
      description = "Show notifications when enabled/disabled";
    };

    show-timer = mkOption {
      type = types.bool;
      default = true;
      description = "Show timer when enabled/disabled";
    };

    show-toggle = mkOption {
      type = types.bool;
      default = true;
      description = "Show the quick settings toggle";
    };

    enable-fullscreen = mkOption {
      type = types.bool;
      default = true;
      description = "Enable when a fullscreen application is running";
    };

    enable-mpris = mkOption {
      type = types.bool;
      default = false;
      description = "Enable when an application is playing media";
    };

    nightlight-control = mkOption {
      type = types.str;
      default = "never";
      description = "Night Light control mode: 'never', 'always', 'for-apps'";
    };

    screen-blank = mkOption {
      type = types.str;
      default = "never";
      description = "Allow screen blank: 'never', 'always', 'for-apps'";
    };

    trigger-apps-mode = mkOption {
      type = types.str;
      default = "on-running";
      description = "Trigger App control mode: 'on-running', 'on-focus', 'on-active-workspace'";
    };

    toggle-shortcut = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Shortcut to toggle Caffeine";
    };

    # UI Preferences (Hidden/Advanced)
    prefs-default-width = mkOption {
      type = types.int;
      default = 570;
      description = "Default width for the preferences window";
    };

    prefs-default-height = mkOption {
      type = types.int;
      default = 590;
      description = "Default height for the preferences window";
    };

    indicator-position = mkOption {
      type = types.int;
      default = 0;
      description = "Visible position offset of status icon in indicator menu";
    };

    indicator-position-index = mkOption {
      type = types.int;
      default = 0;
      description = "Real position offset of status icon in indicator menu";
    };

    indicator-position-max = mkOption {
      type = types.int;
      default = 1;
      description = "Last item index in indicator menu";
    };

    cli-toggle = mkOption {
      type = types.bool;
      default = false;
      description = "Command line key to toggle state";
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.caffeine ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/caffeine" = {
            inhibit-apps = cfg.inhibit-apps;
            user-enabled = cfg.user-enabled;
            duration-timer-list = cfg.duration-timer-list;
            use-custom-duration = cfg.use-custom-duration;
            countdown-timer = cfg.countdown-timer;
            duration-timer = cfg.duration-timer;
            restore-state = cfg.restore-state;
            show-indicator = cfg.show-indicator;
            show-notifications = cfg.show-notifications;
            show-timer = cfg.show-timer;
            show-toggle = cfg.show-toggle;
            enable-fullscreen = cfg.enable-fullscreen;
            enable-mpris = cfg.enable-mpris;
            nightlight-control = cfg.nightlight-control;
            screen-blank = cfg.screen-blank;
            trigger-apps-mode = cfg.trigger-apps-mode;
            toggle-shortcut = cfg.toggle-shortcut;

            prefs-default-width = cfg.prefs-default-width;
            prefs-default-height = cfg.prefs-default-height;
            indicator-position = cfg.indicator-position;
            indicator-position-index = cfg.indicator-position-index;
            indicator-position-max = cfg.indicator-position-max;
            cli-toggle = cfg.cli-toggle;
          };
        };
      }
    ];
  };
}
