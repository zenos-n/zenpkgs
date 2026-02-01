{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.places-status-indicator;

in
{
  meta = {
    description = "Configures the Places Status Indicator GNOME extension";
    longDescription = ''
      This module installs and configures the **Places Status Indicator** extension for GNOME.
      It adds a menu to the top bar for quick navigation to bookmarked places, mounted volumes,
      and network locations.

      **Features:**
      - Quick access to home folder, documents, downloads, etc.
      - Access to network locations and mounted drives.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.places-status-indicator = {
    enable = mkEnableOption "Places Status Indicator GNOME extension configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.places-status-indicator ];
  };
}
