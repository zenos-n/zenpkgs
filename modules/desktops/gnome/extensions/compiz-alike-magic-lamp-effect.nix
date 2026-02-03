{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.compiz-alike-magic-lamp-effect;

in
{
  meta = {
    description = ''
      Retro 'Magic Lamp' window animation for GNOME

      This module installs and configures the **Compiz Alike Magic Lamp Effect** extension for GNOME. It recreates the classic "Magic Lamp" window 
      minimization effect found in Compiz and macOS.

      **Features:**
      - Configurable animation duration.
      - Adjustable grid density (tiles) for smoother or faster animations.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.compiz-alike-magic-lamp-effect = {
    enable = mkEnableOption "Compiz Alike Magic Lamp Effect GNOME extension configuration";

    effect = mkOption {
      type = types.str;
      default = "default";
      description = ''
        Animation effect variant

        Specifies the specific variant of the lamp effect to apply to windows.
      '';
    };

    duration = mkOption {
      type = types.float;
      default = 400.0;
      description = ''
        Animation time in milliseconds

        Total duration for the window to transition between visible and minimized states.
      '';
    };

    x-tiles = mkOption {
      type = types.float;
      default = 10.0;
      description = ''
        Horizontal mesh density

        Number of horizontal tiles used to construct the deformation mesh. 
        Higher values produce smoother animations but increase CPU load.
      '';
    };

    y-tiles = mkOption {
      type = types.float;
      default = 10.0;
      description = ''
        Vertical mesh density

        Number of vertical tiles used to construct the deformation mesh.
      '';
    };
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
