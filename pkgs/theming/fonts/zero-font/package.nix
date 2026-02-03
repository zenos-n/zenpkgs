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
      ZenOS signature typeface for UI and terminals

      **Zero Font** is a custom typeface designed for the ZenOS aesthetic.
      It includes a standard and condensed variant, optimized for UI legibility 
      and high-DPI displays.

      **Features:**
      - Custom glyphs and ligatures.
      - Precise hinting for UI rendering.
    '';
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
