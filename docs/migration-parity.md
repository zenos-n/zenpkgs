# Migration capability parity

This expansion makes the reference installation reproducible through optional
packages and configuration. It does not activate a copy of that host's setup.
The audit used `zenos-old`, the running system and home profiles, `nix profile`,
Flatpak applications, local GNOME extensions, desktop entries, and enabled user
units. No credentials, browser databases, chat histories, or bot environment
files were imported.

The catalog now has 4131 declarations (4096 imports and 35 build providers),
including 74 additions. Codex and OpenCode also have explicit recipes for the
versions used by the reference profile. The registry fixture refresh corrects
pre-existing stale Codex, ZenFS, and setup provider records.

## Capability routes

All paths below are relative to `zenos`. Nullable settings preserve existing
policy when unset; explicit false is forwarded. Existing distribution defaults,
including installed-system zram, remain intact. The installed runtime now uses
default priority for zram and the QEMU guest agent so callers can disable them.

| Capability | Configuration/package route |
| --- | --- |
| Libvirt, virtual TPM, passt, guest agents and Virt Manager | `system.virtualization.libvirt`, `.guest`; packages in `apps.virtualization` |
| Docker, rootless Docker and Podman | `system.virtualization.docker`, `.podman` |
| Steam, Proton GE, controller rules, GameMode, ALVR | `system.gaming`; packages in `apps.gaming` |
| Existing VR manager, launcher and overlays | `users.<name>.services.vr`; `apps.gaming.zenos-vr-tools`, `.alvr-zenos-compat`, `.wlx-overlay-s`, `.wayvr`, `.fnuidesktop-vr`, `.ovr-advanced-settings` |
| Kernel selection, boot modules, parameters, sysctl and out-of-tree modules | `system.kernel`; `system.kernel.popcorn` and `.popcorn-zen4` packages |
| Compressed swap | `system.memory.zram` |
| AMD OpenCL and extra graphics drivers | `system.hardware.amdOpenCL`, `.graphicsPackages`; `system.drivers.graphics`; `apps.graphics.blender-hip`, `apps.ai.llama-cpp-rocm` |
| Kinect, Logitech wireless receivers and Android tools | `system.hardware.kinect2`, `.logitechWireless`, `.androidDebugging`; `libs.libfreenect2` |
| Mouse gestures and haptics | `system.hardware.mouseGestures`; `users.<name>.services.haptics`, `apps.accessibility.hapticspp` |
| Printer definitions, default printer and drivers | `system.printing.printers`, `.defaultPrinter`, `.drivers`; `system.drivers.printing` |
| 32-bit audio and realtime scheduling | Existing `system.audio.applications32Bit`, `.realtimeScheduling` |
| Foreign executables and development environments | `system.packaging.environmentExecutables`, `.compatibilityLibraries`, `.dynamicLibraries`; `apps.system.appimage-run` |
| System and per-user Flatpak applications | `system.flatpak`, `users.<name>.services.flatpak` |
| Firefox profiles and policies, VS Code, Kitty, KeePassXC, Zoxide, Nixcord and Zed | `users.<name>.programs.<program>`; `system.programs.firefox` for system browser policy |
| Firefox web applications and URL routing | `users.<name>.programs.pwamaker` |
| ZeroBridge | `users.<name>.services.zbridge`, `apps.connectivity.zbridge` |
| Agent command-line tools and Telegram bridges | `apps.ai.codex`, `.opencode`, `.takopi`, `.codex-telegram-bot`, `.opencode-telegram-bot`; `users.<name>.services.codexTelegram`, `.opencodeTelegram`, `.opencodeServer` |
| Custom desktop applications | `apps.video.tubefin`, `apps.audio.swisstag`, `apps.browsers.hyperbeam`, `apps.gaming.emulators.ryubing-canary` |
| Shell and language tooling | Existing shell options plus Cargo/Rust, GCC/ccls, Android tools, CSS and Python language servers; `apps.development.gnome-builder-lsp` |
| Local GNOME extensions | `desktops.gnome.extensions.wiggly`, `.codex-usage`, `.zane-indicator`, `.zen-vision`; existing Dash Stacks, lockscreen and OOBE packages |

Package paths are relative to `pkgs.zenos`, distinct from option paths. Select
packages through the existing system/user package selectors or use derivations
in package-valued options. The curated program aliases preserve upstream types,
so editor extensions, arbitrary Firefox preferences and KeePassXC native
messaging do not require new settings wrappers. Device-specific services,
mounts, fonts, shortcuts, files and units remain available through the typed
`legacy` mounts. Syncthing already has its own typed system mount.

## An opt-in configuration

This Nix module illustrates independent choices. Replace the example account
and paths with actual migration state; import `nixosModules.default` once.

```nix
{ pkgs, ... }: {
  zenos.system = {
    virtualization.libvirt = {
      enable = true;
      virtualTpm = true;
      runAsRoot = false;
      manager = true;
      socketNetworkTransport = true;
    };
    virtualization.docker.enable = true;
    memory.zram = { enable = true; memoryPercent = 50; algorithm = "zstd"; };
    hardware = { logitechWireless = true; androidDebugging = true; };
    flatpak = {
      enable = true;
      uninstallUnmanaged = false;
      packages = [ "org.gnome.Showtime" ];
    };
  };
  zenos.users.alice = {
    profile = { normalUser = true; groups = [ "libvirtd" "kvm" "docker" ]; };
    programs.keepassxc = { enable = true; settings.Browser.Enabled = true; };
    programs.vscode = { enable = true; profiles.default.userSettings."editor.fontSize" = 14; };
    services.flatpak = {
      enable = true;
      uninstallUnmanaged = false;
      packages = [ "re.sonny.Workbench" ];
    };
    # Enable separately when the headset/runtime is ready:
    services.vr = { enable = false; allowNetworkAccess = false; };
    services.codexTelegram = {
      enable = false;
      environmentFile = "/run/secrets/codex-telegram";
      workingDirectory = "%h/Projects";
    };
  };
}
```

