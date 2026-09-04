# Transitional Compatibility Code

This directory contains the pre-DSL Nix implementations retained only while
their canonical ZMDL and ZPKG declarations reach behavioral parity.

Rules:

- Do not add new public modules, packages, aliases, or source payloads here.
- Do not expose this directory as a second contributor-facing module or package
  tree.
- Only the tested core, GNOME base, user-action backend, and system bridges are
  part of `nixosModules.default`; optional compatibility modules remain outside
  the default graph until their canonical ZMDL replacements pass parity.
- New functionality must be authored in `modules/` or `pkgs/` and package
  implementation code and assets must live in the package's external source
  repository.
- Remove each compatibility implementation after its canonical declaration
  passes unit, evaluation, and ZenOS VM parity tests.
- The remaining Dash Stacks patches must move to that package's external source
  repository before its compatibility recipe can be removed.

The target state is deletion of this entire directory.
