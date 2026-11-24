{ nixpkgs, moduleFile }:
let
  lib = import (nixpkgs + "/lib");
  make = cfg: import moduleFile { inherit cfg lib; pkgs.zenos.byCategories.desktops.gnome.extensions.aod = "aod-package"; user = "alice"; config = {}; };
  run = choices: let
    cfg = (lib.evalModules { modules = [ (make {}).schema { config = choices; } ]; }).config;
    result = lib.evalModules { modules = [
      { options.home-manager.users = lib.mkOption { type = lib.types.attrsOf (lib.types.submodule {
        options.home.packages = lib.mkOption { type = lib.types.listOf lib.types.anything; default = []; };
        options.assertions = lib.mkOption { type = lib.types.listOf lib.types.anything; default = []; };
        options.dconf.settings = lib.mkOption { type = lib.types.attrsOf (lib.types.attrsOf (lib.types.either (lib.types.listOf lib.types.str) lib.types.anything)); default = {}; };
      }); default = {}; }; }
      { config = lib.mkMerge (make cfg).actions; }
      { home-manager.users.alice.dconf.settings."org/gnome/shell".enabled-extensions = lib.mkDefault [ "existing@extension" ]; }
    ]; };
  in result.config.home-manager.users.alice;
  off = run {};
  on = run { aod.enable = true; power.oledCare = true; };
  badBlank = run { aod.enable = true; power.screenBlankSeconds = 600; };
  badLock = run { aod.enable = true; security.lockScreen = true; };
in
assert off.home.packages == [];
assert on.home.packages == [ "aod-package" ];
assert toString on.dconf.settings."org/gnome/desktop/session".idle-delay == "@u 0";
assert !on.dconf.settings."org/gnome/desktop/screensaver".lock-enabled;
assert builtins.elem "aod@neg-zero.com" on.dconf.settings."org/gnome/shell".enabled-extensions;
assert builtins.elem "existing@extension" on.dconf.settings."org/gnome/shell".enabled-extensions;
assert builtins.all (a: a.assertion) on.assertions;
assert !(builtins.all (a: a.assertion) badBlank.assertions);
assert !(builtins.all (a: a.assertion) badLock.assertions);
{ defaultOff = true; installedAndEnabled = true; noAutomaticLockOrBlank = true; extensionsPreserved = true; incompatiblePoliciesRejected = true; }
