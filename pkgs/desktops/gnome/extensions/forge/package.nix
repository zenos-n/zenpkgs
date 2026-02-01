{
  lib,
  stdenv,
  pkgs,
  ...
}:

stdenv.mkDerivation {
  pname = "forge";
  version = "custom";

  src = ./src/forge;

  dontBuild = true;

  installPhase = ''
    export UUID="forge@jmmaranan.com"
    dest="$out/share/gnome-shell/extensions/$UUID"
    mkdir -p "$dest"

    # Copy the precompiled contents directly
    cp -a . "$dest/"

    # Just in case, ensure schemas are compiled for the store path
    if [ -d "$dest/schemas" ]; then
      ${pkgs.glib.dev}/bin/glib-compile-schemas "$dest/schemas"
    fi
  '';

  meta = with lib; {
    description = "Customized version of the Forge GNOME extension";
    longDescription = ''
      **Forge (Custom)** is a modified build of the Forge GNOME extension, tailored for ZenOS.
      It includes specific tweaks and patches to ensure compatibility with GNOME 49 and integrates
      seamlessly with the ZenOS tiling workflow.

      **Features:**
      - Tiling window management for GNOME.
      - Custom compatibility patches for newer GNOME versions.
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
