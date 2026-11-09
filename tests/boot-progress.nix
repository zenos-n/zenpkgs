{ pkgs, bootvinePackage ? pkgs.zenos.byCategories.system.bootvine,
  plymouthThemePackage ? pkgs.zenos.byCategories.theming.system.zenos-plymouth }:
let
  # Based on Bootvine's GPL-3.0-or-later encrypted-volume VM fixture:
  # https://codeberg.org/wvhulle/bootvine/src/commit/f43ece2f72625efb8ebfe9adede76abc2b0f146f/vm-tests/encrypted-volume/secret-disk.nix
  uuid = "9d1f2a8e-0b7c-4c55-9a8e-6b2f8f3c1d00";
  secretDisk = pkgs.runCommand "bootvine-luks-disk" { nativeBuildInputs = [ pkgs.cryptsetup ]; } ''
    truncate -s 32M disk.img
    printf sample-passphrase | cryptsetup luksFormat -q --disable-locks --type luks2 \
      --pbkdf pbkdf2 --pbkdf-force-iterations 1000 --uuid ${uuid} disk.img -
    mv disk.img $out
  '';
in
pkgs.testers.runNixOSTest {
  name = "zenos-plymouth-bootvine";
  globalTimeout = 300;
  nodes.machine = { lib, config, ... }: {
    imports = [ ../lib/boot-progress.nix ];
    services.bootvine = { enable = true; package = bootvinePackage; plymouth = true; };
    boot.plymouth = { enable = true; theme = "zenos"; themePackages = [ plymouthThemePackage ]; };
    boot.initrd.systemd.enable = true;
    boot.initrd.luks.devices = lib.mkVMOverride { secret.device = "/dev/disk/by-uuid/${uuid}"; };
    virtualisation.qemu.drives = [{ name = "secret"; file = "${secretDisk}"; driveExtraOpts = { format = "raw"; snapshot = "on"; }; }];
    boot.kernelParams = [ "quiet" "splash" "console=tty0" "plymouth.ignore-serial-consoles" "plymouth.debug=stream:/run/plymouth-debug.log" ];
    boot.consoleLogLevel = lib.mkForce 3;
    testing.initrdBackdoor = true;
    virtualisation = { graphics = true; memorySize = 2048; qemu.options = [ "-vga none" "-device virtio-vga,xres=1280,yres=800" ]; };
    boot.initrd.kernelModules = [ "virtio_gpu" "virtio_input" ];
    boot.initrd.systemd.extraBin.grep = "${pkgs.gnugrep}/bin/grep";
    boot.initrd.systemd.services.bootvine-initrd-hold = {
      wantedBy = [ "initrd.target" ];
      after = [ "bootvine.service" ];
      before = [ "initrd-switch-root.target" ];
      serviceConfig = { Type = "oneshot"; ExecStart = "${pkgs.runtimeShell} -c 'while ! test -e /run/release-initrd; do sleep 0.1; done'"; };
    };
    systemd.services.bootvine-host-hold = {
      wantedBy = [ "multi-user.target" ];
      after = [ "bootvine.service" ];
      before = [ "plymouth-quit.service" ];
      serviceConfig = { Type = "oneshot"; ExecStart = "${pkgs.runtimeShell} -c 'while ! test -e /run/release-host; do sleep 0.1; done'"; };
    };
    # Keep the test transport alive while inspecting the shutdown splash.
    systemd.services.backdoor.unitConfig.DefaultDependencies = false;
    systemd.services.shutdown-hold = {
      wantedBy = [ "shutdown.target" ];
      after = [ "bootvine-shutdown.service" ];
      before = [ "systemd-poweroff.service" ];
      unitConfig.DefaultDependencies = false;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.runtimeShell} -c 'while ! test -e /run/release-shutdown; do sleep 0.1; done'";
      };
    };
    system.stateVersion = "26.05";
  };
  testScript = ''
    machine.start()
    machine.wait_until_succeeds("test -S /run/bootvine/plymouth.sock")
    def foreground():
        return machine.succeed("cat /sys/class/tty/tty0/active").strip()
    assert foreground() != "tty12", "hidden tree stole the Plymouth display"
    initial_pid = machine.succeed("systemctl show bootvine -p MainPID --value").strip()
    machine.wait_until_succeeds("plymouth --has-active-vt", timeout=30)
    machine.wait_until_succeeds("test -e /dev/input/event0", timeout=30)
    machine.wait_until_succeeds("grep -q 'QEMU Virtio Keyboard' /run/plymouth-debug.log", timeout=30)
    machine.screenshot("plymouth-initrd")
    machine.send_key("esc")
    machine.wait_until_succeeds("test $(cat /sys/class/tty/tty0/active) = tty12", timeout=30)
    machine.wait_until_succeeds("grep -a -q 'Initrd' /dev/vcs12", timeout=30)
    machine.wait_until_succeeds("test -n \"$(ls /run/systemd/ask-password/ask.* 2>/dev/null)\"", timeout=30)
    machine.screenshot("verbose-initrd")
    # Unlock a real LUKS disk through the visible viewer in stage 1.
    machine.send_chars("sample-passphrase\n")
    machine.wait_until_succeeds("test -e /dev/mapper/secret", timeout=30)
    machine.send_key("esc")
    machine.wait_until_succeeds("test $(cat /sys/class/tty/tty0/active) != tty12", timeout=30)
    machine.screenshot("plymouth-returned")
    machine.succeed("touch /run/release-initrd")
    machine.switch_root()
    machine.wait_until_succeeds("systemctl is-active bootvine")
    machine.wait_until_succeeds("test -S /run/bootvine/plymouth.sock", timeout=5)
    assert initial_pid == machine.succeed("systemctl show bootvine -p MainPID --value").strip(), "viewer lost its initrd history"
    machine.succeed("udevadm settle")
    machine.send_key("esc")
    machine.wait_until_succeeds("test $(cat /sys/class/tty/tty0/active) = tty12", timeout=30)
    machine.wait_until_succeeds("grep -a -q 'Stage 2' /dev/vcs12", timeout=30)
    machine.screenshot("verbose-host")
    # A real systemd password request must be answerable from the visible tree.
    machine.execute("systemd-ask-password --timeout=30 'Unlock test volume' > /run/password-result &")
    machine.wait_until_succeeds("grep -a -q 'Unlock test volume' /dev/vcs12")
    machine.send_chars("sample-passphrase\n")
    machine.wait_until_succeeds("grep -qx sample-passphrase /run/password-result")
    machine.send_key("esc")
    machine.wait_until_succeeds("test $(cat /sys/class/tty/tty0/active) != tty12", timeout=30)
    # A killed foreground viewer must restore Plymouth and its stock details.
    machine.send_key("esc")
    machine.wait_until_succeeds("test $(cat /sys/class/tty/tty0/active) = tty12", timeout=30)
    machine.succeed("systemctl kill --kill-whom=main --signal=KILL bootvine")
    machine.wait_until_succeeds("test ! -S /run/bootvine/plymouth.sock", timeout=30)
    machine.wait_until_succeeds("test $(cat /sys/class/tty/tty0/active) != tty12", timeout=30)
    machine.send_key("esc")
    machine.screenshot("stock-details-fallback")
    assert foreground() != "tty12"
    machine.succeed("touch /run/release-host")
    machine.wait_for_unit("multi-user.target")
    machine.succeed("systemctl poweroff --no-block")
    machine.wait_until_succeeds("systemctl is-active bootvine-shutdown", timeout=30)
    assert foreground() != "tty12", "shutdown viewer stole the splash"
    machine.send_key("esc")
    machine.wait_until_succeeds("test $(cat /sys/class/tty/tty0/active) = tty12", timeout=30)
    machine.screenshot("verbose-shutdown")
    machine.succeed("touch /run/release-shutdown")
    machine.wait_for_shutdown()
  '';
}
