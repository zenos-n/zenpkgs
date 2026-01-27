{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.zenos.webApps;

  extensionSubmodule = types.submodule {
    options = {
      id = mkOption { type = types.str; };
      url = mkOption { type = types.str; };
    };
  };

  searchSubmodule = types.submodule {
    options = {
      name = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      url = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      icon = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };
  };

  mozlz4Script = pkgs.writeScript "json2mozlz4.py" ''
    #!${pkgs.python3}/bin/python3
    import sys, os, json
    try: import lz4.block
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
  sanitizeExtensionId =
    id: "${lib.replaceStrings [ "@" "." ] [ "_" "_" ] (lib.toLower id)}-browser-action";

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

  globalMozillaCfg = ''
    // mozilla.cfg - Zenos WebApps PWA Focus
    if (typeof dump !== 'undefined') dump("PWA_DEBUG: mozilla.cfg is loading...\n");
    try {
      const getService = (c, i) => Cc[c].getService(Ci[i]);
      let Services = {};
      try {
         const { Services: s } = ChromeUtils.importESModule("resource://gre/modules/Services.sys.mjs");
         Services = s;
      } catch(e) { /* fallback */ }
      
      let pwaConfig = {};
      try {
        let profileDir = Services.dirsvc.get("ProfD", Ci.nsIFile);
        let configFile = profileDir.clone(); configFile.append("pwa.json");
        if (configFile.exists()) {
             let data = "";
             let fstream = Cc["@mozilla.org/network/file-input-stream;1"].createInstance(Ci.nsIFileInputStream);
             fstream.init(configFile, -1, 0, 0);
             let sis = Cc["@mozilla.org/scriptableinputstream;1"].createInstance(Ci.nsIScriptableInputStream);
             sis.init(fstream);
             data = sis.read(sis.available());
             sis.close(); fstream.close();
             pwaConfig = JSON.parse(data);
        }
      } catch (ex) {}

      if (pwaConfig.url) {
        try {
           const { AboutNewTab } = ChromeUtils.importESModule("resource:///modules/AboutNewTab.sys.mjs");
           AboutNewTab.newTabURL = pwaConfig.url;
        } catch(e){}
      }

      const forceContentFocus = (win) => {
         if (win && win.gBrowser && win.gBrowser.selectedBrowser) {
            win.setTimeout(() => {
                const browser = win.gBrowser.selectedBrowser;
                const currentSpec = browser.currentURI ? browser.currentURI.spec : "";
                if (pwaConfig.url && (currentSpec === "about:newtab" || currentSpec === "about:home" || currentSpec === "about:blank")) {
                    browser.loadURI(pwaConfig.url, { triggeringPrincipal: Services.scriptSecurityManager.getSystemPrincipal() });
                }
                browser.focus();
            }, 0);
         }
      };

      if (Services.obs) {
        Services.obs.addObserver((s,t,d) => { if(t==="browser-open-newtab-start") forceContentFocus(s); }, "browser-open-newtab-start", false);
        Services.obs.addObserver((s,t,d) => { s.addEventListener("load", () => forceContentFocus(s), {once:true}); }, "domwindowopened", false);
      }
    } catch(e) {}
  '';

  autoconfigJs = pkgs.writeText "autoconfig.js" ''
    pref("general.config.filename", "mozilla.cfg");
    pref("general.config.obscure_value", 0);
    pref("general.config.sandbox_enabled", false);
  '';

  mozillaCfg = pkgs.writeText "mozilla.cfg" globalMozillaCfg;

  pwaFirefox =
    let
      unwrapped = pkgs.firefox.unwrapped or pkgs.firefox;
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
          fi
        '';
      };
    in
    pkgs.runCommand "firefox-pwa-edition" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
      mkdir -p $out/bin
      makeWrapper "${patchedUnwrapped}/lib/firefox/firefox" "$out/bin/firefox-pwa" \
        --set MOZ_NATIVE_MESSAGING_HOSTS "${nativeMessagingHostsJoined}/lib/mozilla/native-messaging-hosts" \
        --add-flags "-name FFPWA"
    '';

  globalUserChrome = ''
    .tab-content::before { display: none; }
    .toolbarbutton-icon { --tab-border-radius: 0; }
    .toolbar-items { padding-left: 0 !important; padding-right: 0px !important; margin-right: 46px !important; height: 46px !important; align-items: center; }
    #TabsToolbar, #navigator-toolbox { height: 46px !important; overflow: visible !important; }
    #TabsToolbar-customization-target { height: 46px; }
    .toolbarbutton-1 { height: 34px !important; }
    #PanelUI-menu-button { right: 8px; top: 6px !important; position: absolute; }
    [data-l10n-id="browser-window-close-button"] { position: relative; right: 3px !important; top: 17px !important; }
    #nav-bar { right: 40px !important; height: 46px !important; }
    #nav-bar:focus-within { z-index: 2147483647 !important; }
    #urlbar-container { position: fixed !important; top: -100px !important; left: 92px; right: 40px !important; width: calc(100vw - 184px) !important; z-index: 9999 !important; pointer-events: none !important; }
    #urlbar-container:focus-within { top: 6px !important; position: fixed !important; pointer-events: auto !important; }
    .urlbarView { margin-top: 0 !important; }
    #taskbar-tabs-button { display: none !important; }
    #nav-bar-customization-target > .unified-extensions-item, #TabsToolbar-customization-target > .unified-extensions-item, #nav-bar > .unified-extensions-item { display: none !important; }
    .notificationbox-stack { position: fixed !important; top: 46px !important; left: 0 !important; right: 0 !important; z-index: 2147483647 !important; width: 100vw !important; max-height: 50vh !important; }
    notification-message { box-shadow: 0 4px 15px rgba(0,0,0,0.3) !important; margin-bottom: 0px !important; border-bottom: 1px solid rgba(0,0,0,0.1) !important; transition: transform 0.2s ease-out !important; }
  '';

