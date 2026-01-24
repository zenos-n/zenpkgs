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

  raw = ./src/resources/zero-src;

  nativeBuildInputs = with pkgs; [
    fontforge
    python3
  ];

  buildPhase = "
    runHook preBuild

    cp $src/make-zero.py ./build.py
    mkdir -p share/fonts/truetype

    echo \"Generating Zero font...\"
    out=. fontforge -script ./build.py

    runHook postBuild
  ";

  installPhase = "
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    install -Dm644 share/fonts/truetype/*.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  ";

  meta = with lib; {
    description = "Zero Font";
    homepage = "https://zenos.neg-zero.com"; # i know this doesn't exist yet but uhhhh
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };

}
