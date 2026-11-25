{ pkgs }:
let
  apply = mutter: import ../lib/mutter-hdr-fix.nix { inherit mutter; inherit (pkgs) fetchurl lib; };
  patched = apply pkgs.mutter;
  future = { version = "50.5"; sentinel = true; };
  source = pkgs.applyPatches { name = "mutter-hdr-checked-source"; src = patched.src; patches = patched.patches; };
in
assert apply future == future;
assert apply patched == patched;
assert pkgs.mutter.version != "50.4" || patched.zenosHdrChromaticityFix;
assert pkgs.mutter.version != "50.4" || patched.zenosTouchFocusGuard;
pkgs.runCommand "mutter-hdr-chromaticity-check" { } ''
  grep -q 'mastering_display_primaries' ${source}/src/backends/meta-output.c
  grep -q 'mastering_display_white_point' ${source}/src/backends/meta-output.c
  ! grep -q 'mastering_display_max_luminance = luminance' ${source}/src/backends/meta-output.c
  ! grep -q 'mastering_display_min_luminance = luminance' ${source}/src/backends/meta-output.c
  touch "$out"
''
