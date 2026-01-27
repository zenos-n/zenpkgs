{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.zenos.webApps;
  enabled = cfg.enable && cfg.base == "helium";
in
{
  meta = {
    maintainers = with maintainers; [ ];
    license = lib.licenses.napl;
  };
  options.zenos.webApps.heliumPackage = mkOption {
    type = types.package;
    default = pkgs.helium;
    description = "The Helium browser package.";
  };

  config = mkIf enabled {
    warnings = [
      "zenos.webApps: The 'helium' backend is experimental. Only 'firefox' is officially supported and tested."
    ];
    # 1. Register Logic
    # Helium is simple: helium <url>
    zenos.webApps.backend.getRunCommand = id: "${getExe cfg.heliumPackage} \"${cfg.apps.${id}.url}\"";

    # Helium usually doesn't allow setting WM Class easily via CLI,
    # so we fallback to the default binary name or a generic one.
    zenos.webApps.backend.getWmClass = id: "helium";

    # 2. Activation Script (No-op)
    # Helium doesn't use persistent profiles in the same way,
    # so we define a dummy activation to prevent errors if the global module expects one.
    home.activation.pwaMakerHeliumApply = lib.hm.dag.entryAfter [ "writeBoundary" ] (''
      echo "PWAMaker (Helium): No profile generation required."
    '');
  };
}
