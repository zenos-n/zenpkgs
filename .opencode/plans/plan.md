# Package Layout Migration

The migration must leave no `pkgs/apps/advanced` or `pkgs/apps/utilities` package root, must not create or retain a `pkgs/programs` package root, and must preserve the distinction that `programs` is reserved for modules. Package manifests are moved into the destinations below. Existing `apps/recovery/gparted-live` and `apps/security-tools/openssl` remain in place and are treated as category evidence.

<!-- BEGIN AGENT: move-bitwarden -->
## AGENT: move-bitwarden
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/security/bitwarden.zpkg`
objective: Move the Bitwarden package manifest out of `pkgs/apps/advanced` into the security category.
ordered changes:
1. Move the existing Bitwarden manifest from `pkgs/apps/advanced/bitwarden.zpkg` to `pkgs/apps/security/bitwarden.zpkg`.
2. Preserve package metadata, outputs, dependencies, and formatting; change only path-derived references required by the move.
dependencies: Complete before registry fixture regeneration; coordinate with no other package worker because the destination is exclusive.
inputs: Scout inventory naming `bitwarden` under `pkgs/apps/advanced`; category decision `apps/security`.
outputs: One Bitwarden manifest at the destination and no source manifest.
verification: Confirm the destination parses and the source path is absent; run the package registry check after reference workers complete.
forbidden scope: No other package, shared reference file, generated fixture, or external consumer.
<!-- END AGENT: move-bitwarden -->

<!-- BEGIN AGENT: move-cockpit -->
## AGENT: move-cockpit
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/system/cockpit.zpkg`
objective: Move Cockpit into the system administration category.
ordered changes:
1. Move `pkgs/apps/advanced/cockpit.zpkg` to `pkgs/apps/system/cockpit.zpkg`.
2. Preserve all manifest semantics and update only path-derived metadata if present.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `cockpit` under `pkgs/apps/advanced`; category decision `apps/system`.
outputs: One Cockpit manifest at the destination and no source manifest.
verification: Parse the destination manifest and verify the old path is absent; defer full registry verification to the registry worker.
forbidden scope: No other package, reference, fixture, or consumer file.
<!-- END AGENT: move-cockpit -->

<!-- BEGIN AGENT: move-gparted -->
## AGENT: move-gparted
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/recovery/gparted.zpkg`
objective: Move GParted into the existing recovery category without altering `gparted-live`.
ordered changes:
1. Move `pkgs/apps/advanced/gparted.zpkg` to `pkgs/apps/recovery/gparted.zpkg`.
2. Leave `pkgs/apps/recovery/gparted-live` unchanged and preserve the GParted manifest contents.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `gparted` under `pkgs/apps/advanced`; existing `apps/recovery/gparted-live` evidence.
outputs: GParted in `apps/recovery`, with the live image package still present.
verification: Confirm both recovery entries exist and parse, and that the advanced source is absent.
forbidden scope: No changes to `gparted-live`, other packages, references, fixtures, or consumers.
<!-- END AGENT: move-gparted -->

<!-- BEGIN AGENT: move-keepassxc -->
## AGENT: move-keepassxc
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/security/keepassxc.zpkg`
objective: Move KeePassXC into the security category.
ordered changes:
1. Move `pkgs/apps/advanced/keepassxc.zpkg` to `pkgs/apps/security/keepassxc.zpkg`.
2. Preserve manifest behavior and update only path-derived metadata if required.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `keepassxc` under `pkgs/apps/advanced`; category decision `apps/security`.
outputs: One KeePassXC manifest at the destination and no source manifest.
verification: Parse the destination and verify the old path is absent.
forbidden scope: No other package, shared reference, fixture, or external consumer.
<!-- END AGENT: move-keepassxc -->

<!-- BEGIN AGENT: move-nmap -->
## AGENT: move-nmap
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/network/nmap.zpkg`
objective: Move Nmap into a useful network category.
ordered changes:
1. Move `pkgs/apps/advanced/nmap.zpkg` to `pkgs/apps/network/nmap.zpkg`.
2. Preserve all package metadata and outputs.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `nmap` under `pkgs/apps/advanced`; category decision `apps/network`.
outputs: One Nmap manifest at the destination and no source manifest.
verification: Parse the destination and verify the old path is absent.
forbidden scope: No other package, reference, fixture, or consumer file.
<!-- END AGENT: move-nmap -->

<!-- BEGIN AGENT: move-podman-desktop -->
## AGENT: move-podman-desktop
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/virtualization/podman-desktop.zpkg`
objective: Move Podman Desktop into the virtualization category.
ordered changes:
1. Move `pkgs/apps/advanced/podman-desktop.zpkg` to `pkgs/apps/virtualization/podman-desktop.zpkg`.
2. Preserve manifest behavior and path-derived metadata.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `podman-desktop` under `pkgs/apps/advanced`; category decision `apps/virtualization`.
outputs: One Podman Desktop manifest at the destination and no source manifest.
verification: Parse the destination and verify the old path is absent.
forbidden scope: No other package, reference, fixture, or external consumer.
<!-- END AGENT: move-podman-desktop -->

