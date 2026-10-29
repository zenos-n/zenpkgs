# Blankbox

The GNOME 50 development fork is available through both package selectors:

```sh
nix build '.#com.neg-zero.blankbox'
nix build '.#apps.terminal.blankbox'
```

Run `blankbox`. Its desktop/GSettings ID is `com.neg-zero.Blankbox`;
settings and user data are separate from upstream Black Box. The package alone does not change desktop terminal defaults.

The package source and Nix recipe live in [zenos-n/blankbox](https://github.com/zenos-n/blankbox).
`source-blankbox` pins its published GitHub revision and NAR hash in `flake.lock`;
no local checkout is needed. `source-blackbox` remains an input alias for older
integrations. The source dependency stays outside the package catalog.

The recipe requires GTK 4.22, libadwaita 1.9 and VTE 0.84. GSK rendering can use
the GPU when supported by the active driver; a GPU speedup has not been measured.
The cursor and trail default to white. Enable Use Desktop Accent under
Preferences → Terminal → Cursor to switch their color. The trail is enabled
by default and can be disabled in the same section. The tab overview button
in both header layouts provides tab thumbnails, search and tab management.
The UI follows the desktop accent. Sixel is inherited. Kitty graphics, splits, and complete Kitty compatibility
are not implemented by this milestone. See the source repository's `FORK.md`
and `PERFORMANCE.md` for checks and remaining validation.

## Program configuration

Available at `system.programs.blankbox` (defaults for managed users) and
`users.<name>.programs.blankbox` (user choices override system defaults):

```nix
users.doromiert.programs.blankbox = {
  enable = true;
  defaultTerminal = true;
  cursorTrail = true;
  cursorUseAccent = false;
  showHeaderBar = false;
  floatingControls = true;
};
```

`enable` installs the catalog package; `package` can override it.
`defaultTerminal` sets `TERMINAL` to its absolute executable and enables Home
Manager's `xdg.terminal-exec` with this desktop entry first in both GNOME and
fallback lists. Login again for the session environment to update. Explicit
shortcuts such as a `kgx` command must be changed separately.

Preferences default to null, so enabling alone does not overwrite application
preferences. Selected values use Home Manager's writable dconf database at
`com/neg-zero/BlackBoxNext`; false, zero and empty strings remain explicit.
Rebuilds reapply selected values. Removing a previously managed value follows
Home Manager dconf behavior and resets that key. Unmanaged preferences and
runtime window state are untouched. There are no dconf locks.

Options cover fonts, terminal themes, opacity, header and floating controls,
scrolling, scrollback, Sixel, cursor, shell commands and working directories.
`padding` is `[ top right bottom left ]`. Enum choices:

| Option | Values |
| --- | --- |
| `stylePreference` | `system`, `light`, `dark` |
| `cursorShape` | `block`, `ibeam`, `underline` |
| `cursorBlinkMode` | `system`, `on`, `off` |
| `scrollbackMode` | `fixed`, `unlimited`, `disabled` |
| `workingDirectoryMode` | `previous`, `home`, `custom` |
| `tabSwitchingOrder` | `position`, `recent` |

`tabSwitchingOrder = "recent"` makes Ctrl+Tab and the other next/previous-tab
shortcuts cycle by last-viewed time. Hold Control and press Tab repeatedly to
traverse a fixed history; release Control to commit the selected tab. Add Shift
to cycle backwards. Tab position is the application default.

`opacity` is 0–100; `cellWidth` and `cellHeight` are 1–2. Timing, scrollback
and padding values are unsigned 32-bit integers. Sixel remains optional and
is not Kitty graphics support.

Check the module with `python3 tests/check-blankbox.py --nixpkgs PATH
--home-manager PATH`. Runtime appearance and overview tests live in the source
repository. A full NixOS activation is a separate check.

ZenOS installed-base installs Blankbox for normal users and selects it
as the desktop terminal through `TERMINAL` and `xdg-terminal-exec`. These are
overridable defaults. ZenOS Setup and the live image use Blankbox for
Super+T and the recovery terminal launcher. The package alone still does not
change defaults on systems without installed-base.

## Compatibility

The old `com.neg-zero.blackbox-next` and `apps.terminal.blackbox-next` package
selectors resolve to the same derivation. `programs.blackbox-next` imports the
Blankbox module for existing configurations. New configurations should use
`programs.blankbox`. The former executable and desktop ID remain compatibility
launchers; the new application stores preferences at the same
`com/neg-zero/BlackBoxNext` dconf path and retains its `blackbox-next` user-data
directory so themes, keybindings and preferences survive the rebrand.
