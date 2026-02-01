{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.window-is-ready-remover;

in
{
  meta = {
    description = "Configures the Window Is Ready Remover GNOME extension";
    longDescription = ''
      This module installs and configures the **Window Is Ready Remover** extension for GNOME.
      It prevents the "Window is Ready" notification from appearing, which often occurs
      when a window tries to grab focus but is denied by the window manager.

      **Features:**
      - Suppresses "Window is ready" notifications.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.window-is-ready-remover = {
    enable = mkEnableOption "Window Is Ready Remover GNOME extension configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.window-is-ready-remover ];
  };
}
