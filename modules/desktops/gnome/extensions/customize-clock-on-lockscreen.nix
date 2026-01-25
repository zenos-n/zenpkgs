{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen;

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

in
{
  options.zenos.desktops.gnome.extensions.customize-clock-on-lockscreen = {
    enable = mkEnableOption "Customize Clock on Lockscreen GNOME extension configuration";

    # --- Toggles ---
    remove-command-output = mkBool false "Remove command output.";
    remove-time = mkBool false "Remove time.";
    remove-date = mkBool false "Remove date.";
    remove-hint = mkBool false "Remove hint.";

    # --- General Configuration ---
    command = mkStr "whoami" "Custom command to execute.";
    custom-time-text = mkStr "" "Custom time format (GLib DateTime format).";
    custom-date-text = mkStr "" "Custom date format (GLib DateTime format).";
    clock-style = mkStr "digital" "Clock style: 'digital', 'analog', or 'led'.";

    # --- Command Output Styling ---
    command-output-font-color = mkStr "rgba(255, 244, 177, 1.0)" "Font color for command output.";
    command-output-font-size = mkInt 48 "Font size for command output.";
    command-output-font-family = mkStr "Default" "Font family for command output.";
    command-output-font-weight = mkStr "Default" "Font weight for command output.";
    command-output-font-style = mkStr "Default" "Font style for command output.";

    # --- Time Styling ---
    time-font-color = mkStr "rgba(160, 230, 163, 1.0)" "Font color for time.";
    time-font-size = mkInt 96 "Font size for time.";
    time-font-family = mkStr "Default" "Font family for time.";
    time-font-weight = mkStr "Default" "Font weight for time.";
    time-font-style = mkStr "Default" "Font style for time.";

    # --- Date Styling ---
    date-font-color = mkStr "rgba(242, 92, 84, 1.0)" "Font color for date.";
    date-font-size = mkInt 28 "Font size for date.";
    date-font-family = mkStr "Default" "Font family for date.";
    date-font-weight = mkStr "Default" "Font weight for date.";
    date-font-style = mkStr "Default" "Font style for date.";

    # --- Hint Styling ---
    hint-font-color = mkStr "rgba(212, 237, 138, 1.0)" "Font color for hint.";
    hint-font-size = mkInt 20 "Font size for hint.";
    hint-font-family = mkStr "Default" "Font family for hint.";
    hint-font-weight = mkStr "Default" "Font weight for hint.";
    hint-font-style = mkStr "Default" "Font style for hint.";
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.customize-clock-on-lockscreen ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/customize-clock-on-lockscreen" = {
            # Toggles
            remove-command-output = cfg.remove-command-output;
            remove-time = cfg.remove-time;
            remove-date = cfg.remove-date;
            remove-hint = cfg.remove-hint;

            # General
            command = cfg.command;
            custom-time-text = cfg.custom-time-text;
            custom-date-text = cfg.custom-date-text;
            clock-style = cfg.clock-style;

            # Command Output
            command-output-font-color = cfg.command-output-font-color;
            command-output-font-size = cfg.command-output-font-size;
            command-output-font-family = cfg.command-output-font-family;
            command-output-font-weight = cfg.command-output-font-weight;
            command-output-font-style = cfg.command-output-font-style;

            # Time
            time-font-color = cfg.time-font-color;
            time-font-size = cfg.time-font-size;
            time-font-family = cfg.time-font-family;
            time-font-weight = cfg.time-font-weight;
            time-font-style = cfg.time-font-style;

            # Date
            date-font-color = cfg.date-font-color;
            date-font-size = cfg.date-font-size;
            date-font-family = cfg.date-font-family;
            date-font-weight = cfg.date-font-weight;
            date-font-style = cfg.date-font-style;

            # Hint
            hint-font-color = cfg.hint-font-color;
            hint-font-size = cfg.hint-font-size;
            hint-font-family = cfg.hint-font-family;
            hint-font-weight = cfg.hint-font-weight;
            hint-font-style = cfg.hint-font-style;
          };
        };
      }
    ];
  };
}
