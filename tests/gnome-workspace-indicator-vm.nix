{ pkgs, zenosModule }:
let
  probe = pkgs.runCommand "workspace-indicator-probe" {} ''
    dir=$out/share/gnome-shell/extensions/workspace-probe@zenos.test
    mkdir -p "$dir"
    echo '{"uuid":"workspace-probe@zenos.test","name":"Workspace test","description":"VM-only probe","shell-version":["50"]}' > "$dir/metadata.json"
    cat > "$dir/extension.js" <<'JS'
    import GLib from 'gi://GLib';
    import St from 'gi://St';
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
        const panel = new St.BoxLayout({name:'panel', width:240, height:32});
        const button = new St.Bin({name:'panelActivities', style_class:'panel-button'});
        button.set_child(widget);
        panel.add_child(button);
        panel.set_position(200, 100);
        Main.uiGroup.add_child(panel);
        const detach = () => {
          const parent = panel.get_parent();
          parent.remove_child(panel);
          parent.add_child(panel);
        };
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
          // Detaching a parent stops transitions recursively; hiding alone does not.
          widget._workspacesAdjustment.upper = 1;
          widget._workspacesAdjustment.value = 0;
          widget._recalculateDots();
          await delay(800);
          widget._workspacesAdjustment.upper = 2;
          widget._recalculateDots();
          await delay(100);
          detach();
          widget._workspacesAdjustment.upper = 3;
          widget._recalculateDots();
          await delay(800);
          const middle = widget.get_children()[1];
          const afterDetachMid = middle.scale_x;
          const dotSize = middle._dot.get_size();
          middle.scaleIn();
          detach();
          await delay(100);
          const afterDetachZero = middle.scale_x;
          middle.scaleIn();
          await delay(100);
          widget.hide();
          await delay(100);
          widget.show();
          await delay(600);
          const afterHidden = middle.scale_x;
          widget._workspacesAdjustment.upper = 2;
          widget._recalculateDots();
          await delay(100);
          detach();
          await delay(600);
          const remainingAfterDetach = widget.get_children().length;
          // Reversing scale-in must not interfere with scale-out settlement.
          widget._workspacesAdjustment.upper = 3;
          widget._recalculateDots();
          await delay(100);
          widget._workspacesAdjustment.upper = 2;
          widget._recalculateDots();
          await delay(100);
          detach();
          await delay(600);
          GLib.file_set_contents('/tmp/workspace-result', JSON.stringify({dots, immediateExpansion, feedbackMs, afterHidden, afterDetachMid, afterDetachZero, dotSize, remainingAfterDetach, remaining:widget.get_children().length}));
        } finally {
          panel.destroy();
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
    assert result["dotSize"][0] >= 5 and result["dotSize"][1] >= 5, result
    assert result["afterDetachMid"] == 1, result
    assert result["afterDetachZero"] == 1, result
    assert result["remainingAfterDetach"] == 2, result
    assert result["remaining"] == 2, result
  '';
}
