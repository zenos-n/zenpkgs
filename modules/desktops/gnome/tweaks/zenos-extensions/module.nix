{
  lib,
  config,
  ...
}:

let
  cfg = config.zenos.desktops.gnome.tweaks.zenosExtensions;
  isAllowed = name: !(lib.elem name cfg.excludedExtensions);
in
{
  meta = {
    description = ''
      Curated ZenOS GNOME extension suite

      Manages the installation and configuration of the curated set of
      GNOME extensions for ZenOS. It provides a single toggle to enable 
      a cohesive desktop experience and allows excluding specific 
      extensions if needed.

      **Includes configuration for:**
      - Visual effects (Burn My Windows, Compiz effects)
      - Shell enhancements (Blur My Shell, App Hider)
      - Utilities (Clipboard Indicator, Forge)
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.tweaks.zenosExtensions = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable the curated ZenOS GNOME extension set

        When enabled, this installs a pre-selected set of extensions 
        designed to work together for a premium desktop experience.
      '';
    };

    excludedExtensions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extensions to exclude from the curated set

        A list of extension names (e.g., 'forge') that should be 
        skipped even if the curated set is enabled.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    zenos.desktops.gnome.extensions = lib.mkMerge [
      (lib.mkIf (isAllowed "blur-my-shell") {
        blur-my-shell = {
          enable = true;
          settings = {
            pipelines = {
              pipeline_default = {
                name = "Default";
                effects = [
                  {
                    blur.gaussian = {
                      radius = 30;
                      brightness = 0.3;
                      unscaled_radius = 100;
                    };
                  }
                  { noise = { }; }
                ];
              };
            };
          };
        };
      })
    ];
  };
}
