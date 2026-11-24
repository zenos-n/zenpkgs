# Rounded Window Corners Native

Opt-in alternative to Rounded Window Corners Reborn, packaged as
`io.github.ztrahmet.rounded-window-corners-native`.

```zcfg
desktops.gnome.extensions.rounded-window-corners-reborn.enable = false;
desktops.gnome.extensions.rounded-window-corners-native.enable = true;
```

The GNOME50 port enables sharp fractional-scale rendering by default. The module
also rounds libadwaita apps; both `sharp-windows` and `round-libadwaita-apps` are
configurable booleans. Other appearance choices follow upstream and can be
changed in the extension preferences. Do not enable both rounding extensions.

The package owns its external source pin and introduces no flake input or Mutter
replacement. Initial synthetic GNOME50.4 Wayland tests preserved interior text
and stripe pixels at100%,150%,200%, including resize/fullscreen/overview checks.
This does not establish every real app or mixed-monitor case. Fractional-scale
XWayland sharpness remains unverified due baseline fixture geometry issues.

Version51.1-gnome50.2 composes corners, outline and shadow before Compiz
deformations, preserving foreign timelines. Tested Compiz Windows31 and Magic
Lamp24 on GNOME50.4, including actual minimize/restore and a shifted-edge pixel
assertion. Sharp interior pixels remain unchanged after animations settle.
GNOME caches the extension module: updated code takes effect at the next login.
