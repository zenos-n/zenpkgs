# Black Box Next

The GNOME 50 development fork is available through both package selectors:

```sh
nix build '.#com.neg-zero.blackbox-next'
nix build '.#apps.terminal.blackbox-next'
```

Run `blackbox-next`. Its desktop/GSettings ID is `com.neg-zero.BlackBoxNext`;
settings and user data are separate from upstream Black Box. The package alone does not change desktop terminal defaults.

The package source and Nix recipe live in the separate `blackbox` repository.
`source-blackbox` is pinned to the published [ZenOS fork](https://github.com/zenos-n/blackbox), commit `9fe9ada7efe6bd6084f891ee7bd98175633c5b7c`.
Local development can override this input with a separate checkout.

## Program configuration

Available at `system.programs.blackbox-next` (defaults for managed users) and
`users.<name>.programs.blackbox-next` (user choices override system defaults):

```nix
users.doromiert.programs.blackbox-next = {
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

`opacity` is 0–100; `cellWidth` and `cellHeight` are 1–2. Timing, scrollback
and padding values are unsigned 32-bit integers. Sixel remains optional and
is not Kitty graphics support.

Check the module with `python3 tests/check-blackbox-next.py --nixpkgs PATH
--home-manager PATH`. Runtime appearance and overview tests live in the source
repository. A full NixOS activation is a separate check.

ZenOS installed-base installs Black Box Next for normal users and selects it
as the desktop terminal through `TERMINAL` and `xdg-terminal-exec`. These are
overridable defaults. ZenOS Setup and the live image use Black Box Next for
Super+T and the recovery terminal launcher. The package alone still does not
change defaults on systems without installed-base.
