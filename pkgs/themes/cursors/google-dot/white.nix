{
  stdenv,
  fetchzip,
  lib,
  ...
}:

stdenv.mkDerivation rec {
  pname = "googledot-cursor-white";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/ful1e5/Google_Cursor/releases/download/v${version}/GoogleDot-White.tar.gz";
    # you'll need to update this hash.
    # run `nix-prefetch-url --unpack <url>` to get the right one.
    sha256 = "sha256-eT/Zy6O6TBD6G8q/dg+9rNYDHutLLxEY1lvLDP90b+g=";
  };

  installPhase = ''
    install -dm755 $out/share/icons
    cp -r . $out/share/icons/GoogleDot-White
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
