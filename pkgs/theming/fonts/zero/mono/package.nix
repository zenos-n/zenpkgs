{
  fetchFromGitHub,
  lib,
  python3Packages,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "zero-mono-font";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "negative-zero-inft";
    repo = "zero-font";
    rev = "1.0.0";
    hash = "sha256-PnrdkHBDUYwJe/KPPEgFKxoJEpWMVZyuewCy+1Wn6qk=";
  };

  nativeBuildInputs = [ python3Packages.fonttools ];

  buildPhase = ''
    runHook preBuild
    python3 builder.py --src glyphs --output Zero-Mono.otf --mono
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 Zero-Mono.otf "$out/share/fonts/opentype/Zero-Mono.otf"
    runHook postInstall
  '';

  meta = {
    description = "Monospaced Zero display typeface";
    homepage = "https://github.com/negative-zero-inft/zero-font";
    license = lib.licenses.napalm;
    platforms = lib.platforms.all;
  };
}