<!-- BEGIN AGENT: move-virt-manager -->
## AGENT: move-virt-manager
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/virtualization/virt-manager.zpkg`
objective: Move Virt-Manager into the virtualization category.
ordered changes:
1. Move `pkgs/apps/advanced/virt-manager.zpkg` to `pkgs/apps/virtualization/virt-manager.zpkg`.
2. Preserve all manifest metadata and outputs.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `virt-manager` under `pkgs/apps/advanced`; category decision `apps/virtualization`.
outputs: One Virt-Manager manifest at the destination and no source manifest.
verification: Parse the destination and verify the old path is absent.
forbidden scope: No other package, reference, fixture, or consumer file.
<!-- END AGENT: move-virt-manager -->

<!-- BEGIN AGENT: move-wireshark -->
## AGENT: move-wireshark
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/network/wireshark.zpkg`
objective: Move Wireshark into the network category beside Nmap.
ordered changes:
1. Move `pkgs/apps/advanced/wireshark.zpkg` to `pkgs/apps/network/wireshark.zpkg`.
2. Preserve package behavior and path-derived metadata.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `wireshark` under `pkgs/apps/advanced`; category decision `apps/network`.
outputs: One Wireshark manifest at the destination and no source manifest.
verification: Parse the destination and verify the old path is absent.
forbidden scope: No other package, reference, fixture, or consumer file.
<!-- END AGENT: move-wireshark -->

<!-- BEGIN AGENT: move-cipher -->
## AGENT: move-cipher
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/security-tools/cipher.zpkg`
objective: Move Cipher into the existing security-tools category.
ordered changes:
1. Move `pkgs/apps/utilities/cipher.zpkg` to `pkgs/apps/security-tools/cipher.zpkg`.
2. Preserve its manifest and leave `openssl` unchanged.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `cipher` under `pkgs/apps/utilities`; existing `apps/security-tools/openssl` evidence.
outputs: Cipher beside the existing security tool package and no utilities source manifest.
verification: Parse the destination and verify both security-tool manifests are present.
forbidden scope: No changes to `openssl`, other packages, references, fixtures, or consumers.
<!-- END AGENT: move-cipher -->

<!-- BEGIN AGENT: move-curtail -->
## AGENT: move-curtail
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/media/curtail.zpkg`
objective: Move Curtail into the media category.
ordered changes:
1. Move `pkgs/apps/utilities/curtail.zpkg` to `pkgs/apps/media/curtail.zpkg`.
2. Preserve all manifest semantics.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `curtail` under `pkgs/apps/utilities`; category decision `apps/media`.
outputs: One Curtail manifest at the destination and no source manifest.
verification: Parse the destination and verify the old path is absent.
forbidden scope: No other package, reference, fixture, or consumer file.
<!-- END AGENT: move-curtail -->

<!-- BEGIN AGENT: move-file-roller -->
## AGENT: move-file-roller
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/file-tools/file-roller.zpkg`
objective: Move File Roller into the file-tools category.
ordered changes:
1. Move `pkgs/apps/utilities/file-roller.zpkg` to `pkgs/apps/file-tools/file-roller.zpkg`.
2. Preserve all manifest semantics.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `file-roller` under `pkgs/apps/utilities`; category decision `apps/file-tools`.
outputs: One File Roller manifest at the destination and no source manifest.
verification: Parse the destination and verify the old path is absent.
forbidden scope: No other package, reference, fixture, or consumer file.
<!-- END AGENT: move-file-roller -->

<!-- BEGIN AGENT: move-gnome-boxes -->
## AGENT: move-gnome-boxes
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/virtualization/gnome-boxes.zpkg`
objective: Move GNOME Boxes into the virtualization category.
ordered changes:
1. Move `pkgs/apps/utilities/gnome-boxes.zpkg` to `pkgs/apps/virtualization/gnome-boxes.zpkg`.
2. Preserve all manifest metadata and outputs.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `gnome-boxes` under `pkgs/apps/utilities`; category decision `apps/virtualization`.
outputs: GNOME Boxes in the shared virtualization category and no utilities source manifest.
verification: Parse the destination and verify it coexists with the two advanced virtualization moves.
forbidden scope: No other package, reference, fixture, or consumer file.
<!-- END AGENT: move-gnome-boxes -->

