# @file: coremodules/desktop/gnome/tweaks/firefox-theming.nix
# @brief: Advanced Firefox theming (GNOME theme integration).
# @context: desktop tweaks
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.desktops.gnome.tweaks.firefoxTheming;
  themeCfg = cfg.theme;

  gnomeThemeRepo = pkgs.fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "v143";
    sha256 = "sha256-0E3TqvXAy81qeM/jZXWWOTZ14Hs1RT7o78UyZM+Jbr4=";
  };

  # [FIX] Import from the subdirectory so relative paths in the theme work
  customChromeCss = pkgs.writeText "userChrome.css" ''
    @import "gnome-theme/userChrome.css";
  '';

  # [FIX] Wrapper for userContent.css to maintain relative path integrity
  customContentCss = pkgs.writeText "userContent.css" ''
    @import "gnome-theme/userContent.css";
  '';
in
{
  meta = {
    description = "Applies native GNOME theming to Firefox";
    longDescription = ''
      Installs the `firefox-gnome-theme` and configures Firefox to look like a
      native GTK4 application.

      Includes activation scripts to rescue profiles with missing `profiles.ini`
      to ensure the theme applies correctly on fresh installs.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.tweaks.firefoxTheming = {
    enable = lib.mkEnableOption "Firefox Theming for GNOME Tweaks" // {
      description = "Enables the Firefox GNOME theme configuration.";
    };

    theme = {
      hideSingleTab = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Hides the tab bar when only one tab is open (GNOME Web style).";
      };

      normalWidthTabs = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Uses standard Firefox tab widths instead of expanding to fill the bar.";
      };

      bookmarksToolbarUnderTabs = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Moves the bookmarks toolbar below the tabs for better aesthetic integration.";
      };

      roundedBottomCorners = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables rounded bottom corners. Disabled by default to prevent double-rounding on GNOME.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # 1. System Level Assets
    environment.etc = {
      "firefox/gnome-theme".source = gnomeThemeRepo;
      "firefox/custom/userChrome.css".source = customChromeCss;
    };

    # 2. Activation Scripts (Rescue only)
    system.activationScripts.firefoxProfileRescue = {
      text = ''
        for user_home in /home/*; do
          p_ini="$user_home/.mozilla/firefox/profiles.ini"
          if [ -f "$p_ini" ] && [ ! -L "$p_ini" ]; then
            mv "$p_ini" "$p_ini.bak.$(date +%s)"
          fi
        done
      '';
    };

    # 3. Home Manager Configuration
    home-manager.sharedModules = [
      (
        { ... }:
        {
          programs.firefox = {
            enable = true;
            profiles.default = {
              id = 0;
              name = "default";
              isDefault = true;
              settings = {
                # --- Core Theme Settings ---
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "svg.context-properties.content.enabled" = true;
                "browser.tabs.drawInTitlebar" = true;
                "browser.uidensity" = 1; # Compact mode matches GNOME better

                # --- Configurable Options ---
                "gnomeTheme.hideSingleTab" = themeCfg.hideSingleTab;
                "gnomeTheme.normalWidthTabs" = themeCfg.normalWidthTabs;
                "gnomeTheme.bookmarksToolbarUnderTabs" = themeCfg.bookmarksToolbarUnderTabs;
                "widget.gtk.rounded-bottom-corners.enabled" = themeCfg.roundedBottomCorners;
              };
            };
          };

          home.file = {
            ".mozilla/firefox/default/chrome/userChrome.css".source = customChromeCss;
            ".mozilla/firefox/default/chrome/userContent.css".source = customContentCss;
            ".mozilla/firefox/default/chrome/gnome-theme".source = gnomeThemeRepo;
          };
        }
      )
    ];
  };
}
