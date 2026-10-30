# GPU Screen Recorder

Enable `system.programs.gpu-screen-recorder.systemSupport = true` on the host
for the standard NixOS KMS helper. Then configure the desired user:

```zcfg
users.alex.programs.gpu-screen-recorder = {
  enable = true;
  autoStart = true;
  replaySeconds = 30;
  recordShortcut = "<Shift><Super>q";
  clipShortcut = "<Shift><Super>w";
  hudShortcut = "<Shift><Super>g";
};
```

The user service runs the official NVIDIA/ShadowPlay-style `gsr-ui` overlay.
It owns a single recorder and RAM replay buffer. GNOME shortcuts use its
`gsr-ui-cli` RPC interface to toggle recording, save a clip, or toggle the HUD.
Recording can run inside the replay session, keeping clipping available.
The old GTK frontend remains separately available but is not installed by this
module. Low-level keyboard and joystick grabbing are disabled; no privileged
keyboard helper is installed. Empty shortcut options emit no GNOME binding.

With `autoStart`, the overlay and replay buffer start with the graphical session.
Otherwise start `systemctl --user start zenos-screen-recorder`, then enable
replay from the HUD. Stop everything with
`systemctl --user stop zenos-screen-recorder`.

Defaults: 60fps, GPU H.264, AAC, system-output audio (no microphone), source
`screen`, clips under `%h/Videos/Clips`, recordings under `%h/Videos/Recordings`.
Directories may be absolute or start with `%h` for the user's home. Preferences
are merged into writable `$XDG_CONFIG_HOME/gpu-screen-recorder/config_ui` during
activation, preserving unselected UI settings with a private backup. Restart
the service after changing declared preferences. The HUD can still edit other
preferences normally. GNOME Wayland uses the upstream XWayland overlay.

Personal shortcuts and autostart apply only to the selected user. Existing
shared shortcuts in `legacy.programs.dconf.profiles.user.databases` are retained,
as are other user-scoped shortcut lists.

The CLI comes from Nixpkgs. UI/notification source comes from dec05eba's official
repositories, built with the external
[gsr-ui-nix recipes](https://github.com/rPlakama/gsr-ui-nix) and ZenPkgs' dependency
set. The installed ZenOS flake still imports only ZenPkgs. Module checks cover
KMS setup, overlay ownership, RPC commands, existing shortcuts and user isolation;
writable-file checks cover JSON merging and home-directory expansion.