To select the old kernel, set `zenos.system.kernel.package` to
`pkgs.zenos.system.kernel.popcorn` or `.popcorn-zen4`. The latter reproduces the
Zen 4 CPU-tuned host variant. Inspection of its generated configuration and
the live kernel confirms that both retain WLAN and i915 support; comments in the
old recipe about stripping drivers do not describe its actual generated config. Neither is selected automatically. Out-of-tree modules
must come from the matching `pkgs.linuxPackagesFor selectedKernel` set. For
ZeroBridge video, select that set's `v4l2loopback`, load `v4l2loopback`, and set
the desired video number through `system.kernel.moduleSettings`.

The VR service sets runtime requirements with default priority and targets PAM
limits to the selected account. Firewall access is separate. The supervisor
tracks unique systemd scopes and stops only the overlays it launched. The
launcher retains its existing SteamVR compatibility repairs and backup behavior.
This preserves the existing XR implementation; the future XR D-Bus API remains
a separate design decision.

Bot services run their foreground commands, reference runtime environment-file
paths, and install the matching agent CLI. Their working directory must already
exist. OpenCode Server defaults to loopback and port 4096. User account `linger`
can keep these units running after logout. Takopi remains a standalone CLI.

## Preserve installation state

Packages and options do not migrate mutable data. Retain the current account's
UID, home data, credentials, Firefox/PWA profiles, KeePass databases, Steam
libraries and compatibility prefixes, ALVR session.json, Flatpak repositories
and `~/.var/app`, Syncthing identity/database, Docker state, Libvirt definitions
and disks, local projects, and model files. Preserve existing `system.stateVersion`
and user `home.stateVersion` values (the audited user has `25.11`).

ZenOS uses `/Users` and `.private/{Config,Packages,Live,State}` for managed XDG
directories. Plan the home/XDG transition before activating a migrated account;
the package expansion does not move or delete current `.config`, `.local/share`,
`.local/state` or `.cache`. Preserve absolute-path references in personal units
and scripts, including any bot launch customizations. Existing mutable extension
settings and cursor calibration are user state as well.

ZenFS already enables system Flatpak support. The system management backend
follows that setting with an empty package selection by default; per-user
management defaults to false rather than following system support. Flatpak
scope and remote names matter. The audit found 32 applications split
between user and system installations; declare them in the corresponding scope.
Preserve non-Flathub remotes, local app origins and discontinued applications
(for example the existing Yuzu Flatpak). Declarative installation cannot recover
a removed remote artifact by itself. `uninstallUnmanaged` defaults to false.

The custom GNOME extensions carry their source's shell-version declarations.
Building their packages is not proof of compatibility with GNOME 50; check them
in a graphical session before relying on them. The Zane and vision indicators
also require their existing agent/model processes and data, which remain in the
external project workspaces.

## Source repository snapshots

Custom implementations and patches live outside ZenPkgs. Published sources
(TubeFin, Swisstag, ZeroBridge, fnuidesktop, Codex Usage and Popcorn) use pinned
revisions and hashes. Hyperbeam and OVR use pinned release artifacts. Ryubing's
mirror was checked against the original 1.3.274 checksum.

The extracted VR tools, ALVR patches, Haptics++, and
the Zane/vision indicators currently use locked local development snapshots:

| Input | Source repository |
| --- | --- |
| `source-vr-tools` | `../zenos-vr` |
| `source-alvr-compat` | `../alvr-zenos-compat` |
| `source-haptics` | `../haptics++` |
| `source-zane-indicator` | `../zenos-zane-indicator` |
| `source-vision-indicator` | `../zenos-vision-indicator` |

The lock records each snapshot's NAR hash. Carry these repositories to a new
checkout and override the corresponding inputs with their new `path:` locations,
or publish them and replace the development URLs with pinned Git revisions.
The current absolute development paths must be replaced before distribution to
machines that do not have this workspace. Sources have not been published by
this change. Updating a source requires explicitly updating its input lock.

## Repeat the audit and checks

```sh
python3 scripts/audit-migration.py --check --output /tmp/zenos-migration.json
nix build --no-link path:.#checks.x86_64-linux.migration-packages
nix build --no-link path:.#checks.x86_64-linux.migration-options
nix build --no-link path:.#checks.x86_64-linux.migration-options-vm
```

The read-only audit records package attributes and store paths, Flatpak IDs,
origins and branches, extension UUIDs/versions, enabled user-unit names and local
entry names. It deliberately omits source URLs, unit contents and environment
files. A catalog match verifies availability of an identity, not binary equality
with a separately pinned imperative profile.

The provider check verifies all 50 added Nixpkgs imports against the pinned
provider's derivation, output and version. Policy checks cover defaults, explicit
false, typed settings, per-user isolation, runtime credential-file references,
VR requirements and opt-in services. The VM boots the installed ZenOS graph and
exercises Docker, Libvirt, zram, kernel settings and user configuration. Physical
VR, GPU acceleration, USB peripherals and printing require hardware acceptance.
