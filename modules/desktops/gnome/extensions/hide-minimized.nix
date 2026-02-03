{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.hide-minimized;

in
{
  meta = {
    description = ''
      Exclude minimized windows from the activities overview

      This module installs and configures the **Hide Minimized** extension for GNOME.
      It modifies the window management behavior so that minimized windows are hidden
      from the Overview, reducing visual clutter during multitasking.

      **Features:**
      - Hides minimized windows from the activities overview.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.hide-minimized = {
    enable = mkEnableOption "Hide Minimized GNOME extension configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.hide-minimized ];
  };
}
