{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "destination-2-wallpapers";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zenos-n";
    repo = "destination-2";
    rev = "ae0bde2f214308325709c05f0f47af5d45eae9fe";
    hash = "sha256-fNenryFtgqxM7ejF7QoO/HVSrj5Vb+HLyJX/WALrMsc=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    backgrounds="$out/share/backgrounds/destination-2"
    properties="$out/share/gnome-background-properties/destination-2.xml"
    install -d "$backgrounds" "$(dirname "$properties")" "$out/share/wallpapers"
    install -m 0644 ./*.png "$backgrounds/"
    install -m 0644 destination-2.xml "$properties"
    substituteInPlace "$properties" \
      --replace-fail '/usr/share/backgrounds/destination-2' "$backgrounds"

    for dark_path in ./*\ dark.png; do
      color="$(basename "$dark_path" ' dark.png')"
      dark_name="$color dark.png"
      safe="Destination-2-$color"

      install -d "$out/share/wallpapers/$safe/contents/images"
      ln -s "$backgrounds/$dark_name" "$out/share/wallpapers/$safe/contents/images/$dark_name"
    done
    runHook postInstall
  '';

  meta = {
    description = "Destination 2 wallpaper collection for ZenOS";
    homepage = "https://github.com/zenos-n/destination-2";
    license = lib.licenses.napalm;
    platforms = lib.platforms.all;
  };
}
