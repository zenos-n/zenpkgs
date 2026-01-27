{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.zenos.webApps;
  enabled = cfg.enable && cfg.base == "firefox";

  # --- Constants & Paths ---
  commonHidden = "Google,Bing,Amazon.com,DuckDuckGo,Wikipedia (en)";

  # --- Python Script for MozLZ4 Compression ---
  mozlz4Script = pkgs.writeScript "json2mozlz4.py" ''
    #!${pkgs.python3}/bin/python3
    import sys
    import os
    import json

    try:
        import lz4.block
    except ImportError:
        sys.stderr.write("Error: python3-lz4 not found.\n")
        sys.exit(1)

    if len(sys.argv) != 2:
        sys.stderr.write("Usage: json2mozlz4.py <output_file>\n")
        sys.exit(1)

    output_path = sys.argv[1]
    json_input = sys.stdin.read()
    json_data = json_input.encode('utf-8')

    header = b"mozLz40\0"
    compressed = lz4.block.compress(json_data)

    with open(output_path, 'wb') as f:
        f.write(header + compressed)
  '';

  pythonWithLz4 = pkgs.python3.withPackages (ps: [ ps.lz4 ]);

  # --- Layout Definitions ---
  layoutMap = {
    "back" = "back-button";
    "forward" = "forward-button";
    "reload" = "stop-reload-button";
    "home" = "home-button";
    "urlbar" = "urlbar-container";
    "spacer" = "spacer";
    "flexible" = "spring";
    "vertical-spacer" = "vertical-spacer";
    "tabs" = "tabbrowser-tabs";
    "alltabs" = "alltabs-button";
    "newtab" = "new-tab-button";
    "close" = "close-page-button";
    "minimize" = "minimize-button";
    "maximize" = "maximize-button";
    "menu" = "open-menu-button";
    "addons" = "unified-extensions-button";
    "downloads" = "downloads-button";
    "library" = "library-button";
    "sidebar" = "sidebar-button";
    "history" = "history-panelmenu";
    "bookmarks" = "bookmarks-menu-button";
    "print" = "print-button";
    "find" = "find-button";
    "fullscreen" = "fullscreen-button";
    "zoom" = "zoom-controls";
    "developer" = "developer-button";
    "site-info" = "site-info";
    "notifications" = "notifications-button";
    "tracking" = "tracking-protection-button";
    "identity" = "identity-button";
    "permissions" = "permissions-button";
  };

  resolveLayout = layoutList: map (item: layoutMap.${item} or item) layoutList;

  # Helper to generate Firefox widget IDs from Extension IDs
  sanitizeExtensionId =
    id:
    let
      lower = lib.toLower id;
      replaced = lib.replaceStrings [ "@" "." ] [ "_" "_" ] lower;
    in
    "${replaced}-browser-action";

  mkLayoutState =
    start: end: extensions:
    let
      extensionWidgets = map (e: sanitizeExtensionId e.id) extensions;
    in
    builtins.toJSON {
      placements = {
        "widget-overflow-fixed-list" = [ ];
        "unified-extensions-area" = extensionWidgets;
        "nav-bar" = [ ];
        "toolbar-menubar" = [ "menubar-items" ];
        "TabsToolbar" =
          (resolveLayout start)
          ++ [
            "tabbrowser-tabs"
            "new-tab-button"
          ]
          ++ (resolveLayout end);
        "PersonalToolbar" = [ ];
        "vertical-tabs" = [ ];
      };
      seen =
        (resolveLayout start)
        ++ [
          "tabbrowser-tabs"
          "new-tab-button"
        ]
        ++ (resolveLayout end)
        ++ extensionWidgets;
      dirtyAreaCache = [
        "nav-bar"
        "TabsToolbar"
        "PersonalToolbar"
        "toolbar-menubar"
        "vertical-tabs"
        "unified-extensions-area"
      ];
      currentVersion = 20;
      newElementCount = 5;
    };

  # --- Autoconfig Script (Global) ---
  globalMozillaCfg = ''
    // mozilla.cfg - PWA Focus, URL Override
    if (typeof dump !== 'undefined') dump("PWA_DEBUG: mozilla.cfg is loading...\n");

    try {
      const getService = (contractID, interfaceName) => 
        Cc[contractID].getService(Ci[interfaceName]);

      let Services = {};
      try {
         if (ChromeUtils.importESModule) {
            const { Services: s } = ChromeUtils.importESModule("resource://gre/modules/Services.sys.mjs");
            Services = s;
         } else {
            Services = ChromeUtils.import("resource://gre/modules/Services.jsm").Services;
         }
      } catch(e) {
         Services = {
           dirsvc: getService("@mozilla.org/file/directory_service;1", "nsIProperties"),
           obs: getService("@mozilla.org/observer-service;1", "nsIObserverService"),
           wm: getService("@mozilla.org/appshell/window-mediator;1", "nsIWindowMediator"),
           scriptSecurityManager: getService("@mozilla.org/scriptsecuritymanager;1", "nsIScriptSecurityManager")
         };
      }
      
      const getSSM = () => {
         if (Services.scriptSecurityManager) return Services.scriptSecurityManager;
         try { return getService("@mozilla.org/scriptsecuritymanager;1", "nsIScriptSecurityManager"); } 
         catch(e) { return null; }
      };

      // READ PROFILE CONFIG
      let pwaConfig = {};
      try {
        let profileDir = Services.dirsvc.get("ProfD", Ci.nsIFile);
        let configFile = profileDir.clone();
        configFile.append("pwa.json");
        
        if (configFile.exists()) {
          let fstream = Cc["@mozilla.org/network/file-input-stream;1"].createInstance(Ci.nsIFileInputStream);
          fstream.init(configFile, -1, 0, 0);
          let cstream = Cc["@mozilla.org/intl/converter-input-stream;1"].createInstance(Ci.nsIConverterInputStream);
          cstream.init(fstream, "UTF-8", 0, 0);
          
          let str = {};
          cstream.readString(-1, str);
          cstream.close();
          fstream.close();
          pwaConfig = JSON.parse(str.value);
        }
      } catch (ex) {
        if (typeof dump !== 'undefined') dump("PWA_DEBUG: Error reading pwa.json: " + ex + "\n");
      }

      // APPLY NEW TAB URL
      if (pwaConfig.url) {
        try {
          const { AboutNewTab } = ChromeUtils.importESModule("resource:///modules/AboutNewTab.sys.mjs");
          AboutNewTab.newTabURL = pwaConfig.url;
        } catch(e) {}
      }

      // FOCUS LOGIC
      const forceContentFocus = (win) => {
        if (win && win.gBrowser && win.gBrowser.selectedBrowser) {
          win.setTimeout(() => {
            const browser = win.gBrowser.selectedBrowser;
            const currentSpec = browser.currentURI ? browser.currentURI.spec : "";
            
            if (pwaConfig.url && (currentSpec === "about:newtab" || currentSpec === "about:home" || currentSpec === "about:blank")) {
               try {
                   const ssm = getSSM();
                   const triggeringPrincipal = ssm ? ssm.getSystemPrincipal() : null;
                   if (browser.fixupAndLoadURIString) {
                        browser.fixupAndLoadURIString(pwaConfig.url, { triggeringPrincipal });
                   } else {
                        browser.loadURI(pwaConfig.url, { triggeringPrincipal });
                   }
               } catch(e) {}
            }
            browser.focus();
          }, 0);
        }
      };
      
      const getTopWindow = () => {
         try {
            const { BrowserWindowTracker } = ChromeUtils.importESModule("resource:///modules/BrowserWindowTracker.sys.mjs");
            return BrowserWindowTracker.getTopWindow();
         } catch(e) {
            return Services.wm.getMostRecentWindow("navigator:browser");
         }
      };

      const NewTabObserver = {
        observe: function(subject, topic, data) {
          if (topic === "browser-open-newtab-start") {
            const win = getTopWindow();
            forceContentFocus(win);
          }
        }
      };

      const WindowOpenObserver = {
        observe: function(subject, topic, data) {
          const win = subject;
          win.addEventListener("load", () => {
             forceContentFocus(win);
          }, { once: true });
        }
      };

      if (Services.obs) {
        Services.obs.addObserver(NewTabObserver, "browser-open-newtab-start", false);
        Services.obs.addObserver(WindowOpenObserver, "domwindowopened", false);
      }

    } catch (e) {
      if (typeof dump !== 'undefined') dump("PWA_DEBUG: FATAL ERROR in mozilla.cfg: " + e + "\n");
    }
  '';

  # Define config files as store paths
  autoconfigJs = pkgs.writeText "autoconfig.js" ''
    pref("general.config.filename", "mozilla.cfg");
    pref("general.config.obscure_value", 0);
    pref("general.config.sandbox_enabled", false);
  '';

  mozillaCfg = pkgs.writeText "mozilla.cfg" globalMozillaCfg;

  # --- Wrapped Firefox Package ---
  pwaFirefox =
    let
      unwrapped = pkgs.firefox.unwrapped or pkgs.firefox;

      # Prepare Native Messaging Hosts
      nativeMessagingHostsJoined = pkgs.symlinkJoin {
        name = "pwa-native-messaging-hosts";
        paths = cfg.nativeMessagingHosts;
      };

      patchedUnwrapped = pkgs.symlinkJoin {
        name = "firefox-pwa-patched";
        paths = [ unwrapped ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          if [ -f "$out/lib/firefox/firefox" ]; then
            rm "$out/lib/firefox/firefox"
            cp "${unwrapped}/lib/firefox/firefox" "$out/lib/firefox/firefox"
            mkdir -p "$out/lib/firefox/defaults/pref"
            mkdir -p "$out/lib/firefox/defaults/preferences"
            cp "${autoconfigJs}" "$out/lib/firefox/defaults/pref/autoconfig.js"
            cp "${autoconfigJs}" "$out/lib/firefox/defaults/preferences/autoconfig.js"
            cp "${mozillaCfg}" "$out/lib/firefox/mozilla.cfg"
          else
            echo "ERROR: Could not find firefox binary in lib/firefox/"
            exit 1
          fi
        '';
      };

    in
    pkgs.runCommand "firefox-pwa-edition"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      }
      ''
        mkdir -p $out/bin
        if [ -f "${pkgs.firefox}/bin/firefox" ]; then
          # Extract the environment setup from the original wrapper, stripping the exec line
          grep -v '^\s*exec' "${pkgs.firefox}/bin/firefox" > "$out/bin/firefox"
          
          # Inject the Native Messaging Hosts environment variable
          echo 'export MOZ_NATIVE_MESSAGING_HOSTS="${nativeMessagingHostsJoined}/lib/mozilla/native-messaging-hosts"' >> "$out/bin/firefox"
          
          # Execute the patched binary
          echo 'exec -a "$0" "${patchedUnwrapped}/lib/firefox/firefox" "$@"' >> "$out/bin/firefox"
          chmod +x "$out/bin/firefox"
        else
          ln -s "${patchedUnwrapped}/lib/firefox/firefox" "$out/bin/firefox"
        fi
      '';

  # --- Global CSS ---
  globalUserChrome = ''
    .tab-content::before { display: none; }
    .toolbarbutton-icon { --tab-border-radius: 0; }
    .toolbar-items {
      padding-left: 0 !important;
      padding-right: 0px !important;
      margin-right: 46px !important;
      height: 46px !important;
      align-items: center;
    }

    /* Strict 46px height to match GNOME headers */
    #TabsToolbar, #navigator-toolbox {
       height: 46px !important;
       overflow: visible !important; 
    }

    #TabsToolbar-customization-target { height: 46px; }
    .toolbarbutton-1 { height: 34px !important; }
    #PanelUI-menu-button {
      right: 8px;
      top: 6px !important;
      position: absolute;
    }
    [data-l10n-id="browser-window-close-button"] {
      position: relative;
      right: 3px !important;
      top: 17px !important;
    }
    #nav-bar {
      right: 40px !important;
      height: 46px !important;
    }
    #nav-bar:focus-within {
      z-index: 2147483647 !important;
    }
    #urlbar-container {
      position: fixed !important;
      top: -100px !important; 
      left: 92px;
      right: 40px !important;
      width: calc(100vw - 92px - 92px) !important;
      z-index: 9999 !important;
      pointer-events: none !important;
    }
    #urlbar-container:focus-within {
      top: 6px !important;
      position: fixed !important; 
      pointer-events: auto !important;
    }
    .urlbarView { margin-top: 0 !important; }
    #taskbar-tabs-button { display: none !important; }

    /* Safety Net: Force extensions to stay off the toolbar */
    #nav-bar-customization-target > .unified-extensions-item,
    #TabsToolbar-customization-target > .unified-extensions-item,
    #nav-bar > .unified-extensions-item {
      display: none !important;
    }

    /* Floating Infobars (Banners) */
    .notificationbox-stack {
      position: fixed !important;
      top: 46px !important; 
      left: 0 !important;
      right: 0 !important;
      z-index: 2147483647 !important;
      width: 100vw !important;
      max-height: 50vh !important;
    }

    notification-message {
      box-shadow: 0 4px 15px rgba(0,0,0,0.3) !important;
      margin-bottom: 0px !important;
      border-bottom: 1px solid rgba(0,0,0,0.1) !important;
      transition: transform 0.2s ease-out !important;
    }
  '';

