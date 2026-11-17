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
    rev = "9d4342a9290f0ecb6c365bc22d3ca6696dbda478";
    hash = "sha256-O3isDwhpQiioiC8QVqX59JUu8V7Jzg8NG/u51fANjmw=";
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
