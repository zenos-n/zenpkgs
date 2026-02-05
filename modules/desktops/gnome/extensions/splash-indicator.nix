{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.zenos.desktops.gnome.extensions.splash-indicator;

  meta = {
    description = ''
      Visual login feedback screen for GNOME Shell

      This module installs and configures the **Splash Indicator** extension for GNOME.
      It displays a splash screen during system startup or login, providing visual
      feedback while the desktop environment is loading.

      **Features:**
      - Visual splash screen on login.
      - Customizable appearance (via extension settings).
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos.desktops.gnome.extensions.splash-indicator = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = mkEnableOption "Splash Indicator GNOME extension configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.splash-indicator ];
  };
}
