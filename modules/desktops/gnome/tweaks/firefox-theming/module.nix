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

  customChromeCss = pkgs.writeText "userChrome.css" ''
    @import "gnome-theme/userChrome.css";
  '';

  customContentCss = pkgs.writeText "userContent.css" ''
    @import "gnome-theme/userContent.css";
  '';
  meta = {
    description = ''
      Native GNOME theming for Firefox

      Installs the `firefox-gnome-theme` and configures Firefox to look like a
      native GTK4 application. Includes activation scripts to rescue profiles 
      with missing `profiles.ini` to ensure the theme is applied reliably.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.tweaks.firefoxTheming = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable Firefox GNOME integration

        Applies GTK4 styling to Firefox via the rafaelmardojai theme and 
        configures necessary CSS overrides.
      '';
    };

    theme = {
      hideSingleTab = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Hide the tab bar when only one tab is open";
      };
      normalWidthTabs = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use standard width tabs instead of expanding them";
      };
      bookmarksToolbarUnderTabs = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Position the bookmarks toolbar beneath the tab bar";
      };
      roundedBottomCorners = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable rounded bottom corners for the browser window";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.activation.firefoxRescue = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
      for p_ini in $HOME/.mozilla/firefox/profiles.ini; do
        if [ ! -f "$p_ini" ] && [ ! -L "$p_ini" ]; then
          mkdir -p $(dirname "$p_ini")
          cat > "$p_ini" <<EOF
      [Profile0]
      Name=default
      IsRelative=1
      Path=default
      Default=1

      [General]
      StartWithLastProfile=1
      Version=2
      EOF
        elif [ -f "$p_ini" ] && [ ! -s "$p_ini" ] && [ ! -L "$p_ini" ]; then
          mv "$p_ini" "$p_ini.bak.$(date +%s)"
        fi
      done
    '';

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
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "svg.context-properties.content.enabled" = true;
                "browser.tabs.drawInTitlebar" = true;
                "browser.uidensity" = 1;
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
