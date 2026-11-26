# SteamBrew (Millennium)

Set `system.gaming.steam.millennium = true;` to enable SteamBrew themes and
plugins through the official [Millennium](https://steambrew.app/) Nix wrapper.
The default is `null`; `false` also leaves the ordinary Steam package in place.
This selects the runtime for all users of the host's Steam installation.

Both curated Steam and Steam (Gamescope) use the selected runtime. Proton GE,
ZenFS private-home handling, and additional Steam runtime libraries are retained.
The option does not start, stop, or restart Steam. Fully quit Steam when convenient
and launch it again to load Millennium, then manage themes/plugins in its settings.
No theme or third-party plugin is installed automatically.

The owning package is `app.steambrew.millennium`, category alias
`apps.gaming.millennium`. Its pinned Nix packaging retains the upstream Bun lock
for the fixed-output dependency hash. The upstream overlay builds the runtime against the host
ZenOS libraries so its glibc/loader match Steam. Merely installing
that runtime package does not enable injection into Steam.

Upstream Nix packaging and Steam injection are maintained by
[SteamClientHomebrew](https://github.com/SteamClientHomebrew/Millennium/tree/3b3702aa4838a22dbf7277dbd535d40499f26e4a/packages/nix),
under the MIT license.

ZenOS maintains a [Nix-only packaging adaptation](https://github.com/zenos-n/millennium-nix)
for upstream [dependency-hash issue #934](https://github.com/SteamClientHomebrew/Millennium/issues/934).
Dependency fetching skips binary/shebang fixups; TTC compilation runs in the
normal build sandbox. The upstream 3.6.3 runtime and Steam wrapper are unchanged.
Header-only nlohmann_json dependency tests are skipped to bound installation disk use.
