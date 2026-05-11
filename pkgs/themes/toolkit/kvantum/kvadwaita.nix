{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation {
  pname = "kvlibadwaita";
  version = "unstable-2024-03-12";

  src = fetchFromGitHub {
    owner = "GabePoel";
    repo = "KvLibadwaita";
    rev = "1f4e0bec44b13dabfa1fe4047aa8eeaccf2f3557";
    hash = "sha256-jCXME6mpqqWd7gWReT04a//2O83VQcOaqIIXa+Frntc=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # this replaces the cp -r ./src/* /usr/share/Kvantum/ logic
    mkdir -p $out/share/Kvantum
    cp -r src/* $out/share/Kvantum/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Libadwaita style theme for Kvantum";
    homepage = "https://github.com/GabePoel/KvLibadwaita";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
