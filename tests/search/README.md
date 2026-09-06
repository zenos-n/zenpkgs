# Search export foundation

Run integration acceptance inside a ZenOS VM. The exporter command is unchanged:

```sh
nix eval --json --file scripts/gen-docs.nix
```

It evaluates `nixosModules.default`, including its ZSTR bundle, Home Manager,
Disko, and production package overlay. It reads `evaluated.options.zenos` and
`evaluated.pkgs.zenos`, not the compatibility loader or flattened flake packages.
No fabricated config users, stub upstream roots, or per-root option maps are used.
The `path:` flake reference includes untracked files in a development checkout.
Flake inputs must be available and import-from-derivation must be enabled; bundle
compilation may build the compiler, but exporting does not build a system closure.

## Encoding

This is the explicitly labeled `zenpkgs-search/meta-sub` adapter, not the final
Lookup `m`/`c` and flat `packages` format. Top-level `options`, hierarchical `pkgs`,
and `maintainers` are retained for the current client. `metadata` adds encoding,
revision, diagnostic, and limit information. No web client changes are included.
The path of every package remains `pkgs.<full.path>`; `legacy` records are marked
`upstream = true` and are not ZPKGs. Unknown versions are null, not made up.
`type` retains basic client categories and structured enum values; `typeName`
and `typeDescription` preserve the evaluated Nix type. Package-selector options
reference the shared hierarchy with `meta.packageTree = "pkgs"`; the runtime
does not expose a separate per-package option schema through `getSubOptions`.

`meta.defaultStatus` distinguishes `value`, `documented`, `absent`, and
`unavailable`. A documented default preserves `defaultText` (including literal
expression records); it is never copied into `default`. Only scalar defaults of
plain bool/int/float/str/enum types are attempted. Container, function, package,
wrapped-type, throwing, and placeholder-dependent defaults remain unavailable.
The runtime's upstream mirrors deliberately discard upstream defaults; this
export does not invent replacements for them. `default = null` alone must not
be interpreted as a known null default. Examples are bounded data, not executed.

Descriptive metadata comes from the compiler's data IR and package metadata.
ZMDL nodes use the compiler's effective `nodeMetadata` records, rebased at every
mount, including user and freeform placeholders. Inherited `zenosVersion` values
and explicit child overrides are preserved without reconstructing inheritance.
Only node-local attribution is used: branch maintainers/licenses never propagate
to upstream children. A missing authored license is not replaced with an assumed
license. The index retains compiler node warnings, full original source/line/
column and message, and each mounted location (including multiple mounts of one
module). These diagnostics are data in `metadata.warnings`, not hidden. The
adapter does not independently revalidate the compiler's metadata contract.
Descriptive metadata expressions the data decoder cannot resolve remain null.

## Traversal Limits

`lib/search-index.nix` exports `mkIndex`, `serializeOptions`, `serializePackages`,
and `defaultLimits`. Tests and consumers can select a small subtree before JSON
serialization. The returned children stay lazy; option siblings are not traversed
to prune empty nodes. Package enumeration checks sibling shape but does not
serialize sibling metadata or recurse into their children.

- Options: 16 public path segments and 5 option-type expansions. The type budget
  resets at each actual bundle mount; it does not reset on recursive upstream
  submodules. Same-named path segments are not mistaken for recursion.
- Type wrappers: at most 8 unwrap/inline steps per expansion. Attr collections
  use `<name>` and lists use `*`. Submodule freeform schemas are expanded, with
  explicit mounted children taking precedence over upstream children.
  Alias roots, including submodules with a mirror freeform type, are upstream.
  Mirrored children inherit upstream provenance; declared local children and
  mounts replace that provenance along with the schema. A local collection is
  not upstream just because its element schema is an alias.
- Packages: 16 levels locally, 2 beneath `pkgs.legacy`. Derivations at the
  boundary are still emitted, but deeper package sets are marked `depth-limit`.
- Legacy package universes beginning with `pkgs`, plus `buildPackages`,
  `targetPackages`, `lib`, `stdenv`, `nixos`, `nixosTests`, `testers`, `tests`,
  `releaseTools`, `source`, `src`, and `modules`, are excluded. Internal `_` names
  and package helper functions are not searchable nodes.
- Catchable schema/package failures retain an `unavailable` node. Depth stops
  retain a `depth-limit` node. `complete` describes only that node's expansion,
  not its entire subtree; `metadata.complete` is always false for this bounded
  export. Nix `tryEval` cannot catch `abort`, all evaluator errors, or divergence.
  These limits are not a time/memory sandbox for arbitrary upstream evaluation.
- Metadata/examples permit 6 data levels and 64 entries per list/attribute set.
  Derivations and functions are rejected rather than coerced to store paths.

## Focused Checks

From the VM checkout, run the synthetic compiled bundle and serializer checks:

```sh
nix build --impure --no-link --print-out-paths --expr '
  let f = builtins.getFlake ("path:" + toString ./.); in
  import ./tests/search/check.nix {
    nixpkgs = f.inputs.nixpkgs;
    home-manager = f.inputs.home-manager;
    bootstrapPkgs = import f.inputs.nixpkgs { system = "x86_64-linux"; };
  }'
nix eval --impure --json --expr 'import ./tests/search/production.nix {}'
nix eval --json --file tests/search/no-structure.nix
```

The synthetic bundle checks relocated mounts, inherited and overridden versions,
node-local attribution, dynamically added upstream options,
NixOS/user/Home Manager and Syncthing alias roots and descendants, local children
overlaid on mirrors, and a local `legacy.homeManager` mount replacing an upstream
child. Mounted overrides retain compiler `nodeMetadata`, including inherited
versions and node-local attribution. Serializer checks cover direct and wrapped
mirrors, alias collection elements, and unavailable/depth-limited alias roots.
The bundle also checks freeforms, package hierarchy and universe
exclusions, diagnostics, defaults, type wrappers, recursion stops, and small
fully serialized samples. Production checks select representative real paths and
serialize only a program, package, and upstream option. The no-structure check
imports the real script from a filtered production source without root ZSTR.
None of these checks claim that the entire upstream index was serialized or that
module activation/runtime behavior was tested.

## Flake Hooks

The flake owner can add these entries to `checks.${system}`; no flake edit is part
of this change. `dsl.bootstrapPkgs`, `nixpkgs`, and `inputs` already exist there:

```nix
search-index = import ./tests/search/check.nix {
  inherit (dsl) bootstrapPkgs;
  inherit nixpkgs;
  home-manager = inputs.home-manager;
};
```

Keep the production and no-structure commands as VM acceptance steps. A pure
flake hook for production should pass an `index` to `tests/search/production.nix`
built with `search.mkIndex`, `self.lib.dslBundleFor system`, and a `nixosSystem`
evaluation importing `self.nixosModules.default`; do not call `getFlake` on an
unlocked working path inside a pure flake check. Build the resulting report using
`bootstrapPkgs.writeText` and `builtins.toJSON`.
