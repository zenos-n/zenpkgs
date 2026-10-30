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
};
```

The user service captures once into a RAM replay buffer. The record shortcut
sends SIGRTMIN to that service's main process to toggle regular recording;
the clip shortcut sends SIGUSR1 to save the replay. Other recorder processes
are not signalled. The service starts at login only with `autoStart`; stop it
with `systemctl --user stop zenos-screen-recorder`.

Defaults: 60fps, GPU H.264, AAC, system-output audio (no microphone), captures
`screen`, saves clips to `%h/Videos/Clips` and recordings to
`%h/Videos/Recordings`. Directories are created before capture. `monitor` and
`audioDevice` accept GPU Screen Recorder source names. Output-directory options
accept systemd user specifiers such as `%h`. The GUI is installed as well;
its manually configured sessions are independent of this replay service.

Personal shortcuts and autostart apply only to the selected user. Existing
shared shortcut paths declared in `legacy.programs.dconf.profiles.user.databases`
are retained when adding the personal shortcuts. Other user-scoped bindings
retain normal Home Manager list merging. Both shortcuts can be left empty to
avoid writing GNOME bindings.

The implementation uses the maintained nixpkgs CLI/GTK packages; no custom
recorder binary or extra installed-flake input is required. The native module
check evaluates KMS setup, replay/recording arguments, signals, preservation of
existing shortcuts, and isolation from a second user.
