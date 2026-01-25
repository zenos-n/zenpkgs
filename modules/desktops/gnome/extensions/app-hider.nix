{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.app-hider;

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

  mkUint =
    default: description:
    mkOption {
      type = types.int;
      default = default;
      description = description;
    };

  mkStrList =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

  # Protocol requirement: Helper for complex variants (unused in this module but defined for standard)
  mkVariant = v: "<${v}>";

in
{
  options.zenos.desktops.gnome.extensions.app-hider = {
    enable = mkEnableOption "App Hider GNOME extension configuration";

    hidden-apps = mkStrList [ ] "Apps that are hidden.";

    hidden-search-apps = mkStrList [ ] "Apps that are hidden from search.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.app-hider ];

    # Standard types (b, i, s, as) are handled directly by dconf module
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/app-hider" = {
            hidden-apps = cfg.hidden-apps;
            hidden-search-apps = cfg.hidden-search-apps;
          };
        };
      }
    ];
  };
}
