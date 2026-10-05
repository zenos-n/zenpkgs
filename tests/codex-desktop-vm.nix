{ pkgs, zenosModule }:
let
  app = pkgs.zenos.apps.ai.codex-desktop;
  appRoot = "${app}/lib/codex-desktop";
in
pkgs.testers.runNixOSTest {
  name = "zenos-codex-desktop";
  node.pkgsReadOnly = false;

  nodes.machine = { lib, ... }: {
    imports = [
      zenosModule
      (pkgs.path + "/nixos/tests/common/x11.nix")
    ];
    boot.consoleLogLevel = lib.mkForce 7;
    boot.initrd.verbose = lib.mkForce true;
    zenos.system.installed-base.enable = true;
    zenos.system.packages.apps.ai.codex-desktop = true;
    test-support.displayManager.auto.user = "alice";
    users.users.alice = {
      isNormalUser = true;
      home = "/Users/alice";
    };
    home-manager.users.alice.home.stateVersion = "26.05";
    environment.systemPackages = [ pkgs.xdotool ];
    system.stateVersion = "26.05";
    virtualisation = {
      memorySize = 4096;
      diskSize = 8192;
      useBootLoader = true;
      useEFIBoot = true;
      mountHostNixStore = true;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("grep -x 'ID=zenos' /etc/os-release")
    machine.succeed("test -d /Config && test -d /Packages && test -d /Users")
    machine.succeed("test $(readlink -f /run/current-system/sw/bin/codex-desktop) = ${app}/bin/codex-desktop")
    machine.succeed("test $(readlink -f ${app}/bin/chatgpt) = ${app}/bin/codex-desktop")
    machine.succeed("${appRoot}/resources/codex --version | grep 'codex-cli'")
    machine.succeed("${appRoot}/resources/cua_node/bin/node --version")
    # Exercise dlopen dependencies that an ELF linkage check alone cannot cover.
    machine.succeed("${appRoot}/resources/cua_node/bin/node -e \"require('${appRoot}/resources/cua_node/lib/node_modules/sharp')({create:{width:1,height:1,channels:3,background:'white'}}).png().toBuffer().then(b => { if (!b.length) process.exit(1) }); require('${appRoot}/resources/native/hid-topology-watcher.node'); require('${appRoot}/resources/native/remote-control-device-key.node');\"")
    machine.wait_for_unit("display-manager.service")
    machine.wait_until_succeeds("test -f /Users/alice/.Xauthority")
    machine.succeed("su - alice -c 'DISPLAY=:0 XAUTHORITY=/Users/alice/.Xauthority codex-desktop --disable-gpu > /tmp/codex-desktop.log 2>&1 &'")
    machine.wait_until_succeeds("su - alice -c 'DISPLAY=:0 XAUTHORITY=/Users/alice/.Xauthority xdotool search --onlyvisible --name \"ChatGPT|Codex\"'", timeout=120)
    machine.wait_until_succeeds("grep -q 'Launching app' /tmp/codex-desktop.log", timeout=120)
    machine.sleep(5)
    machine.screenshot("codex-desktop")
    machine.succeed("! grep -E 'error while loading shared libraries|Module did not self-register|NODE_MODULE_VERSION|Cannot find module' /tmp/codex-desktop.log")
  '';
}
