{ pkgs, zenosModule, policies, vrSupervisorSource }:
let
  report = pkgs.writeText "zenos-migration-policy-results.json" (builtins.toJSON policies);
  mockProcess = pkgs.writeScriptBin "mock-vr-process" ''
    #!${pkgs.python3}/bin/python3
    import ctypes, sys, time
    ctypes.CDLL(None).prctl(15, sys.argv[1].encode(), 0, 0, 0)
    time.sleep(180)
  '';
  wayvr = pkgs.writeShellScriptBin "wayvr" "exec ${mockProcess}/bin/mock-vr-process wayvr";
  ovras = pkgs.writeShellScriptBin "ovr-advanced-settings" "exec ${mockProcess}/bin/mock-vr-process AdvancedSettings";
  steamRun = pkgs.writeShellScriptBin "steam-run" ''exec "$@"'';
  supervisor = pkgs.writeShellApplication {
    name = "vr-overlay-supervisor-test";
    runtimeInputs = [ pkgs.coreutils pkgs.procps pkgs.systemd pkgs.util-linux wayvr ovras steamRun ];
    text = builtins.readFile vrSupervisorSource;
  };
in pkgs.testers.runNixOSTest {
  name = "zenos-migration-options";
  node.pkgsReadOnly = false;
  nodes.machine = { lib, pkgs, ... }: {
    imports = [ zenosModule ];
    boot.consoleLogLevel = lib.mkForce 7;
    boot.initrd.verbose = lib.mkForce true;
    users.users.root.hashedPassword = lib.mkForce null;
    zenos.system = {
      virtualization = {
        docker.enable = true;
        libvirt = { enable = true; virtualTpm = true; runAsRoot = false; };
      };
      memory.zram = { enable = true; memoryPercent = 25; algorithm = "zstd"; priority = 10; };
      kernel.sysctl."vm.max_map_count" = 2147483642;
      hardware.androidDebugging = true;
      flatpak.enable = false;
    };
    zenos.users.alice = {
      profile = { normalUser = true; homeDirectory = "/Users/alice"; groups = [ "docker" "libvirtd" ]; linger = true; };
      services.flatpak.enable = false;
      programs.kitty = { enable = true; settings.font_size = 11; };
    };
    zenos.users.bob.profile = { normalUser = true; homeDirectory = "/Users/bob"; };
    home-manager.users.alice.home.stateVersion = "26.05";
    system.stateVersion = "26.05";
    environment.etc."zenos-migration-policies.json".source = report;
    environment.systemPackages = with pkgs.zenos; [
      apps.ai.codex apps.ai.opencode apps.ai.takopi
      apps.accessibility.hapticspp apps.audio.swisstag
    ];
    virtualisation = { memorySize = 4096; diskSize = 16384; useBootLoader = true; useEFIBoot = true; };
  };
  testScript = ''
    import json
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("grep -x ID=zenos /etc/os-release")
    results = json.loads(machine.succeed("cat /etc/zenos-migration-policies.json"))
    assert all(results.values()), results
    print("Migration policies:", results)
    machine.wait_for_unit("home-manager-alice.service")
    machine.wait_for_unit("docker.service")
    machine.wait_for_unit("libvirtd.service")
    machine.succeed("docker info --format '{{.ServerVersion}}'")
    machine.succeed("virsh -c qemu:///system list --all")
    machine.succeed("test $(cat /proc/sys/vm/max_map_count) = 2147483642")
    machine.succeed("zramctl --noheadings --output ALGORITHM | grep -w zstd")
    machine.succeed("swapon --noheadings --show=NAME,PRIO | grep '/dev/zram0.*10'")
    machine.succeed("id -nG alice | grep -w docker")
    machine.succeed("id -nG alice | grep -w libvirtd")
    machine.succeed("grep -x 'font_size 11' /Users/alice/.config/kitty/kitty.conf")
    machine.fail("systemctl is-enabled flatpak-managed-install.service")
    machine.fail("systemctl is-enabled syncthing.service")
    machine.succeed("codex --version | grep '0.159.0'")
    machine.succeed("opencode --version | grep '1.18.3'")
    machine.succeed("takopi --help >/dev/null")
    machine.succeed("hapticspp-daemon --help >/dev/null")
    machine.succeed("swisstag --help >/dev/null")

    # Exercise the real supervisor with mock compositor/overlay executables.
    # Physical VR is not needed to test account discovery and scope ownership.
    uid = machine.succeed("id -u alice").strip()
    machine.wait_for_unit(f"user@{uid}.service")
    env = f"XDG_RUNTIME_DIR=/run/user/{uid} XDG_STATE_HOME=/tmp/vr-state XDG_CONFIG_HOME=/tmp/vr-config"
    machine.succeed("install -d -o alice -g users /tmp/vr-state /tmp/vr-config/zenos-vr")
    machine.succeed("echo wayvr > /tmp/vr-config/zenos-vr/desktop-overlay")

    def spawn(user, name, pid_file):
        machine.succeed(f"su - {user} -c '${mockProcess}/bin/mock-vr-process {name} >/tmp/{pid_file}.log 2>&1 & echo $! >/tmp/{pid_file}'")
        return machine.succeed(f"cat /tmp/{pid_file}").strip()

    unowned = spawn("alice", "wayvr", "unowned-wayvr")
    other_user = spawn("bob", "wayvr", "bob-wayvr")
    compositor = spawn("alice", "vrcompositor", "compositor")
    machine.succeed(f"su - alice -c 'env {env} ${supervisor}/bin/vr-overlay-supervisor-test >/tmp/supervisor.log 2>&1 & echo $! >/tmp/supervisor.pid'")
    machine.wait_until_succeeds("grep -q 'WayVR instance remains user-owned' /tmp/vr-state/zenos-vr/overlays.log", timeout=60)
    machine.succeed(f"kill {compositor}")
    machine.wait_until_succeeds("test ! -e /tmp/vr-state/zenos-vr/desktop-overlay.backend")
    machine.succeed(f"kill -0 {unowned}; kill -0 {other_user}")

    machine.succeed(f"kill {unowned}")
    compositor = spawn("alice", "vrcompositor", "compositor-next")
    machine.wait_until_succeeds("test -s /tmp/vr-state/zenos-vr/desktop-overlay.pid", timeout=60)
    machine.wait_until_succeeds(f"su - alice -c 'env XDG_RUNTIME_DIR=/run/user/{uid} systemctl --user list-units --type=scope --state=active --no-legend' | grep 'zenos-vr-desktop-'", timeout=30)
    machine.succeed(f"kill {compositor}")
    machine.wait_until_succeeds(f"test $(pgrep -u {uid} -x wayvr | wc -l) = 0", timeout=30)
    machine.succeed(f"kill -0 {other_user}")
    machine.succeed("kill $(cat /tmp/supervisor.pid)")
    machine.succeed(f"kill {other_user}")
  '';
}
