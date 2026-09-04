{
  fetchFromGitHub,
  lib,
  python3Packages,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "zero-font";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "negative-zero-inft";
    repo = "zero-font";
    rev = "1.0.0";
    hash = "sha256-PnrdkHBDUYwJe/KPPEgFKxoJEpWMVZyuewCy+1Wn6qk=";
  };

  nativeBuildInputs = [ python3Packages.fonttools ];

  postPatch = ''
    substituteInPlace builder.py \
      --replace-fail 'x_offset = FONT_PAD' 'x_offset = SCALE' \
      --replace-fail 'adv = _r(svg_w * SCALE + 2 * FONT_PAD)' 'adv = _r(svg_w * SCALE + 2 * SCALE)' \
      --replace-fail 'lsb = FONT_PAD' 'lsb = SCALE'
  '';

  buildPhase = ''
    runHook preBuild
    python3 builder.py --src glyphs --output Zero-Regular.otf
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 Zero-Regular.otf "$out/share/fonts/opentype/Zero-Regular.otf"
    runHook postInstall
  '';

  meta = {
    description = "Zero display typeface";
    homepage = "https://github.com/negative-zero-inft/zero-font";
    license = lib.licenses.napalm;
    platforms = lib.platforms.all;
  };
}
