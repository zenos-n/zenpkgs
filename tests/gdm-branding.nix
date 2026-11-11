{ pkgs, nixpkgs, zenosModule }:
let
  make = settings: (nixpkgs.lib.nixosSystem {
    system = pkgs.stdenv.hostPlatform.system;
    modules = [ zenosModule { zenos = {
      system.installed-base.enable = false;
      desktops.gnome = { enable = true; } // settings;
    }; } ];
  }).config;
  defaults = make { };
  custom = make { defaultAccentColor = "teal"; defaultDarkMode = false; loginScreen.logo = ""; };
  # dconf profiles take the first definition of each key; exercise real merging.
  setting = cfg: schema: key:
    nixpkgs.lib.findFirst (db: builtins.isAttrs db && (db.settings.${schema} or { }) ? ${key})
      (throw "Missing greeter setting ${schema}.${key}") cfg.programs.dconf.profiles.gdm.databases;
  value = cfg: schema: key: (setting cfg schema key).settings.${schema}.${key};
in
assert value defaults "org/gnome/desktop/interface" "accent-color" == "purple";
assert value defaults "org/gnome/desktop/interface" "color-scheme" == "prefer-dark";
assert value defaults "org/gnome/login-screen" "logo" == "${pkgs.zenos.byCategories.theming.system.zenos-branding}/share/pixmaps/zenos-gdm-symbolic.svg";
assert value custom "org/gnome/desktop/interface" "accent-color" == "teal";
assert value custom "org/gnome/desktop/interface" "color-scheme" == "prefer-light";
assert value custom "org/gnome/login-screen" "logo" == "";
assert defaults.systemd.user.services."org.gnome.Shell@gdm".overrideStrategy == "asDropin";
assert defaults.systemd.user.services."org.gnome.Shell@gdm".environment.DCONF_PROFILE == "/etc/dconf/profile/gdm";
pkgs.writeText "zenos-gdm-branding-check" "passed"
