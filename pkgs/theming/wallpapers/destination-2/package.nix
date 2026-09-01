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
    rev = "1.0.0";
    hash = "sha256-vNuSipOuRaZEMRS2oI5vI4TgkzpyYxYMQBDLIMzV9mM=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    backgrounds="$out/share/backgrounds/destination-2"
    properties="$out/share/gnome-background-properties/destination-2.xml"
    install -d "$backgrounds" "$(dirname "$properties")" "$out/share/wallpapers"

    cat > "$properties" <<'EOF'
    <?xml version="1.0"?>
    <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
    <wallpapers>
    EOF

    for dark_path in ./*\ dark.png; do
      color="$(basename "$dark_path" ' dark.png')"
      light_path="./$color light.png"
      dark_name="$color dark.png"
      light_name="$color light.png"
      pretty="$(printf '%s' "$color" | sed 's/.*/\u&/')"
      safe="Destination-2-$color"
      install -m 0644 "$dark_path" "$backgrounds/$dark_name"

      if [ -f "$light_path" ]; then
        install -m 0644 "$light_path" "$backgrounds/$light_name"
        cat >> "$properties" <<EOF
    <wallpaper deleted="false">
      <name>Destination 2 ($pretty)</name>
      <filename>$backgrounds/$light_name</filename>
      <filename-dark>$backgrounds/$dark_name</filename-dark>
      <options>zoom</options>
      <shade_type>solid</shade_type>
      <pcolor>#000000</pcolor>
      <scolor>#000000</scolor>
    </wallpaper>
    EOF
      else
        cat >> "$properties" <<EOF
    <wallpaper deleted="false">
      <name>Destination 2 ($pretty)</name>
      <filename>$backgrounds/$dark_name</filename>
      <options>zoom</options>
      <shade_type>solid</shade_type>
      <pcolor>#000000</pcolor>
      <scolor>#000000</scolor>
    </wallpaper>
    EOF
      fi

      install -d "$out/share/wallpapers/$safe/contents/images"
      ln -s "$backgrounds/$dark_name" "$out/share/wallpapers/$safe/contents/images/$dark_name"
    done

    echo '</wallpapers>' >> "$properties"
    runHook postInstall
  '';

  meta = {
    description = "Destination 2 wallpaper collection for ZenOS";
    homepage = "https://github.com/zenos-n/destination-2";
    license = lib.licenses.napalm;
    platforms = lib.platforms.all;
  };
}
