# DSL module candidate checks

`mkDslArtifacts` compiles the repository root and materializes every ZMDL source
as `modules/<source-path>.nix` inside the bundle store path. Canonical sources
are named `modules/<path>.zmdl` leaves. The compiler derives their canonical
identity and option path as `zenos.<path>`; ZMDL authors must not declare
`_meta.id`. The bundle adapter consumes the compiler's path-derived `modules`
records and rejects noncanonical locations, reserved `module.zmdl` leaves,
source/record drift, identity or option-path mismatches, missing compiler output,
and source/path/identity duplicates before returning one target-neutral private
candidate list. This list is a test input only. It is not imported by the public
`nixosModules` or `homeManagerModules` outputs. The `s!`, `u!`, and `!` action
forms own configuration routing; module source directories do not.

The `dsl-module-contract` check is structural and non-activating. It requires:

1. Exactly 70 ZMDL sources are discovered and compiled.
2. Every source path, module path, option path, and canonical identity is unique.
3. Every compiler record maps `modules/<path>.zmdl` to identity and option path
   `zenos.<path>`.
4. Every generated Nix file passes `nix-instantiate --parse`.

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

Run the non-activation contract and then the complete flake checks in a ZenOS
VM. Until the checked-in `zenos-next` input is advanced to the companion
path-derived compiler revision that emits `zenlang.bundle/2` and
`zenlang.semantic/2`, override it with the local checkout:

```bash
nix build path:/home/doromiert/Projects/zenpkgs#checks.x86_64-linux.dsl-module-contract --override-input zenos-next path:/home/doromiert/Projects/zenos-next --no-link --print-build-logs
nix flake check path:/home/doromiert/Projects/zenpkgs --override-input zenos-next path:/home/doromiert/Projects/zenos-next --print-build-logs
```
