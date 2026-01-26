{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.date-menu-formatter;

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
  options.zenos.desktops.gnome.extensions.date-menu-formatter = {
    enable = mkEnableOption "Date Menu Formatter GNOME extension configuration";

    # --- Schema Options ---

    formatter = mkStr "01_luxon" "Date formatter.";

    pattern = mkStr "EEE, MMM d  H : mm" "Date format pattern.";

    custom-locale = mkStr "" "Custom locale.";

    use-default-locale = mkBool true "Should default system locale be used.";

    custom-calendar = mkStr "" "Custom Calendar.";

    use-default-calendar = mkBool true "Should default calendar be used.";

    custom-timezone = mkStr "" "Custom timezone.";

    use-default-timezone = mkBool true "Should default system timezone be used.";

    remove-messages-indicator = mkBool false "Should unread messages indicator be removed.";

    apply-all-panels = mkBool false "Should extension modify all Dash To Panel panels.";

    font-size = mkInt 10 "Font size.";

    update-level = mkInt 1 "Update Clock Every (0=minute, 1=second, 2=2x/sec, etc).";

    text-align = mkStr "center" "Align the label (left, center, right).";

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.date-menu-formatter ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/date-menu-formatter" = {
            formatter = cfg.formatter;
            pattern = cfg.pattern;
            custom-locale = cfg.custom-locale;
            use-default-locale = cfg.use-default-locale;
            custom-calendar = cfg.custom-calendar;
            use-default-calendar = cfg.use-default-calendar;
            custom-timezone = cfg.custom-timezone;
            use-default-timezone = cfg.use-default-timezone;
            remove-messages-indicator = cfg.remove-messages-indicator;
            apply-all-panels = cfg.apply-all-panels;
            font-size = cfg.font-size;
            update-level = cfg.update-level;
            text-align = cfg.text-align;
          };
        };
      }
    ];
  };
}
