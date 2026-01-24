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

  nativeBuildInputs = with pkgs; [

  ];

  buildPhase = " ";

  installPhase = " ";

  meta = with lib; {
    description = "Indicator for ZenLink that resides in the control center.";
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
