{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.places-status-indicator;
in
{
  options.zenos.desktops.gnome.extensions.places-status-indicator = {
    enable = mkEnableOption "Places Status Indicator GNOME extension";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.places-status-indicator ];
  };
}
