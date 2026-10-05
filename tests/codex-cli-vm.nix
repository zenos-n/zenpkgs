{ pkgs, zenosModule }:
pkgs.testers.runNixOSTest {
  name = "zenos-codex-cli";
  node.pkgsReadOnly = false;

  nodes.machine = { lib, ... }: {
    imports = [ zenosModule ];
    boot.consoleLogLevel = lib.mkForce 7;
    boot.initrd.verbose = lib.mkForce true;
    zenos.system.packages.apps.ai.codex = true;
    users.users.alice = {
      isNormalUser = true;
      home = "/Users/alice";
    };
    home-manager.users.alice.home.stateVersion = "26.05";
    system.stateVersion = "26.05";
    virtualisation = {
      memorySize = 2048;
      diskSize = 4096;
      useBootLoader = true;
      useEFIBoot = true;
      mountHostNixStore = true;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("grep -x ID=zenos /etc/os-release")
    # --version succeeds even when daemon package validation rejects the layout.
    # Start the real daemon as a user, without credentials or a model request.
    machine.succeed("su - alice -c 'codex app-server daemon start'")
    machine.succeed("su - alice -c 'codex app-server daemon version'")
    machine.succeed("su - alice -c 'codex app-server daemon stop'")
  '';
}
