{ pkgs, sourceRoot, homeManager }:
pkgs.runCommand "zenpkgs-blackbox-next-module" {
  nativeBuildInputs = [ pkgs.python3 pkgs.nix ];
} ''
  export PYTHONDONTWRITEBYTECODE=1
  export NIX_REMOTE=dummy://
  python ${sourceRoot}/tests/check-blackbox-next.py \
    --nixpkgs ${pkgs.path} --home-manager ${homeManager}
  touch "$out"
''
