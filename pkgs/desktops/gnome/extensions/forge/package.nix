{
  fetchFromGitHub,
  gettext,
  git,
  glib,
  gnumake,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "forge";
  version = "0-unstable-2026-06-25";

  src = fetchFromGitHub {
    owner = "forge-ext";
    repo = "forge";
    rev = "46736af63815b46cadeb1db2988f04d60e6601b8";
    hash = "sha256-bdoD5k33l0SwwuEmd+EvB0FiVJdbtIMeBrUAjRhSg2s=";
  };

  nativeBuildInputs = [
    gettext
    git
    glib
    gnumake
  ];

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -d "$out/share/gnome-shell/extensions/forge@jmmaranan.com"
    cp -r temp/. "$out/share/gnome-shell/extensions/forge@jmmaranan.com/"
    runHook postInstall
  '';

  passthru.extensionUuid = "forge@jmmaranan.com";

  meta = {
    description = "Forge tiling window manager extension built from GNOME 50-compatible upstream";
    homepage = "https://github.com/forge-ext/forge";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
