{
  lib,
  stdenv,
  hicolor-icon-theme,
  ...
}:

stdenv.mkDerivation {
  pname = "zenos-icons";
  version = "1.0";

  src = ./src;
  propagatedBuildInputs = [ hicolor-icon-theme ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r $src/resources/* $out/share/icons
  '';

  meta = with lib; {
    description = ''
      Core iconography set for the ZenOS environment

      **ZenOS Icons** provides the central brand iconography for the ZenOS 
      desktop environment. It includes system icons, folder symbols, and 
      app icons designed to match the brand's minimal aesthetic.

      **Features:**
      - Consistent visual style across all sizes.
      - High-quality scalable vector graphics (SVG).
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
