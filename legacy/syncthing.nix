{ config, lib, ... }:
with lib;
let
  # [1] Source: The New Option User Sets (e.g. system.boot)
  cfg = config.system.syncthing or { };
in
{
  # [2] Target: The Legacy Backend (e.g. legacy.system.boot)
  # Logic: Pass configuration through to legacy (Direct Mirror)
  config.legacy.services.syncthing = {
    # [3] Custom Mapping / Defaults (Optional)

  }
  // cfg;
}
