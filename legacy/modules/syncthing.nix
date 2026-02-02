{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos.services.syncthing;

  # Target inspection for legacy/upstream paths
  legacyTarget = config.legacy.services.syncthing or { };
  targetEnabled = legacyTarget.enable or false;

  # Construct mapping for the legacy backend
  mappedCfg = {
    # We strip ZenOS-specific meta before passing to legacy
  }
  // (builtins.removeAttrs cfg [ "enable" ]);
in
{
  meta = {
    description = "Configures Syncthing file synchronization service";
    longDescription = ''
      Syncthing is a continuous file synchronization program. It synchronizes files between two or more computers in real time, safely protected from prying eyes.

      This module provides a high-level abstraction over the standard NixOS Syncthing service, 
      integrating it into the ZenOS configuration hierarchy.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.services.syncthing = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Syncthing service.";
    };

    # Note: Additional passthrough options would be defined here using 'zenopt'
  };

  config = lib.mkMerge [
    # Apply Mapping to Legacy Backend
    (lib.mkIf cfg.enable {
      legacy.services.syncthing = mappedCfg;

      # Ensure the package is sourced from zenos overlay if available
      services.syncthing.package = lib.mkDefault pkgs.zenos.syncthing;
    })

    # ZenOS Priority & Conflict Warnings
    {
      warnings =
        [ ]
        ++
          lib.optional (!cfg.enable && targetEnabled)
            "ZenOS Priority: 'syncthing' is active via a broad path (legacy.services). Please use the fine-grained 'zenos.services.syncthing' instead."
        ++
          lib.optional (cfg.enable && legacyTarget != mappedCfg)
            "ZenOS Conflict: You are using 'zenos.services.syncthing' but also modifying 'legacy.services.syncthing' elsewhere. Please stick to the abstraction.";
    }
  ];
}
