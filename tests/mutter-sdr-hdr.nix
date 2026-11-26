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
    gsettings --schemadir "$schemas" range org.gnome.mutter sdr-hdr-grading > grading-range.txt
    grep -Fx 'type a(ssssad)' grading-range.txt
    gsettings --schemadir "$schemas" get org.gnome.mutter sdr-hdr-grading > grading-default.txt
    grep -Fx '@a(ssssad) []' grading-default.txt
    gsettings --schemadir "$schemas" range org.gnome.mutter sdr-hdr-color-mixer > mixer-range.txt
    grep -Fx 'type a(ssssad)' mixer-range.txt
    gsettings --schemadir "$schemas" get org.gnome.mutter sdr-hdr-color-mixer > mixer-default.txt
    grep -Fx '@a(ssssad) []' mixer-default.txt
    gsettings --schemadir "$schemas" range org.gnome.mutter sdr-hdr-brightness-curves > curve-range.txt
    grep -Fx 'type a(ssssad)' curve-range.txt
    gsettings --schemadir "$schemas" get org.gnome.mutter sdr-hdr-brightness-curves > curve-default.txt
    grep -Fx '@a(ssssad) []' curve-default.txt
    GI_TYPELIB_PATH=${mutter}/lib/mutter-18:$GI_TYPELIB_PATH gjs -c '
      imports.gi.versions.Clutter = "18";
      const Clutter = imports.gi.Clutter;
      if (typeof Clutter.ColorState.prototype.params_set_sdr_mixer !== "function")
        throw Error("SDR color mixer API is missing");
      if (typeof Clutter.ColorState.prototype.params_set_sdr_white !== "function")
        throw Error("SDR brightness curve API is missing");
      if (typeof Clutter.PaintContext.prototype.get_target_color_state !== "function")
        throw Error("HDR offscreen effects cannot inspect the paint target");
    '
  fi
''
