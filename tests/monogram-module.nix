{ nixpkgs, moduleFile }:
let
  lib = import (nixpkgs + "/lib");
  package = { type="derivation";outPath="/nix/store/monogram-test";drvPath="/nix/store/monogram-test.drv"; };
  pkgs.zenos.byCategories.apps.communication.monogram = package;
  make = cfg: user: import moduleFile {inherit lib cfg pkgs user;config={};};
  schema = (make {} null).schema;
  normalize = v: if builtins.isList v then map normalize v else if !builtins.isAttrs v then v else
    if (v._type or "")=="if" then (if v.condition then normalize v.content else {}) else
    if (v._type or "")=="override" then normalize v.content else
    if (v._type or "")=="merge" then lib.foldl' lib.recursiveUpdate {} (map normalize v.contents) else lib.mapAttrs (_:normalize) v;
  run = user: values: let cfg=(lib.evalModules {modules=[schema {config=values;}];}).config; in normalize (lib.mkMerge (make cfg user).actions);
  system=run null {enable=true;};
  user=run "tester" {enable=true;};
in
assert (lib.evalModules {modules=[schema];}).config.enable == false;
assert !(run null {} ? networking);
assert system.networking.firewall.allowedTCPPorts == [45950];
assert system.networking.firewall.allowedUDPPorts == [45950];
assert system.environment.systemPackages == [package];
assert user.home-manager.users.tester.home.packages == [package];
assert !(user ? networking);
true
