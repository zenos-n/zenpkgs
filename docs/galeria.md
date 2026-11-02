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

Version 0.11.0 is a development preview. Real albums, metadata/semantic search,
collections, sharing, administration and video playback are implemented. The
editor still lacks saved image processing and AI parity; offline encrypted-vault browsing remains pending. HEIC
decoding is not advertised by the desktop launcher. Production Immich
acceptance still requires the user's server; development tests use loopback
fixtures and generated media.

Validation: 64 app tests; native collection/sharing, legacy-keyring migration,
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


Version0.9.1 moves the year rail into an overlay so it preserves full grid width.
Native overlay-indicator states restore the narrow resting thumb and expanded
hover/drag track. Year divisions hide at rest; the year hint follows actual cursor
coordinates, including dragging outside the track. Captured click/unpaired-release
gestures replace a nullable legacy GdkEvent path. A real private-XTest input check
verifies hover, dragging, outside release, popup movement, track collapse and
unchanged content width; existing53unit/grid/cache/refresh/Trash checks pass.

Version0.10 restores cached ordinary timeline metadata and the initial three
screens of thumbnail pixels before network/session validation. Expired snapshots
can display immediately; refresh keeps the same grid when dates are unchanged.
Cold accounts, evicted thumbnails and cleared caches still need network loading.
Locked media never enters this bootstrap. Native cold-process/warm-cache checks
verify pixels appear while authentication is deliberately blocked.

The account menu loads the real Immich profile photo and changes it via a native
image chooser. Sidebar folder-sync status reads real service activity/counts and
errors, including immediately after Sync now; the repeated username is removed.
Viewer Save As and bulk Download selected stream originals into user-chosen
locations with cancellation/atomic completion. Bulk name collisions get numbered
copies. Selection scopes to the current/selected month or all selected months.
The cursor-following year hint now uses non-targetable in-window widgets, avoiding
the separate native popup input surface that interrupted drags. A real-XTest
pointer regression crosses the actual hint while held. Playback submenu chevron
backgrounds are corrected.60unit tests and native cache/profile/export/sync,
10k-slot LOD, cache/refresh/Trash/stack checks pass; production accounts unchanged.

Version0.10.1 fixes update visibility while Galeria is on an unfocused secondary
display: visible libraries/albums refresh every15seconds regardless of keyboard
focus. Hidden windows and viewer/editing still pause refresh. Upload scanning
already repeats every30seconds by default; read-only diagnosis confirmed a clip
uploaded22seconds after creation. Validated startup resumes only already-enabled
account folder rules and updates their service runtime. Initial service install
no longer sends a wake signal before its handler is ready; the first scan starts
automatically.62unit tests plus native unfocused-update/cache/account tests pass.

Version0.10.2 hides successful idle sync status and closes the open popover;
only pending/active sync or errors retain the sidebar indicator. Background
scanning continues. Native checks verify10px bottom spacing during active work
and both popover/indicator dismissal on completion.

Version0.10.3 reduces resize work by retaining compact justified-row indices and
creating photo rectangles only around the viewport. Full-library heights remain
exact. In the same45,000-item private-Xvfb resize benchmark, measure p95 fell
from66.8ms to20.0/20.9ms and frame p95 from83.3ms to33.3ms in two repeats; max frame
interval fell117->50ms. This is not a physical-GPU or universal16.7ms guarantee.
63unit tests plus native full-height/LOD/date/priority/groups, cache/account/sync
and stack/Trash regressions pass. No renderer/system/monitor changes ship.

Version0.11 resolves cached textures before tier sprite planning, keeps logical
folder clipping through interrupted close/model rebuild, and skips obsolete
motion entries absent from both layouts instead of aborting GTK allocation.
Archive/unarchive and Trash/restore are available in selection and focused media.
Right-click Copy media and focused Ctrl+C offer native image/original-file
clipboard formats; private remote copies are replaced on the next copy/Clear
cache, while locked clipboard payloads/tempfiles clear on lock/sign-out/switch.

Video editing adds a two-handle trim range with an accent-selected span, numeric
endpoints, play/pause and a seekable playhead. Playback shows the original within
the selected interval; rendered5second Preview applies crop/rotation/filters and
Save a copy exports all edits.64unit tests and native interrupted-fold/RAM-tier,
clipboard/locked-cleanup/archive/trash, video play/seek/trim/export,10kLOD and
cache/account/sync regressions pass. No production media was modified by tests.
