{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.date-menu-formatter;

in
{
  meta = {
    description = "Configures the Date Menu Formatter GNOME extension";
    longDescription = ''
      This module installs and configures the **Date Menu Formatter** extension for GNOME.
      It allows customization of the date format in the top bar using Luxon formatting patterns.

      **Features:**
      - Custom date/time patterns.
      - Localization and time zone overrides.
      - Option to remove the messages indicator.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.date-menu-formatter = {
    enable = mkEnableOption "Date Menu Formatter GNOME extension configuration";

    # --- Schema Options ---

    formatter = mkOption {
      type = types.str;
      default = "01_luxon";
      description = "Date formatter";
    };

    pattern = mkOption {
      type = types.str;
      default = "EEE, MMM d  H : mm";
      description = "Date format pattern";
    };

    custom-locale = mkOption {
      type = types.str;
      default = "";
      description = "Custom locale";
    };

    use-default-locale = mkOption {
      type = types.bool;
      default = true;
      description = "Should default system locale be used";
    };

    custom-calendar = mkOption {
      type = types.str;
      default = "";
      description = "Custom Calendar";
    };

    use-default-calendar = mkOption {
      type = types.bool;
      default = true;
      description = "Should default calendar be used";
    };

    custom-timezone = mkOption {
      type = types.str;
      default = "";
      description = "Custom timezone";
    };

    use-default-timezone = mkOption {
      type = types.bool;
      default = true;
      description = "Should default system timezone be used";
    };

    remove-messages-indicator = mkOption {
      type = types.bool;
      default = false;
      description = "Should unread messages indicator be removed";
    };

    apply-all-panels = mkOption {
      type = types.bool;
      default = false;
      description = "Should extension modify all Dash To Panel panels";
    };

    font-size = mkOption {
      type = types.int;
      default = 10;
      description = "Font size";
    };

    update-level = mkOption {
      type = types.int;
      default = 1;
      description = "Update Clock Every (0=minute, 1=second, 2=2x/sec, etc)";
    };

    text-align = mkOption {
      type = types.enum [
        "left"
        "center"
        "right"
      ];
      default = "center";
      description = "Align the label";
    };
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
