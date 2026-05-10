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

        cat <<EOF > $out/share/gnome-background-properties/destination-2.xml
    <?xml version="1.0"?>
    <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
    <wallpapers>
    EOF

        # Using find to handle the spaces in filenames (e.g., 'blue dark.png')
        find . -maxdepth 1 -name "*.png" -type f | while read img; do
          fn=$(basename "$img")

          # Create a pretty name (e.g., "blue dark" -> "Blue Dark")
          pretty_name=$(echo "''${fn%.*}" | sed 's/\b\(.\)/\u\1/g')
          # Create a unique, filesystem-safe name for KDE folders
          safe_name="Destination-2-$(echo "''${fn%.*}" | tr ' ' '-')"

          cp "$img" "$out/share/backgrounds/destination-2/$fn"

          cat <<EOF >> $out/share/gnome-background-properties/destination-2.xml
      <static>
        <name>Destination 2 ($pretty_name)</name>
        <filename>$out/share/backgrounds/destination-2/$fn</filename>
        <options>zoom</options>
      </static>
    EOF

          # KDE Plasma requires a folder per wallpaper entry
          kdir="$out/share/wallpapers/$safe_name"
          mkdir -p "$kdir/contents/images"

          # Use symlinks for KDE to save space (linking to the backgrounds folder)
          ln -s "$out/share/backgrounds/destination-2/$fn" "$kdir/contents/images/$fn"

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
