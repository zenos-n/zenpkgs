{ nixpkgs, moduleFile }:
let
  lib = import (nixpkgs + "/lib");
  package = { type = "derivation"; outPath = "/nix/store/app-library-test"; drvPath = "/nix/store/app-library-test.drv"; extensionUuid = "app-library@neg-zero.com"; };
  pkgs.zenos.byCategories.desktops.gnome.extensions.app-library = package;
  make = cfg: user: import moduleFile { inherit cfg lib pkgs user; config = {}; };
  schema = (make {} null).schema;
  normalize = v:
    if builtins.isList v then map normalize v else
    if !builtins.isAttrs v then v else
    if (v._type or "") == "if" then (if v.condition then normalize v.content else {}) else
    if (v._type or "") == "override" then normalize v.content else
    if (v._type or "") == "merge" then lib.foldl' lib.recursiveUpdate {} (map normalize v.contents) else
    lib.mapAttrs (_: normalize) v;
  run = enable: user: let
    cfg = (lib.evalModules { modules = [schema {config.enable=enable;}]; }).config;
  in normalize (lib.mkMerge (make cfg user).actions);
  global = run true null;
  personal = run true "alice";
in
assert !((run false null) ? environment);
assert (builtins.head (run false null).home-manager.sharedModules).config == {};
assert global.environment.systemPackages == [package];
assert (builtins.head global.home-manager.sharedModules).config.dconf.settings."org/gnome/shell".enabled-extensions == [package.extensionUuid];
assert personal.home-manager.users.alice.dconf.settings."org/gnome/shell".enabled-extensions == [package.extensionUuid];
assert !(personal ? environment);
{ defaultDisabled = true; systemInstalls = true; sharedUsersEnabled = true; personalScoped = true; }
