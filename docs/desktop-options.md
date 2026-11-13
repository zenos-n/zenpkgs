# Desktop options

The desktop catalog adds **416 options**: 104 system settings, 197 GNOME
preferences, and 115 program settings (including enable switches).

System settings default to `null`: keep the existing system policy. Set `true`
or `false` to explicitly enable or disable a capability. Required companion
services remain separate choices. For example, network printer discovery uses
Avahi, and running AppImages directly also requires AppImage support.

GNOME preferences apply when `desktops.gnome.enable` is true. They are editable
system defaults; a user's saved GNOME settings take precedence. Existing ZenOS
preferences are preserved. Newly exposed preferences use GNOME schema defaults. Wallpaper image URIs
default to `null`, retaining the distribution wallpaper.

Program modules work at `system.programs.<program>` (all managed users) and
`users.<name>.programs.<program>` (one user). Enable the module to install the
application and apply its preferences. User configuration overrides system
program defaults through the existing mounting rules. Declare each managed
user in the ZenOS `users` tree; `users.bob = {};` opts an account defined
elsewhere into system program defaults.

```zcfg
system.networking.computerName = "my-laptop";
system.locale.timeZone = "Europe/Warsaw";
system.bluetooth = { enable = true; powerOnAtBoot = false; };
system.printing.enable = true;
system.hardware.firmwareUpdates = true;
system.power.profiles = true;

desktops.gnome = {
  enable = true;
  showBatteryPercentage = true;
  touchpad = { tapToClick = true; naturalScrolling = true; };
  nightLight = { enable = true; temperature = 4000; };
  workspaces = { dynamic = false; count = 4; };
  privacy.rememberRecentFiles = false;
};

users.alex.programs.nautilus = {
  enable = true;
  singleClickOpen = true;
};
users.alex.programs.gnome-text-editor = {
  enable = true;
  indentWithSpaces = true;
  tabWidth = 4;
};
```

System groups: `networking`, `locale`, `audio`, `bluetooth`, `printing`,
`hardware`, `power`, `security`, `packaging`, `storage`, `fonts`, and `sharing`.

GNOME groups cover appearance, fonts, clock, notifications, privacy, locking,
mouse, touchpad, keyboard, windows, workspaces, accessibility, sound, removable
media, wallpaper, Night Light, and idle power behavior. Explicit service choices override GNOME automatic enables. Disabling Flatpak
also stops its ZenFS policy services and export integration. Numeric settings retain
GVariant types and schema ranges. Names state units where useful.

Programs: `nautilus`, `gnome-text-editor`, `gnome-console`, `gnome-calculator`,
`gnome-calendar`, and `gnome-clocks`. For example,
`singleClickOpen` translates to Files' click policy, while `indentWithSpaces`
translates to Text Editor's indentation style. These are user decisions rather
than backend key names.

Printer sharing listens on the network and permits local-network clients;
`printing.allowNetworkAccess` separately controls firewall access. Enabling
fingerprint support needs compatible hardware. Power-profile control can
conflict with an independently configured power manager such as TLP. Fixed
workspace counts require `workspaces.dynamic = false`.

The complete normative mapping is in
[`desktop-options.md`](../../zenos-n-next/design/desktop-options.md).

Verification: run `nix build --no-link path:.#checks.x86_64-linux.desktop-options-vm`.
The test boots ZenOS and checks actual system services, dconf defaults, user
program overrides, mutable GNOME preferences, and all 126 new desktop/program
key mappings against the pinned GSettings schemas. It also evaluates explicit
disable policies against the real pinned backend modules inside the VM. Hardware behavior still
requires the corresponding physical devices.

Additional system choices cover font fallback families and rendering under
`system.fonts`, separate number/date/currency/paper/measurement/sorting locales
under `system.locale`, Wi-Fi scanning privacy and connection device identities
under `system.networking`, keyring/SSH-agent/smart-card services under
`system.security`, color calibration and location services under `system.hardware`,
and external-power lid and suspend/hibernate button actions under `system.power`.
All default to `null`; font family names do not install font packages. Running
desktop sessions may take over power-button handling from the system fallback.

GNOME accessibility also covers hover-to-click, holding for right-click, keyboard
feedback, inactivity timeouts, lock-key announcements, and visual bell feedback.
`desktops.gnome.magnification` controls zoom, tracking, lens placement, crosshairs,
brightness inversion and saturation. Enable the magnifier separately with
`desktops.gnome.accessibility.magnifier = true`.

Core program modules also include `gnome-calculator`, `gnome-calendar`, and
`gnome-clocks`. Enable them under a system or user program mount. Calculator
exposes number formatting, programming bases, suggestions, favorite currencies,
and exchange-rate refreshes (zero disables downloads). Calendar provides month,
week and agenda views; Clocks provides its starting view and location preference.

