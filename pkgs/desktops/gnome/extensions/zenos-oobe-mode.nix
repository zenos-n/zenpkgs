{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "zenos-oobe-mode-extension";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zenos-n";
    repo = "zenos-oobe-mode-extension";
    rev = "${version}";
    hash = "sha256-T/aq+EP1X1trt8TYR/swoB+9UTOt9tZHh7Gn4QCP1V8=";
  };

  # gnome extensions are just data files, no compiling needed
  installPhase = ''
    runHook preInstall

    # gnome expects extensions in a very specific path structure
    # we use the UUID from the extension's metadata.json (usually)
    # assuming the folder in the repo is named correctly or we just grab everything

    mkdir -p $out/share/gnome-shell/extensions/zenos-oobe-mode@neg-zero.com
    cp -r * $out/share/gnome-shell/extensions/zenos-oobe-mode@neg-zero.com/

    runHook postInstall
  '';

  meta = with lib; {
    description = "GNOME Shell extension for ZenOS OOBE mode";
    license = licenses.napalm;
    maintainers = [ maintainers.doromiert ];
  };
}
