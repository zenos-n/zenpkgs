{ pkgs, sourceRoot, zenlinkSource, package, indicator }:
assert package.drvPath == indicator.drvPath;
assert package.extensionUuid == "zenlink@zenos-n.github.io";
pkgs.runCommand "zenpkgs-zenlink-integration" {
  nativeBuildInputs = [ pkgs.python3 pkgs.nix pkgs.gjs ];
} ''
  export PYTHONDONTWRITEBYTECODE=1
  export NIX_REMOTE=dummy://
  python ${sourceRoot}/tests/check-zenlink.py \
    --nixpkgs ${pkgs.path} --zenlink-source ${zenlinkSource}
  test -x ${package}/bin/zenlink
  test -x ${package}/bin/zenlink-preferences
  test ! -e ${package}/bin/zl-daemon
  test ! -e ${package}/bin/zl-installer
  gjs -m ${zenlinkSource}/installed-tests/test-media.js
  touch "$out"
''
