{ pkgs, zenosModule }:
let
  python = pkgs.python3.withPackages (p: [ p.pygobject3 ]);
  app = pkgs.writeText "forge-recorder-app.py" ''
    import gi, sys
    gi.require_version("Gtk", "3.0" if sys.argv[2] == "fixed" else "4.0")
    from gi.repository import Gtk, GLib
    title, mode = sys.argv[1:]
    class App(Gtk.Application):
        def do_activate(self):
            w = Gtk.ApplicationWindow(application=self, title=title)
            w.set_default_size(600, 400)
            w.set_resizable(mode != "fixed")
            w.present()
            if mode != "normal":
                GLib.timeout_add(700, lambda: self.quit() or False)
    App(application_id="org.zenos." + title).run([])
  '';
  probe = pkgs.runCommand "forge-recorder-probe" {} ''
    dir=$out/share/gnome-shell/extensions/forge-probe@zenos.test
    mkdir -p "$dir"
    echo '{"uuid":"forge-probe@zenos.test","name":"Forge test","description":"VM probe","shell-version":["50"]}' > "$dir/metadata.json"
    cat > "$dir/extension.js" <<'JS'
    import Gio from 'gi://Gio';
    import GLib from 'gi://GLib';
    import * as Main from 'resource:///org/gnome/shell/ui/main.js';
    import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
    const delay = ms => new Promise(resolve => GLib.timeout_add(GLib.PRIORITY_DEFAULT, ms, () => {resolve(); return GLib.SOURCE_REMOVE;}));
    export default class Probe extends Extension {
      enable() {
        this.signal = global.display.connect('window-created', (_display, w) => {
          const hide = () => { if (w.get_title() === 'HiddenRecorder') w.hide_from_window_list(); };
          w.connect('notify::title', hide);
          hide();
        });
        this.run().catch(e => GLib.file_set_contents('/tmp/forge-result', JSON.stringify({error:String(e), stack:e.stack})));
      }
      async run() {
        await delay(3000);
        const forge = Main.extensionManager.lookup('forge@jmmaranan.com').stateObj;
        const wm = forge.extWm;
        forge.settings.set_boolean('tiling-mode-enabled', true);
        forge.settings.set_boolean('auto-split-enabled', true);
        let splits = 0;
        const command = wm.command;
        wm.command = function(action, ...args) {
          if (action.name === 'Split') splits++;
          return command.call(this, action, ...args);
        };
        const windows = () => global.get_window_actors().map(a => a.meta_window);
        const spawn = (title, mode) => {
          const launcher = new Gio.SubprocessLauncher({flags:Gio.SubprocessFlags.NONE});
          launcher.setenv('GI_TYPELIB_PATH', '${pkgs.gtk3}/lib/girepository-1.0:' + (GLib.getenv('GI_TYPELIB_PATH') || ""), true);
          launcher.setenv('GDK_BACKEND', mode === 'fixed' ? 'x11' : 'wayland', true);
          return launcher.spawnv(['${python}/bin/python3', '${app}', title, mode]);
        };
        const waitWindow = async title => {
          for (let i = 0; i < 100; i++) {
            const w = windows().find(w => w.get_title() === title);
            if (w) return w;
            await delay(50);
          }
          throw new Error('No window: ' + title);
        };
        spawn('TileOne', 'normal');
        const one = await waitWindow('TileOne');
        Main.activateWindow(one);
        await delay(800);
        spawn('TileTwo', 'normal');
        await waitWindow('TileTwo');
        await delay(800);
        const normalSplits = splits;
        const frames = () => windows().filter(w => ['TileOne','TileTwo'].includes(w.get_title())).map(w => ({title:w.get_title(),rect:(({x,y,width,height}) => ({x,y,width,height}))(w.get_frame_rect())})).sort((a,b) => a.title.localeCompare(b.title));
        const before = frames();
        splits = 0;
        spawn('FixedRecorder', 'fixed');
        await waitWindow('FixedRecorder');
        await delay(1300);
        spawn('HiddenRecorder', 'hidden');
        const hidden = await waitWindow('HiddenRecorder');
        const skipTaskbar = hidden.is_skip_taskbar();
        await delay(1300);
        const after = frames();
        GLib.file_set_contents('/tmp/forge-result', JSON.stringify({normalSplits, helperSplits:splits, skipTaskbar, before, after}));
        wm.command = command;
      }
      disable() { if (this.signal) global.display.disconnect(this.signal); }
    }
JS
  '';
in pkgs.testers.runNixOSTest {
  name = "zenos-forge-recorder";
  globalTimeout = 240;
  node.pkgsReadOnly = false;
  nodes.machine = { pkgs, ... }: {
    imports = [ zenosModule ];
    nixpkgs.config.allowUnfree = true;
    zenos.system.installed-base.enable = false;
    zenos.desktops.gnome = {
      enable = true;
      extraPackages.enable = false;
      extensionPackages = [ probe pkgs.zenos.byCategories.desktops.gnome.extensions.forge ];
    };
    programs.dconf.profiles.user.databases = [{settings."org/gnome/shell".enabled-extensions = [ "forge-probe@zenos.test" "forge@jmmaranan.com" ];}];
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
    machine.wait_until_succeeds("test -s /tmp/forge-result", timeout=120)
    result = json.loads(machine.succeed("cat /tmp/forge-result"))
    print("FORGE_RESULT", result)
    machine.screenshot("forge-recorder")
    assert "error" not in result, result
    assert result["normalSplits"] >= 1, result
    assert result["helperSplits"] == 0, result
    assert result["skipTaskbar"], result
    assert result["before"] == result["after"], result
  '';
}
