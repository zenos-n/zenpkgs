{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.compiz-windows-effect;

in
{
  meta = {
    description = "Configures the Compiz Windows Effect GNOME extension";
    longDescription = ''
      This module installs and configures the **Compiz Windows Effect** extension for GNOME.
      It adds wobbly windows and other Compiz-like animations to window interactions.

      **Features:**
      - Wobbly windows effect on movement and resize.
      - Configurable physics (friction, mass, spring).
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.compiz-windows-effect = {
    enable = mkEnableOption "Compiz Windows Effect GNOME extension configuration";

    friction = mkOption {
      type = types.float;
      default = 3.5;
      description = "Friction";
    };

    spring-k = mkOption {
      type = types.float;
      default = 3.8;
      description = "Spring k";
    };

    speedup-factor-divider = mkOption {
      type = types.float;
      default = 12.0;
      description = "Speedup Factor";
    };

    mass = mkOption {
      type = types.float;
      default = 70.0;
      description = "Mass";
    };

    x-tiles = mkOption {
      type = types.float;
      default = 6.0;
      description = "X Tiles";
    };

    y-tiles = mkOption {
      type = types.float;
      default = 6.0;
      description = "Y Tiles";
    };

    maximize-effect = mkOption {
      type = types.bool;
      default = true;
      description = "Maximize effect";
    };

    resize-effect = mkOption {
      type = types.bool;
      default = false;
      description = "Resize effect";
    };
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
