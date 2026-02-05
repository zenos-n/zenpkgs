{ config, lib, ... }:
with lib;
let
  # [1] Source: ZenOS Abstraction (e.g. zenos.system.syncthing)
  cfg = config.zenos.system.syncthing or { };

  # [2] Target Inspection
  # Check if the legacy backend (Root Namespace) is active via other means
  legacyTarget = config.services.syncthing or { };
  targetEnabled = legacyTarget.enable or false;

  # [3] Construct Mapping
  mappedCfg = cfg;
in
{
  meta = {
    description = ''
      Legacy mapping for syncthing

      **Legacy Map: syncthing**

      Maps the ZenOS option `zenos.system.syncthing` to the root backend `services.syncthing`.
      Includes conflict detection and priority warnings.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  config = mkMerge [
    # A. Forward Configuration (Unconditional)
    {
      services.syncthing = mappedCfg;
    }

    # B. Priority Warnings
    {
      warnings =
        [ ]
        # Case 1: Bypass Detected (Target active via Root, but ZenOS abstraction empty)
        ++
          optional (cfg == { } && targetEnabled)
            "ZenOS Priority: 'syncthing' is active via the root path 'services.syncthing'. Please use the abstraction 'zenos.system.syncthing' instead."
        # Case 2: Conflict Detected (Abstraction used, but result differs)
        ++
          optional (cfg != { } && legacyTarget != mappedCfg)
            "ZenOS Conflict: You are using 'zenos.system.syncthing' but the final config for 'services.syncthing' differs. Please stick to the abstraction.";
    }
  ];
}
