{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.compiz-alike-magic-lamp-effect;

  # --- Helpers for Types ---
  mkStr =
    default: description:
    mkOption {
      type = types.str;
      default = default;
      description = description;
    };

  mkDouble =
    default: description:
    mkOption {
      type = types.float;
      default = default;
      description = description;
    };

in
{
  options.zenos.desktops.gnome.extensions.compiz-alike-magic-lamp-effect = {
    enable = mkEnableOption "Compiz Alike Magic Lamp Effect GNOME extension configuration";

    # --- Schema Options ---

    effect = mkStr "default" "Effect";

    duration = mkDouble 400.0 "Duration";

    x-tiles = mkDouble 10.0 "X Tiles";

    y-tiles = mkDouble 10.0 "Y Tiles";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.compiz-alike-magic-lamp-effect ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/com/github/hermes83/compiz-alike-magic-lamp-effect" = {
            effect = cfg.effect;
            duration = cfg.duration;
            x-tiles = cfg.x-tiles;
            y-tiles = cfg.y-tiles;
          };
        };
      }
    ];
  };
}
