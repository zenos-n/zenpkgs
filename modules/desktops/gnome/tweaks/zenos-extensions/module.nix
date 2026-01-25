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

  config = lib.mkIf (cfg.enable && cfg.extensionConfig.enable) {

    # ==========================================================
    # Core Extensions Configuration
    # ==========================================================

    zenos.desktops.gnome.extensions = {

      # --- User Themes ---
      user-theme.enable = isAllowed "user-themes";

      # --- App Hider ---
      app-hider = {
        enable = isAllowed "app-hider";
        hidden-apps = [ "vesktop.desktop" ];
      };

      # --- Hide Minimized ---
      hide-minimized.enable = isAllowed "hide-minimized";

      # --- Hide Cursor ---
      hide-cursor.enable = isAllowed "hide-cursor";

      # --- Burn My Windows ---
      burn-my-windows = {
        enable = isAllowed "burn-my-windows";
        # We point to the profile we create below using environment.etc
        active-profile = "/etc/burn-my-windows/profiles/zenos.conf";
        prefs-open-count = 2;
        last-extension-version = 47;
        last-prefs-version = 47;
      };

      # --- Compiz Windows Effect ---
      compiz-windows-effect = {
        enable = isAllowed "compiz-windows-effect";
        friction = 4.9;
        mass = 50.0;
        resize-effect = true;
        speedup-factor-divider = 4.7;
        spring-k = 2.2;
      };

      # --- Compiz Alike Magic Lamp ---
      compiz-alike-magic-lamp-effect.enable = isAllowed "compiz-alike-magic-lamp-effect";

      # --- Rounded Window Corners Reborn ---
      rounded-window-corners-reborn = {
        enable = isAllowed "rounded-window-corners-reborn";
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
        enable = isAllowed "alphabetical-app-grid";
        folder-order-position = "end";
      };

      # --- Category Sorted App Grid ---
      category-sorted-app-grid.enable = isAllowed "category-sorted-app-grid";

      # --- Coverflow Alt-Tab ---
      coverflow-alt-tab = {
        enable = isAllowed "coverflow-alt-tab";
        desaturate-factor = 0.0;
        icon-style = "Classic";
        # Converted from GVariant Tuple [ 1.0 1.0 1.0 ]
        switcher-background-color = "(1.0, 1.0, 1.0)";
        use-glitch-effect = false;
      };

      # --- Hide Top Bar ---
      hidetopbar = {
        enable = isAllowed "hide-top-bar";
        enable-intellihide = false;
        mouse-sensitive = true;
        mouse-sensitive-fullscreen-window = false;
      };

      # --- Mouse Tail ---
      mouse-tail.enable = isAllowed "mouse-tail";

      # --- Window Is Ready Remover ---
      window-is-ready-remover.enable = isAllowed "window-is-ready-remover";

      # --- Date Menu Formatter ---
      date-menu-formatter = {
        enable = isAllowed "date-menu-formatter";
        pattern = "dd.MM  HH:mm";
        formatter = "01_luxon";
        text-align = "center";
        font-size = 9;
        update-level = 1;
      };

      # --- GSConnect ---
      gsconnect = {
        enable = isAllowed "gsconnect";
        # Note: Window size/placement preferences are often device-specific or
        # managed by GTK state rather than extension settings in the new module.
      };

      # --- Clipboard Indicator ---
      clipboard-indicator = {
        enable = isAllowed "clipboard-indicator";
      };

      # --- Notification Timeout ---
      notification-timeout = {
        enable = isAllowed "notification-timeout";
        timeout = 2000;
      };

      # --- Forge ---
      forge = {
        enable = isAllowed "forge";
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

      # --- Zenlink Indicator ---
      zenlink-indicator = {
        enable = isAllowed "zenlink-indicator";
      };

      # --- Blur My Shell ---
      blur-my-shell = {
        enable = isAllowed "blur-my-shell";

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

      # ========================================
      # Configs for Excluded/Extra Extensions
      # ========================================
      # These were in the original dconf dump but not in the main enabled list.
      # We enable the config, but the user must enable the extension package explicitly
      # or rely on the module default if they choose to install it.

      # --- Rounded Corners (lennart-k) ---
      # This extension doesn't have a module in extmodules.txt, so config is skipped.
      # If you add a module for it, configure it here.

      # --- Media Controls ---
      # Module mpris-label.nix exists, but Media Controls usually refers to
      # 'org.gnome.shell.extensions.mediacontrols'. Checking if mpris-label covers it...
      # mpris-label settings are different. Skipping specific dconf for un-moduled extension.

      # --- Quick Settings Tweaks ---
      # No module found.

      # --- Panel Corners ---
      # No module found.
    };

    # ==========================================================
    # Manual Resource Handling (Legacy Support)
    # ==========================================================

    # Maintain the file placement for Burn My Windows profile
    environment.etc."burn-my-windows/profiles/zenos.conf" = {
      source = lib.readFile ./resources/bmw.conf;
    };
  };
}
