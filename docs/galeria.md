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

Version 0.9.0 is a development preview. Real albums, metadata/semantic search,
collections, sharing, administration and video playback are implemented. The
editor still lacks saved image processing and AI parity; offline encrypted-vault browsing and viewer downloads remain pending. HEIC
decoding is not advertised by the desktop launcher. Production Immich
acceptance still requires the user's server; development tests use loopback
fixtures and generated media.

Validation: 53 app tests; native collection/sharing, legacy-keyring migration,
and desktop file-open checks; package/module DSL checks and exact pinned-source
package build. No installed configuration or production account was changed.

Galeria includes a native interactive Shumate map using the server's configured
style, with OpenStreetMap fallback and clustered photo markers. Immich 3.3.3
metadata searches use opaque cursors; semantic search retains numeric paging.
Library/album/Trash/search paging was also checked read-only against Immich 3.3.3.

`startAtLogin = null` (default) preserves the app's writable Startup preference.
Set true to manage a desktop login launcher using `galeria --background`, or
false to manage a disabled launcher. This option does not enable uploads.
Preferences also offers Keep running in the background; Ctrl+Q or Quit exits.

The optional package `pkgs.com.neg-zero.galeria-extension` provides the GNOME 50
Quick Settings helper (UUID `galeria@neg-zero`). Install it and enable that UUID
through the normal GNOME extensions configuration. It does not enable itself.
The helper provides Open, Folder sync, Sync now, keep-running and Quit controls;
only status and control messages cross the session bus, never account secrets.
Its independent source is https://github.com/zenos-n/galeria-gnome-extension.

The app repository also has a locked Nix flake: `nix run`, `nix build` and
`nix develop`, for x86_64-linux and aarch64-linux. Both system outputs evaluate;
the x86_64-linux package and development shell were built locally. The helper
was built and its JavaScript syntax and D-Bus contract checked; live GNOME Shell
activation has not been exercised.

Version0.7 adds original-preserving video trim/crop/quarter-turn rotation and
Original/Vivid/Warm/Cool/Mono/Noir filters, encoded five-second preview and
cancellable H.264/AAC MP4 save-copy export. Remote edits use originals through
the authenticated range bridge, without exposing session tokens to FFmpeg.
The image editor's saved processing and AI parity remain unfinished.

The supplied app icon is now packaged. Video buffering uses one transparent
Adwaita spinner; Clapper's duplicate dot animation is hidden. Map photo markers
stay56x56 after texture load. Grid results/date covers/collection textures have
bounded RAM caches; visible active views poll remote changes every15seconds.
Cached views stay visible during refresh; failed refresh preserves cached media.
Date tiers close stacks and animate actual image IDs into cover quadrants.
Successful batch Trash flies thumbnails to the sidebar, then closes grid gaps
without a network reload. Native tests cover these flows and actual video export;
FFmpeg8.1.2 and packaged9.0.1 both pass the video export checks. Native GNOME
helper activation remains untested; no system configuration activation occurred.

Version0.8 uses the compact Immich3.3.3 timeline endpoint for IDs/ratios/types
before fetching images. The unfiltered Library has its entire placeholder scroll
range immediately; exact sizes arrive with compact month metadata. Native button,
image and checkbox children exist only in the two-screen viewport band. Filtered
views/legacy servers retain pagination. The native10000-slot fixture used90live
button trees after an old-date jump; metadata/image jobs prioritise the viewport.
The typical1200-image tier allocation pass is~1.2ms in softwareGL; outliers remain.
Month/year transitions group all visible photos under the containing date, keep
the current date in view, and use the final cover geometry without padded-size
inflation. Empty video thumbnails use preview/frame fallback, never whole-video
image decoding or repeated error toasts. The main header is46px.

Folder sync has explicit Unlimited depth and Folders to albums switches. Album
mode can create one album per directory or use a single named/existing target.
Per-directory names include the relative path; originals/deletions are untouched.
Batch selection supports moving to the locked folder with elevation and ordinary
cache/in-flight-write invalidation. Album sidebar hover restores actual selection.
`galeria --monitor DP-2` chooses a connector on initial launch without reconfiguring
monitors or manipulating other windows. Both native UI and49unit checks pass.


Version0.8.1 fixes a live performance regression: cache writes use an eviction
index, hover/selection touch active cells, and row geometry is cached per month.
The grid keeps full month heights but constructs rectangles/native child trees
only near the viewport. Group transitions use visible photos rather than
constructing sprites for the whole library. Select All still reaches loaded
matching media outside the viewport. Fifty unit tests and offline native checks
pass. Two read-only44,854-item Vulkan traces measured tier p95 around17ms and
scroll p9517–33ms; first-layout outliers remain. See upstream PERF.md for the
method, renderer experiment, cache benchmark and limits.


Version0.9 adds a native year-weighted scrollbar in the indexed All Photos view.
Each year gets equal track space; scrolling inside it remains proportional.
Native thumb/direction/keyboard behavior is retained, with small year divisions.
The year hint stays hidden until hover or dragging. Stale thumbnail jobs are
retired in a batch instead of repeated full-queue priority scans. Two fresh-cache
3,600-step read-only44,855-item scrolling runs in the actual catalog runtime
(Python3.13.15, GTK4.22.4) had frame p9517/30ms and max149/134ms, with no reproduced
multi-second pause. Initial model construction still has an approximately0.7s
pause. All53unit tests and native rail direction/hint/LOD/refresh/Trash checks
pass. No allocation-skip, renderer, scheduler or system changes ship.
