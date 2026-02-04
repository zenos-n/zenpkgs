import Gio from 'gi://Gio';
import GObject from 'gi://GObject';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as QuickSettings from 'resource:///org/gnome/shell/ui/quickSettings.js';
import * as PopupMenu from 'resource:///org/gnome/shell/ui/popupMenu.js';
import {Extension, gettext as _} from 'resource:///org/gnome/shell/extensions/extension.js';

function communicate(proc, input) {
    return new Promise((resolve, reject) => {
        proc.communicate_utf8_async(input, null, (proc, res) => {
            try {
                const result = proc.communicate_utf8_finish(res);
                resolve(result);
            } catch (e) {
                reject(e);
            }
        });
    });
}

const runCommand = async (args) => {
    try {
        const proc = new Gio.Subprocess({
            argv: ['zl-config', ...args],
            flags: Gio.SubprocessFlags.STDOUT_PIPE | Gio.SubprocessFlags.STDERR_PIPE
        });
        
        proc.init(null);
        const [ok, stdout, stderr] = await communicate(proc, null);
        
        if (!proc.get_successful()) {
            return ""; // Fail silently for list checks
        }
        return stdout ? stdout.trim() : "";
    } catch (e) {
        return "";
    }
};

const ZenLinkToggle = GObject.registerClass(
class ZenLinkToggle extends QuickSettings.QuickMenuToggle {
    _init(extensionObject, indicator) {
        super._init({
            title: _('ZenLink'),
            subtitle: _('Offline'),
            iconName: 'phone-symbolic',
            toggleMode: true,
        });

        this._extension = extensionObject;
        this._indicator = indicator;
        this._isSyncing = false;
        
        this._buildMenu();
        this._syncState(); 
        this.connect('clicked', () => this._onMainToggle());
    }

    _buildMenu() {
        this._turnOnItem = new PopupMenu.PopupMenuItem(_('Turn ZenLink On'));
        this._turnOnItem.connect('activate', () => this._onMainToggle());
        this.menu.addMenuItem(this._turnOnItem);

        this._advancedItems = [];

        // === Saved Phones Switcher (Backend Driven) ===
        this._phoneMenu = new PopupMenu.PopupSubMenuMenuItem(_('Switch Phone'), true);
        this._phoneMenu.icon.icon_name = 'phone-symbolic';
        this.menu.addMenuItem(this._phoneMenu);
        this._advancedItems.push(this._phoneMenu);

        // === Camera Source Submenu ===
        this._sourceMenu = new PopupMenu.PopupSubMenuMenuItem(_('Camera Source'), true);
        this._sourceMenu.icon.icon_name = 'camera-video-symbolic';
        this._sourceItems = {};

        ['back', 'front', 'none'].forEach(type => {
            let label = type.charAt(0).toUpperCase() + type.slice(1);
            if (type === 'none') label = _('No Video (Audio Only)');
            let item = new PopupMenu.PopupMenuItem(label);
            item.connect('activate', () => this._runConfig(['-c', type]));
            this._sourceMenu.menu.addMenuItem(item);
            this._sourceItems[type] = item;
        });
        this.menu.addMenuItem(this._sourceMenu);
        this._advancedItems.push(this._sourceMenu);

        // === Orientation ===
        this._orientMenu = new PopupMenu.PopupSubMenuMenuItem(_('Camera Orientation'), true);
        this._orientMenu.icon.icon_name = 'object-rotate-right-symbolic';
        this._orientItems = {};
        
        this._currentAngle = '0'; 
        this._isFlipped = false;

        ['0', '90', '180', '270'].forEach(angle => {
             let item = new PopupMenu.PopupMenuItem(angle + '°');
             item.connect('activate', () => this._onOrientChange(angle, this._isFlipped));
             this._orientMenu.menu.addMenuItem(item);
             this._orientItems[angle] = item;
        });
        this._orientMenu.menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());
        this._flipSwitch = new PopupMenu.PopupSwitchMenuItem(_('Mirror / Flip'), false);
        this._flipSwitch.connect('toggled', (item) => this._onOrientChange(this._currentAngle, item.state));
        this._orientMenu.menu.addMenuItem(this._flipSwitch);
        this.menu.addMenuItem(this._orientMenu);
        this._advancedItems.push(this._orientMenu);

        // === Audio ===
        const sep1 = new PopupMenu.PopupSeparatorMenuItem();
        this.menu.addMenuItem(sep1);
        this._advancedItems.push(sep1);

        let addHeader = (text) => {
             let item = new PopupMenu.PopupMenuItem(text, { reactive: false, can_focus: false });
             item.add_style_class_name('popup-subtitle-menu-item');
             this.menu.addMenuItem(item);
             this._advancedItems.push(item);
        };
        addHeader(_('Audio Routing'));
        
        this._monitorSwitch = new PopupMenu.PopupSwitchMenuItem(_('Use Phone as Mic'), false);
        this._monitorSwitch.connect('toggled', (item) => { 
            if(!this._isSyncing) this._runConfig(['-m', item.state ? 'on' : 'off']); 
        });
        this.menu.addMenuItem(this._monitorSwitch);
        this._advancedItems.push(this._monitorSwitch);

        this._desktopSwitch = new PopupMenu.PopupSwitchMenuItem(_('Stream PC Audio to Phone'), false);
        this._desktopSwitch.connect('toggled', (item) => { 
            if(!this._isSyncing) this._runConfig(['-d', item.state ? 'on' : 'off']); 
        });
        this.menu.addMenuItem(this._desktopSwitch);
        this._advancedItems.push(this._desktopSwitch);

        const sep2 = new PopupMenu.PopupSeparatorMenuItem();
        this.menu.addMenuItem(sep2);
        this._advancedItems.push(sep2);

        const settingsItem = new PopupMenu.PopupMenuItem(_('Connection Settings'));
        settingsItem.connect('activate', () => this._extension.openPreferences());
        this.menu.addMenuItem(settingsItem);

        this.menu.connect('open-state-changed', (menu, open) => {
            if (open) {
                this._syncState(); // Also triggers list update
            }
        });
    }

    async _updatePhoneList() {
        this._phoneMenu.menu.removeAll();
        
        // FETCH FROM BACKEND
        const output = await runCommand(['-L']);
        const savedIps = output.split('\n').filter(line => line.trim() !== '');
        
        if (savedIps.length === 0) {
            let item = new PopupMenu.PopupMenuItem(_('No saved phones'), { reactive: false });
            this._phoneMenu.menu.addMenuItem(item);
        } else {
            savedIps.forEach(ip => {
                let item = new PopupMenu.PopupMenuItem(ip);
                if (this._currentIp === ip) {
                    item.setOrnament(PopupMenu.Ornament.DOT);
                }
                item.connect('activate', () => {
                    this._runConfig(['-i', ip]);
                });
                this._phoneMenu.menu.addMenuItem(item);
            });
        }
    }

    async _onMainToggle() {
        if (this._isSyncing) return;
        await this._runConfig(['-t']);
    }

    async _onOrientChange(angle, flipped) {
        if (this._isSyncing) return;
        this._currentAngle = angle;
        this._isFlipped = flipped;
        let cmd = angle;
        if (flipped) cmd = 'flip' + angle;
        await this._runConfig(['-o', cmd]);
    }

    async _runConfig(args) {
        this._isSyncing = true;
        await runCommand(args);
        await this._syncState();
        this._isSyncing = false;
    }

    async _syncState() {
        this._isSyncing = true;
        
        // 1. Get State
        let output = await runCommand([]); 
        
        const getVal = (key) => {
            const match = output.match(new RegExp(`${key}:\\s+(.*)`));
            return match ? match[1].trim() : '';
        };

        const ip = getVal('IP');
        this._currentIp = ip;
        
        // 2. Update List (now that we know current IP)
        await this._updatePhoneList();

        const cam = getVal('Cam'); 
        const monitor = getVal('Monitor'); 
        const desktop = getVal('Desktop');
        const status = getVal('Daemon');
        const isRunning = (status === 'active');

        this.set({ checked: isRunning, subtitle: isRunning ? (ip || _('Streaming')) : _('Ready') });
        if (this._indicator) this._indicator.visible = isRunning;

        this._turnOnItem.visible = !isRunning;
        this._advancedItems.forEach(item => { item.visible = isRunning; });
        this._orientMenu.visible = (cam !== 'none');

        if (isRunning) {
            ['back', 'front', 'none'].forEach(k => {
                 this._sourceItems[k].setOrnament(cam === k ? PopupMenu.Ornament.DOT : PopupMenu.Ornament.NONE);
            });

            let orientRaw = getVal('Camera orientation').split(' ')[0];
            let isFlipped = orientRaw.startsWith('flip');
            let angle = orientRaw.replace('flip', '');
            if (!['0','90','180','270'].includes(angle)) angle = '0';

            this._currentAngle = angle;
            this._isFlipped = isFlipped;

            Object.keys(this._orientItems).forEach(k => {
                this._orientItems[k].setOrnament(k === angle ? PopupMenu.Ornament.DOT : PopupMenu.Ornament.NONE);
            });
            this._flipSwitch.setToggleState(isFlipped);

            this._monitorSwitch.setToggleState(monitor.includes('[ACTIVE]') || monitor.includes('[on]'));
            this._desktopSwitch.setToggleState(desktop.includes('[ACTIVE]') || desktop.includes('[on]'));
        }

        this._isSyncing = false;
    }
});

const ZenLinkIndicator = GObject.registerClass(
class ZenLinkIndicator extends QuickSettings.SystemIndicator {
    _init(extensionObject) {
        super._init();
        this._toggle = new ZenLinkToggle(extensionObject, this);
        this.quickSettingsItems = [this._toggle];
        this.visible = false;
    }
});

export default class ZenLinkExtension extends Extension {
    enable() {
        this._indicator = new ZenLinkIndicator(this);
        Main.panel.statusArea.quickSettings.addExternalIndicator(this._indicator);
    }

    disable() {
        this._indicator.quickSettingsItems.forEach(item => item.destroy());
        this._indicator.destroy();
        this._indicator = null;
    }
}