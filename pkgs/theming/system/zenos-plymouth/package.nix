{
  lib,
  stdenv,
  pkgs,
  distroName ? "unknown",
  releaseVersion ? "unknown",
  deviceName ? "unknown",
  icon ? "negzero",
  color ? "C532FF",
  ...
}:

stdenv.mkDerivation {
  pname = "zenos-plymouth";
  version = "1.0";

  src = ./src;

  nativeBuildInputs = with pkgs; [
    imagemagick
    coreutils-full
  ];

  env_distroName = distroName;
  env_version = releaseVersion;
  env_deviceName = deviceName;

  buildPhase = ''
    ${pkgs.coreutils-full}/bin/echo "Building zenos-plymouth..."

    # main .plymouth file
    ${pkgs.coreutils-full}/bin/cat > zenos.plymouth << EOF
    [Plymouth Theme]
    Name=ZenOS
    Description=ZenOS Boot Animation
    ModuleName=script

    [script]
    ImageDir=$out/share/plymouth/themes/zenos/graphics
    ScriptFile=$out/share/plymouth/themes/zenos/scripts/zenos.script
    EOF

    # generate assets
    font_reg="${pkgs.atkinson-hyperlegible}/share/fonts/opentype/AtkinsonHyperlegible-Regular.otf"
    font_bold="${pkgs.atkinson-hyperlegible}/share/fonts/opentype/AtkinsonHyperlegible-Bold.otf"

    ${pkgs.imagemagick}/bin/magick -background none -density 120 -fill white -font "$font_reg" -pointsize 48 label:"$env_distroName " os_name.png
    ${pkgs.imagemagick}/bin/magick -background none -fill white -font "$font_bold" -pointsize 48 label:"$env_version" os_version.png
    ${pkgs.imagemagick}/bin/magick -background none -density 8000 icons/${icon}.svg -resize 1640x1640 -channel A -evaluate multiply 0.10 watermark_bg.png
    ${pkgs.imagemagick}/bin/magick -size 600x600 xc:transparent -fill "#${color}" -draw "rectangle 250,250 350,350" -blur 0x100 -resize 6000x6000 glow.png

    ${pkgs.coreutils-full}/bin/rm -rf icons/
    ${pkgs.coreutils-full}/bin/mkdir graphics
    ${pkgs.coreutils-full}/bin/mv ./*.png graphics
  '';

  installPhase = ''
    ${pkgs.coreutils-full}/bin/mkdir -p $out/share/plymouth/themes/zenos
    ${pkgs.coreutils-full}/bin/cp -r * $out/share/plymouth/themes/zenos/
  '';

  meta = with lib; {
    description = ''
      Branded Plymouth boot animation for ZenOS

      **ZenOS Plymouth Theme** provides a high-fidelity boot animation featuring 
      animated typography and a custom breathing glow effect. It dynamically 
      generates assets based on the system's branding configuration.

      **Features:**
      - Dynamic OS name and version label generation.
      - Hardware-specific center iconography.
      - Configurable animated glow effect color.
    '';
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
