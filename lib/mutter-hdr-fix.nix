# Upstream MR5230 keeps HDR chromaticities without claiming 10,000-nit mastering.
# Replace only the known Nixpkgs 50.4 revert; leave other versions untouched.
{ mutter, fetchurl, lib }:
let
  isRevert = patch: lib.hasInfix "a1ae71798ef1ab2e0d2f753f5c98b38b1039b056" (toString patch);
in
if mutter.version != "50.4" || (mutter.zenosHdrChromaticityFix or false)
  || !(builtins.any isRevert (mutter.patches or [ ])) then mutter else
mutter.overrideAttrs (old: {
  patches = builtins.filter (patch: !(isRevert patch)) (old.patches or [ ]) ++ [
    (fetchurl {
      name = "mutter-50.4-hdr-chromaticity.patch";
      url = "https://github.com/GNOME/mutter/commit/35eda8a55e811aa0086fd2b5a33be9e5da9a0b72.patch";
      hash = "sha256-KKbhx/wwPtKDNDq/wb1kTamEDQQyDnJe8xlRB7d2Rwc=";
    })
  ];
  passthru = (old.passthru or { }) // { zenosHdrChromaticityFix = true; };
})
