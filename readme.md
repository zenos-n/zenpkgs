# ZenPkgs

The Nix packages repository for ZenOS.

Curated nixpkgs interfaces are declared in `dsl/packages/*.zpkg`. The flake
compiles that tree in interface mode and uses the result for the overlay,
registry documentation, and flattened public package outputs. The 130-entry
normalized contract in `tests/fixtures/package-registry.json` protects the
126 active mappings and every declared target, alias, and nixpkgs source path.

The `.zpkg` files are the only package registry declaration source. See
[metadata guidelines.md](metadata%20guidelines.md) for the schema and validation
commands.

Package registry compilation uses Nix import-from-derivation (IFD), keeping
generated compiler output in the store instead of the repository. The compiler
is built with a clean, overlay-free nixpkgs bootstrap to avoid a circular
dependency. Evaluators and CI must allow IFD until ZenOS provides a native
evaluator plugin or another non-IFD compiler boundary.