`desktops.gnome.shortcuts` assigns additional GTK-style accelerator strings to
47 desktop actions. For example, `openCalculator = [ "<Super>c" ]` adds a shortcut
to launch the calculator. Empty lists clear configurable bindings; dedicated
hardware media keys retain their standard bindings. The shortcuts do not install
target applications.

`system.sharing` controls availability of online accounts, personal file sharing,
media-library sharing, remote desktops, and network media players. These options
do not configure credentials or choose content to share. Font packages can be
installed through `system.fonts.packages`; family preferences remain separate.
Network discovery publication and its firewall access are separate choices.

Sleep availability can be controlled through `system.power.allowSuspend`,
`allowHibernate`, `allowHybridSleep`, and `allowSuspendThenHibernate`.
`hibernateAfterSuspendSeconds` applies to suspend-then-hibernate. These choices
still require hardware support and suitable hibernation/resume configuration.
`system.diagnostics` provides disk/memory/disabled log storage, retention days,
disk and memory budgets in mebibytes, and per-service message rate limits.

Additional program modules include `git`, `ripgrep`, `loupe`, and `papers`.
Git and Ripgrep preferences default to `null` to preserve their existing behavior.
Git exposes identity, signing, history integration, review and large-file support;
Ripgrep exposes file selection, matching and result formatting. Loupe controls
its image-information sidebar. Papers configures document layout, annotations,
page caching and zoom; remembered document-specific choices can take precedence.

`desktops.gnome.loginScreen` configures the GDM greeter independently of user
sessions. Its nullable settings cover account visibility, a welcome message,
text size, clock format, accessibility, automatic suspend and authentication
methods. Authentication still needs the corresponding system services; these
options do not enroll credentials or change account lockout policy.

GNOME greeter defaults use the monochrome symbolic ZenOS glyph and host accent/color scheme.
Explicit loginScreen.logo and existing greeter database settings take precedence.
Only the GDM shell selects the system GDM profile explicitly.


GNOME Destination II wallpapers follow accent changes only when the current
variant matches the previous accent. Light and dark image settings are checked
independently and retain their light/dark flavor. Teal uses the Cyan variant;
slate uses Slate. A different Destination color, an unrelated wallpaper, or a
manually copied image remains untouched. Selecting a matching installed variant
resumes following on the next accent change. Starting or restarting the session
helper never rewrites the current selection.

GNOME's system MIME defaults select GNOME Text Editor for plain/empty text and
for the text/code formats that upstream GNOME otherwise sends to Builder,
including JSON, XML and Markdown. Explicit user associations keep priority.
These defaults live in the GNOME-specific profile, leaving other desktops' text
editors and browser/file-manager associations alone.


GNOME's Activities workspace indicator excludes outgoing dot actors from the
workspace indices during removal animations. This prevents the active pill from
vanishing after rapid workspace removal/addition; GNOME's inactive dot size and
opacity remain unchanged. The shared GNOME overlay carries the maintained Shell
source fix, covered by the animated `gnome-workspace-indicator-vm` check.


Forge auto-splits only for a new window eligible for tiling. Internal window types,
hidden taskbar helpers, dialogs/transients, fixed-size windows, floating overrides
and untiled workspaces do not split the focused app container. Duplicate tracking
events also leave the layout unchanged. The maintained Forge source and
`forge-recorder-vm` regression check cover recorder-style helper lifecycles while
retaining normal application tiling.


Workspace dots settle their grow/shrink animations when a parent is detached.
Cancelled incoming dots restore full actor scale; outgoing dots are removed even
when their transition is stopped. This prevents tiny/invisible or stale dots when
startup panel extensions reparent the panel. Normal inactive styling is retained.
The native VM check covers styled parent removal/re-addition at zero/partial grow
and partial shrink, alongside the earlier workspace-index regression.

## Dash Stacks folder pins

The Dash Stacks package supports app-grid folders alongside existing directory
stacks. Right-click a GNOME app folder and choose Pin to Dock; use Unpin from
Dock on its dock context menu to restore it to the app grid. Folder settings,
app membership, category/exclusion rules and search remain managed by GNOME.
The per-user extension setting `pinned-app-folders` stores only folder IDs.
Disabling the extension restores the grid without deleting stored pins.

`nix build .#checks.x86_64-linux.dash-stacks-vm` exercises the actual GNOME50
folder context menu, pin/unpin, native dialog, folder edits, missing/duplicate
pins, empty-folder recovery, disable/re-enable and square actor allocations.
The fixture measures pin feedback against the400ms responsiveness limit.
