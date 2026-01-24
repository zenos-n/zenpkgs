{
  lib,
  stdenv,
  pkgs,
  ...
}:
stdenv.mkDerivation {
  pname = "zenos-refind-theme";
  version = "1.0";

  src = ./src;

  unpackPhase = "null";

  nativeBuildInputs = with pkgs; [
    # guess leave it as empty
  ];

  buildPhase = " 
  cat > theme.conf << EOF
  #
  # ZenOS boot theme
  #

  # Load banner and fit to screen
  banner themes/zenos-refind-theme/background.png
  banner_scale fillscreen

  # Load icons
  big_icon_size 256
  small_icon_size 64
  icons_dir themes/zenos-refind-theme/icons

  # Load selection background
  selection_big themes/zenos-refind-theme/selection/big.png
  selection_small themes/zenos-refind-theme/selection/small.png

  # Hide everything
  hideui singleuser,arrows
  showtools
  dont_scan_tools memtest,shell,mok_tool

EOF
  ";

  installPhase = "
  mkdir $out/boot/EFI/refind/themes/zenos-refind-theme -p
  cp -r * $out/boot/EFI/refind/themes/zenos-refind-theme/
  
  ";

  meta = with lib; {
    description = "The REFInd theme for zenos";
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.linux; # oh
  };
}
