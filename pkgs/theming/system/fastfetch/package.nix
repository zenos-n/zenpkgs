{
  lib,
  stdenv,
  pkgs,
  ...
}:

stdenv.mkDerivation {
  pname = "zenos-fastfetch";
  version = "1.0";

  src = ./src;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/fastfetch/presets
    mkdir -p $out/bin

    # Copy resource files
    cp resources/ascii.txt $out/share/fastfetch/presets/
    cp resources/zenos.jsonc $out/share/fastfetch/presets/

    # CRITICAL: Patch the config to point to the global store path instead of ~/.config
    substituteInPlace $out/share/fastfetch/presets/zenos.jsonc \
        --replace "~/.config/fastfetch/ascii.txt" "$out/share/fastfetch/presets/ascii.txt"

    # Wrap the upstream binary to use our config by default
    makeWrapper ${pkgs.fastfetch}/bin/fastfetch $out/bin/fastfetch \
        --add-flags "--config $out/share/fastfetch/presets/zenos.jsonc"
  '';

  meta = with lib; {
    description = "ZenOS fastfetch theming (Global)";
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
    mainProgram = "fastfetch";
  };
}
