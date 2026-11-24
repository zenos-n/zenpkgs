{ nixpkgs, moduleFile }:
let
  lib = import (nixpkgs + "/lib");
  package = { extensionUuid = "rounded-window-corners@ztrahmet.github.io"; };
  make = cfg: user: import moduleFile {
    inherit cfg lib;
    pkgs.zenos.byCategories.desktops.gnome.extensions.rounded-window-corners-native = package;
    inherit user; shareUserActions = false; config = {};
  };
  run = choices: let
    cfg = (lib.evalModules { modules = [ (make {} null).schema { config = choices; } ]; }).config;
    result = lib.evalModules { modules = [
      { options = {
        environment.systemPackages = lib.mkOption { type = lib.types.listOf lib.types.anything; default = []; };
        home-manager.users = lib.mkOption { type = lib.types.attrsOf (lib.types.submodule {
          options.dconf.settings = lib.mkOption { type = lib.types.attrsOf (lib.types.attrsOf (lib.types.either (lib.types.listOf lib.types.str) lib.types.anything)); default = {}; };
        }); default = {}; };
      }; }
      { config = lib.mkMerge ((make cfg null).actions ++ (make cfg "alice").actions); }
      { home-manager.users.alice.dconf.settings."org/gnome/shell".enabled-extensions = [ "existing@extension" ]; }
    ]; };
  in result.config;
  off = run {};
  on = run { enable = true; };
  custom = run { enable = true; sharp-windows = false; round-libadwaita-apps = false; };
  prefs = on.home-manager.users.alice.dconf.settings;
in
assert off.environment.systemPackages == [];
assert on.environment.systemPackages == [ package ];
assert prefs."org/gnome/shell/extensions/rounded-window-corners-native".sharp-windows;
assert prefs."org/gnome/shell/extensions/rounded-window-corners-native".round-libadwaita-apps;
assert builtins.elem package.extensionUuid prefs."org/gnome/shell".enabled-extensions;
assert builtins.elem "existing@extension" prefs."org/gnome/shell".enabled-extensions;
assert !(builtins.elem "rounded-window-corners@fxgn" prefs."org/gnome/shell".enabled-extensions);
assert !custom.home-manager.users.alice.dconf.settings."org/gnome/shell/extensions/rounded-window-corners-native".sharp-windows;
{ defaultOff=true; sharpDefault=true; configurable=true; extensionsPreserved=true; alternateUuid=true; }
