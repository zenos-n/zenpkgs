{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gnome;
in
{
  # Wrap metadata in the standard 'meta' attribute block
  meta = {
    brief = "The GNOME desktop environment";
    description = ''
      for later
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napalm;
    dependencies = [ "pkgs.desktops.gnome.desktop" ];
  };

  options.gnome = {
    enable = lib.mkEnableOption "Enable the GNOME desktop environment";
  };

  config = lib.mkIf cfg.enable {
    _devlegacy = {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      # To disable installing GNOME's suite of applications
      # and only be left with GNOME shell.
      services.gnome.core-apps.enable = false;
      services.gnome.core-developer-tools.enable = false;
      services.gnome.games.enable = false;
      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-user-docs
      ];
    };
  };
}
