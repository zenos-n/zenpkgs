{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "destination-2";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zenos-n";
    repo = "destination-2";
    rev = "1.0.0";
    sha256 = "sha256-vNuSipOuRaZEMRS2oI5vI4TgkzpyYxYMQBDLIMzV9mM=";
  };

  # we don't need to build anything, just move files
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/wallpapers/destination-2
    cp $src/* $out/share/wallpapers/destination-2
  '';

  meta = with lib; {
    description = "Fastfetch theme for ZenOS";
    homepage = "https://github.com/zenos-n/destination-2";
    license = licenses.napalm;
    maintainers = [ maintainers.doromiert ];
  };
}