<!-- BEGIN AGENT: move-impression -->
## AGENT: move-impression
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/productivity/impression.zpkg`
objective: Move Impression into the productivity category.
ordered changes:
1. Move `pkgs/apps/utilities/impression.zpkg` to `pkgs/apps/productivity/impression.zpkg`.
2. Preserve all manifest semantics.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `impression` under `pkgs/apps/utilities`; category decision `apps/productivity`.
outputs: One Impression manifest at the destination and no source manifest.
verification: Parse the destination and verify the old path is absent.
forbidden scope: No other package, reference, fixture, or consumer file.
<!-- END AGENT: move-impression -->

<!-- BEGIN AGENT: move-metadata-cleaner -->
## AGENT: move-metadata-cleaner
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/file-tools/metadata-cleaner.zpkg`
objective: Move Metadata Cleaner into the file-tools category.
ordered changes:
1. Move `pkgs/apps/utilities/metadata-cleaner.zpkg` to `pkgs/apps/file-tools/metadata-cleaner.zpkg`.
2. Preserve all manifest behavior.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `metadata-cleaner` under `pkgs/apps/utilities`; category decision `apps/file-tools`.
outputs: Metadata Cleaner beside File Roller and no utilities source manifest.
verification: Parse the destination and verify both file-tools manifests are present.
forbidden scope: No other package, reference, fixture, or consumer file.
<!-- END AGENT: move-metadata-cleaner -->

<!-- BEGIN AGENT: move-mission-center -->
## AGENT: move-mission-center
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/system-monitoring/mission-center.zpkg`
objective: Move Mission Center into the system-monitoring category.
ordered changes:
1. Move `pkgs/apps/utilities/mission-center.zpkg` to `pkgs/apps/system-monitoring/mission-center.zpkg`.
2. Preserve all manifest semantics.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `mission-center` under `pkgs/apps/utilities`; category decision `apps/system-monitoring`.
outputs: One Mission Center manifest at the destination and no source manifest.
verification: Parse the destination and verify the old path is absent.
forbidden scope: No other package, reference, fixture, or consumer file.
<!-- END AGENT: move-mission-center -->

<!-- BEGIN AGENT: move-pika-backup -->
## AGENT: move-pika-backup
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/backup/pika-backup.zpkg`
objective: Move Pika Backup into the backup category.
ordered changes:
1. Move `pkgs/apps/utilities/pika-backup.zpkg` to `pkgs/apps/backup/pika-backup.zpkg`.
2. Preserve all manifest metadata and outputs.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `pika-backup` under `pkgs/apps/utilities`; category decision `apps/backup`.
outputs: One Pika Backup manifest at the destination and no source manifest.
verification: Parse the destination and verify the old path is absent.
forbidden scope: No other package, reference, fixture, or consumer file.
<!-- END AGENT: move-pika-backup -->

<!-- BEGIN AGENT: move-resources -->
## AGENT: move-resources
agent type: code-monkey-pro
exact single-file path scope: `pkgs/apps/system-monitoring/resources.zpkg`
objective: Move Resources into the system-monitoring category beside Mission Center.
ordered changes:
1. Move `pkgs/apps/utilities/resources.zpkg` to `pkgs/apps/system-monitoring/resources.zpkg`.
2. Preserve all manifest semantics.
dependencies: Complete before registry fixture regeneration.
inputs: Scout inventory naming `resources` under `pkgs/apps/utilities`; category decision `apps/system-monitoring`.
outputs: Resources beside Mission Center and no utilities source manifest.
verification: Parse the destination and verify both system-monitoring manifests are present.
forbidden scope: No other package, reference, fixture, or consumer file.
<!-- END AGENT: move-resources -->

