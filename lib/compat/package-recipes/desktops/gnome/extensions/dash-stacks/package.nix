{
  fetchFromGitHub,
  glib,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "dash-stacks";
  version = "0-unstable-2026-11-17";

  src = fetchFromGitHub {
    owner = "doromiert";
    repo = "dash-stacks";
    rev = "17168f5234cf21608d80283dbf30ff1e94c5b0e6";
    hash = "sha256-g8OJHAfVwpY1tU/Bk9kvmR7pDmcI2jo23nAcHMAsFPw=";
  };

  nativeBuildInputs = [ glib ];

  installPhase = ''
    runHook preInstall
    destination="$out/share/gnome-shell/extensions/dash-stacks@neg-zero.com"
    install -d "$destination"
    cp -r . "$destination/"
    glib-compile-schemas "$destination/schemas"
    runHook postInstall
  '';

  passthru.extensionUuid = "dash-stacks@neg-zero.com";

  meta = {
    description = "macOS-style folder stacks for the GNOME dash";
    homepage = "https://github.com/doromiert/dash-stacks";
    license = lib.licenses.napalm;
    platforms = lib.platforms.linux;
  };
}
