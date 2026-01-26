{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.zenos.desktops.gnome.tweaks.zeroClock;
in
{
  options.zenos.desktops.gnome.tweaks.zeroClock = {
    enable = lib.mkEnableOption "Zero GNOME clock font";
  };

  config = lib.mkIf cfg.enable {
    zenos.desktops.gnome.extensions.customize-clock-on-lockscreen = {
      enable = true;

    };
  };
}
