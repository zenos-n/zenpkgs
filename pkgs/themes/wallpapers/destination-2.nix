{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation {
  pname = "destination-2";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zenos-n";
    repo = "destination-2";
    rev = "1.0.0";
    sha256 = "sha256-vNuSipOuRaZEMRS2oI5vI4TgkzpyYxYMQBDLIMzV9mM=";
  };

  dontBuild = true;

  installPhase = ''
      mkdir -p $out/share/backgrounds/destination-2
      mkdir -p $out/share/gnome-background-properties
      mkdir -p $out/share/wallpapers

      # XML Header - matching your adwaita.xml sample
      cat <<EOF > $out/share/gnome-background-properties/destination-2.xml
    <?xml version="1.0"?>
    <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
    <wallpapers>
    EOF

      # loop through dark files, skip the ".light" archival crap
      find . -name "* dark.png" -type f | grep -v "\.light" | while read dark_path; do

        filename=$(basename "$dark_path")
        color_name=$(echo "$filename" | sed 's/ dark.png//')
        light_path="./$color_name light.png"

        pretty_name=$(echo "$color_name" | sed 's/\b\(.\)/\u\1/g')
        safe_name="Destination-2-$(echo "$color_name" | tr ' ' '-')"

        # cp dark image
        cp "$dark_path" "$out/share/backgrounds/destination-2/$filename"

        if [ -f "$light_path" ]; then
          light_filename=$(basename "$light_path")
          cp "$light_path" "$out/share/backgrounds/destination-2/$light_filename"

          # using <wallpaper> tag instead of <static> to match adwaita.xml
          cat <<EOF >> $out/share/gnome-background-properties/destination-2.xml
    <wallpaper deleted="false">
      <name>Destination 2 ($pretty_name)</name>
      <filename>$out/share/backgrounds/destination-2/$light_filename</filename>
      <filename-dark>$out/share/backgrounds/destination-2/$filename</filename-dark>
      <options>zoom</options>
      <shade_type>solid</shade_type>
      <pcolor>#000000</pcolor>
      <scolor>#000000</scolor>
    </wallpaper>
    EOF
        else
          cat <<EOF >> $out/share/gnome-background-properties/destination-2.xml
    <wallpaper deleted="false">
      <name>Destination 2 ($pretty_name)</name>
      <filename>$out/share/backgrounds/destination-2/$filename</filename>
      <options>zoom</options>
      <shade_type>solid</shade_type>
      <pcolor>#000000</pcolor>
      <scolor>#000000</scolor>
    </wallpaper>
    EOF
        fi

        # KDE fallback
        kdir="$out/share/wallpapers/$safe_name"
        mkdir -p "$kdir/contents/images"
        ln -s "$out/share/backgrounds/destination-2/$filename" "$kdir/contents/images/$filename"

        cat <<EOF > "$kdir/metadata.desktop"
    [Desktop Entry]
    Name=Destination 2 ($pretty_name)
    X-KDE-PluginInfo-Name=$safe_name
    X-KDE-PluginInfo-Author=doromiert
    X-KDE-ServiceTypes=Wallpaper
    Type=Service
    EOF
      done

      echo "</wallpapers>" >> $out/share/gnome-background-properties/destination-2.xml
  '';

  meta = with lib; {
    description = "Destination 2 wallpaper pack by doromiert (GNOME/KDE Support)";
    homepage = "https://github.com/zenos-n/destination-2";
    license = licenses.napalm;
    maintainers = [ maintainers.doromiert ];
    platforms = platforms.all;
  };
}
