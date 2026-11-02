# Galeria

Native GTK4/libadwaita photo and video library, application ID
`com.neg-zero.Galeria`. Source and assets live in the separate
[Galeria repository](https://github.com/zenos-n/galeria); ZenPkgs pins its source
and calls the upstream Nix build.

Package: `pkgs.com.neg-zero.Galeria`, with category alias
`pkgs.byCategories.apps.graphics.galeria`. Executables: `galeria` and
`galeria-sync`. The package includes its desktop entry, icon and AppStream data.

Enable it in the normal program tree:

```nix
users.alice.programs.galeria = {
  enable = true;
  defaultViewer = false;
};
```

`system.programs.galeria` supplies the corresponding managed-user defaults.
`package` can select another compatible derivation. `defaultViewer` defaults to
false; enabling it associates the supported image/video MIME types with
`com.neg-zero.Galeria.desktop`. Opening a single device file focuses it in the
viewer. No MIME defaults change when the option is false.

The module installs the package and optional associations. It does not declare
accounts, tokens, libraries, preferences or sync rules. These remain writable
and managed by the app. Passwords/session tokens and encrypted-cache keys use
the system Secret Service. Legacy `gallery` data directories and the existing
folder-sync service name are retained so the rename preserves current data.

Folder sync is opt-in inside the app: device folders upload to Immich, with
subfolder inclusion/depth and album destination controls. It never edits
originals or mirrors deletions. Enabling it installs an app-owned user service;
the service keeps its selected runtime alive independently of the UI. Disable
Background uploads in Galeria to stop it. The program module never starts it
or supplies credentials.

Version 0.5.0 is a development preview. Real albums, metadata/semantic search,
collections, sharing, administration and video playback are implemented. The
editor still lacks saved image processing and AI parity; graphical maps,
offline encrypted-vault browsing and viewer downloads remain pending. HEIC
decoding is not advertised by the desktop launcher. Production Immich
acceptance still requires the user's server; development tests use loopback
fixtures and generated media.

Validation: 33 app tests; native collection/sharing, legacy-keyring migration,
and desktop file-open checks; package/module DSL checks and exact pinned-source
package build. No installed configuration or production account was changed.
