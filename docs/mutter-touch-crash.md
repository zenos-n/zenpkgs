# Mutter 50.4 touchscreen grab crash

Mutter 50.4 can dereference an empty touch focus surface while handling a
Wayland client's window move, resize, or activation request. A real session
crash on 2026-11-05 had this stack:

```
touch_can_grab_surface
meta_wayland_touch_find_grab_sequence
meta_wayland_seat_get_grab_info
xdg_toplevel_move
```

The ZenPkgs overlay backports upstream commit
[13ed6cae](https://gitlab.gnome.org/GNOME/mutter/-/commit/13ed6caed4580d6d1ee8812a4d180ea8b5035ddc)
([MR5375](https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/5375)). The change
rejects the grab if its touch focus is empty. Attribution and the upstream
GPL-2.0-or-later implementation stay with Mutter; the recipe downloads the
immutable, hash-checked upstream patch rather than vendoring package code.

This backport applies only to the exact 50.4 source version tested. Review
upstream status when changing Mutter versions. The existing desktop session
keeps its old loaded library after a system update: a new GNOME session is
required to load the fix. Do not restart a user's compositor automatically.

Verified so far: the patched package builds, and a disposable process calling
its actual compiled private function rejects empty focus and accepts matching
focus. The original crash core proves the failing call path; no deliberate
crash/reproduction was attempted inside the live desktop. A live touchscreen
regression still requires starting a session with the patched compositor.
