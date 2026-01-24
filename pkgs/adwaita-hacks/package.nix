{
  lib,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "adwaita-hacks";
  version = "1.0";

  # prob should be packaged separately but eh
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