<!-- BEGIN AGENT: move-zenos-rebuild -->
## AGENT: move-zenos-rebuild
agent type: code-monkey-pro
exact single-file path scope: `pkgs/system/zenos-rebuild.zpkg`
objective: Remove the package from the reserved `pkgs/programs` root and place it in the system category.
ordered changes:
1. Move `pkgs/programs/zenos-rebuild.zpkg` to `pkgs/system/zenos-rebuild.zpkg`.
2. Remove the obsolete empty package-root placeholders `pkgs/programs/swisstag` and `pkgs/programs/zenos-rebuild` only after confirming they contain no package files.
3. Remove `pkgs/programs` itself only if empty after the move; do not remove or rename any module-owned `programs` path elsewhere.
dependencies: Complete before reference updates and fixture regeneration.
inputs: Scout inventory of `zenos-rebuild.zpkg` plus empty `swisstag` and `zenos-rebuild` directories; requirement that `programs` is reserved for modules.
outputs: Zenos rebuild package under `pkgs/system`, no package root at `pkgs/programs`, and an explicit empty-directory report for the final user summary.
verification: Parse the destination, verify the old manifest and obsolete placeholders are absent, and verify no package path remains under `pkgs/programs`.
forbidden scope: No module-owned `programs` paths, other packages, shared reference files, fixtures, or external consumers.
<!-- END AGENT: move-zenos-rebuild -->

<!-- BEGIN AGENT: update-flake-reference -->
## AGENT: update-flake-reference
agent type: code-monkey
exact single-file path scope: `flake.nix`
objective: Update the root package discovery and any explicit package references for the new category paths.
ordered changes:
1. Replace references to `pkgs/apps/advanced`, `pkgs/apps/utilities`, and `pkgs/programs` package roots with the concrete category destinations.
2. Preserve module-owned `programs` references and keep package discovery deterministic.
3. Do not hand-edit generated fixture data in this file.
dependencies: All package moves must be complete before editing; run after the package workers.
inputs: All destination paths in this plan and the existing root `flake.nix`.
outputs: Root flake importing the relocated packages without forbidden package roots.
verification: Evaluate the relevant flake package registry and assert no forbidden package-root path is referenced.
forbidden scope: No package manifests, generated fixture, tests, or external repositories.
<!-- END AGENT: update-flake-reference -->

<!-- BEGIN AGENT: update-runtime-reference -->
## AGENT: update-runtime-reference
agent type: code-monkey
exact single-file path scope: `installed-runtime.nix`
objective: Update runtime package references to the relocated package paths.
ordered changes:
1. Replace old advanced, utilities, and programs package paths with the destinations defined above.
2. Preserve runtime ordering, profiles, and module references.
dependencies: Package moves complete; run after `flake.nix` ownership is settled if it shares generated path lists.
inputs: Destination map in this plan and existing `installed-runtime.nix`.
outputs: Runtime installation definitions resolving every moved package.
verification: Evaluate the runtime expression and check that every moved package resolves exactly once.
forbidden scope: No package manifests, root flake, tests, fixture, or external repositories.
<!-- END AGENT: update-runtime-reference -->

<!-- BEGIN AGENT: update-package-registry-test -->
## AGENT: update-package-registry-test
agent type: code-monkey
exact single-file path scope: `tests/package-registry.nix`
objective: Update registry expectations and add assertions for the new category layout.
ordered changes:
1. Replace old package paths with the complete destination map.
2. Assert `pkgs/apps/advanced`, `pkgs/apps/utilities`, and `pkgs/programs` are not package roots.
3. Assert the moved package names remain discoverable exactly once.
4. Keep the empty-directory report as an explicit verification input rather than broadening cleanup.
dependencies: All package moves and root references must be complete; coordinate sequentially with fixture regeneration.
inputs: Scout inventory, destination map, and current registry test.
outputs: Registry test covering package discovery, uniqueness, forbidden roots, and retained module-root semantics.
verification: Run the focused registry test and the generated fixture check.
forbidden scope: No package manifests, generated JSON, collision test, or external repository files.
<!-- END AGENT: update-package-registry-test -->

<!-- BEGIN AGENT: update-collision-test -->
## AGENT: update-collision-test
agent type: code-monkey
exact single-file path scope: `tests/package-output-collisions.nix`
objective: Keep output-collision coverage correct after package relocation.
ordered changes:
1. Replace any old package paths in fixtures or expectations with destination paths.
2. Preserve collision semantics and add coverage for packages sharing a newly created category.
3. Ensure the test distinguishes a valid category directory from a duplicate package output.
dependencies: Package moves complete; run after registry path decisions are fixed.
inputs: Destination map and existing collision test.
outputs: Collision test valid for the reclassified package set.
verification: Run the focused collision test and confirm no false positives from directory moves.
forbidden scope: No package manifests, registry test, generated fixture, or external repositories.
<!-- END AGENT: update-collision-test -->

