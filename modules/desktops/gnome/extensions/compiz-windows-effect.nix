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
    description = ''
      Wobbly window physics and animations for GNOME

      This module installs and configures the **Compiz Windows Effect** extension for GNOME. It adds wobbly windows and other Compiz-like 
      animations to window interactions.

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
      description = ''
        Window movement friction

        Determines how quickly window wobble energy dissipates. Lower values 
        result in longer-lasting oscillations.
      '';
    };

    spring-k = mkOption {
      type = types.float;
      default = 3.8;
      description = ''
        Spring stiffness constant

        Determines the 'tightness' of the wobble effect. Higher values 
        make windows snap back faster.
      '';
    };

    speedup-factor-divider = mkOption {
      type = types.float;
      default = 12.0;
      description = ''
        Animation speed divisor

        Scaling factor for the overall speed of the physics simulation.
      '';
    };

    mass = mkOption {
      type = types.float;
      default = 70.0;
      description = ''
        Simulated window mass

        Determines the inertia of the wobble. Heavier windows feel 'sluggish' 
        and wobble with greater amplitude.
      '';
    };

    x-tiles = mkOption {
      type = types.float;
      default = 6.0;
      description = ''
        Horizontal mesh density

        Determines the number of points on the X-axis used to calculate 
        window deformation.
      '';
    };

    y-tiles = mkOption {
      type = types.float;
      default = 6.0;
      description = ''
        Vertical mesh density

        Determines the number of points on the Y-axis used to calculate 
        window deformation.
      '';
    };

    maximize-effect = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable wobble on maximization

        Whether windows should wobble when transitioning to a maximized state.
      '';
    };

    resize-effect = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable wobble on manual resize

        Whether windows should wobble while being resized by the user.
      '';
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
