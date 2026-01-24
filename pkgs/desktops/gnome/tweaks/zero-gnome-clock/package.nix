{
  lib,
  stdenv,
  pkgs,
  ...
}:
stdenv.mkDerivation {
  pname = "zero-gnome-clock";
  version = "1.0";

  nativeBuildInputs = with pkgs; [
    zero-font
    gnomeExtensions.user-themes
  ];

  dontUnpack = true;

  buildPhase = "
    echo 'Building Zero GNOME Clock...'
    mkdir -p $out/share/themes/zero-gnome-clock

    FONT_PATH=$(find ${pkgs.zero-font} -name \"*.ttf\" -o -name \"*.otf\" | head -n 1)

    cat > $out/share/themes/zero-gnome-clock/gnome-clock.css << EOF
@import url(\"resource:///org/gnome/shell/theme/default.css\");
@font-face {
  font-family: 'Zero';
  src: url(\"file://$FONT_PATH\");
}

.clock-display {
  font-family: 'Zero', sans-serif !important;
  font-weight: normal !important;
  font-style: normal !important;
  font-size: 12px;
}
  ";

  installPhase = "
    echo 'Installing Zero GNOME Clock...'
    mkdir -p $out/share/dconf/profile
    echo \"system-db:local\" > $out/share/dconf/profile/user
    mkdir -p $out/share/glib-2.0/schemas
    cat > $out/share/glib-2.0/schemas/org.gnome.shell.extensions.user-theme.gschema.xml << EOF
    <?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <schemalist>
      <schema id=\"org.gnome.shell.extensions.user-theme\" path=\"/org/gnome/shell/extensions/user-theme/\">
      <key name=\"ClockOverride\" type=\"s\">
        <default>''</default>
      </key>
      </schema>
    </schemalist>
    EOF
    glib-compile-schemas $out/share/glib-2.0/schemas
  ";

  meta = with lib; {
    description = "Zero GNOME Clock";
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