<!-- BEGIN AGENT: regenerate-package-fixture -->
## AGENT: regenerate-package-fixture
agent type: code-monkey-lite
exact single-file path scope: `tests/fixtures/package-registry.json`
objective: Regenerate the package registry fixture from the updated package tree.
ordered changes:
1. Run the repository's supported fixture generator after all package and reference changes are present.
2. Confirm the generated JSON contains the complete destination map and excludes the three forbidden package roots.
3. Keep the file generator-owned; do not manually reorder or hand-author entries.
dependencies: All package moves, `flake.nix`, `installed-runtime.nix`, and registry test updates must be complete.
inputs: Updated package tree and the repository's existing fixture-generation command.
outputs: Deterministic `package-registry.json` matching the new tree.
verification: Regenerate twice and compare results; run the registry and collision tests.
forbidden scope: No source package files, Nix reference files, external consumers, or unrelated fixtures.
<!-- END AGENT: regenerate-package-fixture -->

<!-- BEGIN AGENT: update-zenos-next-consumer -->
## AGENT: update-zenos-next-consumer
agent type: code-monkey
exact single-file path scope: `/home/doromiert/Projects/zenos-next/flake.nix`
objective: Update the external zenos-next consumer to the relocated package paths while preserving module-owned program references.
ordered changes:
1. Replace only package-root paths that point at advanced, utilities, or package-level programs.
2. Preserve external interface names and module imports.
3. Do not vendor or duplicate package manifests into the consumer repository.
dependencies: The zenpkgs destination map and generated fixture must be stable first.
inputs: Existing zenos-next flake and this plan's destination map.
outputs: zenos-next resolving the relocated packages without forbidden package roots.
verification: Evaluate the consumer flake's affected packages and run its focused package-resolution checks.
forbidden scope: No zenpkgs source files, zenos-n files, module-owned `programs`, or unrelated consumer configuration.
<!-- END AGENT: update-zenos-next-consumer -->

<!-- BEGIN AGENT: update-zenos-n-consumer -->
## AGENT: update-zenos-n-consumer
agent type: code-monkey
exact single-file path scope: `/home/doromiert/Projects/zenos-n/flake.nix`
objective: Update the external zenos-n consumer to the relocated package paths while preserving module-owned program references.
ordered changes:
1. Replace only package-root paths that point at advanced, utilities, or package-level programs.
2. Preserve external interface names and module imports.
3. Do not vendor or duplicate package manifests into the consumer repository.
dependencies: The zenpkgs destination map and generated fixture must be stable first.
inputs: Existing zenos-n flake and this plan's destination map.
outputs: zenos-n resolving the relocated packages without forbidden package roots.
verification: Evaluate the consumer flake's affected packages and run its focused package-resolution checks.
forbidden scope: No zenpkgs source files, zenos-next files, module-owned `programs`, or unrelated consumer configuration.
<!-- END AGENT: update-zenos-n-consumer -->

<!-- BEGIN AGENT: final-migration-verification -->
## AGENT: final-migration-verification
agent type: code-monkey-lite
exact single-file path scope: `tests/package-registry.nix`
objective: Own the final verification pass for the completed migration without changing package logic outside the registry assertions.
ordered changes:
1. Run the package registry, collision, fixture determinism, root flake, runtime, zenos-next, and zenos-n checks after all implementation workers finish.
2. Verify every package named by the scout report appears once at its planned destination.
3. Verify `pkgs/apps/advanced`, `pkgs/apps/utilities`, and `pkgs/programs` are absent as package roots.
4. Record every empty directory reported by the scout, including `pkgs/programs/swisstag` and `pkgs/programs/zenos-rebuild`, in the final user-facing report; confirm only obsolete package-root placeholders were removed.
dependencies: All other workers must complete; this worker is last and may only adjust non-overlapping verification assertions if a test expectation is stale.
inputs: Final tree, generated fixture, all focused test results, and the scout's empty-directory inventory.
outputs: Verification evidence and a concise empty-directory report for the user.
verification: Full focused test suite passes; fixture regeneration is clean; both external consumers evaluate; no forbidden package root or unintended broad cleanup remains.
forbidden scope: No package relocation, shared reference rewrite, generated fixture rewrite, external consumer edit, or cleanup beyond the explicitly obsolete package-root placeholders.
<!-- END AGENT: final-migration-verification -->
