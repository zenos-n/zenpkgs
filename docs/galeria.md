# Galeria

Native GTK4/libadwaita photo and video library, application ID
`com.neg-zero.Galeria`. Source and assets live in the separate
[Galeria repository](https://github.com/zenos-n/galeria); ZenPkgs pins its source
and calls the upstream Nix build.

Package: `pkgs.com.neg-zero.Galeria`, with category alias
`pkgs.byCategories.apps.graphics.galeria`. Executables: `galeria` and
`galeria-sync`. The package includes its desktop entry, icon and AppStream data.

Run the published package directly (the canonical ID has a capital `G`):

```sh
nix run github:zenos-n/zenpkgs/main#com.neg-zero.Galeria
```

The lowercase category selector `#apps.graphics.galeria` selects the same package.

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

Version 0.14.0 is a development preview. Real albums, metadata/semantic search,
collections, sharing, administration and video playback are implemented. Advanced AI editing and offline encrypted-vault browsing remain pending. HEIC
decoding is not advertised by the desktop launcher. Production Immich
acceptance still requires the user's server; development tests use loopback
fixtures and generated media.

Validation: 70 app tests; native collection/sharing, legacy-keyring migration,
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
Advanced AI editing remains unfinished.

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

Version0.11.1 keeps all structural date-card starting rects during folder motion,
so offscreen rows slide into place rather than jumping. The reveal gap collapses
with the panel; native photo children remain bounded. Tier captions retain
natural size and paint above sprites while only cover pictures are hidden.
Interrupted captions fade out. Native18k-photo/120-card frame checks and inspected
opening/closing/tier snapshots cover the intermediate states.

Album cards have one hover background. Owned album menus include Delete album…
with confirmation; the album endpoint is used, never media deletion. Caches,
sidebar and pins refresh after success, including an empty cached album list.
65unit tests and private-XTest hover/delete/cancel,10kLOD and existing motion/cache/
media-action tests pass. No production album was deleted during verification.


Version0.11.2 adds Pin album/Unpin album to ellipsis and right-click menus,
including sidebar albums. Pins persist per account; the empty pinned section is
hidden. Collections uses the same label-to-row spacing as other sidebar groups.

Remote upload arrivals keep populated months visible while new metadata loads.
Complete changes animate into the existing geometry with cached textures,
selection and the scroll anchor retained. Visible incoming thumbnails prepare
before insertion (at most24), within the768-texture RAM limit. Failed refreshes
keep the current photos and retry on the next15-second check.65unit tests and
native pointer/pin/spacing, blocked-response insertion, bottom scroll anchor,
failure/retry, album deletion, group frames and startup/cache checks pass.


Version0.11.3 isolates video preloads in a128MB cache, preserving512MB for
ordinary image/metadata data; old video packets migrate without deleting
thumbnails. Two cached-read workers bypass blocked network image workers.
Initial month metadata fills existing cells in place; deferred restoration yields
to newer scroll input and a held year scrollbar. Native checks hold all four
HTTP workers while cached pixels appear and verify no month-hydration scroll reset.

Copy media prefers image pixels, with a rendered-preview fallback for originals
that cannot be decoded locally; the original file remains available to file
consumers. Actual right clicks and an independent clipboard reader pass on X11
and nested Wayland. Shift+D downloads the current expanded media or selection
through the chosen-location picker. Photo editing now exposes only Crop, Adjust
and Markup; Contrast has one background, and the hamburger has no Quit item.
66unit tests plus cache/scroll, clipboard/editor/shortcuts, pins, startup/export,
media-action, year-rail and10kLOD native checks passed for that release.
Photo processing is connected in0.12.0 below; video editing remains separate.


Version0.11.4 fixes a reconnect race that could leave All Photos permanently
showing placeholders: three old-index metadata requests kept all pending slots
after a changed date catalog replaced the index. Replace the pending set with
the index, retain populated cached months while changed counts reload, and mark
those ranges for fresh metadata until it is applied. A gated native regression
holds three old requests across reconnect and verifies cached pixels remain,
new data arrives and the pending queue clears. Live-library verification reached
all144months loaded, zero placeholders and179 active cached textures.66unit and
startup/cache/insertion/10kLOD native checks pass; no production media mutation.


Version0.12.0 connects all16 photo adjustment controls to distinct processing,
retains per-tool values and snaps pointer drags to neutral while preserving
fine keyboard steps. Pen, highlighter, opaque redaction and placed text support
real on-photo input, color selection and Undo. Compare/Reset operate on pixels;
chosen-path PNG copies apply adjustments, markup, crop, rotation, mirror and
straighten without replacing originals. An unsupported remote original falls
back to the server preview and explicitly reports the resolution fallback.
Preview renders coalesce in a worker with1200px maximum dimensions.

The header date follows viewport content; the small inline month label hands
off to an animated header only after scrolling away, avoiding duplicate dates.
69unit tests and native real-pointer drawing/export/date-handoff checks pass,
along with existing clipboard, video-edit/playback/export, media-action,
startup/account/download and reconnect-index regressions. Original byte
preservation and preview-resolution fallback are covered with generated media.


Version0.12.1 replaces the disconnected month/header reveal with one shared
glyph run. Slow scrolling moves it1:1 from the exact source position to the
header, reversing continuously; fast skips use a short vertical exchange
clipped inside the header. Original headings are suppressed while the overlay
owns their text. Native coordinate and screenshot checks cover both paths.

Moving assets to Locked preserves unrelated RAM textures and known ordinary
disk thumbnails/previews/video prefixes. All moved revisions, stale metadata
and affected covers are removed; pre-move cache writes are blocked. A480-item
indexed fixture moves two assets with zero blank active cells, no downloads
and unchanged scroll position, while checking privacy cleanup and original bytes.
The upload indicator appears only while transferring files or for attention
errors; folder scans, hashing and duplicate checks stay quiet. Existing SHA-1
preflight checks skip downloaded originals already present on Immich.70unit
checks plus native date, Locked retention, photo/editor, startup/status,
reconnect, selection/motion and pins/insertion checks pass.


Version0.12.2 makes fast header exchanges direction-aware: upward scrolling
exits downward and enters from above. The newest library month appears only
in the header; its duplicate inline label and reserved space are removed.
Older headings retain their shared vertical path. Explicit left alignment,
matching content/header insets and constant overlay X prevent title-length
and transition padding shifts. A native fixture checks opposite up/down
coordinates, newest-heading omission, exact source/reverse positions, and
matching left edges across long/short dates and the Months year label.
70unit checks and native photo, startup/status, Locked retention, pins/insertion
and selection/motion regressions pass; screenshots were inspected.


Version0.13.0 connects file/folder drag-and-drop to real reviewed Immich uploads,
with checksum duplicate checks, cancellation and unchanged source files. Gio
directory notifications wake folder sync after a250ms debounce, following
recursive/depth rules and new directories. Stable-file checks remain; pending
files retry after2.2seconds, errors after30seconds and a600second recovery pass
covers missed/unavailable notifications. Scans/hash/duplicate checks stay quiet.

Photo Save a copy uploads PNG bytes directly to Immich from memory, with locked
visibility at creation for private sources. Both editors support bounded Undo/Redo
history and Ctrl+Z/Ctrl+Shift+Z/Ctrl+Y. Photo text uses inline on-image typing and
move/rotate/scale handles; the selected color has a visible ring. Focused media
has working Favorite, Archive, Trash and Locked actions. Space controls video
playback without leaving focus; Replay and Loop are available. Wheel/pinch zoom
spans1–8x with bounded drag panning/reset, transforming the existing player.

Image Copy supplies pixels only, without FileList/URI/private paths. Videos have
no Copy action; right-click Share is available for both. Removal animations fly
into the invoked toolbar icon in selection and viewer modes. Locked moves retain
visible pixels even after LRU eviction; metadata-only updates retain native
cells/textures. The year-scroll hint has an explicit popover background.

78unit checks and native real cross-window drop/multipart upload, image clipboard
receiver/context Share, action-target, viewer/video controls, text transform/history,
in-memory private PNG upload and Locked retention checks pass, plus existing
startup/cache/scroll/group/date/reconnect regressions. Pinch callbacks were
simulated; physical touchpad/touch and production-server mutations were not tested.
No new frame-time improvement is claimed.


Version0.13.1 starts selection-grid reflow immediately after capturing the removal
flight snapshots. Remaining tiles move concurrently with Trash, Archive and
Locked flights; the toolbar stays visible until the snapshots reach its icon.
Native checks verify intermediate tile positions while all three flights are
active, empty-grid/reduced-motion completion, viewer targets and failed-request
retention. The Locked cache/privacy/scroll regression also passes.


Version0.14.0 adds Save/Cancel/Discard for unsaved photo/video edits when using
Done, Back/Escape, changing media, closing the window or quitting. Save uses the
existing photo-to-Immich/video-save-copy flow and resumes the requested action
only after success; failed uploads/exports and cancelled choosers retain edits.
Cancel keeps editing; Discard restores the last saved snapshot. Clean or already
saved state leaves directly, independently of Undo history limits.

Text annotations use shared Pango/Cairo glyph outlines across live photo-edit
categories and final-resolution PNG rendering. Scaling text no longer enlarges
a small glyph bitmap. The saved photo remains PNG. Rotation has6degree detents
around every90degrees, with free rotation between them. Private cleanup clears
the saved edit snapshot and glyph cache with the rest of the editor state.

80unit checks pass, plus native photo/text rotation, full Save/Cancel/Discard
photo/video decisions, save failures/chooser cancellation/close/quit guards,
video edit/export, image clipboard and selection-action regressions. Generated
media/fixture uploads and real local video exports preserve original bytes.
Large-text/prompt screenshots inspected; no production media changed for tests.
Exact added text runtime: Pango1.57.1/Cairo1.18.4.
