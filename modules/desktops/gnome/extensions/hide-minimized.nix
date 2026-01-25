{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.hide-minimized;
in
{
  options.zenos.desktops.gnome.extensions.hide-minimized = {
    enable = mkEnableOption "Hide Minimized GNOME extension";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.hide-minimized ];
  };
}