in
{
  meta = {
    description = "Firefox backend for ZenOS webapps";
    longDescription = ''
      Configures **Firefox** as the execution backend for the ZenOS WebApps system.

      ### Role & Status
      This is the **official, supported backend** for ZenOS web applications. It leverages a custom-patched Firefox wrapper ("PWA Edition") to provide a native-like application experience.

      ### Key Features
      * **Isolation:** Generates unique profiles (`pwa.json`, `user.js`) for each webapp.
      * **Styling:** Injects `userChrome.css` to hide browser chrome (tabs, URL bar) for an app-like feel.
      * **Optimization:** Aggressively strips telemetry, "pocket", and unnecessary network requests via `autoconfig.js`.
      * **Native Messaging:** Supports connecting specific native hosts per-app.

      ### GNOME Integration
      Supports the `firefox-gnome-theme` via the `firefoxGnomeTheme` option, allowing PWAs to blend seamlessly with the Adwaita aesthetic.

      ### Implementation Details
      This module compiles a python script (`json2mozlz4.py`) to handle the proprietary `mozLz4` compression required for search engine configuration, ensuring custom search engines work inside the PWAs.
    '';
    maintainers = with maintainers; [ doromiert ];
    license = licenses.napl;
    platforms = platforms.zenos;
  };

  options.zenos.webApps = {
    nativeMessagingHosts = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "List of packages containing native messaging hosts (Firefox specific)";
    };

    firefoxGnomeTheme = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Firefox gnome theme path";
      longDescription = ''
        Since the lead dev uses GNOME, he wanted to add gnome theme support but he didn't want to force it so he made this option.
      '';
    };
  };

  config = mkIf enabled {
    # 1. Register Logic for Global Dispatcher & Desktop Entries
    zenos.webApps.backend.getRunCommand =
      id:
      "${pwaFirefox}/bin/firefox --no-remote --profile \"${cfg.profileDir}/${id}\" --name \"FFPWA-${id}\"";

    zenos.webApps.backend.getWmClass = id: "FFPWA-${id}";

    # 2. Activation Script (Profile Generation)
    home.activation.pwaMakerApply = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      let
        curl = getExe pkgs.curl;
        profileBaseDir = cfg.profileDir;

        cleanupScript = ''
          echo "Cleaning up stale PWA profiles..."
          CURRENT_IDS=(${toString (mapAttrsToList (n: v: v.id) cfg.apps)})
          if [ -d "${profileBaseDir}" ]; then
            for dir in "${profileBaseDir}"/*; do
              [ -d "$dir" ] || continue
              base_name=$(basename "$dir")
              keep=0
              for id in "''${CURRENT_IDS[@]}"; do
                if [ "$id" == "$base_name" ]; then keep=1; break; fi
              done
              if [ "$keep" -eq 0 ]; then
                echo "Removing deleted PWA profile: $base_name"
                rm -rf "$dir"
              fi
            done
          fi
        '';

        mkAppScript =
          name: app:
          let
            pwaConfigJson = builtins.toJSON {
              url = app.url;
              id = app.id;
              name = app.name;
            };

            layoutJson = lib.replaceStrings [ "'" ] [ "\\'" ] (
              mkLayoutState app.layoutStart app.layoutEnd app.extensions
            );

            hasBack = elem "back" (app.layoutStart ++ app.layoutEnd);
            hasForward = elem "forward" (app.layoutStart ++ app.layoutEnd);
            hideButtonsCss = ''
              ${optionalString (!hasBack) "#back-button { display: none !important; }"}
              ${optionalString (!hasForward) "#forward-button { display: none !important; }"}
            '';
            baseChrome = optionalString (
              cfg.firefoxGnomeTheme != null
            ) ''@import "firefox-gnome-theme/userChrome.css";'';
            baseContent = optionalString (
              cfg.firefoxGnomeTheme != null
            ) ''@import "firefox-gnome-theme/userContent.css";'';
            fullChromeCss =
              baseChrome + "\n" + globalUserChrome + "\n" + hideButtonsCss + "\n" + app.userChrome;
            fullContentCss = baseContent + "\n" + app.userContent;
            allExtensions = app.extensions;
            builtinExtensionPreferences = {
              "newtab@mozilla.org" = {
                permissions = [
                  "internal:privateBrowsingAllowed"
                  "internal:svgContextPropertiesAllowed"
                ];
                origins = [ ];
                data_collection = [ ];
              };
            };
            userExtensionPreferences = lib.listToAttrs (
              map (ext: {
                name = ext.id;
                value = {
                  permissions = [
                    "internal:privateBrowsingAllowed"
                    "internal:svgContextPropertiesAllowed"
                  ];
                  origins = [ ];
                  data_collection = [ ];
                };
              }) allExtensions
            );
            extensionPreferencesJson = builtins.toJSON (
              builtinExtensionPreferences // userExtensionPreferences
            );
            extensionSettingsJson = builtins.toJSON {
              version = 3;
              commands = { };
              url_overrides = { };
              prefs = { };
              default_search = { };
            };

            searchJson =
              if (app.search.name != null && app.search.url != null) then
                builtins.toJSON {
                  version = 13;
                  engines = [
                    {
                      id = "google";
                      _name = "Google";
                      _isConfigEngine = true;
                      _metaData = {
                        order = 1;
                        hidden = true;
                      };
                    }
                    {
                      id = "bing";
                      _name = "Bing";
                      _isConfigEngine = true;
                      _metaData = {
                        order = 2;
                        hidden = true;
                      };
                    }
                    {
                      id = "ddg";
                      _name = "DuckDuckGo";
                      _isConfigEngine = true;
                      _metaData = {
                        order = 3;
                        hidden = true;
                      };
                    }
                    {
                      id = "perplexity";
                      _name = "Perplexity";
                      _isConfigEngine = true;
                      _metaData = {
                        order = 5;
                        hidden = true;
                      };
                    }
                    {
                      id = "wikipedia";
                      _name = "Wikipedia (en)";
                      _isConfigEngine = true;
                      _metaData = {
                        order = 6;
                        hidden = true;
                      };
                    }
                    {
                      id = "ebay-pl";
                      _name = "eBay";
                      _isConfigEngine = true;
                      _metaData = {
                        order = 4;
                        hidden = true;
                      };
                    }

                    {
                      id = "pwa-custom-search";
                      _name = app.search.name;
                      _loadPath = "[user]";
                      _iconMapObj = if (app.search.icon != null) then { "32" = app.search.icon; } else { };
                      _metaData = {
                        alias = "";
                        order = 7;
                      };
                      _urls = [
                        {
                          template = app.search.url;
                          rels = [ ];
                          params = [ ];
                        }
                      ];
                      _definedAliases = [ ];
                    }
                  ];
                  metaData = {
                    locale = "en-US";
                    region = "PL";
                    channel = "default";
                    experiment = "";
                    distroID = "nixos";
                    appDefaultEngineId = "google";
                    useSavedOrder = true;
                    defaultEngineId = "pwa-custom-search";
                    defaultEngineIdHash = "coWN0aFt2mwVL03WgGmnIeb8U8Eq9Jk8TGFEL/vyFZM=";
                  };
                }
              else
                "";

          in
          ''
            echo "Configuring PWA: ${app.name} (${app.id})"
            PWA_DIR="${profileBaseDir}/${app.id}"
            mkdir -p "$PWA_DIR/chrome" "$PWA_DIR/extensions"

            ${optionalString (searchJson != "") ''
              echo '${searchJson}' | ${pythonWithLz4}/bin/python3 ${mozlz4Script} "$PWA_DIR/search.json.mozlz4"
            ''}

            cat > "$PWA_DIR/pwa.json" <<EOF
            ${pwaConfigJson}
            EOF
            cat > "$PWA_DIR/user.js" <<EOF
            // Generated by nixpwamaker
            user_pref("browser.uiCustomization.state", '${layoutJson}');
            user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
            user_pref("browser.link.open_newwindow", 3);
            user_pref("browser.link.open_newwindow.restriction", 0);
            user_pref("browser.tabs.loadInBackground", false);
            user_pref("browser.search.openintab", false);
            user_pref("browser.taskbarTabs.enabled", false);
            user_pref("browser.sessionstore.resume_from_crash", false);
            user_pref("browser.startup.homepage_override.mstone", "ignore");
            user_pref("browser.startup.page", 1);

            // Password Manager (Default: Disabled)
            user_pref("signon.rememberSignons", ${if app.enablePasswordManager then "true" else "false"});
            user_pref("signon.autofillForms", ${if app.enablePasswordManager then "true" else "false"});

            user_pref("browser.ctrlTab.sortByRecentlyUsed", true);
            user_pref("middlemouse.paste", false);
            user_pref("general.autoScroll", true);

            user_pref("browser.startup.homepage", "${app.url}");

            user_pref("browser.newtab.url", "${app.url}");
            user_pref("devtools.chrome.enabled", true);
            user_pref("browser.dom.window.dump.enabled", true);
            user_pref("extensions.autoDisableScopes", 0);
            user_pref("extensions.install_distro_addons", true);

            // --- [P5.2] BLOAT REMOVAL & NETWORK SILENCE ---
            user_pref("extensions.pocket.enabled", false);
            user_pref("identity.fxaccounts.enabled", false);
            user_pref("extensions.screenshots.disabled", true);
            user_pref("reader.parse-on-load.enabled", false);

            // --- Network Silence ---
            user_pref("network.http.speculative-parallel-limit", 0);
            user_pref("network.dns.disablePrefetch", true);
            user_pref("browser.urlbar.speculativeConnect.enabled", false);

            // --- Crash Reporter ---
            user_pref("toolkit.crashreporter.enabled", false);
            user_pref("browser.tabs.crashReporting.sendReport", false);

            // --- [P13.D] GRAPHICS & PERFORMANCE ---
            user_pref("gfx.webrender.all", true);
            user_pref("media.ffmpeg.vaapi.enabled", true);
            user_pref("widget.dmabuf.force-enabled", true);
            user_pref("widget.wayland.fractional-scale.enabled", false);
            user_pref("layers.acceleration.force-enabled", true);

            // --- [P5.2] RESOURCE OPTIMIZATION ---
            user_pref("dom.ipc.processCount", 2);
            user_pref("accessibility.force_disabled", 1);
            user_pref("browser.sessionhistory.max_entries", 5);
            user_pref("browser.cache.memory.capacity", 262144);
            user_pref("network.prefetch-next", false);
            user_pref("browser.sessionstore.interval", 120000);
            user_pref("toolkit.cosmeticAnimations.enabled", false);

            // --- UI ANNOYANCE REMOVAL ---
            user_pref("browser.translations.enable", false);
            user_pref("browser.translations.automaticallyPopup", false);
            user_pref("browser.shell.checkDefaultBrowser", false);
            user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);

            ${optionalString (app.search.name != null) ''
              user_pref("browser.search.hiddenOneOffs", "${commonHidden}");
              user_pref("keyword.enabled", true);
            ''}

            ${optionalString (cfg.firefoxGnomeTheme != null) ''
              user_pref("svg.context-properties.content.enabled", true);
              user_pref("gnomeTheme.hideSingleTab", true);
              user_pref("gnomeTheme.tabsAsHeaderbar", true);
            ''}
            ${app.extraPrefs}
            EOF
            ${optionalString (cfg.firefoxGnomeTheme != null) ''
              ln -sfn "${cfg.firefoxGnomeTheme}" "$PWA_DIR/chrome/firefox-gnome-theme"
            ''}
            cat > "$PWA_DIR/chrome/userChrome.css" <<EOF
            ${fullChromeCss}
            EOF
            cat > "$PWA_DIR/chrome/userContent.css" <<EOF
            ${fullContentCss}
            EOF
            cat > "$PWA_DIR/extension-preferences.json" <<EOF
            ${extensionPreferencesJson}
            EOF
            cat > "$PWA_DIR/extension-settings.json" <<EOF
            ${extensionSettingsJson}
            EOF
            ${concatMapStrings (ext: ''
              EXT_FILE="$PWA_DIR/extensions/${ext.id}.xpi"
              if [ -f "$EXT_FILE" ] && [ ! -s "$EXT_FILE" ]; then rm "$EXT_FILE"; fi
              if [ ! -f "$EXT_FILE" ]; then
                echo "Downloading extension ${ext.id}..."
                ${curl} -f -L -s -o "$EXT_FILE" "${ext.url}" || (rm -f "$EXT_FILE" && echo "Failed to download ${ext.id}")
              fi
            '') allExtensions}
          '';

      in
      ''
        echo "Starting PWAMaker (Firefox) activation..."
        mkdir -p "${profileBaseDir}"
        ${cleanupScript}
        ${concatStrings (mapAttrsToList mkAppScript cfg.apps)}
        echo "PWAMaker activation complete."
      ''
    );
  };
}
