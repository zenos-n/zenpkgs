# Optional check hook. Build only in the dedicated ZenOS acceptance VM.
{ pkgs, zenDsl, nixpkgsSrc, homeManagerSrc }:
pkgs.runCommand "zenpkgs-gnome-extension-actions" {
  nativeBuildInputs = [ pkgs.python3 pkgs.nix ];
  src = ../.;
} ''
  export PYTHONDONTWRITEBYTECODE=1
  export PYTHONPATH=${zenDsl}/lib/zen-dsl
  export NIX_PATH=nixpkgs=${nixpkgsSrc}
  export ZENOS_ACCEPTANCE_VM=1
  python3 ${./test-gnome-extension-actions.py} "$src" ${homeManagerSrc}
  touch "$out"
''
