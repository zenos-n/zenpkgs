# Configuration-only bridges for native GNOME preferences and desktop handlers.
{ config, lib, pkgs, ... }:
let
  python = pkgs.python3.withPackages (p: [ p.pygobject3 ]);
  wallpapers = pkgs.zenos.byCategories.theming.wallpapers.destination-2;
  watcher = pkgs.writeShellScript "zenos-accent-wallpaper" ''
    export GI_TYPELIB_PATH=${lib.getLib pkgs.glib}/lib/girepository-1.0
    export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:''${XDG_DATA_DIRS:-/run/current-system/sw/share}
    exec ${python}/bin/python3 ${./gnome-wallpaper.py} ${wallpapers}/share/backgrounds/destination-2
  '';
  mimeDefaults = pkgs.runCommand "zenos-gnome-text-defaults" { nativeBuildInputs = [ pkgs.gawk ]; } ''
    {
      echo '[Default Applications]'
      echo 'text/plain=org.gnome.TextEditor.desktop'
      echo 'application/x-zerosize=org.gnome.TextEditor.desktop'
      awk -F= '$2 ~ /^org[.]gnome[.]Builder[.]desktop;?$/ {print $1 "=org.gnome.TextEditor.desktop"}' \
        ${pkgs.gnome-session}/share/applications/gnome-mimeapps.list
    } > "$out"
  '';
in {
  config = lib.mkIf config.services.desktopManager.gnome.enable {
    environment.etc."xdg/gnome-mimeapps.list".source = mimeDefaults;
    systemd.user.services.zenos-accent-wallpaper = {
      description = "Follow GNOME accents for matching Destination wallpapers";
      wantedBy = [ "gnome-session.target" ];
      partOf = [ "gnome-session.target" ];
      after = [ "graphical-session-pre.target" ];
      unitConfig.ConditionEnvironment = "!XDG_SESSION_CLASS=greeter";
      serviceConfig = {
        ExecStart = watcher;
        Restart = "on-failure";
        RestartSec = 3;
      };
    };
  };
}
