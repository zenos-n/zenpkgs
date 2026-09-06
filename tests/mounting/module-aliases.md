# Module-local typed alias acceptance

Run only in a ZenOS VM, from a private source snapshot. Set `PYTHONPATH` to
that snapshot's `lib/zen-dsl` and pass the pinned input source paths:

```sh
python3 tests/mounting/run-module-aliases.py --nixpkgs "$NIXPKGS" --home-manager "$HOME_MANAGER"
python3 tests/mounting/run.py --nixpkgs "$NIXPKGS" --home-manager "$HOME_MANAGER"
python3 -m unittest discover -s tests/zen-dsl/zenlang -p test_module_aliases.py -v
```

The alias runner checks module-root, named subtree and leaf aliases, lexical
freeform keys and shadowing, explicit system/user mounts, root exclusions,
action reads, list merges, definition priorities, unknown paths, invalid values,
no forwarded defaults, no exposure without ZSTR, and ambiguous collisions.
Its fixtures are independent of the existing mounting and production trees.

Supported ZMDL declarations use the same marker as ZSTR:

```zmdl
ssh._meta.type = (alias nixpkgs.services.openssh);
accounts = { (freeform account) = {
  login._meta.type = (alias nixpkgs.users.users.($f.account));
}; };
```

ZSTR must mount the declaring module. Targets are explicit absolute upstream
paths, not implicitly rebased by system/user mounting. Dynamic target segments
must reference lexical ZMDL freeform identifiers. Imported alias declarations
remain local to the importing module; importing does not mount the imported
module's independent filesystem identity.

Overlapping alias/local-child and independently owned mount declarations are
errors, with full paths and both source locations; disjoint local children remain
valid. Alias-local defaults/actions and ancestor defaults currently have explicit
unsupported-backend diagnostics rather than silently changing forwarding. Named
aliases inside freeforms work; aliases directly on freeform items are currently
rejected with a diagnostic. Root aliases retain their upstream value shape;
they do not synthesize a conflicting `enable` child. The older record-form
`(alias ...) = { ... };` remains descriptor-only and is rejected during mounting
because its execution semantics are unspecified. Standalone `compiledNix`
retains descriptors; executable alias options require `mountNix` and the ZSTR
runtime. Search provenance is outside this acceptance suite.
