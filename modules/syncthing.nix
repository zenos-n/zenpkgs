{ lib, ... }:

{
  imports = [
    # 1. The Functional Link (Functionality)
    (lib.mkAliasOptionModule [ "zenos" "system" "syncthing" ] [ "services" "syncthing" ])
  ];

  # 2. The Meta Injection (Documentation Data)
  # Use "_zenpkgs-meta" to target the specific custom logic in doc_gen.py
  options.zenos.system.syncthing."_zenpkgs-meta" = lib.mkOption {
    type = lib.types.str;
    description = ''
      High-performance, continuous file synchronization service

      Syncthing replaces proprietary sync and cloud services with something open, trustworthy and decentralized.
    '';
    default = "meta-marker";
    visible = true;
    internal = false;
  };
}
