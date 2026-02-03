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
    description = ''
      Customized version of the Forge GNOME tiling extension

      **Forge (Custom)** is a modified build of the Forge GNOME extension, 
      tailored specifically for ZenOS. It includes specific tweaks and 
      patches to ensure compatibility with modern GNOME versions and 
      integrates seamlessly with the ZenOS tiling workflow.

      **Features:**
      - Native-like tiling window management for GNOME Shell.
      - ZenOS-specific compatibility patches and workflow tweaks.
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
