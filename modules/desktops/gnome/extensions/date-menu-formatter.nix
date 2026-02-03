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
    description = ''
      Custom date and time formatting for the GNOME top bar

      This module installs and configures the **Date Menu Formatter** extension 
      for GNOME. It allows customization of the date format in the top bar 
      using Luxon formatting patterns.

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

    formatter = mkOption {
      type = types.str;
      default = "01_luxon";
      description = ''
        Backend formatting engine

        Specifies the library used for parsing and rendering the date strings.
      '';
    };

    pattern = mkOption {
      type = types.str;
      default = "EEE, MMM d  H : mm";
      description = ''
        Custom date display pattern

        Luxon-compatible formatting string (e.g., 'yyyy-MM-dd HH:mm:ss').
      '';
    };

    custom-locale = mkOption {
      type = types.str;
      default = "";
      description = "Override the default system locale for date rendering";
    };

    use-default-locale = mkOption {
      type = types.bool;
      default = true;
      description = "Ignore the custom-locale setting and use system defaults";
    };

    custom-calendar = mkOption {
      type = types.str;
      default = "";
      description = "Override the calendar system (e.g., gregorian, islamic)";
    };

    use-default-calendar = mkOption {
      type = types.bool;
      default = true;
      description = "Ignore the custom-calendar setting and use system defaults";
    };

    custom-timezone = mkOption {
      type = types.str;
      default = "";
      description = "Display time for a specific IANA time zone identifier";
    };

    use-default-timezone = mkOption {
      type = types.bool;
      default = true;
      description = "Ignore the custom-timezone setting and use system defaults";
    };

    remove-messages-indicator = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Suppress the message counter

        Whether to hide the unread message/notification indicator next 
        to the clock.
      '';
    };

    apply-all-panels = mkOption {
      type = types.bool;
      default = false;
      description = "Modify all panels when using the Dash to Panel extension";
    };

    font-size = mkOption {
      type = types.int;
      default = 10;
      description = "Pixel font size for the panel clock label";
    };

    update-level = mkOption {
      type = types.int;
      default = 1;
      description = ''
        Clock refresh frequency

        Determines update interval (0: minute, 1: second, 2+: sub-second).
      '';
    };

    text-align = mkOption {
      type = types.enum [
        "left"
        "center"
        "right"
      ];
      default = "center";
      description = "Horizontal alignment of the date label within its panel slot";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.date-menu-formatter ];
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/shell/extensions/date-menu-formatter" = {
          inherit (cfg)
            formatter
            pattern
            custom-locale
            use-default-locale
            custom-calendar
            use-default-calendar
            custom-timezone
            use-default-timezone
            remove-messages-indicator
            apply-all-panels
            font-size
            update-level
            text-align
            ;
        };
      }
    ];
  };
}
