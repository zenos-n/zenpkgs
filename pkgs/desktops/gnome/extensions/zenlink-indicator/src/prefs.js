import Adw from 'gi://Adw';
import Gio from 'gi://Gio';
import Gtk from 'gi://Gtk';
import {ExtensionPreferences, gettext as _} from 'resource:///org/gnome/Shell/Extensions/js/extensions/prefs.js';

export default class ZenLinkPrefs extends ExtensionPreferences {
    fillPreferencesWindow(window) {
        const page = new Adw.PreferencesPage();

        const groupConnect = new Adw.PreferencesGroup({
            title: _('Connection Management'),
            description: _('Connect to a new device or manage saved phones.')
        });

        // 1. New Connection
        const ipRow = new Adw.EntryRow({
            title: _('New Connection (IP)'),
            input_purpose: Gtk.InputPurpose.FREE_FORM
        });

        const connectBtn = new Gtk.Button({
            label: _('Connect & Save'),
            valign: Gtk.Align.CENTER
        });
        connectBtn.add_css_class('suggested-action');

        connectBtn.connect('clicked', () => {
            const ip = ipRow.get_text();
            if (ip) {
                // Connect (-i) AND Save (-A)
                this._runCommand(['zl-config', '-i', ip], connectBtn, _('Connect & Save'), true, ip);
            }
        });

        ipRow.add_suffix(connectBtn);
        groupConnect.add(ipRow);

        // 2. Saved List (Backend Driven)
        this._savedGroup = new Adw.ExpanderRow({
            title: _('Saved Phones'),
            subtitle: _('Loading...'),
            expanded: true
        });
        this._savedGroup.add_prefix(new Gtk.Image({ icon_name: 'phone-symbolic' }));
        groupConnect.add(this._savedGroup);

        this._refreshSavedList();

        const groupCam = new Adw.PreferencesGroup({
            title: _('Camera Defaults'),
            description: _('Set the default orientation for each camera lens.')
        });

        const orientations = ['0', '90', '180', '270', 'flip0', 'flip90', 'flip180', 'flip270'];
        const orientList = new Gtk.StringList({ strings: orientations });

        const frontRow = new Adw.ComboRow({ title: _('Default Front Orientation'), model: orientList });
        frontRow.set_selected(5); 
        frontRow.connect('notify::selected', () => {
             this._runSilentCommand(['zl-config', '-F', orientations[frontRow.get_selected()]]);
        });
        groupCam.add(frontRow);

        const backRow = new Adw.ComboRow({ title: _('Default Back Orientation'), model: orientList });
        backRow.set_selected(7);
        backRow.connect('notify::selected', () => {
             this._runSilentCommand(['zl-config', '-B', orientations[backRow.get_selected()]]);
        });
        groupCam.add(backRow);
        
        page.add(groupConnect);
        page.add(groupCam);
        window.add(page);
    }

    _refreshSavedList() {
        if (this._currentRows) {
            this._currentRows.forEach(row => this._savedGroup.remove(row));
        }
        this._currentRows = [];

        // ASYNC FETCH
        const proc = new Gio.Subprocess({
            argv: ['zl-config', '-L'],
            flags: Gio.SubprocessFlags.STDOUT_PIPE
        });
        proc.init(null);
        proc.communicate_utf8_async(null, null, (proc, res) => {
            try {
                const [, stdout] = proc.communicate_utf8_finish(res);
                const savedIps = stdout ? stdout.split('\n').filter(l => l.trim() !== '') : [];

                savedIps.forEach(ip => {
                    const row = new Adw.ActionRow({ title: ip });
                    
                    const connBtn = new Gtk.Button({
                        icon_name: 'network-transmit-receive-symbolic',
                        valign: Gtk.Align.CENTER,
                        tooltip_text: _('Connect')
                    });
                    connBtn.add_css_class('flat');
                    connBtn.connect('clicked', () => {
                        this._runCommand(['zl-config', '-i', ip], connBtn, null);
                    });
                    row.add_suffix(connBtn);

                    const delBtn = new Gtk.Button({
                        icon_name: 'user-trash-symbolic',
                        valign: Gtk.Align.CENTER,
                        tooltip_text: _('Remove')
                    });
                    delBtn.add_css_class('flat');
                    delBtn.add_css_class('destructive-action');
                    delBtn.connect('clicked', () => {
                        // Remove via Backend
                        this._runSilentCommand(['zl-config', '-R', ip]);
                        // Refresh UI after short delay
                        setTimeout(() => this._refreshSavedList(), 500); 
                    });
                    row.add_suffix(delBtn);

                    this._savedGroup.add_row(row);
                    this._currentRows.push(row);
                });
                
                this._savedGroup.set_subtitle(_(`${savedIps.length} phone(s) saved`));

            } catch (e) {
                console.error(e);
            }
        });
    }

    _runCommand(argv, button, defaultLabel, saveIp, ipStr) {
        button.set_sensitive(false);
        try {
            const proc = new Gio.Subprocess({ argv: argv, flags: Gio.SubprocessFlags.NONE });
            proc.init(null);
            proc.wait_check_async(null, (proc, res) => {
                try {
                    proc.wait_check_finish(res);
                    if (!button.icon_name) button.set_label(_('Success!'));
                    
                    if (saveIp && ipStr) {
                        this._runSilentCommand(['zl-config', '-A', ipStr]);
                        setTimeout(() => this._refreshSavedList(), 500);
                    }
                } catch (e) {
                    if (!button.icon_name) button.set_label(_('Failed'));
                }
                setTimeout(() => {
                    if (defaultLabel) button.set_label(defaultLabel);
                    button.set_sensitive(true);
                }, 1500);
            });
        } catch (e) { button.set_sensitive(true); }
    }

    _runSilentCommand(argv) {
        try {
            const proc = new Gio.Subprocess({ argv: argv, flags: Gio.SubprocessFlags.NONE });
            proc.init(null);
        } catch (e) { console.error(e); }
    }
}