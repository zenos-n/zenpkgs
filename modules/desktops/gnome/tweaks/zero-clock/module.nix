{ lib, pkgs, ... }:
{
  options.zenos.desktops.gnome.tweaks.zeroClock = {
    enable = lib.mkEnableOption "Zero GNOME clock font";
  };
}
