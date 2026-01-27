{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.zenos.webApps;

  appSubmodule = types.submodule (
    { name, ... }:
    {
      options = {
        id = mkOption {
          type = types.str;
          default = name;
        };
        name = mkOption { type = types.str; };
        url = mkOption { type = types.str; };
        icon = mkOption {
          type = types.str;
          default = "web-browser";
        };
        categories = mkOption {
          type = types.listOf types.str;
          default = [
            "Network"
            "WebBrowser"
          ];
        };
        keywords = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
        openUrls = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "List of substrings to match in the URL for the dispatcher.";
        };
      };
    }
  );

in
{
  options.zenos.webApps = {
    enable = mkEnableOption "Zenos WebApps Module";

    base = mkOption {
      type = types.enum [ "firefox" ];
      default = "firefox";
      description = "The backend browser engine to use for PWAs.";
    };

    dispatcher = {
      enable = mkEnableOption "Enable internal URL dispatcher";
      fallbackBrowser = mkOption {
        type = types.str;
        default = "firefox";
        description = "Command for the fallback browser.";
      };
    };

    apps = mkOption {
      default = { };
      type = types.attrsOf appSubmodule;
    };
  };

  config = mkIf cfg.enable {
    home.packages = mkIf cfg.dispatcher.enable [
      (pkgs.writeScriptBin "pwa-dispatcher" ''
        #!${pkgs.bash}/bin/bash
        URL="$1"

        if [ -z "$URL" ]; then
          exec ${cfg.dispatcher.fallbackBrowser}
        fi

        ${concatStrings (
          mapAttrsToList (
            name: app:
            optionalString (app.openUrls != [ ]) ''
              # Match for PWA: ${app.name} (${app.id})
              ${concatMapStrings (pattern: ''
                if [[ "$URL" == *"${pattern}"* ]]; then
                  echo "PWA Dispatcher: Opening $URL in ${app.name}..."
                  # Check backend
                  if [ "${cfg.base}" == "firefox" ]; then
                      exec firefox-pwa --no-remote --profile "${config.home.homeDirectory}/.local/share/pwamaker-profiles/${app.id}" --name "FFPWA-${app.id}" "$URL"
                  fi
                fi
              '') app.openUrls}
            ''
          ) cfg.apps
        )}

        echo "PWA Dispatcher: No PWA match found. Opening in fallback browser..."
        exec ${cfg.dispatcher.fallbackBrowser} "$URL"
      '')
    ];

    xdg.desktopEntries =
      (mapAttrs (key: app: {
        name = app.name;
        genericName = "Web Application";
        exec = "firefox-pwa --no-remote --profile \"${config.home.homeDirectory}/.local/share/pwamaker-profiles/${app.id}\" --name \"FFPWA-${app.id}\" %U";
        icon = app.icon;
        categories = app.categories;
        settings = {
          Keywords = concatStringsSep ";" app.keywords;
          StartupWMClass = "FFPWA-${app.id}";
        };
      }) cfg.apps)
      // (optionalAttrs cfg.dispatcher.enable {
        pwa-dispatcher = {
          name = "PWA Dispatcher";
          genericName = "Web Browser Dispatcher";
          exec = "pwa-dispatcher %U";
          icon = "web-browser";
          categories = [
            "Network"
            "WebBrowser"
          ];
          mimeType = [
            "text/html"
            "text/xml"
            "application/xhtml+xml"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ];
        };
      });

    xdg.mimeApps = mkIf cfg.dispatcher.enable {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "pwa-dispatcher.desktop";
        "x-scheme-handler/https" = "pwa-dispatcher.desktop";
        "text/html" = "pwa-dispatcher.desktop";
        "application/xhtml+xml" = "pwa-dispatcher.desktop";
      };
    };
  };
}
