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
  meta = {
    description = ''
      Helium browser backend for ZenOS webapps

      Configures Helium Browser as the execution backend for the ZenOS WebApps system. 
      This module handles the generation of isolated profiles and PWA wrappers using 
      Helium's `--app` flags. It is intended for users who prefer Helium-based 
      rendering for their web applications.

      > **Maintenance Warning:** This backend is **experimental** and community-maintained. 
      > The core ZenOS maintainer (doromiert) does not officially test or support Helium. 
      > Issues specific to this backend will be closed unless accompanied by a PR. 
      > For a supported experience, use the `firefox` backend.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  # options.zenos.webApps.heliumPackage = mkOption {
  #   type = types.package;
  #   default = pkgs.helium;
  #   description = ''
  #     Helium browser package for PWA execution

  #     Specifies the browser package used to run Helium-based web applications.
  #     This package is invoked with the target URL as its primary argument.
  #   '';
  # };

  config = mkIf enabled {
    warnings = [
      "zenos.webApps: The 'helium' backend is experimental. Only 'firefox' is officially supported and tested."
    ];

    # 1. Register Logic
    # Helium is simple: helium <url>
    # zenos.webApps.backend.getRunCommand = id: "${getExe cfg.heliumPackage} \"${cfg.apps.${id}.url}\"";

    # Helium usually doesn't allow setting WM Class easily via CLI,
    # so we fallback to the default binary name or a generic one.
    zenos.webApps.backend.getWmClass = id: "helium";

    # 2. Activation Script (No-op)
    # Helium doesn't use persistent profiles in the same way,
    # so we define a dummy activation to prevent errors if the global module expects one.
    home.activation.pwaMakerHeliumApply = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "PWAMaker (Helium): No profile generation required."
    '';
  };
}
