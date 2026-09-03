# ZenPkgs

The Nix packages repository for ZenOS.

Curated nixpkgs interfaces are declared in `dsl/packages/*.zpkg`. The flake
compiles that tree in interface mode and compares the candidate registry with
the legacy Nix registry before it can replace the live package namespace.

During shadow parity, package mapping contributors must update both the `.zpkg`
declaration and its matching `mappings/packages.nix` entry in the same commit.
After cutover, `.zpkg` becomes the only package declaration source. See
[metadata guidelines.md](metadata%20guidelines.md) for the schema and validation
commands.

The shadow bundle uses Nix import-from-derivation so generated compiler output
stays in the store instead of the repository. Evaluators and CI must allow IFD
until ZenOS provides a native evaluator plugin or another non-IFD compiler
boundary.
