{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.caffeine;

  # --- Helpers for Types ---
  mkBool =
    default: description:
    mkOption {
      type = types.bool;
      default = default;
      description = description;
    };

  mkInt =
    default: description:
    mkOption {
      type = types.int;
      default = default;
      description = description;
    };

  mkStr =
    default: description:
    mkOption {
      type = types.str;
      default = default;
      description = description;
    };

  mkOptionStrList =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

  mkOptionIntList =
    default: description:
    mkOption {
      type = types.listOf types.int;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.caffeine = {
    enable = mkEnableOption "Caffeine GNOME extension configuration";

    inhibit-apps = mkOptionStrList [ ] "List of applications to inhibit (desktop file names).";
    user-enabled = mkBool false "Store caffeine user state.";
    duration-timer-list = mkOptionIntList [ 900 1800 3600 ] "List of duration timer values (seconds).";
    use-custom-duration = mkBool false "Use custom duration values for the timer.";
    countdown-timer = mkInt 0 "Time (seconds) for the timer countdown.";
    duration-timer = mkInt 2 "Index of duration range for the timer.";
    restore-state = mkBool false "Restore caffeine state.";
    show-indicator = mkStr "only-active" "Show indicator: 'only-active', 'always', or 'never'.";
    show-notifications = mkBool true "Show notifications when enabled/disabled.";
    show-timer = mkBool true "Show timer when enabled/disabled.";
    show-toggle = mkBool true "Show the quick settings toggle.";
    enable-fullscreen = mkBool true "Enable when a fullscreen application is running.";
    enable-mpris = mkBool false "Enable when an application is playing media.";
    nightlight-control = mkStr "never" "Night Light control mode: 'never', 'always', 'for-apps'.";
    screen-blank = mkStr "never" "Allow screen blank: 'never', 'always', 'for-apps'.";
    trigger-apps-mode = mkStr "on-running" "Trigger App control mode: 'on-running', 'on-focus', 'on-active-workspace'.";
    toggle-shortcut = mkOptionStrList [ ] "Shortcut to toggle Caffeine.";

    # UI Preferences (Hidden/Advanced)
    prefs-default-width = mkInt 570 "Default width for the preferences window.";
    prefs-default-height = mkInt 590 "Default height for the preferences window.";
    indicator-position = mkInt 0 "Visible position offset of status icon in indicator menu.";
    indicator-position-index = mkInt 0 "Real position offset of status icon in indicator menu.";
    indicator-position-max = mkInt 1 "Last item index in indicator menu.";
    cli-toggle = mkBool false "Command line key to toggle state.";
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
