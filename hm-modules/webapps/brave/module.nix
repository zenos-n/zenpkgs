{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.zenos.webApps;
  enabled = cfg.enable && cfg.base == "brave";
in
{
  meta = {
    description = ''
      Brave browser backend for ZenOS webapps

      Configures Brave Browser as the execution backend for the ZenOS WebApps system. 
      This module handles the generation of isolated profiles and PWA wrappers using 
      Brave's `--app` flags. It is intended for users who prefer Brave-based rendering 
      for their web applications.

      > **Maintenance Warning:** This backend is **experimental** and community-maintained. 
      > The core ZenOS maintainer (doromiert) does not officially test or support Brave. 
      > Issues specific to this backend will be closed unless accompanied by a PR. 
      > For a supported experience, use the `firefox` backend.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.webApps.bravePackage = mkOption {
    type = types.package;
    default = pkgs.brave;
    description = ''
      Brave browser package for PWA execution

      Specifies the browser package used to run Brave-based web applications. 
      The package must support the `--app` and `--user-data-dir` flags.
    '';
  };

  config = mkIf enabled {
    warnings = [
      "zenos.webApps: The 'brave' backend is experimental. Only 'firefox' is officially supported and tested."
    ];

    # 1. Register Logic
    zenos.webApps.backend.getRunCommand =
      id:
      "${getExe cfg.bravePackage} --app=\"${cfg.apps.${id}.url}\" --user-data-dir=\"${cfg.profileDir}/${id}\" --class=\"brave-${id}\"";

    zenos.webApps.backend.getWmClass = id: "brave-${id}";

    # 2. Activation Script (Profile Generation)
    home.activation.pwaMakerBraveApply = hm.dag.entryAfter [ "writeBoundary" ] (
      let
        profileBaseDir = cfg.profileDir;
      in
      ''
        echo "Starting PWAMaker (Brave) activation..."
        mkdir -p "${profileBaseDir}"

        # Cleanup Logic:
        # We clean up profiles that are no longer in the apps list to prevent clutter.

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

        # Profile Directory Creation:
        # Brave handles the internal file structure on first launch, we just need the folder.
        ${concatStrings (
          mapAttrsToList (name: app: ''
            mkdir -p "${profileBaseDir}/${app.id}"
          '') cfg.apps
        )}
      ''
    );
  };
}
