{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    mapAttrs
    mapAttrsToList
    optionalString
    optionalAttrs
    concatStrings
    concatMapStrings
    concatStringsSep
    ;

  cfg = config.zenos.webApps;

  # --- Submodules Definition ---

  extensionSubmodule = types.submodule {
    options = {
      id = mkOption {
        type = types.str;
        description = "The ID of the extension to install";
        example = "ublock-origin@raymondhill.net";
      };
      url = mkOption {
        type = types.str;
        description = "The URL where the extension XPI can be downloaded";
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
        description = "The URL of the custom search engine with placeholder";
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
          description = "Unique identifier for the web application";
        };
        name = mkOption {
          type = types.str;
          description = "Display name of the application";
        };
        url = mkOption {
          type = types.str;
          description = "The home URL of the web application";
        };
        icon = mkOption {
          type = types.str;
          default = "web-browser";
          description = "The icon name or path for the desktop entry";
        };
        extensions = mkOption {
          type = types.listOf extensionSubmodule;
          default = [ ];
          description = "List of browser extensions to pre-install in the PWA profile";
        };
        search = mkOption {
          type = searchSubmodule;
          default = { };
          description = "Custom search engine configuration for the PWA";
        };
        enablePasswordManager = mkOption {
          type = types.bool;
          default = false;
          description = "Enable the built-in password manager";
          longDescription = "Whether to allow the backend browser to store and autofill credentials. Availability depends on the chosen backend.";
        };
        layoutStart = mkOption {
          type = types.listOf types.str;
          default = [
            "home"
            "reload"
          ];
          description = "Toolbar elements to display at the start of the navigation bar";
        };
        layoutEnd = mkOption {
          type = types.listOf types.str;
          default = [ "addons" ];
          description = "Toolbar elements to display at the end of the navigation bar";
        };
        userChrome = mkOption {
          type = types.lines;
          default = "";
          description = "Custom CSS for the browser UI (userChrome.css)";
        };
        userContent = mkOption {
          type = types.lines;
          default = "";
          description = "Custom CSS for web pages (userContent.css)";
        };
        extraPrefs = mkOption {
          type = types.lines;
          default = "";
          description = "Additional browser preferences (prefs.js)";
        };
        categories = mkOption {
          type = types.listOf types.str;
          default = [
            "Network"
            "WebBrowser"
          ];
          description = "Desktop categories for the application";
        };
        keywords = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Keywords for desktop search providers";
        };
        openUrls = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "URL substrings that should trigger this PWA via the dispatcher";
          example = [ "discord.com" ];
        };
      };
    }
  );

in
{
  meta = {
    description = "Declarative web application (PWA) manager for ZenOS";
    longDescription = ''
      This module provides a framework for creating isolated, declarative web applications 
      (Progressive Web Apps) using various browser backends.

      ### Why use this?
      - **Isolation**: Each app runs in its own profile, keeping cookies and history separate from your main browser.
      - **Integration**: Generates standard `.desktop` entries that integrate with your app launcher and taskbar.
      - **Routing**: Includes an optional dispatcher that intercepts links and opens them in the correct PWA (e.g., clicking a Discord link in your browser opens the Discord PWA).

      ### Key Features
      - Custom CSS injection via `userChrome` and `userContent`.
      - Declarative extension management.
      - Deep integration with `xdg.desktopEntries` for correct window grouping (WM_CLASS).
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.webApps = {
    enable = mkEnableOption "ZenOS WebApps declarative module";

    base = mkOption {
      type = types.enum [
        "firefox"
        "brave"
        "chrome"
        "helium"
      ];
      default = "firefox";
      description = "The backend browser engine to use for PWAs";
      longDescription = ''
        Firefox is the primary supported backend. Other backends are available but may 
        require manual maintenance or have limited feature support regarding CSS injection 
        and extension management.
      '';
    };

    profileDir = mkOption {
      type = types.path;
      default = "${config.home.homeDirectory}/.local/share/pwamaker-profiles";
      description = "Directory where PWA browser profiles are stored";
    };

    backend = {
      getRunCommand = mkOption {
        internal = true;
        type = types.functionTo types.str;
        default = _: "echo 'No backend configured'";
        description = "Internal function to generate the launch command for a specific PWA ID";
      };

      getWmClass = mkOption {
        internal = true;
        type = types.functionTo types.str;
        default = id: "PWA-${id}";
        description = "Internal function to generate the WM_CLASS for window matching";
        longDescription = ''
          Used to link windows to their desktop entries. This ensures that pinned 
          applications don't create duplicate icons in the taskbar when launched.
        '';
      };
    };

    dispatcher = {
      enable = mkEnableOption "internal URL dispatcher";
      fallbackBrowser = mkOption {
        type = types.str;
        default = "firefox";
        description = "Command to run for links that don't match any registered PWA";
      };
    };

    apps = mkOption {
      default = { };
      type = types.attrsOf appSubmodule;
      description = "Attribute set of web applications to configure";
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
    xdg.desktopEntries =
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
      }) cfg.apps);

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
