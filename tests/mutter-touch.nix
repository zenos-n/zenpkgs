# Evaluate without building GNOME or changing any running desktop.
{ pkgs }:
let
  patched = import ../lib/mutter-touch-fix.nix { inherit (pkgs) mutter fetchurl; };
  future = { version = "50.5"; sentinel = true; };
  unchanged = import ../lib/mutter-touch-fix.nix { mutter = future; inherit (pkgs) fetchurl; };
in
assert unchanged == future;
assert (import ../lib/mutter-touch-fix.nix { mutter = patched; inherit (pkgs) fetchurl; }) == patched;
assert pkgs.mutter.version != "50.4" || patched.zenosTouchFocusGuard;
assert pkgs.mutter.version != "50.4" || builtins.length patched.patches == builtins.length (pkgs.mutter.patches or [ ]) + (if pkgs.mutter.zenosTouchFocusGuard or false then 0 else 1);
pkgs.runCommand "mutter-touch-backport-check" { } ''
  touch "$out"
''
