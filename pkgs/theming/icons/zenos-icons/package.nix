{
  lib,
  stdenv,
  hicolor-icon-theme,
  ...
}:
stdenv.mkDerivation {
  pname = "zenos-icons";
  version = "1.0";

  propagatedBuildInputs = [ hicolor-icon-theme ];

  src = ./src;

  dontUnpack = true;

  installPhase = "
    mkdir -p $out/share/icons
    cp -r $src/resources/* $out/share/icons
  ";

  meta = with lib; {
    description = "ZenOS brand icons";
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
