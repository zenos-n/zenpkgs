{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.splash-indicator;
in
{
  options.zenos.desktops.gnome.extensions.splash-indicator = {
    enable = mkEnableOption "Splash Indicator GNOME extension";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.splash-indicator ];
  };
}
