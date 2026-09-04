{
  fetchFromGitHub,
  fontforge,
  lib,
  python3Packages,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "zero-mono-thin-font";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "negative-zero-inft";
    repo = "zero-font";
    rev = "1.0.0";
    hash = "sha256-PnrdkHBDUYwJe/KPPEgFKxoJEpWMVZyuewCy+1Wn6qk=";
  };

  nativeBuildInputs = [
    fontforge
    python3Packages.fonttools
  ];

  buildPhase = ''
    runHook preBuild
    python3 builder.py --src glyphs --output Zero-Mono.otf --mono
    cat > thin.py <<'PY'
    import fontforge

    font = fontforge.open("Zero-Mono.otf")
    font.selection.all()
    font.changeWeight(-45)
    font.familyname = "Zero Mono Thin"
    font.fullname = "Zero Mono Thin"
    font.fontname = "ZeroMonoThin"
    font.weight = "Thin"
    font.os2_weight = 100
    font.generate("Zero-Mono-Thin.otf")
    PY
    fontforge -lang=py -script thin.py
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 Zero-Mono-Thin.otf "$out/share/fonts/opentype/Zero-Mono-Thin.otf"
    runHook postInstall
  '';

  meta = {
    description = "Thin monospaced Zero display typeface";
    homepage = "https://github.com/negative-zero-inft/zero-font";
    license = lib.licenses.napalm;
    platforms = lib.platforms.all;
  };
}
