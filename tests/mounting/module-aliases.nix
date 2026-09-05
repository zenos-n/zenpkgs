{ nixpkgsPath, homeManagerPath, runtimePath, bundlePath }:
let
  pkgs = import nixpkgsPath { system = "x86_64-linux"; };
  inherit (pkgs) lib;
  runtime = import runtimePath { inherit lib; };
  bundle = builtins.fromJSON (builtins.readFile bundlePath);
  evaluateBundle = bundle: extra: import (nixpkgsPath + "/nixos/lib/eval-config.nix") {
    system = "x86_64-linux";
    modules = [
      (homeManagerPath + "/nixos")
      (runtime.moduleFromBundle { inherit bundle; })
      {
        system.stateVersion = "26.05";
        users.users.alice.isNormalUser = true;
        users.users.bob.isNormalUser = true;
        home-manager.useGlobalPkgs = true;
        home-manager.users.alice.home.stateVersion = "26.05";
        home-manager.users.bob.home.stateVersion = "26.05";
      }
      ({ lib, ... }: { options.future.marker = lib.mkOption { type = lib.types.str; default = "untouched"; }; })
      extra
    ];
  };
  evaluate = evaluateBundle bundle;
  cfg = (evaluate {
    zenos.system.demo.network.hostName = "module-alias";
    zenos.system.demo.raw.future.marker = "lazy-discovery";
    zenos.system.demo.accounts.alice.login.description = "Alice via alias";
    zenos.system.demo.accounts.bob.home.home.sessionVariables.DYNAMIC = "bob";
    zenos.system.ssh.enable = true;
    zenos.users.alice.aliases.accounts.alice.home.home.sessionVariables.LOCAL = "alice";
    zenos.users.bob.aliases.accounts.bob.home.home.sessionVariables.LOCAL = "bob";
  }).config;
  fails = value: !(builtins.tryEval (builtins.deepSeq value true)).success;
