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
        description = ''
          Extension ID to install

          Unique identifier for the extension, e.g., `ublock-origin@raymondhill.net`.
        '';
        example = "ublock-origin@raymondhill.net";
      };
      url = mkOption {
        type = types.str;
        description = ''
          Direct XPI download URL

          Specifies where the extension package can be retrieved for installation.
        '';
      };
    };
  };

  searchSubmodule = types.submodule {
    options = {
      name = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Custom search engine name

          Display label for the search engine in the browser UI.
        '';
      };
      url = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Search engine template URL

          URL containing a `{searchTerms}` placeholder for query substitution.
        '';
        example = "https://www.youtube.com/results?search_query={searchTerms}";
      };
      icon = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Search engine icon identifier

          Specifies the icon used for the search engine in selection menus.
        '';
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
          description = ''
            Unique web application identifier

            Used for profile directory naming and internal routing.
          '';
        };
        name = mkOption {
          type = types.str;
          description = ''
            Application display name

            Name used for desktop entries and browser window titles.
          '';
        };
        url = mkOption {
          type = types.str;
          description = ''
            Application home URL

            The primary address loaded when the application is launched.
          '';
        };
        icon = mkOption {
          type = types.str;
          default = "web-browser";
          description = ''
            Desktop entry icon

            Theme icon name or absolute path for the application launcher.
          '';
        };
        extensions = mkOption {
          type = types.listOf extensionSubmodule;
          default = [ ];
          description = ''
            List of pre-installed extensions

            Browser extensions to be automatically provisioned within the app profile.
          '';
        };
        search = mkOption {
          type = searchSubmodule;
          default = { };
          description = ''
            Search engine configuration

            Defines a custom search engine for the application's search bar.
          '';
        };
        enablePasswordManager = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable built-in password manager

            Whether to allow the backend browser to store and autofill credentials. 
            Availability depends on the chosen backend.
          '';
        };
        layoutStart = mkOption {
          type = types.listOf types.str;
          default = [
            "home"
            "reload"
          ];
          description = ''
            Leading toolbar elements

            Widget IDs to display at the beginning of the navigation bar.
          '';
        };
        layoutEnd = mkOption {
          type = types.listOf types.str;
          default = [ "addons" ];
          description = ''
            Trailing toolbar elements

            Widget IDs to display at the end of the navigation bar.
          '';
        };
        userChrome = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Custom browser UI CSS

            Raw CSS injected into `userChrome.css` for interface customization.
          '';
        };
        userContent = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Custom web content CSS

            Raw CSS injected into `userContent.css` to modify web page appearance.
          '';
        };
        extraPrefs = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Additional browser preferences

            Low-level preference strings to be written directly to `prefs.js`.
          '';
        };
        categories = mkOption {
          type = types.listOf types.str;
          default = [
            "Network"
            "WebBrowser"
          ];
          description = ''
            Desktop entry categories

            Categories assigned to the generated `.desktop` file for launcher organization.
          '';
        };
        keywords = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            Search provider keywords

            List of terms to index the application in desktop search results.
          '';
        };
        openUrls = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            URL interception patterns

            Substrings that, when encountered by the dispatcher, trigger this PWA.
          '';
          example = [ "discord.com" ];
        };
      };
    }
  );

in
{
  meta = {
    description = ''
      Declarative web application (PWA) manager for ZenOS

      This module provides a framework for creating isolated, declarative web applications 
      (Progressive Web Apps) using various browser backends.

      ### Why use this?
      - **Isolation**: Each app runs in its own profile, keeping cookies separate from your main browser.
      - **Integration**: Generates standard `.desktop` entries that integrate with your app launcher.
      - **Routing**: Includes an optional dispatcher that intercepts links and opens them in the correct PWA.

      ### Key Features
      - Custom CSS injection via `userChrome` and `userContent`.
      - Declarative extension management.
      - Deep integration with `xdg.desktopEntries` for correct window grouping.
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
      description = ''
        Backend browser engine

        Specifies the underlying engine for PWAs. Firefox is the primary 
        supported backend; others may have limited feature parity.
      '';
    };

    profileDir = mkOption {
      type = types.path;
      default = "${config.home.homeDirectory}/.local/share/pwamaker-profiles";
      description = ''
        Profile storage directory

        Root path where all PWA browser profiles and configuration will be stored.
      '';
    };

    backend = {
      getRunCommand = mkOption {
        internal = true;
        type = types.functionTo types.str;
        default = _: "echo 'No backend configured'";
        description = ''
          Internal launch command generator

          Function used to generate the execution string for a given application.
        '';
      };

      getWmClass = mkOption {
        internal = true;
        type = types.functionTo types.str;
        default = id: "PWA-${id}";
        description = ''
          Internal WM_CLASS generator

          Used to link windows to desktop entries for correct taskbar grouping.
        '';
      };
    };

    dispatcher = {
      enable = mkEnableOption "internal URL dispatcher";
      fallbackBrowser = mkOption {
        type = types.str;
        default = "firefox";
        description = ''
          Fallback browser command

          Command to execute for links that do not match any registered PWA pattern.
        '';
      };
    };

    apps = mkOption {
      default = { };
      type = types.attrsOf appSubmodule;
      description = ''
        PWA application definitions

        Attribute set mapping application names to their specific configurations.
      '';
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
