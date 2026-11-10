{ pkgs, zenosModule }:
pkgs.testers.runNixOSTest {
  name = "zenos-gdm-branding";
  globalTimeout = 240;
  node.pkgsReadOnly = false;
  nodes.machine = { ... }: {
    imports = [ zenosModule ];
    zenos = {
      system.installed-base.enable = false;
      desktops.gnome = { enable = true; extraPackages.enable = false; };
    };
    users.users.alice = { isNormalUser = true; password = "vm-only"; };
    virtualisation = {
      graphics = true;
      memorySize = 3072;
      qemu.options = [ "-vga none" "-device virtio-vga,xres=1280,yres=800" ];
    };
    system.stateVersion = "26.05";
  };
  testScript = ''
    machine.start()
    machine.wait_for_unit("display-manager.service")
    machine.wait_until_succeeds("systemctl --user --machine=gdm-greeter@.host is-active org.gnome.Shell@gdm.service", timeout=90)
    machine.succeed("p=$(pgrep -u gdm-greeter -f '/bin/gnome-shell --mode=gdm' | head -1); tr '\\0' '\\n' < /proc/$p/environ | grep -qx 'DCONF_PROFILE=/etc/dconf/profile/gdm'")
    # Read exactly the profile and persistent config directory used by the greeter.
    prefix = "env DCONF_PROFILE=/etc/dconf/profile/gdm XDG_CONFIG_HOME=/var/lib/gdm/seat0/config dconf read "
    assert machine.succeed(prefix + "/org/gnome/desktop/interface/accent-color").strip() == "'purple'"
    logo = machine.succeed(prefix + "/org/gnome/login-screen/logo").strip().strip("'")
    assert logo.endswith("/share/icons/hicolor/scalable/apps/zenos.svg"), logo
    machine.succeed("test -r " + logo)
    machine.sleep(10)
    machine.screenshot("zenos-greeter")
    machine.send_key("ret")
    machine.sleep(2)
    machine.send_chars("v")
    machine.screenshot("zenos-greeter-password")
  '';
}
