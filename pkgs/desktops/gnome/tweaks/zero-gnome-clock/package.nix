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
    zenos.theming.fonts.zero-font
    gnomeExtensions.user-themes
  ];

  dontUnpack = true;

  buildPhase = ''
    echo 'Building Zero GNOME Clock...'
    mkdir -p $out/share/themes/zero-gnome-clock

    # Find the font file dynamically from the Zero Font package
    FONT_PATH=$(find ${pkgs.zenos.theming.fonts.zero-font} -name "*.ttf" -o -name "*.otf" | head -n 1)

    # Generate the theme CSS with font injection
    cat > $out/share/themes/zero-gnome-clock/gnome-clock.css << EOF
    @import url("resource:///org/gnome/shell/theme/default.css");
    @font-face {
      font-family: 'Zero';
      src: url("file://$FONT_PATH");
    }

    .clock-display {
      font-family: 'Zero', sans-serif !important;
      font-weight: normal !important;
      font-style: normal !important;
      font-size: 12px;
    }
    EOF
  '';

  installPhase = ''
    echo 'Installing Zero GNOME Clock...'
    # Create dconf profile for automatic integration
    mkdir -p $out/share/dconf/profile
    echo "system-db:local" > $out/share/dconf/profile/user

    # Provide the GSchema for the user-theme extension to handle overrides
    mkdir -p $out/share/glib-2.0/schemas
    cat > $out/share/glib-2.0/schemas/org.gnome.shell.extensions.user-theme.gschema.xml << EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <schemalist>
      <schema id="org.gnome.shell.extensions.user-theme" path="/org/gnome/shell/extensions/user-theme/">
      <key name="ClockOverride" type="s">
        <default>""</default>
      </key>
      </schema>
    </schemalist>
    EOF

    # Compile the schemas for the store path
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with lib; {
    description = ''
      GNOME Shell top bar clock typography override

      **Zero GNOME Clock** is a custom GNOME Shell theme component that overrides the 
      default top bar clock font. It uses the custom "Zero" font to provide a minimal 
      and stylized clock appearance.

      **Features:**
      - Applies the "Zero" font family to the clock display.
      - Uses `@font-face` injection via generated CSS.
      - Includes dconf profile setup for user theme integration.
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
