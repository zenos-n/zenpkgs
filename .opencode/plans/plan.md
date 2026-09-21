<!-- BEGIN AGENT: burn-my-windows-zpkg -->
## AGENT: burn-my-windows-zpkg
agent type: code-monkey-lite
exact single-file path scope: `/home/doromiert/Projects/zenpkgs/pkgs/apps/gnome-extensions/burn-my-windows.zpkg`; permitted rename destination: `/home/doromiert/Projects/zenpkgs/pkgs/desktops/gnome/extensions/burn-my-windows.zpkg`
objective: Update or relocate the burn-my-windows package using `/home/doromiert/Projects/zenos-n-next` as the source of truth while preserving its provider and filesystem-derived package identity.
ordered changes:
1. Compare the assigned package file against the corresponding source-of-truth package in `/home/doromiert/Projects/zenos-n-next` and determine the required package content or location change.
2. Apply only the required change to the single owned package file; if relocation is required, move it to the permitted destination path without changing its provider.
3. Keep package identity derived from the resulting filesystem path and avoid unrelated formatting or metadata changes.
dependencies: Source-of-truth files under `/home/doromiert/Projects/zenos-n-next` must be available; no other worker dependencies.
inputs: Existing package at `/home/doromiert/Projects/zenpkgs/pkgs/apps/gnome-extensions/burn-my-windows.zpkg`; source of truth at `/home/doromiert/Projects/zenos-n-next`; permitted destination `/home/doromiert/Projects/zenpkgs/pkgs/desktops/gnome/extensions/burn-my-windows.zpkg`.
outputs: The corrected `burn-my-windows.zpkg` at the existing path or permitted destination, with provider unchanged and filesystem-derived identity preserved.
verification: Run focused syntax verification for the resulting `burn-my-windows.zpkg`; confirm the provider is unchanged and report the exact resulting path.
forbidden scope: Do not edit, create, delete, or move any other file; do not modify the provider; do not alter package identity independently of the filesystem path; do not change configuration, tests, or unrelated package metadata.
<!-- END AGENT: burn-my-windows-zpkg -->
