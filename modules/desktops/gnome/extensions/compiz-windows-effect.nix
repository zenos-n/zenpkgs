{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.compiz-windows-effect;

  # --- Helpers for Types ---
  mkBool =
    default: description:
    mkOption {
      type = types.bool;
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
  options.zenos.desktops.gnome.extensions.compiz-windows-effect = {
    enable = mkEnableOption "Compiz Windows Effect GNOME extension configuration";

    # --- Schema Options ---

    friction = mkDouble 3.5 "Friction";

    spring-k = mkDouble 3.8 "Spring k";

    speedup-factor-divider = mkDouble 12.0 "Speedup Factor";

    mass = mkDouble 70.0 "Mass";

    x-tiles = mkDouble 6.0 "X Tiles";

    y-tiles = mkDouble 6.0 "Y Tiles";

    maximize-effect = mkBool true "Maximize effect";

    resize-effect = mkBool false "Resize effect";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.compiz-windows-effect ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect" = {
            friction = cfg.friction;
            spring-k = cfg.spring-k;
            speedup-factor-divider = cfg.speedup-factor-divider;
            mass = cfg.mass;
            x-tiles = cfg.x-tiles;
            y-tiles = cfg.y-tiles;
            maximize-effect = cfg.maximize-effect;
            resize-effect = cfg.resize-effect;
          };
        };
      }
    ];
  };
}
