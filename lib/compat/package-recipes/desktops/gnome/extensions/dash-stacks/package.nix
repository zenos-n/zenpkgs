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
    rev = "b0592609f2cd138c566675033a708d414632b2b7";
    hash = "sha256-9pSQYsHC7hOAVv8O/QqBM7JdXTjj2jrdHhz+fAmvuro=";
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
