{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.window-is-ready-remover;

  meta = {
    description = ''
      Suppress focus-stealing prevention notifications

      This module installs and configures the **Window Is Ready Remover** extension.
      It prevents the "Window is Ready" notification from appearing, which occurs 
      when a background window attempts to grab focus but is denied by the 
      window manager.

      **Features:**
      - Silences annoying "Window is ready" notification banners.
      - Improves workflow by removing redundant focus alerts.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.window-is-ready-remover = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Window Is Ready Remover GNOME extension configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.window-is-ready-remover ];
  };
}