in
{
  options.zenos.webApps = {
    firefoxGnomeTheme = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to firefox-gnome-theme directory.";
    };

    nativeMessagingHosts = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Packages containing native messaging hosts (backend agnostic).";
    };

    apps = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              enablePasswordManager = mkOption {
                type = types.bool;
                default = false;
              };
              extensions = mkOption {
                type = types.listOf extensionSubmodule;
                default = [ ];
              };
              search = mkOption {
                type = searchSubmodule;
                default = { };
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
            };
          }
        )
      );
    };
  };

  config = mkIf (cfg.enable && cfg.base == "firefox") {
    home.packages = [ pwaFirefox ];

    home.activation.pwaMakerApply = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      let
        profileBaseDir = "${config.home.homeDirectory}/.local/share/pwamaker-profiles";
        curl = getExe pkgs.curl;

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
                      id = "pwa-custom";
                      _name = app.search.name;
                      _loadPath = "[user]";
                      _iconMapObj = (if app.search.icon != null then { "32" = app.search.icon; } else { });
                      _urls = [ { template = app.search.url; } ];
                    }
                  ];
                  metaData = {
                    appDefaultEngineId = "google";
                    defaultEngineId = "pwa-custom";
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
            user_pref("browser.uiCustomization.state", '${layoutJson}');
            user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
            user_pref("browser.startup.homepage", "${app.url}");
            user_pref("browser.newtab.url", "${app.url}");
            user_pref("signon.rememberSignons", ${if app.enablePasswordManager then "true" else "false"});
            user_pref("extensions.pocket.enabled", false);
            user_pref("toolkit.cosmeticAnimations.enabled", false);
            ${app.extraPrefs}
            ${optionalString (cfg.firefoxGnomeTheme != null) ''
              user_pref("svg.context-properties.content.enabled", true);
              user_pref("gnomeTheme.hideSingleTab", true);
              user_pref("gnomeTheme.tabsAsHeaderbar", true);
            ''}
            EOF

            ${optionalString (cfg.firefoxGnomeTheme != null) ''
              ln -sfn "${cfg.firefoxGnomeTheme}" "$PWA_DIR/chrome/firefox-gnome-theme"
            ''}

            cat > "$PWA_DIR/chrome/userChrome.css" <<EOF
            ${baseChrome}
            ${globalUserChrome}
            ${hideButtonsCss}
            ${app.userChrome}
            EOF

            cat > "$PWA_DIR/chrome/userContent.css" <<EOF
            ${baseContent}
            ${app.userContent}
            EOF

            ${concatMapStrings (ext: ''
              EXT_FILE="$PWA_DIR/extensions/${ext.id}.xpi"
              if [ ! -f "$EXT_FILE" ]; then
                  echo "Downloading ${ext.id}..."
                  ${curl} -f -L -s -o "$EXT_FILE" "${ext.url}" || echo "Failed to download ${ext.id}"
              fi
            '') app.extensions}
          '';

      in
      ''
        echo "Running Zenos PWA Manager (Firefox Engine)..."
        mkdir -p "${profileBaseDir}"

        # Cleanup Stale Profiles
        CURRENT_IDS="${toString (mapAttrsToList (n: v: v.id) cfg.apps)}"
        for dir in "${profileBaseDir}"/*; do
            [ -d "$dir" ] || continue
            base_name=$(basename "$dir")
            if [[ ! " $CURRENT_IDS " =~ " $base_name " ]]; then
                echo "Removing stale profile: $base_name"
                rm -rf "$dir"
            fi
        done

        ${concatStrings (mapAttrsToList mkAppScript cfg.apps)}
        echo "Zenos PWA Manager complete."
      ''
    );
  };
}
