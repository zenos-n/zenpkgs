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
  options.zenos.webApps.bravePackage = mkOption {
    type = types.package;
    default = pkgs.brave;
    description = "Package to use for Brave-based PWAs.";
  };

  config = mkIf enabled {
    # 1. Register Logic
    zenos.webApps.backend.getRunCommand =
      id:
      "${getExe cfg.bravePackage} --app=\"${cfg.apps.${id}.url}\" --user-data-dir=\"${cfg.profileDir}/${id}\" --class=\"brave-${id}\"";

    zenos.webApps.backend.getWmClass = id: "brave-${id}";

    # 2. Activation Script (Profile Generation)
    home.activation.pwaMakerBraveApply = lib.hm.dag.entryAfter [ "writeBoundary" ] (
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
