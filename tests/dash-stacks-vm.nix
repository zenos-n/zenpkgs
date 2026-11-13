{ pkgs, zenosModule, stacksPackage ? pkgs.zenos.byCategories.desktops.gnome.extensions.dash-stacks }:
let
  probe = pkgs.runCommand "dash-stacks-probe" {} ''
    dir=$out/share/gnome-shell/extensions/stacks-probe@zenos.test
    mkdir -p "$dir"
    echo '{"uuid":"stacks-probe@zenos.test","name":"Stacks test","description":"VM-only probe","shell-version":["50"]}' > "$dir/metadata.json"
    cat > "$dir/extension.js" <<'JS'
    import GLib from 'gi://GLib';
    import * as Main from 'resource:///org/gnome/shell/ui/main.js';
    import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
    import {run} from 'file://${stacksPackage}/share/gnome-shell/extensions/dash-stacks@neg-zero.com/tests/appFolders.js';
    export default class Probe extends Extension {
      enable() {
        GLib.timeout_add(GLib.PRIORITY_DEFAULT, 2500, () => {
          const extension = Main.extensionManager.lookup('dash-stacks@neg-zero.com').stateObj;
          run(extension).then(result => GLib.file_set_contents('/tmp/stacks-result', JSON.stringify(result)))
            .catch(e => GLib.file_set_contents('/tmp/stacks-result', JSON.stringify({error:String(e), stack:e.stack})));
          return GLib.SOURCE_REMOVE;
        });
      }
      disable() {}
    }
JS
  '';
in pkgs.testers.runNixOSTest {
  name = "zenos-dash-stacks";
  globalTimeout = 180;
  node.pkgsReadOnly = false;
  nodes.machine = { pkgs, ... }: {
    imports = [ zenosModule ];
    nixpkgs.config.allowUnfree = true;
    zenos = {
      system.installed-base.enable = false;
      desktops.gnome = { enable = true; extraPackages.enable = false; extensionPackages = [ stacksPackage probe ]; };
    };
    environment.systemPackages = [ pkgs.nautilus pkgs.gnome-text-editor ];
    programs.dconf.profiles.user.databases = [{settings = {
      "org/gnome/shell" = {
        enabled-extensions = [ "dash-stacks@neg-zero.com" "stacks-probe@zenos.test" ];
        favorite-apps = [ "unused-fixture.desktop" ];
      };
      "org/gnome/shell/extensions/dash-stacks".stacks = ''[{"name":"Fixture","path":"/tmp","icon":"folder","autoIcon":false}]'';
    };}];
    services.displayManager.autoLogin = {enable = true; user = "alice";};
    users.users.alice = {isNormalUser = true; password = "vm-only";};
    virtualisation = {
      graphics = true;
      memorySize = 3072;
      qemu.options = [ "-vga none" "-device virtio-vga,xres=1280,yres=800" ];
    };
    system.stateVersion = "26.05";
  };
  testScript = ''
    import json
    machine.start()
    machine.wait_for_unit("display-manager.service")
    machine.wait_until_succeeds("test -s /tmp/stacks-result", timeout=90)
    result = json.loads(machine.succeed("cat /tmp/stacks-result"))
    print("DASH_STACKS_RESULT", result)
    machine.screenshot("dash-stacks-folders")
    assert "error" not in result, result
    assert result["feedbackMs"] < 400, result
    assert result["membersPreserved"] and result["lifecycle"], result
    machine.succeed("journalctl -b > /tmp/shell.log")
    print(machine.succeed("tail -n40 /tmp/shell.log"))
    machine.fail("grep -E 'JS ERROR|already disposed|clutter_actor_(remove|add)_child: assertion' /tmp/shell.log")
  '';
}
