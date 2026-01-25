{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.zenos.desktops.gnome.tweaks.zenosExtensions;

  # Helper to check if an extension name is NOT in the exclusion list
  isAllowed = name: !(lib.elem name cfg.excludedExtensions);
in
{
  imports = [ ./imports.nix ]; # Imports the list of modules we created

  options.zenos.desktops.gnome.tweaks.zenosExtensions = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable installation of curated ZenOS GNOME extensions.";
        };
        excludedExtensions = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of curated ZenOS GNOME extensions to exclude from installation (by name, e.g. \"user-themes\").";
        };
        extensionConfig.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Default ZenOS extension settings.";
        };
      };
    };
    default = true;
    description = "Install the curated ZenOS GNOME extension set.";
  };

  # Main configuration block only checks if the main feature is enabled
  config = lib.mkIf cfg.enable {

    zenos.desktops.gnome.extensions = lib.mkMerge [
      # ==========================================================
      # 1. Enable Extensions
      # ==========================================================
      # This block handles the installation/enablement of extensions based on the exclusion list.
      # It runs regardless of whether extensionConfig (defaults) is enabled.
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

      # ==========================================================
      # 2. Configure Extensions (ZenOS Defaults)
      # ==========================================================
      # This block applies the opinionated ZenOS settings.
      # It is guarded by extensionConfig.enable.
      (lib.mkIf cfg.extensionConfig.enable {

        # --- App Hider ---
        app-hider.hidden-apps = [ "vesktop.desktop" ];

        # --- Burn My Windows ---
        burn-my-windows = {
          # We point to the profile we create below using environment.etc
          active-profile = "/etc/burn-my-windows/profiles/zenos.conf";
          prefs-open-count = 2;
          last-extension-version = 47;
          last-prefs-version = 47;

          # Converted from bmw.conf INI
          settings = {
            apparition-enable-effect = false;
            fire-enable-effect = false;
            apparition-twirl-intensity = 0.0;
            apparition-shake-intensity = 0.0;
            apparition-suction-intensity = 1.0;
            apparition-randomness = 0.0;
            aura-glow-enable-effect = false;
            broken-glass-enable-effect = false;
            broken-glass-gravity = -2.0;
            broken-glass-blow-force = 2.0;
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
            team-rocket-animation-time = 500;
            team-rocket-animation-split = 0.28999999999999998;
            trex-enable-effect = false;
            tv-enable-effect = false;
            tv-glitch-enable-effect = false;
            wisps-enable-effect = false;
            glide-scale = 0.73999999999999999;
            glide-squish = 1.0;
            glide-tilt = -0.69999999999999996;
            glide-shift = -0.050000000000000003;
            glide-animation-time = 150;
            energize-b-animation-time = 1100;
            energize-b-scale = 1.0;
            aura-glow-animation-time = 149;
          };
        };

        # --- Compiz Windows Effect ---
        compiz-windows-effect = {
          friction = 4.9;
          mass = 50.0;
          resize-effect = true;
          speedup-factor-divider = 4.7;
          spring-k = 2.2;
        };

        # --- Rounded Window Corners Reborn ---
        rounded-window-corners-reborn = {
          border-width = 1;

          # Converted from rwcr_settings.txt
          global-rounded-corner-settings = {
            enabled = true;
            borderRadius = 12;
            smoothing = 0;
            borderColor = [
              0.19215686619281769
              0.19215686619281769
              0.20784313976764679
              1.0
            ];
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

        # --- Alphabetical App Grid ---
        alphabetical-app-grid = {
          folder-order-position = "end";
        };

        # --- Coverflow Alt-Tab ---
        coverflow-alt-tab = {
          desaturate-factor = 0.0;
          icon-style = "Classic";
          # Converted from GVariant Tuple [ 1.0 1.0 1.0 ]
          switcher-background-color = "(1.0, 1.0, 1.0)";
          use-glitch-effect = false;
        };

        # --- Hide Top Bar ---
        hidetopbar = {
          enable-intellihide = false;
          mouse-sensitive = true;
          mouse-sensitive-fullscreen-window = false;
        };

        # --- Date Menu Formatter ---
        date-menu-formatter = {
          pattern = "dd.MM  HH:mm";
          formatter = "01_luxon";
          text-align = "center";
          font-size = 9;
          update-level = 1;
        };

        # --- Notification Timeout ---
        notification-timeout = {
          timeout = 2000;
        };

        # --- Forge ---
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

        # --- Blur My Shell ---
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
            sigma = 30;
          };

          coverflow-alt-tab = {
            pipeline = "pipeline_default";
          };

          dash-to-dock = {
            blur = true;
            brightness = 0.6;
            pipeline = "pipeline_default_rounded";
            sigma = 30;
            static-blur = true;
            style-dash-to-dock = 0; # Transparent
          };

          lockscreen = {
            pipeline = "pipeline_default";
          };

          overview = {
            pipeline = "pipeline_default";
          };

          panel = {
            blur = false;
            brightness = 0.6;
            pipeline = "pipeline_default";
            sigma = 30;
          };

          screenshot = {
            pipeline = "pipeline_default";
          };

          window-list = {
            brightness = 0.6;
            sigma = 30;
          };
        };
      })
    ];

    # ==========================================================
    # Manual Resource Handling (Legacy Support)
    # ==========================================================

    # Maintain the file placement for Burn My Windows profile
    # Only generated if extensionConfig is enabled, matching the logic above
    environment.etc."burn-my-windows/profiles/zenos.conf" = lib.mkIf cfg.extensionConfig.enable {
      source = lib.readFile ./resources/bmw.conf;
    };
  };
}
