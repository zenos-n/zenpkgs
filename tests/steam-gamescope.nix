{ pkgs }:
let
  package = pkgs.zenos.com.neg-zero.SteamGamescope;
in
assert package.drvPath == pkgs.zenos.byCategories.apps.gaming.steam-gamescope.drvPath;
pkgs.runCommand "steam-gamescope-desktop-check" {
  nativeBuildInputs = [ pkgs.desktop-file-utils ];
} ''
  test -x ${package}/bin/steam-gamescope
  desktop=${package}/share/applications/com.neg-zero.SteamGamescope.desktop
  desktop-file-validate "$desktop"
  grep -Fx 'Exec=steam-gamescope' "$desktop"
  grep -Fx 'Icon=steam' "$desktop"
  touch "$out"
''
