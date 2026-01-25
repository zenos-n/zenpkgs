{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.extension-list;

  # --- Helpers for Types ---
  mkBool =
    default: description:
    mkOption {
      type = types.bool;
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

  mkUint =
    default: description:
    mkOption {
      type = types.int;
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

in
{
  options.zenos.desktops.gnome.extensions.extension-list = {
    enable = mkEnableOption "Extension List GNOME extension configuration";

    button-icon = mkUint 0 "Tail button icon: 0 - prefs, 1 - remove, 2 - url.";
    extension-appid = mkStr "" "Open extension app or web.";
    enable-tooltip = mkBool true "Enable toolbar tooltip.";
    extension-button = mkBool true "Show extension button.";
    homepage-button = mkBool true "Show homepage button.";
    remove-button = mkBool true "Show remove button.";
    filter-button = mkBool true "Show filter button.";
    enable-filter = mkBool true "Filter out ignored extensions.";
    ignore-button = mkBool true "Show button for toggling ignore-menu.";
    ignore-menu = mkBool false "Show menu for managing ignore-list.";
    ignore-list = mkOptionStrList [ ] "List of ignored extensions.";
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
