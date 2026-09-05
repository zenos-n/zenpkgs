{ evaluate, lib, nixpkgs }:
let
  disabled = (evaluate {
    zenos.system.programs.demo = true;
    zenos.users.alice.programs.demo = false;
  }).config;
  enabled = (evaluate {
    zenos.system.programs.demo = { enable = false; message = "inherited"; };
    zenos.users.alice.programs.demo = true;
  }).config;
  partial = (evaluate {
    zenos.system.programs.demo = { enable = true; message = "shared"; settings.first = 9; };
    zenos.users.alice.programs.demo = { message = "alice"; settings.second = 8; };
  }).config;
  defaults = (evaluate {
    zenos.users.alice.programs.demo.settings = {
      first = 7;
      nested.third = 30;
    };
    zenos.users.bob.programs.demo.settings.first = lib.mkDefault 10;
  }).config;
  priority = (evaluate { imports = [
    { zenos.system.programs.demo.enable = lib.mkDefault false; }
    { zenos.system.programs.demo.enable = lib.mkForce true; }
    { zenos.system.programs.demo.settings.items = [ "one" ]; }
    { zenos.system.programs.demo.settings.items = [ "two" ]; }
    { zenos.users.alice.programs.demo = { enable = false; settings.items = [ "alice" ]; }; }
  ]; }).config;
  hasHello = values: builtins.elem nixpkgs.hello.outPath (map (value: value.outPath) values);
in {
  scopedProgramInheritance =
    assert !(disabled.home-manager.users.alice.home.sessionVariables ? ZSTR_USER);
    assert !(disabled.home-manager.users.alice.xdg.configFile ? "demo-enabled");
    assert !(hasHello disabled.home-manager.users.alice.home.packages);
    assert disabled.home-manager.users.bob.home.sessionVariables.ZSTR_USER == "default";
    assert hasHello disabled.home-manager.users.bob.home.packages;
    assert disabled.home-manager.users.alice.home.sessionVariables.ZSTR_BASE == "loaded";
    assert enabled.home-manager.users.alice.home.sessionVariables.ZSTR_USER == "inherited";
    assert !(enabled.home-manager.users.bob.home.sessionVariables ? ZSTR_USER);
    assert partial.home-manager.users.alice.home.sessionVariables.ZSTR_USER == "alice";
    assert partial.home-manager.users.bob.home.sessionVariables.ZSTR_USER == "shared";
    assert partial.zenos.users.alice.programs.demo.settings.first == 9;
    assert partial.zenos.users.alice.programs.demo.settings.second == 8;
    assert partial.zenos.users.bob.programs.demo.settings.second == 2;
    assert !(priority.home-manager.users.alice.home.sessionVariables ? ZSTR_USER);
    assert priority.home-manager.users.bob.home.sessionVariables.ZSTR_USER == "default";
    assert priority.zenos.users.alice.programs.demo.settings.items == [ "alice" ];
    assert priority.zenos.users.bob.programs.demo.settings.items == priority.zenos.system.programs.demo.settings.items;
    assert builtins.length priority.zenos.users.bob.programs.demo.settings.items == 2;
    true;

  aliasWrapperMerges =
    assert (evaluate { zenos.legacy.networking = lib.mkDefault { hostName = "example"; }; })
      .config.networking.hostName == "example";
    assert (evaluate { imports = [
      { zenos.legacy.networking = lib.mkDefault { hostName = "default"; }; }
      { networking.hostName = "upstream"; }
    ]; }).config.networking.hostName == "upstream";
    assert (evaluate { zenos.legacy.networking = lib.mkMerge [
      (lib.mkDefault { hostName = "default"; })
      (lib.mkIf true { hostName = lib.mkForce "forced"; })
    ]; }).config.networking.hostName == "forced";
    assert (evaluate { zenos.legacy.networking = lib.mkMerge [
      { hostName = "lazy"; }
      (lib.mkIf false (throw "disabled branch was evaluated"))
      { nonexistent = lib.mkIf false (throw "disabled nonexistent option was evaluated"); }
    ]; }).config.networking.hostName == "lazy";
    true;

  leafwiseBranchDefaults =
    assert defaults.zenos.users.alice.programs.demo.settings.first == 7;
    assert defaults.zenos.users.alice.programs.demo.settings.second == 2;
    assert defaults.zenos.users.alice.programs.demo.settings.nested.third == 30;
    assert defaults.zenos.users.alice.programs.demo.settings.nested.fourth == 4;
    assert defaults.zenos.users.alice.programs.demo.settings.items == [ "default" ];
    assert defaults.zenos.users.bob.programs.demo.settings.first == 10;
    assert defaults.zenos.users.bob.programs.demo.settings.second == 2;
    true;
}
