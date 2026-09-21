<!-- BEGIN AGENT: lib-interface-nix -->
## AGENT: lib-interface-nix
agent type: code-monkey
exact single-file path scope: /home/doromiert/Projects/zenpkgs/lib/interface.nix
objective: Update the interface definition to match the source-of-truth conventions in /home/doromiert/Projects/zenos-n-next while preserving filesystem-derived package identity and validating the canonical roots desktops/system/theming/apps/libs/dev.
ordered changes:
1. Inspect the existing interface implementation and the corresponding source-of-truth interface/package structure in /home/doromiert/Projects/zenos-n-next.
2. Align /home/doromiert/Projects/zenpkgs/lib/interface.nix with the source-of-truth behavior and canonical root validation.
3. Ensure package identity continues to be derived from the filesystem; do not introduce authored IDs or aliases.
dependencies: Source-of-truth path /home/doromiert/Projects/zenos-n-next must be available; no other worker or file dependency.
inputs: Existing /home/doromiert/Projects/zenpkgs/lib/interface.nix and the relevant interface/package conventions under /home/doromiert/Projects/zenos-n-next.
outputs: The updated /home/doromiert/Projects/zenpkgs/lib/interface.nix only.
verification: Run focused checks for the interface file and its canonical-root behavior, including desktops, system, theming, apps, libs, and dev; verify filesystem-derived identity and confirm no authored IDs or aliases were added.
forbidden scope: Do not modify any file other than /home/doromiert/Projects/zenpkgs/lib/interface.nix; do not alter configuration, add authored package IDs, add aliases, refactor unrelated behavior, or broaden canonical roots beyond desktops/system/theming/apps/libs/dev.
<!-- END AGENT: lib-interface-nix -->
