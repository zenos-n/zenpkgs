{
  lib,
  stdenv,
  pkgs,
  ...
}:

stdenv.mkDerivation {
  pname = "zero-font";
  version = "1.0";

  src = ./src;
  nativeBuildInputs = with pkgs; [
    fontforge
    python3
  ];
  rawPath = "./resources/zero-src";

  buildPhase = ''
    runHook preBuild
    mkdir -p ./dist
    env out=./dist rawPath=$rawPath fontforge -script ./scripts/make-zero.py
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    install -Dm644 ./dist/share/fonts/truetype/*.ttf -t $out/share/fonts/truetype/
    runHook postInstall
  '';

  meta = with lib; {
    description = ''
      ZenOS signature typeface for titles

      **Zero Font** is a custom typeface designed for the ZenOS aesthetic.
    '';
    license = licenses.napalm;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
