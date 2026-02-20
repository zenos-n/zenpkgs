{
  lib,
  pkgs,
  config,
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

  };
}
