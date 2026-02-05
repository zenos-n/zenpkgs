{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.hide-minimized;

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
in
{

  options.zenos.desktops.gnome.extensions.hide-minimized = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Hide Minimized GNOME extension configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.hide-minimized ];
  };
}
