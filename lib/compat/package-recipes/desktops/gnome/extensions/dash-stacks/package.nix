{
  fetchFromGitHub,
  glib,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "dash-stacks";
  version = "0-unstable-2026-11-13";

  src = fetchFromGitHub {
    owner = "doromiert";
    repo = "dash-stacks";
    rev = "b936451b92f172c660b668762a34dd66be98a2a0";
    hash = "sha256-Ph0YDvAIBQkcffa0cVHV1jsdzWSZI65x/5B5KDk5P2M=";
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
