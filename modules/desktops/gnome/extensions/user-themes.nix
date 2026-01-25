{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.user-theme;

  # --- Helpers ---
  mkStr =
    default: description:
    mkOption {
      type = types.str;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.user-theme = {
    enable = mkEnableOption "User Theme GNOME extension configuration";

    name = mkStr "" "The name of the theme";
  };

  config = mkIf cfg.enable {
    # Ensure the extension is installed
    environment.systemPackages = [ pkgs.gnomeExtensions.user-themes ];

    # Apply dconf settings
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/user-theme" = {
            name = cfg.name;
          };
        };
      }
    ];
  };
}
