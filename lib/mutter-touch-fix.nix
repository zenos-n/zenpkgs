# GNOME upstream MR5375: a touch-triggered window move must reject empty focus.
# Keep this narrowly scoped to the source version verified against the crash core.
{ mutter, fetchurl }:
if mutter.version != "50.4" || (mutter.zenosTouchFocusGuard or false) then mutter else
mutter.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    (fetchurl {
      name = "mutter-50.4-touch-empty-focus.patch";
      url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/13ed6caed4580d6d1ee8812a4d180ea8b5035ddc.patch";
      hash = "sha256-MSrM16EkgWUt4iTvo9VqRw2jRgCTKzqbJlNcq6s6FfI=";
    })
  ];
  passthru = (old.passthru or { }) // { zenosTouchFocusGuard = true; };
})
