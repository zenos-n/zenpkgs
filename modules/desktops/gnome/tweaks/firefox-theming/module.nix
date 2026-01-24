{ lib, pkgs, ... }:
{
  options.zenos.desktops.gnome.tweaks.firefoxTheming = {
    enable = lib.mkEnableOption "Firefox Theming for GNOME Tweaks";
  };

}
