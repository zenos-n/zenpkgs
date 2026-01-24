{
  lib,
  stdenv,
  pkgs,
  ...
}:
stdenv.mkDerivation {
  pname = "swisstag";
  version = "1.0";

  src = ./src;

  unpackPhase = " ";

  nativeBuildInputs = with pkgs; [

  ];

  buildPhase = " ";

  installPhase = " ";

  meta = with lib; {
    description = "Automatic music tagger and renamer";
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
