<!-- BEGIN AGENT: structure-zstr -->
## AGENT: structure-zstr
Agent type: code-monkey
Exact single-file path scope: /home/doromiert/Projects/zenpkgs/structure.zstr

Objective: Rework structure.zstr so zenpkgs follows the current taxonomy and exposure model from /home/doromiert/Projects/zenos-n-next, replacing the rushed current layout.

Ordered changes:
1. Use /home/doromiert/Projects/zenos-n-next as the source of truth for the structure and package organization.
2. Define the required taxonomy roots: desktops, system, theming, apps, libs, and dev.
3. Preserve filesystem-derived package identity.
4. Make structure.zstr control package exposure.
5. Ensure there are no physical legacy or programs roots in the resulting layout.
6. Keep all changes confined to structure.zstr.

Dependencies: The source-of-truth repository at /home/doromiert/Projects/zenos-n-next and the existing structure.zstr contents; Git checkpoint cdde34b5ada34119860fee21d9bc9838ed66ad8c is the rollback/reference checkpoint.

Inputs: /home/doromiert/Projects/zenos-n-next; current /home/doromiert/Projects/zenpkgs/structure.zstr; required roots desktops, system, theming, apps, libs, dev; filesystem-derived package identity; exposure controlled by structure.zstr; prohibition on physical legacy and programs roots.

Outputs: Updated /home/doromiert/Projects/zenpkgs/structure.zstr implementing the required taxonomy, identity, and exposure behavior.

Verification: Validate structure.zstr syntax using the repository's available validator or parser; verify mount behavior and confirm the mounted/exposed package paths use the six required roots, derive package identity from the filesystem, and do not create physical legacy or programs roots.

Forbidden scope: Do not edit any file other than /home/doromiert/Projects/zenpkgs/structure.zstr; do not change repository configuration, source-of-truth files, package contents, mount tooling, or Git history; do not introduce physical legacy or programs roots; do not widen the taxonomy beyond the stated requirements without evidence from the source of truth.
<!-- END AGENT: structure-zstr -->
