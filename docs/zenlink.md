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


Phone webcam capture uses the Android hardware H.264 encoder at up to 1280×720,
30 fps, with continuous Camera2 recording/auto-exposure. Video has a bounded
four-frame credit window and recovers dropped access units at keyframes. The
Android and desktop updates are required together. The legacy reverse PC-camera
preview remains JPEG-based.

The desktop decodes AVC once and publishes a native PipeWire `Video/Source`
(`ZenLink Phone`) for Snapshot and camera portals, alongside `/dev/video10` for
V4L2 clients. This avoids the V4L2 monitor caching `exclusive_caps` as output-only
before the producer starts. Raw preview bytes are framed independently of pipe
read boundaries, and encoded camera writes are queued/acknowledged only after
being written to the decoder. The package includes the PipeWire GStreamer plugin.


## Quest workspace / PCVR

ZenLink73 includes the native C++ backend and portal-free GNOME workspace bridge.
The existing ZenLink extension owns a systemd user socket; the native streaming
process starts for a receiver and exits when idle. No separate Quest Workspace
extension is required. ZenLink's **VR & Desktop** entry opens libadwaita preferences
for WiVRn/SteamVR runtime selection, runtime-specific startup apps and immersive
overlays within the existing PCVR stream.

The first integrated login archives and uninstalls the prototype Quest extension,
retires its host service and standalone launcher, and preserves private receiver
pairing/configuration. Changed GNOME extension code needs a new login. A private
user-service `PrivateTmp` sandbox must not be applied to the mapped-Mutter startup
guard: it prevents access to the compositor's proc metadata.

Verified PC-only: native package/CTest, inherited socket + TLS authenticated
WebSocket and idle exit, private setup idempotency, mock-systemd lifecycle and
migration/archive/pair preservation, packaged PC environment, settings entry and
libadwaita window offscreen. Live headset/PCVR acceptance remains pending; the
user requested no headset tests during this integration.


The catalog build uses its existing final-package recipe helper so workspace
checks resolve the same overridden Mutter as the running desktop. The legacy
upstream package set intentionally excludes overlay overrides and must not be
used to decide runtime capture compatibility. The integration check asserts that Mutter50.4 carries the tested touch-focus
guard and workspace support is enabled. Installation checks also match the
prepared guard library against the live compositor's mapped library.
