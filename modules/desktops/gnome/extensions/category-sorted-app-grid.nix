{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.category-sorted-app-grid;

in
{
  meta = {
    description = ''
      Automatic category-based sorting for the GNOME application grid

      This module installs and configures the **Category Sorted App Grid** extension 
      for GNOME. It automatically organizes the application grid by category, 
      ensuring a tidy and accessible layout.

      **Features:**
      - Automatically sorts apps into category folders.
      - Keeps the app grid organized without manual intervention.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.category-sorted-app-grid = {
    enable = mkEnableOption "Category Sorted App Grid GNOME extension configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.category-sorted-app-grid ];
  };
}
