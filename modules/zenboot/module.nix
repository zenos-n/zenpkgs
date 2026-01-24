{
  lib,
  stdenv,
  pkgs,
  ...
}:
stdenv.mkDerivation {
  pname = "";
  version = "1.0";

  src = ./src;

  nativeBuildInputs = with pkgs; [
  ];

  buildPhase = "";

  installPhase = "";

  meta = with lib; {
    description = "";
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
