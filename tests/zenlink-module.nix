{ nixpkgs, zenlinkSource, sourceRoot, moduleFile }:
let
  lib = import (nixpkgs + "/lib");
  package = { type = "derivation"; outPath = "/nix/store/zenlink-test"; drvPath = "/nix/store/zenlink-test.drv"; };
  pkgs.zenos.byCategories.system.zenlink = package;
  make = cfg: user: import moduleFile { inherit lib cfg pkgs user; config = {}; };
  schema = (make {} null).schema;
  normalize = v:
    if builtins.isList v then map normalize v else
    if !builtins.isAttrs v then v else
    if (v._type or "") == "if" then (if v.condition then normalize v.content else {}) else
    if (v._type or "") == "override" then normalize v.content else
    if (v._type or "") == "merge" then lib.foldl' lib.recursiveUpdate {} (map normalize v.contents) else
    lib.mapAttrs (_: normalize) v;
  runFor = user: values: let
    cfg = (lib.evalModules { modules = [ schema { config = values; } ]; }).config;
  in normalize (lib.mkMerge (make cfg user).actions);
  run = runFor "tester";
  defaults = (lib.evalModules { modules = [ schema ]; }).config;
  enabled = run { enable = true; };
  system = runFor null { enable = true; };
  session = enabled.home-manager.users.tester;
  manual = (run { enable = true; autoStart = false; }).home-manager.users.tester;
  custom = (run { enable = true; package = package // {outPath="/nix/store/custom-zenlink";}; }).home-manager.users.tester;
  # Compare transitional user lowering so it cannot retain the old daemon.
  legacy = normalize (import (sourceRoot + "/lib/compat/user-modules/zenlink/module.nix") {
    inherit lib pkgs;
    config.zenos.zenlink = { enable = true; autoStart = true; inherit package; };
  }).config;
  # A deliberately distinct kernel provider catches hard-coded linuxPackages.
  devices = active: normalize (import (zenlinkSource + "/nix/devices.nix") {
    inherit lib;
    pkgs.writeTextDir = path: text: { inherit path text; };
    config = { programs.zenlink.enable = active; boot.kernelPackages.v4l2loopback = "matching-kernel-module"; };
  }).config;
  host = devices true;
in
assert defaults.enable == false && defaults.autoStart == true;
assert (run {}).home-manager.users.tester == {} && !((run {}) ? programs);
assert system.programs.zenlink.enable && system.environment.systemPackages == [ package ];
assert session == legacy;
assert session.systemd.user.services.zenlink.Service == {
  Type = "dbus"; BusName = "org.zenos.ZenLink";
  ExecStart = "/nix/store/zenlink-test/bin/zenlink";
  Restart = "on-failure"; RestartSec = "3s";
};
assert session.systemd.user.services.zenlink.Install.WantedBy == [ "graphical-session.target" ];
assert manual.systemd.user.services.zenlink.Install.WantedBy == [];
assert manual.dconf.settings."org/zenos/zenlink".enabled == false;
assert lib.hasInfix "SystemdService=zenlink.service" manual.xdg.dataFile."dbus-1/services/org.zenos.ZenLink.service".text;
assert custom.systemd.user.services.zenlink.Service.ExecStart == "/nix/store/custom-zenlink/bin/zenlink";
assert session.dconf.settings."org/gnome/shell".enabled-extensions == [ "zenlink@zenos-n.github.io" ];
assert session.dconf.settings."org/gnome/shell".disabled-extensions == [ "gsconnect@andyholmes.github.io" ];
assert devices false == {};
assert host.boot.extraModulePackages == [ "matching-kernel-module" ];
assert host.boot.kernelModules == [ "v4l2loopback" ];
assert lib.hasInfix "video_nr=10" host.boot.extraModprobeConfig;
assert lib.hasInfix "TAG+=\"uaccess\"" (builtins.head host.services.udev.packages).text;
assert host.networking.firewall.allowedTCPPortRanges == [{from=1716;to=1764;}];
assert host.networking.firewall.allowedUDPPortRanges == [{from=1716;to=1764;}];
{ service = session.systemd.user.services.zenlink.Service; inherit host; }
