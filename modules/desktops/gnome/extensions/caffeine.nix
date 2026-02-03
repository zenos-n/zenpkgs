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
    description = ''
      Manual and automatic screensaver inhibition for GNOME

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
      description = ''
        Auto-inhibit application list

        List of applications (desktop file IDs) that trigger caffeine when running.
      '';
    };

    user-enabled = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Manual toggle state persistence

        Whether caffeine should remember its enabled state across sessions.
      '';
    };

    duration-timer-list = mkOption {
      type = types.listOf types.int;
      default = [
        900
        1800
        3600
      ];
      description = ''
        Available timer duration intervals

        List of possible timer values in seconds for the dropdown menu.
      '';
    };

    use-custom-duration = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable custom duration timer

        Whether to use custom user-defined values for the inhibition timer.
      '';
    };

    countdown-timer = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Active countdown remaining time

        Internal timer state representing seconds remaining until inhibition ends.
      '';
    };

    duration-timer = mkOption {
      type = types.int;
      default = 2;
      description = ''
        Default timer duration index

        The default index from the duration list used when starting a timer.
      '';
    };

    restore-state = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Restore inhibition state on startup

        Whether to automatically re-enable caffeine if it was active on shutdown.
      '';
    };

    show-indicator = mkOption {
      type = types.str;
      default = "only-active";
      description = ''
        Indicator visibility mode

        Controls the top bar icon visibility: 'only-active', 'always', or 'never'.
      '';
    };

    show-notifications = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Display status notifications

        Whether to show desktop notifications when caffeine is toggled.
      '';
    };

    show-timer = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Display countdown in top bar

        Whether to show the remaining inhibition time next to the icon.
      '';
    };

    show-toggle = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable quick settings toggle

        Whether the toggle switch appears in the GNOME Quick Settings menu.
      '';
    };

    enable-fullscreen = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Auto-inhibit on fullscreen apps

        Enable caffeine automatically when any application enters fullscreen mode.
      '';
    };

    enable-mpris = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Auto-inhibit on media playback

        Enable caffeine automatically when an MPRIS-compatible media player is active.
      '';
    };

    nightlight-control = mkOption {
      type = types.str;
      default = "never";
      description = ''
        Inhibit GNOME Night Light

        Mode for suppressing Night Light: 'never', 'always', or 'for-apps'.
      '';
    };

    screen-blank = mkOption {
      type = types.str;
      default = "never";
      description = ''
        Allow screen blanking while active

        Mode for allowing the screen to turn off: 'never', 'always', or 'for-apps'.
      '';
    };

    trigger-apps-mode = mkOption {
      type = types.str;
      default = "on-running";
      description = ''
        Application trigger logic

        Criteria for app-based inhibition: 'on-running', 'on-focus', 'on-active-workspace'.
      '';
    };

    toggle-shortcut = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Keyboard shortcut to toggle state

        List of key combination strings used to manually enable/disable caffeine.
      '';
    };

    prefs-default-width = mkOption {
      type = types.int;
      default = 570;
      description = "Default width for the preferences window interface";
    };

    prefs-default-height = mkOption {
      type = types.int;
      default = 590;
      description = "Default height for the preferences window interface";
    };

    indicator-position = mkOption {
      type = types.int;
      default = 0;
      description = "Visual offset for the status icon in the panel";
    };

    indicator-position-index = mkOption {
      type = types.int;
      default = 0;
      description = "Logical sorting index for the status icon";
    };

    indicator-position-max = mkOption {
      type = types.int;
      default = 1;
      description = "Maximum index for icon positioning in the indicator menu";
    };

    cli-toggle = mkOption {
      type = types.bool;
      default = false;
      description = "Allow toggling caffeine via command line signals";
    };
  };

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
