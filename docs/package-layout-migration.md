# Package layout migration — 2026-09-22

The table below records filesystem category moves (paths relative to `pkgs/`,
without `.zpkg`). Under the current two-view contract these paths are selectors
below `pkgs.byCategories`, not canonical IDs. Canonical `pkgs.<reverse DNS>`
comes from required `_meta.id` and survives category moves. Both views resolve
to the same derivation; no old root category aliases are exported. Preserve
established upstream IDs and project-owned `com.neg-zero` IDs. For a third-party
package without a verified upstream ID, use `unknown.<normalized leaf package
name>` without category segments.
`pkgs.legacy` and module paths under `programs` are unchanged. See
[metadata guidelines](metadata-guidelines.md).

GNOME extension packages now live under `desktops/gnome/extensions`,
`apps/themes/adw-gtk3` is `theming/apps/adw-gtk3`, and
`apps/cursors/google-dot` is `theming/cursors/google-dot`. Extension modules,
OOBE, Setup, and the live ISO must use canonical IDs or the corresponding `pkgs.byCategories` selectors.

| Previous path | New path |
| --- | --- |
| apps/advanced/bitwarden | apps/security/bitwarden |
| apps/advanced/keepassxc | apps/security/keepassxc |
| apps/advanced/nmap | apps/networking/nmap |
| apps/advanced/wireshark | apps/networking/wireshark |
| apps/advanced/cockpit | apps/system/administration/cockpit |
| apps/advanced/gparted | apps/storage/gparted |
| apps/advanced/virt-manager | apps/virtualization/virt-manager |
| apps/advanced/podman-desktop | apps/containers/podman-desktop |
| apps/utilities/mission-center | apps/system/monitoring/mission-center |
| apps/utilities/resources | apps/system/monitoring/resources |
| apps/utilities/gnome-boxes | apps/virtualization/gnome-boxes |
| apps/utilities/impression | apps/storage/impression |
| apps/utilities/pika-backup | apps/backup/pika-backup |
| apps/utilities/cipher | apps/security/cipher |
| apps/utilities/metadata-cleaner | apps/security/metadata-cleaner |
| apps/utilities/curtail | apps/graphics/curtail |
| apps/utilities/file-roller | apps/archives/file-roller |
| programs/zenos-rebuild | apps/system/zenos/zenos-rebuild |
| programs/swisstag (compatibility recipe) | apps/audio/swisstag |
| system/zenos-setup | apps/system/zenos-setup |

Setup uses canonical ID `com.neg-zero.zenos-setup`, independently of its
category path. The corresponding selectors are `pkgs.com.neg-zero.zenos-setup`
and `pkgs.byCategories.apps.system.zenos-setup`.

Swisstag was also exposed by the internal compatibility recipe loader. Its
recipe moved from `lib/compat/package-recipes/programs/swisstag` to
`lib/compat/package-recipes/apps/audio/swisstag`, so the evaluated package tree
no longer exposes a `programs` branch. This is a compatibility recipe move, not
an additional ZPKG declaration.
The obsolete empty compatibility `programs/swisstag`, `programs/zenos-rebuild`,
and `programs` directories were removed after checking their contents; these
empty directories can be recreated.

Initial additions: GIMP and Inkscape in `apps/graphics`, VLC and mpv in
`apps/multimedia`, Audacity in `apps/audio`, OBS Studio in `apps/video`, and
Signal Desktop and Telegram Desktop in `apps/communication`.
Versions and licenses were checked against pinned Nixpkgs. The DSL currently
rejects lists in `_meta.license`; mpv, Audacity, OBS Studio and Signal therefore
omit that field rather than misrepresent their multiple upstream licenses.
Their imported recipes retain upstream metadata; registry license fields remain
unknown and emit warnings.

## Empty package directories remaining

Snapshot after this migration, relative to the repository root:

```text
pkgs/desktops/gnome/extensions/dash-stacks
pkgs/desktops/gnome/extensions/forge
pkgs/desktops/gnome/extensions/zenlink-indicator
pkgs/desktops/gnome/tweaks/zero-gnome-clock
pkgs/system/zenboot
pkgs/system/zenclean
pkgs/system/zenfs
pkgs/system/zenlink
pkgs/theming/fonts/zero-font
pkgs/theming/fonts/zero/mono
pkgs/theming/fonts/zero/mono-thin
pkgs/theming/fonts/zero/regular
pkgs/theming/icons/adwaita-hacks
pkgs/theming/icons/zenos-icons
pkgs/theming/system/fastfetch
pkgs/theming/system/zenos-plymouth
pkgs/theming/system/zenos-refind-theme
pkgs/theming/wallpapers/destination-2
```

Removed only the empty `pkgs/apps/advanced`, `pkgs/apps/utilities`,
`pkgs/programs/swisstag`, `pkgs/programs/zenos-rebuild`, and `pkgs/programs`
directories. No package content was deleted; empty directories can be recreated.

## Other empty source directories

The wider source-tree inventory also found these 16 empty directories outside
`pkgs/`. They were left untouched; the migration only removed the retired empty
package roots and their obsolete compatibility counterparts.

```text
modules/desktops/gnome/base
modules/desktops/gnome/tweaks/blackbox-settings
modules/desktops/gnome/tweaks/firefox-theming
modules/desktops/gnome/tweaks/zenos-extensions
modules/desktops/gnome/tweaks/zenos-fonts
modules/desktops/gnome/tweaks/zero-clock
modules/desktops/ii
modules/zenboot
modules/zenfs
modules/zenos-maintenance
modules/zenos-plymouth
modules/users/programs/web-apps/backends
lib/compat/package-recipes/system/zenfs
lib/compat/package-recipes/theming/system/zenos-plymouth
lib/compat/package-recipes/theming/system/zenos-refind-theme
tests/zen-dsl/zenlang/shared
```
