{ pkgs, nixpkgs, zenosModule }:
let
  python = pkgs.python3.withPackages (p: [ p.pygobject3 ]);
  configuration = (nixpkgs.lib.nixosSystem {
    system = pkgs.stdenv.hostPlatform.system;
    modules = [ zenosModule { zenos.system.installed-base.enable = false; zenos.desktops.gnome.enable = true; system.stateVersion = "26.05"; } ];
  }).config;
  defaults = configuration.environment.etc."xdg/gnome-mimeapps.list".source;
in
assert configuration.systemd.user.services.zenos-accent-wallpaper.wantedBy == [ "gnome-session.target" ];
pkgs.runCommand "zenos-gnome-desktop-defaults" {
  nativeBuildInputs = [ python pkgs.dbus ];
} ''
  export PATH=${pkgs.lib.makeBinPath [ pkgs.gnome-text-editor pkgs.gnome-builder ]}:$PATH
  export PYTHONDONTWRITEBYTECODE=1
  export GI_TYPELIB_PATH=${pkgs.glib.out}/lib/girepository-1.0
  export GIO_EXTRA_MODULES=${pkgs.dconf.lib}/lib/gio/modules
  export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.dconf}/share:${pkgs.gnome-text-editor}/share:${pkgs.gnome-builder}/share:${pkgs.gnome-session}/share:${pkgs.shared-mime-info}/share
  export XDG_CONFIG_HOME="$TMPDIR/config" XDG_RUNTIME_DIR="$TMPDIR/runtime" DCONF_PROFILE="$TMPDIR/profile"
  mkdir -p "$XDG_CONFIG_HOME" "$XDG_RUNTIME_DIR"
  chmod 700 "$XDG_RUNTIME_DIR"
  echo user-db:user > "$DCONF_PROFILE"
  dbus-run-session --config-file=${pkgs.dbus}/share/dbus-1/session.conf -- python ${./test-gnome-desktop-defaults.py} ${../lib/compat/gnome-wallpaper.py} ${defaults} ${pkgs.zenos.byCategories.theming.wallpapers.destination-2}/share/backgrounds/destination-2
  touch "$out"
''
