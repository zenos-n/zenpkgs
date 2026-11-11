{ pkgs, zenosModule }:
let
  probe = pkgs.runCommand "workspace-indicator-probe" {} ''
    dir=$out/share/gnome-shell/extensions/workspace-probe@zenos.test
    mkdir -p "$dir"
    echo '{"uuid":"workspace-probe@zenos.test","name":"Workspace test","description":"VM-only probe","shell-version":["50"]}' > "$dir/metadata.json"
    cat > "$dir/extension.js" <<'JS'
    import GLib from 'gi://GLib';
    import * as Main from 'resource:///org/gnome/shell/ui/main.js';
    import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
    const delay = ms => new Promise(resolve => GLib.timeout_add(GLib.PRIORITY_DEFAULT, ms, () => {
      resolve();
      return GLib.SOURCE_REMOVE;
    }));
    export default class Probe extends Extension {
      enable() {
        this.run().catch(e => GLib.file_set_contents('/tmp/workspace-result', JSON.stringify({error:String(e), stack:e.stack})));
      }
      async run() {
        await delay(2000);
        const original = Main.panel.statusArea.activities.get_first_child();
        const widget = new original.constructor();
        Main.uiGroup.add_child(widget);
        widget.set_position(200, 100);
        try {
          // Use the actual Shell actors without changing the session's workspaces.
          widget._workspacesAdjustment = {upper: 3, value: 0};
          widget._recalculateDots();
          await delay(800);
          widget._workspacesAdjustment.upper = 1;
          widget._recalculateDots();
          widget._workspacesAdjustment.upper = 2;
          widget._workspacesAdjustment.value = 1;
          const started = GLib.get_monotonic_time();
          widget._recalculateDots();
          const active = widget._getActiveIndicators()[1];
          const feedbackMs = (GLib.get_monotonic_time() - started) / 1000;
          const immediateExpansion = active.expansion;
          await delay(800);
          const dots = widget.get_children().map(d => ({expansion:d.expansion, scale:d.scale_x, destroying:d.destroying}));
          // Hiding the panel during an animation must not strand a shrunken dot.
          active.scaleIn();
          await delay(100);
          widget.hide();
          await delay(100);
          widget.show();
          await delay(600);
          const afterHidden = active.scale_x;
          active.scaleOutAndDestroy();
          await delay(100);
          widget.hide();
          await delay(600);
          GLib.file_set_contents('/tmp/workspace-result', JSON.stringify({dots, immediateExpansion, feedbackMs, afterHidden, remaining:widget.get_children().length}));
        } finally {
          widget.destroy();
        }
      }
      disable() {}
    }

JS
  '';
in pkgs.testers.runNixOSTest {
  name = "zenos-workspace-indicator";
  globalTimeout = 180;
  node.pkgsReadOnly = false;
  nodes.machine = { pkgs, ... }: {
    imports = [ zenosModule ];
    nixpkgs.config.allowUnfree = true;
    zenos = {
      system.installed-base.enable = false;
      desktops.gnome = { enable = true; extraPackages.enable = false; extensionPackages = [ probe ]; };
    };
    programs.dconf.profiles.user.databases = [{settings."org/gnome/shell".enabled-extensions = [ "workspace-probe@zenos.test" ];}];
    systemd.user.services."org.gnome.Shell@" = {
      overrideStrategy = "asDropin";
      serviceConfig.ExecStart = [ "" "${pkgs.gnome-shell}/bin/gnome-shell --mode=%i --force-animations" ];
    };
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
    machine.wait_until_succeeds("test -s /tmp/workspace-result", timeout=90)
    result = json.loads(machine.succeed("cat /tmp/workspace-result"))
    print("WORKSPACE_RESULT", result)
    machine.screenshot("workspace-indicator-race")
    assert "error" not in result, result
    assert len(result["dots"]) == 2, result
    assert result["dots"][1]["expansion"] == 1, result
    assert result["immediateExpansion"] == 1, result
    assert result["feedbackMs"] < 400, result
    assert result["afterHidden"] == 1, result
    assert result["remaining"] == 1, result
  '';
}
