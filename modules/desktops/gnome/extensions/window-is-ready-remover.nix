{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.window-is-ready-remover;
in
{
  options.zenos.desktops.gnome.extensions.window-is-ready-remover = {
    enable = mkEnableOption "Window Is Ready Remover GNOME extension";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.window-is-ready-remover ];
  };
}
