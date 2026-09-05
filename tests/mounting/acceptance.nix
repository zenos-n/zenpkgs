{ nixpkgsPath, homeManagerPath, runtimePath, bundlePath }:
let
  nixpkgs = import nixpkgsPath { system = "x86_64-linux"; };
  lib = nixpkgs.lib;
  runtime = import runtimePath { inherit lib; };
  bundle = builtins.fromJSON (builtins.readFile bundlePath);
  packages = { tools = { one = nixpkgs.hello; two = nixpkgs.cowsay; }; legacy = nixpkgs; };
  evaluate = extra: import (nixpkgsPath + "/nixos/lib/eval-config.nix") {
    system = "x86_64-linux";
    modules = [
      (homeManagerPath + "/nixos")
      (runtime.moduleFromBundle { inherit bundle; packageTree = packages; })
      {
        nixpkgs.overlays = [ (_: _: { zenos = packages; }) ];
        system.stateVersion = "26.05";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        zenos.users.alice.legacy = {
          isNormalUser = true;
          homeManager.home.stateVersion = "26.05";
        };
        zenos.users.bob.legacy = {
          isNormalUser = true;
          homeManager.home.stateVersion = "26.05";
        };
      }
      ({ lib, ... }: {
        options.future.marker = lib.mkOption { type = lib.types.str; default = ""; };
        config.home-manager.sharedModules = [ ({ lib, ... }: {
          options.zenos.private = lib.mkOption { type = lib.types.bool; default = false; };
        }) ];
      })
      extra
    ];
  };
  evaluated = evaluate {
    zenos = {
      system = {
        programs.demo.message = "system";
        link = true;
        packages.tools = { one = true; two = false; };
        services.openssh.enable = true;
      };
      users.alice = {
        programs.demo = {
          enable = true;
          message = "alice";
          child = true;
          instances = { FIRST = true; SECOND = false; };
        };
        packages.tools.two = true;
        legacy.homeManager.home.sessionVariables.ALIAS = "alice-only";
      };
      users.bob.programs.demo = false;
      legacy.networking.hostName = "zstr-fixture";
      legacy.future.marker = "discovered";
    };
  };
  cfg = evaluated.config;
  alice = cfg.home-manager.users.alice;
  bob = cfg.home-manager.users.bob;
  shared = (evaluate {
    zenos.system.programs.demo = { enable = true; message = "system-default"; };
    zenos.users.alice.programs.demo = { enable = true; message = "user-override"; };
  }).config;
  host = builtins.head (builtins.filter (source: source.kind == "zcfg") bundle.sources);
  fromZcfg = (evaluate { config = import (builtins.toFile "mounted-host.nix" host.compiledNix) {
    pkgs = nixpkgs // { zenos = packages; };
  }; }).config;
  without = lib.evalModules {
    modules = [ (runtime.moduleFromBundle { bundle = bundle // {
      structure = { present = false; mounts = [ ]; nodes = [ ]; };
    }; }) ];
    specialArgs.pkgs = nixpkgs;
  };
  fails = value: !(builtins.tryEval (builtins.deepSeq value true)).success;
