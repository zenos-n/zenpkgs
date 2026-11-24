{ nixpkgs, moduleFile }:
let
  lib = import (nixpkgs + "/lib");
  make = cfg: import moduleFile { inherit cfg lib; pkgs = {}; user = "alice"; config = {}; };
  run = choices: let
    cfg = (lib.evalModules { modules = [ (make {}).schema { config = choices; } ]; }).config;
    result = lib.evalModules { modules = [
      { options.home-manager.users = lib.mkOption { type = lib.types.attrsOf (lib.types.submodule {
        options.assertions = lib.mkOption { type = lib.types.listOf lib.types.anything; default = []; };
        options.dconf.settings = lib.mkOption { type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything); default = {}; };
      }); default = {}; }; }
      { config = lib.mkMerge (make cfg).actions; }
    ]; };
  in result.config.home-manager.users.alice.dconf.settings;
  off = run {};
  on = run { power.oledCare = true; };
  explicit = run { power = { oledCare = true; screenBlankSeconds = 600; dimWhenIdle = false; }; };
in
assert !((off."org/gnome/desktop/session" or {}) ? idle-delay);
assert toString on."org/gnome/desktop/session".idle-delay == "@u 300";
assert on."org/gnome/settings-daemon/plugins/power".idle-dim;
assert toString explicit."org/gnome/desktop/session".idle-delay == "@u 600";
assert !explicit."org/gnome/settings-daemon/plugins/power".idle-dim;
assert on."org/gnome/desktop/background" == off."org/gnome/desktop/background";
{ defaultOff = true; idleBlanking = true; personalOverrides = true; noWallpaperChange = true; }
