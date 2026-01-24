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

  nativeInputs = with pkgs; [
    bash
  ];

  dontUnpack = true;
  installPhase = "
    mkdir -p $out/bin
    install -Dm755 $src/scripts/zenos-rebuild.sh $out/bin/zenos-rebuild
  ";

  meta = with lib; {
    description = "nixos-rebuild switch wrapper with some niceties";
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