in {
  mountedAliases =
    assert cfg.networking.hostName == "module-alias";
    assert cfg.services.openssh.enable;
    assert cfg.future.marker == "lazy-discovery";
    assert cfg.users.users.alice.description == "Alice via alias";
    assert cfg.home-manager.users.bob.home.sessionVariables.DYNAMIC == "bob";
    assert !(cfg.home-manager.users.alice.home.sessionVariables ? DYNAMIC);
    assert cfg.home-manager.users.alice.home.sessionVariables.LOCAL == "alice";
    assert cfg.home-manager.users.bob.home.sessionVariables.LOCAL == "bob";
    assert !(cfg.zenos.system ? unused);
    true;
  leafAliases =
    assert (evaluate { zenos.system.demo.host = "leaf"; }).config.networking.hostName == "leaf";
    assert (evaluate { zenos.system.hostname = "root-leaf"; }).config.networking.hostName == "root-leaf";
    assert (evaluate { zenos.system.demo = { host = "action-read"; readAlias = true; }; }).config.environment.variables.ALIAS_READ == "action-read";
    true;
  lexicalShadowing =
    let result = (evaluate { zenos.system.demo.groups.outer.members.alice.login.description = "inner-key"; }).config;
    in assert result.users.users.alice.description == "inner-key";
    assert !(result.users.users ? outer); true;
  noForwardedDefaults =
    assert (evaluate { networking.hostName = "upstream-only"; }).config.networking.hostName == "upstream-only";
    assert (evaluate { }).config.future.marker == "untouched";
    true;
  leafSchema =
    let
      evaluated = evaluate { };
      root = evaluated.options.zenos.type.getSubOptions [ "zenos" ];
      system = root.system.type.getSubOptions [ "zenos" "system" ];
      demo = system.demo.type.getSubOptions [ "zenos" "system" "demo" ];
    in assert demo.host.type.name == evaluated.options.networking.hostName.type.name;
    assert !(demo.host ? default);
    assert !(system.hostname ? default);
    true;
  priorities =
    assert (evaluate { zenos.system.demo.host = lib.mkDefault "weak"; networking.hostName = "normal"; }).config.networking.hostName == "normal";
    assert (evaluate { zenos.system.demo.host = lib.mkForce "strong"; networking.hostName = "normal"; }).config.networking.hostName == "strong";
    assert (evaluate { zenos.system.demo.network = lib.mkMerge [
      (lib.mkDefault { hostName = "weak"; })
      (lib.mkIf true { hostName = lib.mkForce "wrapped"; })
      (lib.mkIf false (throw "inactive alias forced"))
    ]; }).config.networking.hostName == "wrapped";
    assert (evaluate { zenos.system.demo.accounts.alice.home.home.sessionVariables.PRIORITY = lib.mkForce "alias";
      home-manager.users.alice.home.sessionVariables.PRIORITY = "upstream";
    }).config.home-manager.users.alice.home.sessionVariables.PRIORITY == "alias";
    assert (evaluate { imports = [
      { zenos.system.demo.ports = [ 2201 ]; }
      { zenos.system.demo.ports = [ 2202 ]; }
    ]; }).config.services.openssh.ports == (evaluate { imports = [
      { services.openssh.ports = [ 2201 ]; }
      { services.openssh.ports = [ 2202 ]; }
    ]; }).config.services.openssh.ports;
    true;
  typeAndPathErrors =
    assert fails (evaluate { zenos.system.demo.host = 42; }).config.networking.hostName;
    assert fails (evaluate { zenos.system.ssh.enable = "yes"; }).config.services.openssh.enable;
    assert fails (evaluate { zenos.system.demo.network.nonexistent = true; }).config.networking.hostName;
    assert fails (evaluate { zenos.system.demo.raw.zenos.recursion = true; }).config.future.marker;
    assert fails (evaluate { zenos.system.demo.accounts.alice.home.zenos.recursion = true; }).config.home-manager.users.alice.home.sessionVariables;
    assert fails (evaluate { zenos.system.demo.host = "one"; networking.hostName = "two"; }).config.networking.hostName;
    true;
  noStructureNoExposure =
    let result = lib.evalModules {
      specialArgs.pkgs = pkgs;
      modules = [ (runtime.moduleFromBundle { bundle = bundle // { structure.present = false; }; }) ];
    }; in assert !(result.options ? zenos); true;
  collisionRejected =
    let collision = bundle // { structure = bundle.structure // {
      nodes = bundle.structure.nodes ++ [ { path = [ "system" "demo" "network" "local" ]; } ];
    }; };
    sameNode = mount: bundle // { structure = bundle.structure // {
      mounts = bundle.structure.mounts ++ [ mount ];
    }; };
    aliasMount = { kind = "alias"; path = [ "system" "ssh" ]; target = [ "nixpkgs" "services" "openssh" ]; };
    reversed = bundle // { structure = bundle.structure // { mounts = [ aliasMount ] ++ bundle.structure.mounts; }; };
    localOption = bundle // { structure = bundle.structure // { nodes = bundle.structure.nodes ++ [ {
      path = [ "system" "ssh" ]; optionNix = "{ lib, ... }: lib.mkOption { type = lib.types.str; default = \"collision\"; }";
    } ]; }; };
    moduleMount = { kind = "zmdl"; path = [ "system" "ssh" ]; target = [ "system" "demo" ]; };
    in assert fails (evaluateBundle collision { }).config.zenos.system.demo;
    assert fails (evaluateBundle (sameNode aliasMount) { }).config.zenos.system.ssh;
    assert fails (evaluateBundle reversed { }).config.zenos.system.ssh;
    assert fails (evaluateBundle localOption { }).config.zenos.system.ssh;
    assert fails (evaluateBundle (sameNode moduleMount) { }).config.zenos.system.ssh;
    true;
}
