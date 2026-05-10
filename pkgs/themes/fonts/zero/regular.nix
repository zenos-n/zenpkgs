{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation rec {
  pname = "zero-font";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "negative-zero-inft";
    repo = "zero-font";
    rev = "${version}";
    hash = "sha256-PnrdkHBDUYwJe/KPPEgFKxoJEpWMVZyuewCy+1Wn6qk=";
  };

  nativeBuildInputs = [
    (pkgs.python3.withPackages (ps: [ ps.fonttools ]))
  ];

  buildPhase = ''
    runHook preBuild

    # run the builder for the standard version
    # assumes builder.py and glyphs/ are in the root of the source
    python3 builder.py --src ./glyphs --output Zero-Regular.otf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    cp Zero-Regular.otf $out/share/fonts/opentype/

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Zero display typeface";
    homepage = "https://github.com/negative-zero-inft/zero-font";
    license = licenses.napalm;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
