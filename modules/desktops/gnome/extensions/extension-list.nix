{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.extension-list;

  meta = {
    description = ''
      GNOME extension management menu for the top bar

      This module installs and configures the **Extension List** extension for GNOME.
      It adds a convenient list of installed extensions to the top bar, allowing for
      quick management, toggling, and configuration.

      **Features:**
      - Quick access to extension settings and homepage.
      - Toggle extensions on/off.
      - Filter and ignore lists for cleaner management.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.extension-list = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Extension List GNOME extension configuration";

    button-icon = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Extension entry action icon

        Defines the function of the trailing button on each list item: 
        0 for preferences, 1 for removal, or 2 for the extension URL.
      '';
    };

    extension-appid = mkOption {
      type = types.str;
      default = "";
      description = ''
        Target application for management

        Specifies the application ID used to open extension management 
        tools or web pages.
      '';
    };

    enable-tooltip = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable extension name tooltips

        Whether to show descriptive tooltips when hovering over the 
        toolbar extension list items.
      '';
    };

    extension-button = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Display the main extension toggle button

        Controls visibility of the primary switch used to enable or 
        disable the individual extensions.
      '';
    };

    homepage-button = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Display link to extension homepage

        Adds a button to each entry that opens the developer's 
        website or the GNOME extensions page.
      '';
    };

    remove-button = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Display extension removal button

        Adds a button to each entry that allows for the immediate 
        uninstallation of the extension.
      '';
    };

    filter-button = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Display management filter button

        Shows or hides the button used to manage ignored or filtered 
        extensions in the list.
      '';
    };

    enable-filter = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Activate extension filtering

        When enabled, extensions listed in the ignore-list will be 
        hidden from the top bar menu.
      '';
    };

    ignore-button = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Display ignore list toggle button

        Shows a button that opens the menu for managing which 
        extensions are hidden.
      '';
    };

    ignore-menu = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Show ignore list management menu

        Whether to display the sub-menu used for selecting 
        extensions to be hidden from view.
      '';
    };

    ignore-list = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Identifiers for hidden extensions

        List of extension UUIDs or names that should not appear 
        in the extension list menu.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.extension-list ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/extension-list" = {
            extension-appid = cfg.extension-appid;
            enable-tooltip = cfg.enable-tooltip;
            extension-button = cfg.extension-button;
            homepage-button = cfg.homepage-button;
            remove-button = cfg.remove-button;
            filter-button = cfg.filter-button;
            enable-filter = cfg.enable-filter;
            ignore-button = cfg.ignore-button;
            ignore-menu = cfg.ignore-menu;
            ignore-list = cfg.ignore-list;
          };
        };
      }
    ];

    systemd.user.services.extension-list-setup = {
      description = "Apply Extension List specific configuration";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/extension-list/button-icon "uint32 ${toString cfg.button-icon}"
      '';
    };
  };
}
