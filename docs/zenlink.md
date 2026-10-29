# ZenLink

ZenLink replaces the former ADB/Termux bridge with a native KDE Connect Android
fork and a GSConnect-based GNOME desktop service. Both desktop package selectors
`system.zenlink` and `desktops.gnome.extensions.zenlink-indicator` resolve to the
same derivation. Existing package IDs are retained.

Enable the system capability in ZCFG:

```zcfg
system.programs.zenlink.enable = true;
```

The existing `desktops.gnome.extensions.zenlink-indicator.enable` selector also
enables this capability. The module installs the desktop package, enables
`zenlink@zenos-n.github.io`, disables `gsconnect@andyholmes.github.io`, and creates
the `zenlink.service` user unit and `org.zenos.ZenLink` D-Bus activation file.
`autoStart = false` leaves on-demand activation available without starting the
service at login. Per-user `users.<name>.programs.zenlink` preferences can override
the system's session defaults; host webcam/firewall setup requires the system
capability.

The host uses the selected kernel's v4l2loopback package, `/dev/video10` named
`ZenLink Phone`, exclusive capabilities, and an active-user udev access rule.
TCP and UDP ports 1716–1764 are opened for local-network discovery and transfer.
The desktop service creates dedicated ZenLink playback and microphone devices
through PulseAudio/PipeWire-Pulse. Its wrapped GStreamer runtime includes the
base, good and bad plugin sets.

Pair using the native ZenLink Android app (`org.zenos.zenlink`, or
`org.zenos.zenlink.debug` for development). Streaming settings live on the phone:
phone microphone and camera feed the PC, and PC playback feeds the phone by
default. Camera and microphone selection can change during streaming. Pairing,
certificates and media preferences remain writable at runtime. Existing
GSConnect/KDE Connect data is preserved separately.

The desktop source is pinned by the `source-zenlink` flake input to an immutable
revision of [zenos-n/zenlink-gnome](https://github.com/zenos-n/zenlink-gnome).
The Android companion is published at
[zenos-n/zenlink-android](https://github.com/zenos-n/zenlink-android); its local
checkout and APK build live in `~/Projects/ZenLink/app`. Desktop activation does
not install anything on a phone.

Run `nix build .#checks.x86_64-linux.zenlink-integration` to build the desktop
package, validate both selectors, evaluate the real NixOS/Home Manager graph,
check startup/disabled/manual behavior and kernel matching, and run the media
protocol tests. This check never connects to a phone or activates the host.
