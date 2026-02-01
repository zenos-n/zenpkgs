{
  lib,
  stdenv,
  pkgs,
  ...
}:

stdenv.mkDerivation {
  pname = "zenos-rebuild";
  version = "1.0";

  src = ./src;

  propagatedBuildInputs = with pkgs; [
    libnotify
    tmux
  ];

  # Corrected from 'nativeInputs'
  nativeBuildInputs = with pkgs; [
    bash
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 $src/scripts/zenos-rebuild.sh $out/bin/zenos-rebuild
  '';

  meta = with lib; {
    description = "Wrapper for nixos-rebuild switch with additional features";
    longDescription = ''
      **zenos-rebuild** is a wrapper script around `nixos-rebuild switch` designed for ZenOS.
      It provides additional convenience features such as desktop notifications and
      integration with the ZenOS system environment.

      **Features:**
      - Automates the rebuild process.
      - Provides user feedback via libnotify.
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
