# Internal GNOME integration; the public theme/size options remain unchanged.
{ config, lib, pkgs, ... }:
let
  python = pkgs.python3.withPackages (p: [ p.pygobject3 ]);
  bridge = pkgs.writeShellScript "zenos-gnome-cursor" ''
    export GI_TYPELIB_PATH=${lib.getLib pkgs.glib}/lib/girepository-1.0
    export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:''${XDG_DATA_DIRS:-/run/current-system/sw/share}
    export PATH=${lib.makeBinPath ([ pkgs.xrdb pkgs.dbus ] ++ lib.optional config.services.flatpak.enable pkgs.flatpak)}:$PATH
    exec ${python}/bin/python3 ${./gnome-cursor.py} "$@"
  '';
in
{
  config = lib.mkIf config.services.desktopManager.gnome.enable {
    environment.extraInit = ''eval "$(${bridge} --environment --shell)"'';
    environment.etc."systemd/user-environment-generators/25-zenos-cursor".source =
      pkgs.writeShellScript "zenos-cursor-environment" ''exec ${bridge} --environment'';
    systemd.user.services.zenos-gnome-cursor = {
      description = "Synchronize GNOME cursors for Xwayland and sandboxed applications";
      wantedBy = [ "gnome-session.target" ];
      partOf = [ "gnome-session.target" ];
      after = [ "graphical-session-pre.target" ];
      serviceConfig = {
        ExecStart = "${bridge} --watch";
        Restart = "on-failure";
        RestartSec = 3;
      };
    };
  };
}
