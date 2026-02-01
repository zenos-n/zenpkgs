{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  chromaprint,
  makeWrapper,
}:

let
  pyPkgs = python3.pkgs;

  lyricsgenius = pyPkgs.buildPythonPackage rec {
    pname = "lyricsgenius";
    version = "3.7.5";
    pyproject = true;

    src = pyPkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-xPEMFPeYBFXGXIfQz9EIa+CWba7K+ZaTAy02tlo4qhY=";
    };

    doCheck = false;
    nativeBuildInputs = with pyPkgs; [
      setuptools
      hatchling
    ];
    propagatedBuildInputs = with pyPkgs; [
      requests
      beautifulsoup4
      hatchling
    ];
  };

  syncedlyrics = pyPkgs.buildPythonPackage rec {
    pname = "syncedlyrics";
    version = "1.0.0";
    pyproject = true;

    src = pyPkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-JrwIR7s1tYAyS3eYCsmxzkHJz/7WOe7rkDABfhumuZE=";
    };

    doCheck = false;
    nativeBuildInputs = with pyPkgs; [ poetry-core ];
    propagatedBuildInputs = with pyPkgs; [
      requests
      beautifulsoup4
      rapidfuzz
    ];
  };

  pythonEnv = python3.withPackages (
    ps: with ps; [
      mutagen
      musicbrainzngs
      thefuzz
      requests
      unidecode
      pillow
      beautifulsoup4
      rapidfuzz
      syncedlyrics
      lyricsgenius
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "swisstag";
  version = "5.2";

  src = fetchFromGitHub {
    owner = "doromiert";
    repo = "swisstag";
    rev = version;
    sha256 = "sha256-/ttw8TfzXk9UrwHKZfuEALRUnYlUIq+b7bOrOC8bf6A=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    pythonEnv
    chromaprint
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/man/man1
    cp swisstag.py $out/bin/swisstag
    cp swisstag.1 $out/share/man/man1/swisstag.1

    chmod +x $out/bin/swisstag

    runHook postInstall
  '';

  postFixup = ''
    # 1. Patch the shebang to use our constructed pythonEnv
    sed -i "1s|^#!/usr/bin/env python3|#!${pythonEnv}/bin/python3|" $out/bin/swisstag

    # 2. Wrap the binary to include fpcalc (from chromaprint) in the PATH
    wrapProgram $out/bin/swisstag \
      --prefix PATH : ${lib.makeBinPath [ chromaprint ]}
  '';

  meta = with lib; {
    description = "Automatic music tagger and renamer";
    longDescription = ''
      **Swisstag** is a powerful CLI tool for automatically tagging and organizing music collections.
      It uses MusicBrainz and other sources to fetch metadata, lyrics, and cover art, ensuring
      a clean and consistent music library.

      **Features:**
      - Automatic tagging via MusicBrainz.
      - Lyrics fetching (synced and unsynced).
      - Cover art downloading.
      - Intelligent file renaming.
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    mainProgram = "swisstag";
    platforms = platforms.zenos;
  };
}
