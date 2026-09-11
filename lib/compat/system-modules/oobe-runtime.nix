# The session wrapper is an evaluated NixOS value, not an authored legacy value.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  command = "${pkgs.coreutils}/bin/env XDG_SESSION_TYPE=wayland XDG_SESSION_CLASS=user XDG_SESSION_DESKTOP=GNOME XDG_CURRENT_DESKTOP=GNOME ZENOS_OOBE=1 ${config.services.displayManager.sessionData.wrapper} ${pkgs.gnome-session}/bin/gnome-session --session=zenos-oobe";
in
{
  config = lib.mkIf config.zenos.system.oobe.enable {
    services.greetd.settings = {
      initial_session.command = lib.mkForce command;
      default_session.command = lib.mkForce command;
    };
  };
}
