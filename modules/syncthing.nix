{ lib, ... }:

{
  imports = [
    # 1. The Magic Link: Aliases the entire directory tree
    (lib.mkAliasOptionModule [ "zenos" "system" "syncthing" ] [ "services" "syncthing" ])
  ];

  # 2. The Meta Injection
  # Since we aliased the namespace, adding options here adds them to 'services.syncthing' too.
  # We add a hidden '_meta' option that our Python script will scrape.
  options.zenos.system.syncthing._meta = lib.mkOption {
    type = lib.types.str;
    description = "High-performance, continuous file synchronization service
    
    stuff";
    default = "meta-marker";
    internal = true; # Hide from standard NixOS docs, but visible to our JSON generator
    visible = true; # Ensure it ends up in options.json
  };
}
