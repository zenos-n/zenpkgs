{ pkgs }:
let
  apply = mutter: import ../lib/mutter-sdr-hdr-fix.nix { inherit mutter; inherit (pkgs) fetchFromGitHub; };
  future = { version = "50.5"; sentinel = true; };
  mutter = apply pkgs.mutter;
in
assert apply future == future;
assert apply mutter == mutter;
assert mutter.version != "50.4" || mutter.zenosSdrHdrCorrection;
assert mutter.version != "50.4" || mutter.zenosHdrChromaticityFix;
assert mutter.version != "50.4" || mutter.zenosTouchFocusGuard;
pkgs.runCommand "mutter-sdr-hdr-package-check" { nativeBuildInputs = [ pkgs.glib pkgs.gjs pkgs.gobject-introspection ];
  buildInputs = [ pkgs.gtk4 pkgs.at-spi2-core ]; } ''
  export GSETTINGS_BACKEND=memory
  schemas=${mutter}/share/gsettings-schemas/${mutter.name}/glib-2.0/schemas
  gsettings --schemadir "$schemas" range org.gnome.mutter sdr-hdr-corrections > "$out"
  grep -Fx 'type a(ssssdd)' "$out"
  if [ "${mutter.version}" = "50.4" ]; then
    GI_TYPELIB_PATH=${mutter}/lib/mutter-18:$GI_TYPELIB_PATH gjs -c '
      imports.gi.versions.Clutter = "18";
      const Clutter = imports.gi.Clutter;
      if (typeof Clutter.PaintContext.prototype.get_target_color_state !== "function")
        throw Error("HDR offscreen effects cannot inspect the paint target");
    '
  fi
''
