{
  pkgs,
  lib,
  options,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.zenlink-indicator;
in
{
  options.zenos.desktops.gnome.extensions.zenlink-indicator = {
    enable = mkEnableOption "ZenLink indicator gnome extension";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.desktops.gnome.extensions.zenlink-indicator ];
  };
}
