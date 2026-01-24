{ lib, pkgs, ... }:
{
  options.zenos.desktops.gnome.tweaks.zenosFonts = {
    enable = lib.mkEnableOption "ZenOS Fonts for GNOME";
  };

}
