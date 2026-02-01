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
  # condensedPath = "./resources/zero-condensed-src";

  buildPhase = ''
    runHook preBuild

    # Create a local output directory that is writable
    mkdir -p ./dist

    echo "Generating Zero font..."

    # We set 'out' to our local dist folder so the script can write to it
    # We use 'rawPath' which we defined above
    env out=./dist rawPath=$rawPath fontforge -script ./scripts/make-zero.py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Now we move files from the local 'dist' to the actual Nix $out
    mkdir -p $out/share/fonts/truetype
    install -Dm644 ./dist/share/fonts/truetype/*.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Zero Font";
    longDescription = ''
      **Zero Font** is a custom typeface designed for the ZenOS aesthetic.
      It includes a standard and condensed variant, optimized for UI legibility.

      **Features:**
      - Custom glyphs and ligatures.
      - Optimized for high-DPI displays.
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
