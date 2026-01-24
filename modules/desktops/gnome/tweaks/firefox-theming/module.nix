{ lib, pkgs, ... }:
{
  options.zenos.desktops.gnome.tweaks.firefox-theming = {
    enable = lib.mkEnableOption "Firefox Theming for GNOME Tweaks";
  };

}
