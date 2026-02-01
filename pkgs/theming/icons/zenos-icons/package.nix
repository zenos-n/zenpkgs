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
    description = "ZenOS brand icons";
    longDescription = ''
      **ZenOS Icons** provides the core iconography for the ZenOS desktop environment.
      It includes system icons, folder icons, and application icons designed to match the ZenOS aesthetic.

      **Features:**
      - Consistent visual style.
      - Scalable vector graphics (SVG).
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
