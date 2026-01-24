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

  # Pass paths to the script via environment variables as it expects
  # We use '.' because we 'cd' into the source directory or reference relative to build root
  rawPath = "./resources/zero-src";
  # condensedPath = "./resources/zero-condensed-src"; # Uncomment if you have this

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
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl; # Updated to reflect your custom NAPL if defined elsewhere
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
