{
  lib,
  stdenv,
  ...
}:

stdenv.mkDerivation {
  pname = "adwaita-hacks";
  version = "1.0";

  src = ./src;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r $src/resources/* $out/share/icons
  '';

  meta = with lib; {
    description = ''
      Extended Adwaita icon pack for ZenOS compatibility

      **Adwaita Hacks** extends the standard Adwaita icon theme with additional 
      icons needed for a complete ZenOS experience. It fills in gaps where 
      standard themes are missing specific application or system icons.

      **Features:**
      - Additional icons matching the Adwaita aesthetic.
      - Seamless integration with the default GNOME icon theme.
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
