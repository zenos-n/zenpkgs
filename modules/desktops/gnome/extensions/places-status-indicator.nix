{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.places-status-indicator;

  meta = {
    description = ''
      Filesystem navigation menu for the GNOME top bar

      This module installs and configures the **Places Status Indicator** extension 
      for GNOME. It adds a menu to the top bar for quick navigation to bookmarked 
      places, mounted volumes, and network locations.

      **Features:**
      - Quick access to home folder, documents, downloads, etc.
      - Access to network locations and mounted drives.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.places-status-indicator = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Places Status Indicator GNOME extension configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.places-status-indicator ];
  };
}
