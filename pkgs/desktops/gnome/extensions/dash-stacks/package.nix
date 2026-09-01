{
  fetchFromGitHub,
  glib,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "dash-stacks";
  version = "0-unstable-2026-08-30";

  src = fetchFromGitHub {
    owner = "doromiert";
    repo = "dash-stacks-doromiert.neg-zero.com";
    rev = "eb2dc300850b55e738e05209d2a4dc34fc5e3639";
    hash = "sha256-2oyDm5wI4AEceh2wSqwzhMYB1NwRcY8heNNbpQOU0gA=";
  };

  patches = [
    ./gnome-50.patch
    ./standard-icons.patch
  ];

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
