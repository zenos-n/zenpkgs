{
  fetchFromGitHub,
  lib,
  stdenv,
  pkgs,
  ...
}:

stdenv.mkDerivation {
  pname = "zenos-fastfetch";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "zenos-n";
    repo = "fastfetch-config";
    rev = "251097014340b0942f978c66698e0bf803517369";
    hash = "sha256-Rhq5uFVZ/KOvHZucfFA+5Aoa1pl9NQf0xJQHnINQumQ=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/fastfetch/presets
    mkdir -p $out/bin

    # Copy resource files
    cp $src/ascii.txt $out/share/fastfetch/presets/
    cp $src/config.jsonc $out/share/fastfetch/presets/zenos.jsonc

    # CRITICAL: Patch the config to point to the global store path instead of ~/.config
    substituteInPlace $out/share/fastfetch/presets/zenos.jsonc \
        --replace "~/.config/fastfetch/ascii.txt" "$out/share/fastfetch/presets/ascii.txt"

    # Wrap the upstream binary to use our config by default
    makeWrapper ${pkgs.fastfetch}/bin/fastfetch $out/bin/fastfetch \
        --add-flags "--config $out/share/fastfetch/presets/zenos.jsonc"
  '';

  meta = with lib; {
    description = ''
      ZenOS fastfetch theming and ASCII art

      **ZenOS Fastfetch** provides a custom configuration for `fastfetch` that aligns 
      with the ZenOS brand. It wraps the standard `fastfetch` binary to load the 
      ZenOS preset and ASCII art by default.

      **Features:**
      - Custom ZenOS ASCII art.
      - Pre-configured JSONC preset.
      - Global availability without user-level configuration.
    '';
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux;
  };
}
