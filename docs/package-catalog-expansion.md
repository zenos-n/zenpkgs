# Package catalog expansion — September 2026

The catalog contains 4057 declarations: 4048 Nixpkgs imports and 9 custom build
providers. This expansion added 3914 imports after the initial eight-package batch
in [the layout migration](package-layout-migration.md).

## September 24 initial continuation batch

Added 112 previously unrepresented Nixpkgs providers, bringing the catalog from
2785 to 2897 declarations without moving existing packages. The additions include
Backrest, Barman, Beyond Compare, BeeRef, BambooTracker, BeamerPresenter,
BlueBubbles, Boatswain, and developer tools such as Bicep, Bloaty, and Bashly.
Each addition has multiple discovery tags and inherits its provider's dependencies.

All 112 additions were checked against their actual pinned legacy providers for
matching derivations, outputs, and versions. No new duplicate provider outputs
were introduced. This does not claim that every added application was built or run.

## Discovery and identity

Each package has one canonical filesystem identity. Multiple `_meta.tags`
make applications discoverable in several categories without creating duplicate
package definitions or aliases. Examples:

| Package | Discovery tags include |
| --- | --- |
| VLC | multimedia, audio, video, player, streaming |
| Rnote | office, productivity, notes, drawing, graphics |
| Wireshark | networking, diagnostics, security |
| OBS Studio | video, multimedia, creativity, recording, streaming, gaming |
| Restic | backup, storage, encryption, command-line |
| QGIS | science, education, maps, geography |
| Ghidra | development, reverse-engineering, security |

4057 declarations have multiple tags. These are ordinary supported metadata
tags, not a new category field or module API.

## Coverage

| Package directory | Declarations |
| --- | ---: |
| apps/accessibility | 42 |
| apps/ai | 26 |
| apps/archives | 43 |
| apps/audio | 218 |
| apps/backup | 39 |
| apps/browsers | 29 |
| apps/cad | 75 |
| apps/communication | 119 |
| apps/containers | 63 |
| apps/development | 859 |
| apps/development-tools | 2 |
| apps/downloads | 41 |
| apps/editors | 45 |
| apps/education | 48 |
| apps/files | 221 |
| apps/finance | 34 |
| apps/fonts | 22 |
| apps/gaming | 328 |
| apps/gaming/emulators | 36 |
| apps/graphics | 202 |
| apps/infrastructure | 32 |
| apps/launchers | 18 |
| apps/maps | 25 |
| apps/multimedia | 9 |
| apps/networking | 227 |
| apps/office | 322 |
| apps/radio | 46 |
| apps/recovery | 48 |
| apps/science | 143 |
| apps/security | 188 |
| apps/security-tools | 1 |
| apps/storage | 61 |
| apps/system | 15 |
| apps/system/administration | 133 |
| apps/system/monitoring | 97 |
| apps/system/zenos | 1 |
| apps/terminal | 56 |
| apps/video | 97 |
| apps/virtualization | 13 |
| apps/weather | 5 |
| desktops/gnome/extensions | 18 |
| system | 6 |
| theming/apps | 1 |
| theming/cursors | 1 |
| theming/system | 2 |

Versions and descriptive text for additions were read from the pinned Nixpkgs
recipes. Imports leave upstream dependencies and derivations intact. Update
authored `packageVersion` values when refreshing the corresponding upstream pin.

The current DSL accepts one license reference, not a list. Packages whose
upstream metadata contains multiple licenses omit authored `_meta.license`;
their recipes retain upstream metadata and the registry reports an unknown
license with a warning. No single license was chosen to stand in for a list.
Across the complete catalog, including pre-existing declarations, 513 registry
license fields remain unset.

Candidates marked broken, unsupported on x86_64-linux, removed, or requiring an
insecure dependency exception were excluded. Examples include Logseq, Nheko,
Surf, Stacer, and DuckStation. Resolved renames use the actual pinned attribute:
Kate and Marble come from `kdePackages`; Floorp imports `floorp-bin`; Crosspipe
was added after Nixpkgs reported Helvum's removal.
The existing `apps/system/administration/swww` identity imports `awww`, its
identical renamed provider, rather than using the deprecated Nixpkgs alias.
Surge XT and Proton VPN likewise import the current `surge-xt` and `proton-vpn`
attributes without changing their ZenPkgs identities.
The `xxHash` and `nekoray` declarations likewise use the identical current
providers `xxhash` and `throne`, keeping their existing filesystem identities.
The Serf declaration imports `serfdom`, the pinned HashiCorp orchestration CLI;
the unrelated Apache HTTP library named `serf` was caught during metadata review
and removed from that declaration.

Game engines and source ports retain their upstream game-data requirements.
These declarations do not add assets or alter the imported recipes.

## Verification

All 4048 imports were checked for matching upstream `drvPath` values in both
`pkgs.zenos` and the flattened public flake outputs, using each declaration's
`pkgs.legacy` provider as the reference. Coreutils, diffutils, and binutils in
the existing legacy view resolve to bootstrap variants whose derivations differ
from standalone top-level Nixpkgs attributes; their declarations preserve the
legacy providers exactly. This expansion does not change that legacy-view
behavior or claim identity with those separate top-level attributes.
Registry records were
compared against the full fixture, and the count, path identity, provider,
invalid identity, exposure, and metadata-default checks were evaluated.
These checks do not claim that every imported application was built or run.
Authored `packageVersion` fields on additions were also checked against their
actual legacy providers, rather than relying solely on candidate metadata.

The VM acceptance check imports the real ZenOS module, recompiles the complete
DSL tree inside the guest, and compares its decoded registry against the fixture.
It exercises system-scoped Restic, age, ripgrep, fd, SoX, and Numbat selectors and a
user-scoped bat selector through the internal Home Manager backend:

```sh
nix build path:.#checks.x86_64-linux.package-catalog-vm \
  --no-link --print-out-paths --print-build-logs
```

The installed-system acceptance passed with the 4057-declaration snapshot, including
UEFI boot, ZenOS identity, ZenFS directories, fresh compilation, and the system-
and user-scoped commands. It mounts the host store for test-only compiler inputs;
the guest still boots the installed ZenOS image. For this snapshot, the fresh
image build was interrupted to avoid exhausting host disk space. The existing
installed-image test driver then ran the new compiler from the shared store,
asserted that the compiled tree contains more than 4096 sources, compared all
4057 registry records, and exercised the same system and user commands. The
reused-image run passed; this is not a claim that the fresh-image build completed.
Its script and log are `/tmp/zenpkgs-catalog.195321/unlocked-vm-test.py` and
`/tmp/zenpkgs-catalog.195321/vm-unlocked-reused.log`.
The refreshed search JSON is generated at `/tmp/zenpkgs-docs.json`; the existing
`pkgs.legacy` depth limit remains in effect because of the previously diagnosed
recursive upstream package sets. The catalog expansion does not claim to fix
that separate export limitation.

The next 163 reviewed imports initially exceeded the compiler's hard-coded
4096-source-file limit, which counted all DSL files rather than just packages.
The normative design now specifies no fixed tree-size ceiling; the compiler
guard was removed and the imports restored. A regression test compiles 4097
package sources while checking deterministic ordering. Per-source safeguards
and collision validation remain in place.

The directory migration and remaining empty directories are documented in
[package-layout-migration.md](package-layout-migration.md).
