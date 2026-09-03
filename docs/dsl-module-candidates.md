# DSL module candidate checks

`mkDslArtifacts` compiles the repository root and materializes every ZMDL source
as `modules/<source-path>.nix` inside the bundle store path. Canonical sources
are named `modules/<path>.zmdl` leaves. Their path-derived `_meta.id` is `<path>`
with `/` replaced by `.`, and their option attachment is `zenos.<path>`. The
bundle adapter rejects noncanonical locations, reserved `module.zmdl` leaves,
ID mismatches, attachment-path drift, compile-target drift, and
source/ID/attachment duplicates before returning private `system` and `user`
candidate lists. These lists are test inputs only. They are not imported by the
public `nixosModules` or `homeManagerModules` outputs.

The `dsl-module-contract` check is structural and non-activating. It requires:

1. Exactly 70 ZMDL sources are discovered and compiled.
2. Every path-derived module ID is unique and matches `_meta.id`.
3. The repository has exactly one root `structure.zstr`, with exactly one
   attachment for every ZMDL and no orphan attachments.
4. Every attachment path and `system` or `user` compile target matches the
   canonical source path.
5. Every generated Nix file passes `nix-instantiate --parse`.

The parser check does not invoke a generated module function. No check evaluates
candidate options or config through NixOS or Home Manager, compares candidates
with legacy modules, activates a configuration, or claims behavioral parity.

## Behavioral blockers

Behavioral validation remains blocked by unsupported or flattened module-system
semantics in the current ZMDL compiler output.

| Area | Recorded blocker |
| --- | --- |
| Core users and packages | Nested Home Manager user schemas, recursive package lookup, external freeforms, and `zenUserModules` imports are not representable. |
| Disk and Syncthing bridges | Externally owned freeforms and Syncthing conflict/warning inspection require ZSTR or evaluator support. |
| Installed base and OOBE | `mkDefault`/`mkForce`, package assertions, and fallback metadata construction are flattened or unavailable. |
| Zenboot and GNOME tweaks | Priority provenance and `internal`/`readOnly` option fields are unavailable. |
| ZenFS, maintenance, and janitor | Generated JSON, dynamic source values, and services depending on generated files are unavailable. |
| System web apps | Home Manager imports require flake-side assembly and typed user records are represented as freeform attrs. |
| Home Manager web apps | Nested app schemas, dynamic defaults, patched browser derivations, cross-module guards, and DAG cleanup are unavailable. |
| Zenlink | `internal`, `readOnly`, and `defaultText` option fields are unavailable. |

The next task is to add the missing compiler and schema semantics, then introduce
isolated option/config evaluation tests per module family before any candidate is
eligible for an active output.

Run the non-activation contract from a test VM or development host:

```bash
nix build path:/home/doromiert/Projects/zenpkgs#checks.x86_64-linux.dsl-module-contract --no-link --print-build-logs
```
