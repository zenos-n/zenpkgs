{
  fetchFromGitHub,
  gettext,
  git,
  glib,
  gnumake,
  gjs,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "forge";
  version = "0-unstable-2026-11-13";

  src = fetchFromGitHub {
    owner = "zenos-n";
    repo = "forge";
    rev = "102a8ef05d05218ce5b82fc5a47b3616a762c0d4";
    hash = "sha256-Y+zW5GXaGuUPytP/C9k9Y/d84OG8N/+60bM3hos7OWs=";
  };

  nativeBuildInputs = [
    gettext
    git
    glib
    gnumake
    gjs
  ];

  postPatch = ''
    substituteInPlace lib/shared/theme.js \
      --replace-fail 'this.configMgr.stylesheetFileName + ".bak"' 'configCss.get_path() + ".bak"' \
      --replace-fail 'Gio.FileCopyFlags.OVERWRITE, null, null' '(Gio.FileCopyFlags.OVERWRITE | Gio.FileCopyFlags.TARGET_DEFAULT_PERMS), null, null'
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    gjs -m tests/window-tracking.js
    runHook postCheck
  '';

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
