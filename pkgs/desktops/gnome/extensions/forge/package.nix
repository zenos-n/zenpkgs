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
    description = "Customized version of the forge gnome extension with tweaks to work with gnome 49. The license applies to my patches, not the original code.";
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
