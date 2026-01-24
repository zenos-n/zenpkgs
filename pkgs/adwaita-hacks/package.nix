{
  lib,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "adwaita-hacks";
  version = "1.0";

  src = ./src;

  dontUnpack = true;

  installPhase = "
    mkdir -p $out/share/icons
    cp -r $src/resources/* $out/share/icons
  ";

  meta = with lib; {
    description = "Modified Adwaita icon pack with more icons";
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
