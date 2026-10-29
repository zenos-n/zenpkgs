{ pkgs, sourceRoot, homeManager }:
pkgs.runCommand "zenpkgs-blankbox-module" {
  nativeBuildInputs = [ pkgs.python3 pkgs.nix ];
} ''
  export PYTHONDONTWRITEBYTECODE=1
  export NIX_REMOTE=dummy://
  python ${sourceRoot}/tests/check-blankbox.py \
    --nixpkgs ${pkgs.path} --home-manager ${homeManager}
  touch "$out"
''
