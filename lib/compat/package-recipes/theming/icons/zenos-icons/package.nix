{
  fetchFromGitHub,
  lib,
  stdenv,
  hicolor-icon-theme,
  ...
}:

stdenv.mkDerivation {
  pname = "zenos-icons";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "zenos-n";
    repo = "zenos-icons";
    rev = "d9a053bd0e625973bdf7eb59315ee4a77bee6434";
    hash = "sha256-KxNRIFO3b4zuXGrpu1xOxyU0PbTiWJ9rFVvc1UsrU+g=";
  };
  propagatedBuildInputs = [ hicolor-icon-theme ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r $src/resources/* $out/share/icons
  '';

  meta = with lib; {
    description = ''
      Core iconography set for the ZenOS environment

      **ZenOS Icons** provides the central brand iconography for the ZenOS 
      desktop environment. It includes system icons, folder symbols, and 
      app icons designed to match the brand's minimal aesthetic.

      **Features:**
      - Consistent visual style across all sizes.
      - High-quality scalable vector graphics (SVG).
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
