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
    description = "Modified Adwaita icon pack with more icons";
    longDescription = ''
      **Adwaita Hacks** extends the standard Adwaita icon theme with additional icons
      needed for a complete ZenOS experience. It fills in gaps where standard Adwaita
      might be missing specific application or system icons.

      **Features:**
      - Additional icons matching the Adwaita style.
      - Seamless integration with the default icon theme.
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
