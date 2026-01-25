{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.category-sorted-app-grid;
in
{
  options.zenos.desktops.gnome.extensions.category-sorted-app-grid = {
    enable = mkEnableOption "Category Sorted App Grid GNOME extension";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.category-sorted-app-grid ];
  };
}
