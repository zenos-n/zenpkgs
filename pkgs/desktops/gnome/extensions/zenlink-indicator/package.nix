{
  lib,
  stdenv,
  pkgs,
  ...
}:

stdenv.mkDerivation {
  pname = "zenlink-indicator";
  version = "1.0";

  src = ./src;

  unpackPhase = " ";

  nativeBuildInputs = with pkgs; [ ];

  buildPhase = " ";

  installPhase = " ";

  meta = with lib; {
    description = ''
      ZenLink status indicator and control interface for GNOME

      **ZenLink Indicator** provides a status icon and control interface for the 
      ZenLink service. It integrates directly into the GNOME control center or 
      top bar, offering quick access to device pairing, file transfers, and 
      notification settings.

      **Features:**
      - Visual status indicator for connectivity.
      - Quick access menu for common actions.
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
