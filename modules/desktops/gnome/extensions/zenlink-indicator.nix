{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.zenlink-indicator;

in
{
  meta = {
    description = "Configures the ZenLink indicator GNOME extension";
    longDescription = ''
      This module installs and configures the **ZenLink Indicator** extension for GNOME.
      It adds a dedicated indicator to the top bar for quick access to ZenLink functionality,
      enhancing the integration between ZenOS devices.

      **Features:**
      - Quick access indicator for ZenLink.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.zenlink-indicator = {
    enable = mkEnableOption "ZenLink indicator GNOME extension configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.zenos.desktops.gnome.extensions.zenlink-indicator ];
  };
}
