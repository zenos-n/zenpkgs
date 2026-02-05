{
  lib,
  config,
  ...
}:

let
  cfg = config.zenos.desktops.gnome.tweaks.zenosExtensions;

  # Helper to check if an extension name is NOT in the exclusion list
  isAllowed = name: !(lib.elem name cfg.options.excludedExtensions);
  meta = {
    description = ''
      Configures the curated ZenOS GNOME extension set

      This module manages the installation and configuration of the curated set of
      GNOME extensions for ZenOS. It provides a single toggle to enable a cohesive
      desktop experience and allows excluding specific extensions if needed.

      **Includes configuration for:**
      - Visual effects (Burn My Windows, Compiz effects)
      - Shell enhancements (Blur My Shell, App Hider)
      - Utilities (Clipboard Indicator, Forge)
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.tweaks.zenosExtensions = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = lib.mkEnableOption "Enable the curated ZenOS GNOME extension set";

    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable installation of curated ZenOS GNOME extensions";
      };

      excludedExtensions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of curated ZenOS GNOME extensions to exclude from installation (by name, e.g. \"user-themes\")";
      };

      extensionConfig = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Default ZenOS extension settings";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {

    zenos.desktops.gnome.extensions = lib.mkMerge [
      {
        user-theme.enable = isAllowed "user-themes";
        app-hider.enable = isAllowed "app-hider";
        hide-minimized.enable = isAllowed "hide-minimized";
        hide-cursor.enable = isAllowed "hide-cursor";
        burn-my-windows.enable = isAllowed "burn-my-windows";
        compiz-windows-effect.enable = isAllowed "compiz-windows-effect";
        compiz-alike-magic-lamp-effect.enable = isAllowed "compiz-alike-magic-lamp-effect";
        rounded-window-corners-reborn.enable = isAllowed "rounded-window-corners-reborn";
        alphabetical-app-grid.enable = isAllowed "alphabetical-app-grid";
        category-sorted-app-grid.enable = isAllowed "category-sorted-app-grid";
        coverflow-alt-tab.enable = isAllowed "coverflow-alt-tab";
        hidetopbar.enable = isAllowed "hide-top-bar";
        mouse-tail.enable = isAllowed "mouse-tail";
        window-is-ready-remover.enable = isAllowed "window-is-ready-remover";
        date-menu-formatter.enable = isAllowed "date-menu-formatter";
        gsconnect.enable = isAllowed "gsconnect";
        clipboard-indicator.enable = isAllowed "clipboard-indicator";
        notification-timeout.enable = isAllowed "notification-timeout";
        forge.enable = isAllowed "forge";
        zenlink-indicator.enable = isAllowed "zenlink-indicator";
        blur-my-shell.enable = isAllowed "blur-my-shell";
      }

      (lib.mkIf cfg.options.extensionConfig.enable {

        app-hider.hidden-apps = [ "vesktop.desktop" ];

        burn-my-windows = {
          prefs-open-count = 2;
          last-extension-version = 47;
          last-prefs-version = 47;

          settings = {
            apparition-enable-effect = false;
            fire-enable-effect = false;
            aura-glow-enable-effect = false;
            broken-glass-enable-effect = false;
            doom-enable-effect = false;
            energize-a-enable-effect = false;
            energize-b-enable-effect = false;
            focus-enable-effect = false;
            glide-enable-effect = true;
            glitch-enable-effect = false;
            hexagon-enable-effect = false;
            incinerate-enable-effect = false;
            matrix-enable-effect = false;
            mushroom-enable-effect = false;
            paint-brush-enable-effect = false;
            pixelate-enable-effect = false;
            pixel-wheel-enable-effect = false;
            pixel-wipe-enable-effect = false;
            portal-enable-effect = false;
            rgbwarp-enable-effect = false;
            snap-enable-effect = false;
            team-rocket-enable-effect = false;
            trex-enable-effect = false;
            tv-enable-effect = false;
            tv-glitch-enable-effect = false;
            wisps-enable-effect = false;
            glide-scale = 0.7;
            glide-squish = 1.0;
            glide-tilt = -1.0;
            glide-shift = -0.2;
            glide-animation-time = 150;
          };
        };

        compiz-windows-effect = {
          friction = 5.0;
          mass = 50.0;
          resize-effect = true;
          speedup-factor-divider = 5.0;
          spring-k = 2.0;
        };

        rounded-window-corners-reborn = {
          border-width = 1;

          global-rounded-corner-settings = {
            enabled = true;
            borderRadius = 12;
            smoothing = 0;
            borderColor = "#ffffff12";
            padding = {
              left = 1;
              right = 1;
              top = 1;
              bottom = 1;
            };
            keepRoundedCorners = {
              maximized = false;
              fullscreen = false;
            };
          };
        };

        alphabetical-app-grid = {
          folder-order-position = "end";
        };

        coverflow-alt-tab = {
          desaturate-factor = 0.0;
          icon-style = "Classic";
          switcher-background-color = "#ffffff";
          use-glitch-effect = false;
        };

        hidetopbar = {
          enable-intellihide = false;
          mouse-sensitive = true;
          mouse-sensitive-fullscreen-window = false;
        };

        date-menu-formatter = {
          pattern = "dd.MM  HH:mm";
          formatter = "01_luxon";
          text-align = "center";
          update-level = 1;
        };

        notification-timeout = {
          timeout = 2000;
        };

        forge = {
          css-last-update = 37;
          dnd-center-layout = "swap";
          float-always-on-top-enabled = false;
          focus-border-toggle = false;
          quick-settings-enabled = false;
          split-border-toggle = false;
          stacked-tiling-mode-enabled = false;
          tabbed-tiling-mode-enabled = false;
          window-gap-size = 4;
        };

        blur-my-shell = {
          general = {
            settings-version = 2;
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
              pipeline_default_rounded = {
                name = "Default rounded";
                effects = [
                  {
                    blur.gaussian = {
                      radius = 30;
                      brightness = 0.6;
                    };
                  }
                  {
                    corner = {
                      radius = 24;
                    };
                  }
                ];
              };
            };
          };

          appfolder = {
            brightness = 0.6;
            sigma = 60;
          };

          coverflow-alt-tab = {
            pipeline = "pipeline_default";
          };

          lockscreen = {
            pipeline = "pipeline_default";
          };

          overview = {
            pipeline = "pipeline_default";
          };

          panel = {
            blur = false;
          };

          screenshot = {
            pipeline = "pipeline_default";
          };

          window-list = {
            brightness = 0.3;
            sigma = 100;
          };
        };
      })
    ];
  };
}