in
assert cfg.networking.hostName == "zstr-fixture";
assert cfg.services.openssh.enable;
assert cfg.future.marker == "discovered";
assert cfg.zenos.system.port == 8080;
assert cfg.zenos.users.alice.label == "alice";
assert cfg.zenos.users.bob.label == "bob";
assert cfg.environment.variables.ZSTR_FILE == "mounted";
assert cfg.environment.variables.ZSTR_LINK == "linked";
assert cfg.environment.variables.ZSTR_PRIORITY == "strong";
assert alice.home.sessionVariables.ZSTR_PRIORITY == "strong";
assert bob.home.sessionVariables.ZSTR_PRIORITY == "strong";
assert !(shared.home-manager.users.alice.xdg.configFile ? "disabled-record");
assert cfg.environment.variables.ZSTR_BASE == "loaded";
assert !(cfg.environment.variables ? ZSTR_SYSTEM);
assert !(cfg.environment.variables ? ZSTR_HIDDEN);
assert alice.home.sessionVariables.ZSTR_USER == "alice";
assert alice.home.sessionVariables.CHILD == "nested-module";
assert !(bob.home.sessionVariables ? CHILD);
assert alice.home.sessionVariables.FIRST == "instance";
assert !(alice.home.sessionVariables ? SECOND);
assert !(bob.home.sessionVariables ? FIRST);
assert !(bob.home.sessionVariables ? ZSTR_USER);
assert alice.home.sessionVariables.ALIAS == "alice-only";
assert !(bob.home.sessionVariables ? ALIAS);
assert alice.home.sessionVariables.ZSTR_BASE == "loaded";
assert bob.home.sessionVariables.ZSTR_BASE == "loaded";
assert builtins.elem nixpkgs.hello cfg.environment.systemPackages;
assert !(builtins.elem nixpkgs.cowsay cfg.environment.systemPackages);
assert builtins.elem nixpkgs.cowsay alice.home.packages;
assert !(builtins.elem nixpkgs.cowsay bob.home.packages);
assert shared.environment.variables.ZSTR_SYSTEM == "system-default";
assert shared.home-manager.users.bob.home.sessionVariables.ZSTR_USER == "system-default";
assert shared.home-manager.users.alice.home.sessionVariables.ZSTR_USER == "user-override";
assert fromZcfg.networking.hostName == "zcfg-mounted";
assert fromZcfg.home-manager.users.alice.home.sessionVariables.ZSTR_USER == "from-zcfg";
assert fromZcfg.home-manager.users.alice.home.sessionVariables.FROM_ZCFG == "yes";
assert builtins.elem nixpkgs.hello fromZcfg.environment.systemPackages;
assert !(without.options ? zenos);
assert !(runtime.packageExposure (bundle // { structure.present = false; }));
assert fails (lib.evalModules {
  specialArgs.pkgs = nixpkgs;
  modules = [ (runtime.moduleFromBundle { bundle = bundle // {
    structure = { present = true; nodes = [ ]; mounts = [ {
      kind = "zmdl"; path = [ "system" "missing" ]; target = [ "missing" ];
    } ]; };
  }; }) ];
}).options;
assert fails (evaluate { zenos.system.packages.tools.one = "yes"; }).config.environment.systemPackages;
assert fails (evaluate { zenos.system.port = "invalid"; }).config.zenos.system.port;
assert fails (evaluate { zenos.system.packages.tools.missing = false; }).config.environment.systemPackages;
assert fails (evaluate { zenos.legacy.networking.hostName = 5; }).config.networking.hostName;
assert fails (evaluate { zenos.legacy.zenos.system.probe = true; }).config.networking.hostName;
assert fails (evaluate { zenos.users.alice.legacy.homeManager.zenos.private = true; }).config.home-manager.users.alice.home.sessionVariables;
assert (evaluate { imports = [
  { zenos.legacy.networking.hostName = lib.mkDefault "alias-default"; }
  { networking.hostName = "upstream"; }
]; }).config.networking.hostName == "upstream";
assert (evaluate { imports = [
  { zenos.legacy.networking.hostName = lib.mkForce "alias-force"; }
  { networking.hostName = "upstream"; }
]; }).config.networking.hostName == "alias-force";
assert fails (evaluate { zenos.system.priority.conflict = true; }).config.environment.variables.ZSTR_PRIORITY;
assert builtins.any (warning: lib.hasInfix "modules/system/link.zmdl:" warning) cfg.warnings;
assert !(builtins.any (warning: lib.hasInfix "modules/hidden/unused.zmdl:" warning) cfg.warnings);
{
  fileMount = true;
  subtreeMount = true;
  userIsolation = true;
  unconditionalActions = true;
  booleanSelectors = true;
  typedAliases = true;
  rootExclusion = true;
  noStructureNoExposure = true;
  dynamicSchemaDiscovery = true;
  nestedModule = true;
  userFreeforms = true;
  systemUserDefaults = true;
  compiledZcfg = true;
  structureOptions = true;
  missingMountRejected = true;
  crossModuleActions = true;
  noDisabledRecords = true;
  actionPriorities = true;
  aliasPriorities = true;
  sourceDiagnostics = true;
} // import ./merge-regressions.nix { inherit evaluate lib nixpkgs; }
