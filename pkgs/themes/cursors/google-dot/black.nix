{
  stdenv,
  fetchzip,
  lib,
  ...
}:

stdenv.mkDerivation rec {
  pname = "googledot-cursor-black";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/ful1e5/Google_Cursor/releases/download/v${version}/GoogleDot-Black.tar.gz";
    # you'll need to update this hash.
    # run `nix-prefetch-url --unpack <url>` to get the right one.
    sha256 = "sha256-pb2U9j1m8uJaILxUxKqp8q9FGuwzZsQvhPP3bfGZL5I=";
  };

  installPhase = ''
    install -dm755 $out/share/icons
    cp -r . $out/share/icons/GoogleDot-Black
  '';

  meta = with lib; {
    description = ''
      Custom rEFInd bootloader theme for ZenOS

      **ZenOS rEFInd Theme** provides a clean, modern look for the rEFInd
      bootloader. It includes custom icons, high-resolution backgrounds,
      and configuration settings optimized for the ZenOS minimal aesthetic.

      **Features:**
      - Fullscreen high-detail banner support.
      - Branded icon sets for various operating systems.
      - Streamlined UI hiding unnecessary boot elements.
    '';
    license = licenses.napalm;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
