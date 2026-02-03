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
    description = ''
      ZenLink integration indicator for GNOME Shell

      This module installs and configures the **ZenLink Indicator** extension.
      It adds a dedicated indicator to the top bar for quick access to ZenLink 
      functionality, facilitating seamless device synchronization within 
      the ZenOS ecosystem.

      **Features:**
      - Quick access panel menu for ZenLink actions.
      - Native integration with the ZenOS connectivity stack.
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
