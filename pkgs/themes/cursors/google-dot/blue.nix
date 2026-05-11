{
  stdenv,
  fetchzip,
  lib,
  ...
}:

stdenv.mkDerivation rec {
  pname = "googledot-cursor-blue";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/ful1e5/Google_Cursor/releases/download/v${version}/GoogleDot-Blue.tar.gz";
    # you'll need to update this hash.
    # run `nix-prefetch-url --unpack <url>` to get the right one.
    sha256 = "sha256-PmJeGShQLIC7ceRwQvSbphqz19fKptksZeHKi9QSL5Y=";
  };

  installPhase = ''
    install -dm755 $out/share/icons
    cp -r . $out/share/icons/GoogleDot-Blue
  '';

  meta = with lib; {
    description = ''
      Google Cursor

      An OpenSource cursor theme inspired by Google.
    '';
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
