{ nixpkgs, moduleFile }:
let
  lib = import (nixpkgs + "/lib");
  package = {
    type = "derivation";
    outPath = "/nix/store/tubefin-test";
    drvPath = "/nix/store/tubefin-test.drv";
  };
  other = {
    type = "derivation";
    outPath = "/nix/store/tubefin-override";
    drvPath = "/nix/store/tubefin-override.drv";
  };
  pkgs.zenos.com.neg-zero.Tubefin = package;
  make =
    cfg:
    import moduleFile {
      inherit lib cfg pkgs;
      user = "tester";
      config = { };
    };
  schema = (make { }).schema;
  normalize =
    v:
    if builtins.isList v then
      map normalize v
    else if !builtins.isAttrs v then
      v
    else if (v._type or "") == "if" then
      (if v.condition then normalize v.content else { })
    else if (v._type or "") == "override" then
      normalize v.content
    else if (v._type or "") == "merge" then
      lib.foldl' lib.recursiveUpdate { } (map normalize v.contents)
    else
      lib.mapAttrs (_: normalize) v;
  run =
    values:
    let
      cfg =
        (lib.evalModules {
          modules = [
            schema
            { config = values; }
          ];
        }).config;
    in
    normalize (lib.mkMerge (make cfg).actions);
  enabled = run { enable = true; };
  defaults = (lib.evalModules { modules = [ schema ]; }).config;
in
assert defaults.enable == false && defaults.package == package;
assert (run { }).home-manager.users.tester == { };
assert enabled.home-manager.users.tester.home.packages == [ package ];
assert builtins.attrNames enabled.home-manager.users.tester == [ "home" ];
assert
  (run {
    enable = true;
    package = other;
  }).home-manager.users.tester.home.packages == [ other ];
true
