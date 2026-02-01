{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.extension-list;

in
{
  meta = {
    description = "Configures the Extension List GNOME extension";
    longDescription = ''
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

  options.zenos.desktops.gnome.extensions.extension-list = {
    enable = mkEnableOption "Extension List GNOME extension configuration";

    button-icon = mkOption {
      type = types.int;
      default = 0;
      description = "Tail button icon: 0 - prefs, 1 - remove, 2 - url";
    };

    extension-appid = mkOption {
      type = types.str;
      default = "";
      description = "Open extension app or web";
    };

    enable-tooltip = mkOption {
      type = types.bool;
      default = true;
      description = "Enable toolbar tooltip";
    };

    extension-button = mkOption {
      type = types.bool;
      default = true;
      description = "Show extension button";
    };

    homepage-button = mkOption {
      type = types.bool;
      default = true;
      description = "Show homepage button";
    };

    remove-button = mkOption {
      type = types.bool;
      default = true;
      description = "Show remove button";
    };

    filter-button = mkOption {
      type = types.bool;
      default = true;
      description = "Show filter button";
    };

    enable-filter = mkOption {
      type = types.bool;
      default = true;
      description = "Filter out ignored extensions";
    };

    ignore-button = mkOption {
      type = types.bool;
      default = true;
      description = "Show button for toggling ignore-menu";
    };

    ignore-menu = mkOption {
      type = types.bool;
      default = false;
      description = "Show menu for managing ignore-list";
    };

    ignore-list = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of ignored extensions";
    };
  };

  # --- Implementation ---
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.extension-list ];

    # Standard types (b, s, as) handled by dconf module directly
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

    # Complex/Specific types (uint32) handled by systemd service
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
