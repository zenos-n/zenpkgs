{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.zenos.webApps;

  # --- Submodules Definition ---

  extensionSubmodule = types.submodule {
    options = {
      id = mkOption {
        type = types.str;
        description = "The ID of the extension you want to install (usually something@something.xyz or {2a3ef5...})";
      };
      url = mkOption {
        type = types.str;
        description = "The URL of the extension to install";
      };
    };
  };

  searchSubmodule = types.submodule {
    options = {
      name = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The name of the custom search engine";
      };
      url = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The URL of the custom search engine";
        example = "https://www.youtube.com/results?search_query={searchTerms}";
      };
      icon = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The icon of the custom search engine";
      };
    };
  };

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
        extensions = mkOption {
          type = types.listOf extensionSubmodule;
          default = [ ];
        };
        search = mkOption {
          type = searchSubmodule;
          default = { };
        };
        enablePasswordManager = mkOption {
          type = types.bool;
          default = false;
          description = "Enable the built-in password manager (Backend dependent).";
        };
        layoutStart = mkOption {
          type = types.listOf types.str;
          default = [
            "home"
            "reload"
          ];
        };
        layoutEnd = mkOption {
          type = types.listOf types.str;
          default = [ "addons" ];
        };
        userChrome = mkOption {
          type = types.lines;
          default = "";
        };
        userContent = mkOption {
          type = types.lines;
          default = "";
        };
        extraPrefs = mkOption {
          type = types.lines;
          default = "";
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
          description = "List of substrings to match in the URL to route to this PWA.";
        };
      };
    }
  );

in
{
  meta = {
    description = "The webapp maker tool for ZenOS";
    longDescription = ''
      Detailed module documentation.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.webApps = {
    enable = mkEnableOption "Zenos WebApps Declarative Module";

    base = mkOption {
      type = types.enum [
        "firefox"
        "brave"
        "chrome"
        "helium"
      ];
      default = "firefox";
      description = "The backend browser engine to use for PWAs ";
      longDescription = ''
        Firefox is the only one that's officially supported. 
        If you want the base for your browser to be supported, you need to maintain it yourself. 

        PRs welcome is what i'm saying.
      '';
    };

    profileDir = mkOption {
      type = types.path;
      default = "${config.home.homeDirectory}/.local/share/pwamaker-profiles";
      description = "Directory where PWA profiles are stored";
    };

    backend = {
      # Internal interface for the backend module to provide the execution command
      getRunCommand = mkOption {
        internal = true;
        type = types.functionTo types.str;
        default = _: "echo 'No backend configured'";
        description = "Function that takes an App ID and returns the shell command to launch it";
      };

      # Internal interface for WM Class (used for window matching in desktop entries)
      getWmClass = mkOption {
        internal = true;
        type = types.functionTo types.str;
        default = id: "PWA-${id}";
        description = "Internal interface for WM class";
        longDescription = ''
          It's basically used to get the WM class for the webapps so that window managers know that window x is actually an instance of x.desktop.
          This makes it so that if you let's say pin a webapp to your taskbar, it won't make a separate icon on it when you launch it but just use the icon you already pinned.

          Without this, webapps would look glitchy
        '';
      };
    };

    dispatcher = {
      enable = mkEnableOption "Enable internal URL dispatcher";
      longDescription = ''
        A small script that opens all web links and decides what app to open them in.
        Useful if you want to open all related links in the appropriate webapp.  
      '';
      fallbackBrowser = mkOption {
        type = types.str;
        default = "firefox";
        description = "Command to run for links that don't match any PWA.";
      };
    };

    apps = mkOption {
      default = { };
      type = types.attrsOf appSubmodule;
      description = "The webapps you want to use";
    };
  };

  config = mkIf cfg.enable {
    # 1. Generate the Dispatcher Script
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
                  exec ${cfg.backend.getRunCommand app.id} "$URL"
                fi
              '') app.openUrls}
            ''
          ) cfg.apps
        )}

        echo "PWA Dispatcher: No PWA match found. Opening in fallback browser..."
        exec ${cfg.dispatcher.fallbackBrowser} "$URL"
      '')
    ];

    # 2. Register Desktop Entries (Merged: Dispatcher + Apps)
    xdg.desktopEntries = (
      # Dispatcher Entry (Conditional)
      (optionalAttrs cfg.dispatcher.enable {
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
      })
      # PWA App Entries
      // (mapAttrs (key: app: {
        name = app.name;
        genericName = "Web Application";
        exec = "${cfg.backend.getRunCommand app.id} %U";
        icon = app.icon;
        categories = app.categories;
        settings = {
          Keywords = concatStringsSep ";" app.keywords;
          StartupWMClass = cfg.backend.getWmClass app.id;
        };
      }) cfg.apps)
    );

    # 3. Set Dispatcher as Default Application
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
