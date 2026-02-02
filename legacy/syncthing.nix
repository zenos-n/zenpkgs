{ config, lib, ... }:
with lib;
let
  # [1] Source: Fine-Grained Option (e.g. system.syncthing)
  cfg = config.system.syncthing or { };
  srcEnabled = cfg.enable or false;

  # [2] Target Inspection
  # Check if the legacy backend is active (via broad map or manual config)
  legacyTarget = config.legacy.services.syncthing or { };
  targetEnabled = legacyTarget.enable or false;

  # [3] Construct Mapping
  mappedCfg = {

  }
  // cfg;
in
{
  config = mkMerge [
    # A. Apply Map (Only if source is enabled)
    (mkIf srcEnabled {
      legacy.services.syncthing = mappedCfg;
    })

    # B. Priority Warnings
    {
      warnings =
        [ ]
        # Case 1: Bypass Detected (Target is active via Broad Map, but Fine-grained is OFF)
        ++
          optional (!srcEnabled && targetEnabled)
            "ZenOS Priority: 'syncthing' is active via a broad path (e.g. legacy.services). Please use the fine-grained 'system.syncthing' instead."
        # Case 2: Conflict Detected (Both enabled, but content differs)
        ++
          optional (srcEnabled && legacyTarget != mappedCfg)
            "ZenOS Conflict: You are using 'system.syncthing' but also modifying 'legacy.services.syncthing' elsewhere. Please stick to the abstraction.";
    }
  ];
}
