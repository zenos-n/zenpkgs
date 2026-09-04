# ZenOS Implementation Rules

Before editing this repository, read the relevant design in the sibling
`/home/doromiert/Projects/zenos-n-next` checkout. That repository is the
normative authority for ZenOS architecture and DSL behavior.

- Do not invent behavior when the design is missing or contradictory.
- Resolve the design in `zenos-n-next` first, then implement it here.
- The only non-dotfile root entries are `flake.nix`, `flake.lock`, `readme.md`,
  `AGENTS.md`, `LICENSE`, `structure.zstr`, `modules/`, `docs/`, `lib/`, `pkgs/`,
  `scripts/`, and `tests/`.
- The only dot entries are `.git/`, `.gitignore`, `.github/`, and `.vscode/`.
- Package and module identity must follow the documented filesystem mapping.
- `modules/` is the only public module tree. Do not create separate NixOS,
  Home Manager, program, user, or legacy module roots.
- Home Manager is an internal lowering backend for user-scoped actions, not a
  separate ZenOS config or module API.
- Transitional backend implementations belong only under `lib/compat/` and
  must not be treated as contributor-facing module declarations.
- The canonical DSL compiler lives under `lib/`; its tests live under `tests/`.
- Package source and assets belong to one external repository per package.
- Runtime tests and integration acceptance must run in a ZenOS VM.
