{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation {
  pname = "atkinson-hyperlegible-next";
  version = "2024-11-20";

  # Using direct GitHub links ensures the download is a valid font file, not an HTML error
  srcs = [
    (fetchurl {
      url = "https://github.com/google/fonts/raw/main/ofl/atkinsonhyperlegiblenext/AtkinsonHyperlegibleNext%5Bwght%5D.ttf";
      hash = "sha256-WkVdHPoJm2AatwdRu5Zz6P4YVNxFAMgOGiINDXXjF0U=";
    })
    (fetchurl {
      url = "https://github.com/google/fonts/raw/main/ofl/atkinsonhyperlegiblenext/AtkinsonHyperlegibleNext-Italic%5Bwght%5D.ttf";
      hash = "sha256-zpz/7TJ0KtLZI4xWGpMiA4Xlk0zcArjrQJelDvqVfcY=";
    })
  ];

  sourceRoot = ".";
  unpackPhase = "true";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    for file in $srcs; do
      cp $file $out/share/fonts/truetype/$(stripHash $file)
    done
    runHook postInstall
  '';

  meta = with lib; {
    description = "Atkinson Hyperlegible Next - An evolved high-visibility typeface";
    homepage = "https://fonts.google.com/specimen/Atkinson+Hyperlegible+Next";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
