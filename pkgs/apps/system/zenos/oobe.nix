{ pkgs, ... }:

pkgs.writeShellScriptBin "zenos-oobe" ''
  # We reach into the zenos tree specifically
  exec ${pkgs.zenos.apps.system.zenos.installer}/bin/zenos-setup --oobe "$@"
''
