{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.zenos.webApps;
  enabled = cfg.enable && cfg.base == "chrome";
in
{
  meta = {
    description = "Chrome submodule for ZenOS webapps";
    longDescription = ''
      Configures Chrome Browser as the execution backend for the ZenOS WebApps system.

      This module handles the generation of isolated profiles and PWA wrappers using Chrome's `--app` flags. 
      1It is intended for users who prefer Chrome-based rendering for their web applications.

      > **Maintenance Warning:** This backend is **experimental** and community-maintained. The core ZenOS maintainer (doromiert) does not officially test or support Brave. Issues specific to this backend will be closed unless accompanied by a PR. For a supported experience, use the `firefox` backend.
    '';
    maintainers = with maintainers; [ ];
    license = licenses.napl;
    platforms = platforms.zenos;
  };

  options.zenos.webApps.chromePackage = mkOption {
    type = types.package;
    default = pkgs.google-chrome;
    description = "Package to use for Chrome-based PWAs (e.g., google-chrome, chromium, brave).";
  };

  config = mkIf enabled {
    warnings = [
      "zenos.webApps: The 'chrome' backend is experimental. Only 'firefox' is officially supported and tested."
    ];
    # 1. Register Logic
    zenos.webApps.backend.getRunCommand =
      id:
      "${getExe cfg.chromePackage} --app=\"${cfg.apps.${id}.url}\" --user-data-dir=\"${cfg.profileDir}/${id}\" --class=\"chrome-${id}\"";

    zenos.webApps.backend.getWmClass = id: "chrome-${id}";

    # 2. Activation Script (Simple Directory Creation)
    home.activation.pwaMakerChromeApply = hm.dag.entryAfter [ "writeBoundary" ] (
      let
        profileBaseDir = cfg.profileDir;
      in
      ''
        echo "Starting PWAMaker (Chrome) activation..."
        mkdir -p "${profileBaseDir}"

        # Chrome creates its own profile structure on first run, 
        # so we just ensure the directory exists and clean up old ones.

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

        ${concatStrings (
          mapAttrsToList (name: app: ''
            mkdir -p "${profileBaseDir}/${app.id}"
          '') cfg.apps
        )}
      ''
    );
  };
}
