# Steam (Gamescope)

Install `com.neg-zero.SteamGamescope`, category alias
`apps.gaming.steam-gamescope`, to add **Steam (Gamescope)** to the app grid.
The ordinary Steam launcher and URL associations remain available.

On GNOME Wayland, it reads the user's primary monitor and active physical mode
from Mutter at each launch. Gamescope's SDL2 Wayland display index is matched to
that monitor, and native game/output dimensions are supplied. Fractional scaling
and rotated modes are handled. The detected refresh is supplied at startup too, so games do not inherit a
default 60 Hz mode. Gamescope accepts whole Hz; fractional rates round to the
nearest Hz. No resolution, connector or refresh rate is hardcoded.
Relaunch after changing the primary monitor or its resolution.

Steam opens in Big Picture. Quit an existing Steam client first: Steam's singleton
would otherwise forward the request outside Gamescope. The launcher explains this
and never terminates Steam or games automatically. It uses the existing curated
Steam package, including Proton GE and ZenFS private-home handling.

`steam-gamescope --print-plan` checks display selection without opening a window
or starting Steam/Gamescope. Source, recipe, license, tests and limitations live
in [zenos-n/steam-gamescope](https://github.com/zenos-n/steam-gamescope).

The 1.1.0 launcher shows a Steam loading view inside the nested compositor and dismisses it on a visible Steam window. It includes/starts MangoApp, which Gamescope Steam integration selects for Steam's performance statistics. Monitor detection remains dynamic; game-specific VSync/frame limits remain the game's own settings. UI readiness/cleanup are tested on isolated Xvfb with a fake Steam window, without starting or stopping a real Steam client.
