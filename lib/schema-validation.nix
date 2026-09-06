# Trusted context export, separate from checking untrusted ZCFG. Pass the SAME
# bundle and packageTree used by zstr-runtime.moduleFromBundle, and its evaluated
# module result. No original defaults, config values, action bodies or descriptions
# are read. Only literal request data enters an isolated lib.evalModules type check.
# Do not include the ZCFG being checked in evaluated: its only input here must be
# data from `zen-dsl schema-requests host.zcfg`, never compiled ZCFG expressions.
# Export with `nix eval --json --file context.nix`, where context.nix returns
# `import ./lib/schema-validation.nix { inherit lib; } { inherit evaluated bundle packageTree requests; }`.
# The consumer is `zen-dsl validate host.zcfg --schema schema.json`. This bounded
# internal context is not the legacy search index, nor a full-inference claim.
# Requests are { path = [ ... ]; } with optional literal `value` descriptors.
# Exact queries take priority over root; requested branches do not export their
# descendants. With no requests, root retains the bounded generic export.
{ lib }:
{ evaluated, bundle, packageTree, requests ? [ ], maxDepth ? 12, packageDepth ? 4 }:
let
  unsupported = reason: { kind = "unsupported"; inherit reason; };
  adapter = import ./dsl-bundle.nix { inherit lib; };
  option = path: type: annotation: {
    kind = "option";
    inherit annotation;
    typeName = type.name;
    checks = checkLiterals type (builtins.filter (request: request.path == path && request ? value) requests);
  };
  # Names alone are not type identity: addCheck can retain the original name.
  # Use the actual option type and module checker, not a second type checker.
  checkLiterals = type: selected: map (request: let
      value = adapter.decodeValue request.value;
      result = attempt (assert type.check value; (lib.evalModules {
        modules = [ {
          options.value = lib.mkOption { inherit type; };
          config.value = value;
        } ];
      }).config.value);
    in { inherit (request) value; status = if result.success then "accepted" else "rejected"; }) selected;
  branch = children: freeform: { kind = "branch"; inherit children freeform; };
  attempt = value: builtins.tryEval (builtins.deepSeq value value);
  clean = tree: builtins.removeAttrs tree [ "_module" "_freeformOptions" ];

  # These annotations identify the supported data shapes, not check identity.
  # Unknown shapes, functions and coercions are not widened to any.
  annotation = fuel: type:
    if fuel == 0 then null else
    let
      name = type.name or "unknown";
      nested = type.nestedTypes or { };
      primitives = { bool = "bool"; str = "string"; int = "int"; float = "float"; path = "path"; attrs = "set"; };
      wrap = name: types:
        if builtins.any (x: x == null) types then null
        else "$type.${name} [ ${lib.concatMapStringsSep " " (x: "(${x})") types} ]";
    in
    if builtins.hasAttr name primitives then "$type.${primitives.${name}}"
    else if lib.hasPrefix "strMatching " name then "$type.string"
    else if name == "enum" then
      let values = type.functor.payload.values or [ ]; in
      if values == [ ] || !builtins.all builtins.isString values then null
      else "$type.enum [ ${lib.concatMapStringsSep " " (v: lib.replaceStrings [ "\${" ] [ "\\\${" ] (builtins.toJSON v)) values} ]"
    else if name == "listOf" then wrap "list" [ (annotation (fuel - 1) nested.elemType) ]
    else if builtins.elem name [ "attrsOf" "lazyAttrsOf" ] then wrap "set" [ (annotation (fuel - 1) nested.elemType) ]
    else if name == "nullOr" then wrap "either" [ "$type.null" (annotation (fuel - 1) nested.elemType) ]
    else if name == "either" then wrap "either" [ (annotation (fuel - 1) nested.left) (annotation (fuel - 1) nested.right) ]
    else null;

  packages = depth: path: tree:
    if depth == 0 then unsupported "package depth limit" else
    let result = attempt (
      if !builtins.isAttrs tree then unsupported "not a package or package set"
      else if lib.isDerivation tree then option path lib.types.bool "$type.bool"
      else branch (lib.mapAttrs (key: child: packages (depth - 1) (path ++ [ key ]) child) tree) null
    ); in if result.success then result.value else unsupported "package schema unavailable";

  walk = depth: path: tree:
    if depth == 0 then unsupported "option depth limit" else
    let result = attempt (
      if lib.isOption tree then typed depth path tree.type
      else branch (lib.mapAttrs (name: child: walk (depth - 1) (path ++ [ name ]) child) (clean tree)) null
    ); in if result.success then result.value else unsupported "option schema unavailable";

  typed = depth: path: type:
    if depth == 0 then unsupported "type depth limit" else
    let
      name = type.name or "unknown";
      nested = type.nestedTypes or { };
      simple = annotation depth type;
      raw = type.getSubOptions path;
      freeform =
        if nested ? freeformType then nested.freeformType
        else null;
      base = branch (lib.mapAttrs (key: child: walk (depth - 1) (path ++ [ key ]) child) (clean raw)) null;
    in
    if name == "zstr-package-selectors" then
      # The unbounded direct Nixpkgs universe includes recursive package sets.
      # Do not recreate the search adapter's traversal/filter policy here.
      let selected = packages packageDepth path (builtins.removeAttrs packageTree [ "legacy" ]); in
      selected // lib.optionalAttrs (selected.kind == "branch" && packageTree ? legacy) {
        children = selected.children // { legacy = unsupported "direct legacy package discovery requires an exact query"; };
      }
    else if name != "submodule" && nested ? coercedType && nested ? finalType then
      if nested.coercedType.name == "bool" && nested.finalType.name == "submodule" then
        (typed (depth - 1) path nested.finalType) // { shorthand = true; }
      else unsupported "unsupported coercion"
    else if simple != null then option path type simple
    else if builtins.elem name [ "attrsOf" "lazyAttrsOf" ] then
      branch { } (typed (depth - 1) (path ++ [ "<name>" ]) nested.elemType)
    else if name == "submodule" then base // {
      freeform = if freeform == null then null
        else if freeform.name == "zstr-upstream-mirror" then
          if clean (freeform.getSubOptions path) == { } then unsupported "alias has no discoverable child schema" else null
        else if builtins.elem freeform.name [ "attrsOf" "lazyAttrsOf" ] then
          typed (depth - 1) (path ++ [ "<name>" ]) freeform.nestedTypes.elemType
        else unsupported "unsupported submodule freeform type";
      children = lib.optionalAttrs (freeform != null && freeform.name == "zstr-upstream-mirror")
        (lib.mapAttrs (key: child: walk (depth - 1) (path ++ [ key ]) child) (clean (freeform.getSubOptions path)))
        // base.children;
    }
    else if name == "zstr-upstream-mirror" then
      if clean raw == { } then unsupported "alias has no discoverable child schema" else base
    else unsupported "unsupported runtime type: ${name}";

  found = node: { status = "found"; inherit node; };
  missing = { status = "missing"; };
  unavailable = reason: { status = "unsupported"; inherit reason; };
  unqueried = unsupported "unqueried schema coverage; request the exact path";
  selectedBranch = branch { } unqueried;
  protect = reason: value:
    let result = attempt value; in if result.success then result.value else unavailable reason;

  # Only the result is forced, never the schema tree or a package's attributes.
  # A branch query describes its shape, not discovery of all its descendants.
  queryPackages = depth: path: rest: tree:
    if depth == 0 then unavailable "package depth limit" else
    protect "package schema unavailable" (
      if tree == null then missing
      else if !builtins.isAttrs tree then unavailable "not a package or package set"
      else if lib.isDerivation tree then
        if rest == [ ] then found (option path lib.types.bool "$type.bool") else missing
      else if rest == [ ] then found selectedBranch
      else let key = builtins.head rest; in
        if !builtins.hasAttr key tree then missing
        else queryPackages (depth - 1) (path ++ [ key ]) (builtins.tail rest) tree.${key}
    );

  queryTree = depth: path: rest: tree:
    if depth == 0 then unavailable "option depth limit" else
    protect "option schema unavailable" (
      if lib.isOption tree then queryType depth path rest tree.type
      else if rest == [ ] then found selectedBranch
      else let key = builtins.head rest; in
        if !builtins.hasAttr key (clean tree) then missing
        else queryTree (depth - 1) (path ++ [ key ]) (builtins.tail rest) tree.${key}
    );

  queryType = depth: path: rest: type:
    if depth == 0 then unavailable "type depth limit" else
    let
      name = type.name or "unknown";
      nested = type.nestedTypes or { };
      simple = annotation depth type;
      # getSubOptions alone supplies a documentation placeholder for `name`.
      # Substitution retains the upstream submoduleWith arguments and evaluates
      # both declared options and the freeform type with the concrete key.
      concrete = type.substSubModules (type.getSubModules ++ [ {
        _module.args.name = if path == [ ] then "zenos" else lib.last path;
      } ]);
      raw = clean (concrete.getSubOptions path);
      freeform = concrete.nestedTypes.freeformType or null;
      key = builtins.head rest;
      child = element: queryType (depth - 1) (path ++ [ key ]) (builtins.tail rest) element;
      mirror = schema:
        let children = clean schema; in
        if children == { } then unavailable "alias has no discoverable child schema"
        else queryTree depth path rest children;
    in
    if name == "zstr-package-selectors" then
      queryPackages (lib.min depth packageDepth) path rest packageTree
    else if name != "submodule" && nested ? coercedType && nested ? finalType then
      if nested.coercedType.name == "bool" && nested.finalType.name == "submodule" then
        let result = queryType (depth - 1) path rest nested.finalType; in
        result // lib.optionalAttrs (rest == [ ] && result.status == "found") {
          node = result.node // { shorthand = true; };
        }
      else unavailable "unsupported coercion"
    else if name == "submodule" then
      if rest == [ ] then found selectedBranch
      else if builtins.hasAttr key raw then
        queryTree (depth - 1) (path ++ [ key ]) (builtins.tail rest) raw.${key}
      else if freeform == null then missing
      else if freeform.name == "zstr-upstream-mirror" then mirror (freeform.getSubOptions path)
      else if builtins.elem freeform.name [ "attrsOf" "lazyAttrsOf" ] then child freeform.nestedTypes.elemType
      else unavailable "unsupported submodule freeform type"
    else if name == "zstr-upstream-mirror" then mirror (type.getSubOptions path)
    # Element schemas cannot certify an enclosing value option's check or merge.
    # Even checking singleton records misses constraints on combined assignments.
    else if rest != [ ] && builtins.elem name [ "attrsOf" "lazyAttrsOf" "attrs" "either" "nullOr" ] then
      unavailable "traversal inside a value-typed option is unsupported; query its record value"
    else if simple != null then
      if rest == [ ] then found (option path type simple) else missing
    else if builtins.elem name [ "attrsOf" "lazyAttrsOf" ] && rest == [ ] then found selectedBranch
    else unavailable "unsupported runtime type: ${name}";

  queryPaths = lib.unique (map (request: request.path) requests);
  query = path: { inherit path; } // (
    if !(bundle.structure.present or false) then
      if path == [ ] then found (branch { } null) else missing
    else protect "option schema unavailable" (
      if !(evaluated.options ? zenos) then unavailable "evaluated context has no mounted zenos option"
      else queryTree maxDepth [ ] path evaluated.options.zenos
    )
  );
in
assert bundle.bundleVersion == "zenlang.bundle/2";
assert builtins.isList requests && builtins.length requests <= 4096 && builtins.all (request:
  builtins.isAttrs request && builtins.isList (request.path or null)
  && builtins.length request.path <= 64 && builtins.all builtins.isString request.path
  && (!(request ? value) || builtins.isAttrs request.value)
) requests;
assert builtins.isInt maxDepth && maxDepth > 0 && maxDepth <= 64;
assert builtins.isInt packageDepth && packageDepth >= 0 && packageDepth <= 64;
{
  encoding = "zenlang.schema-validation/1";
  schemaVersion = "1.0.0Na";
  zenosVersion = "1.0.0Na";
  # The existing no-ZSTR runtime bundle has no compiler version fields.
  grammarVersion = if bundle.structure.present or false then bundle.grammarVersion else bundle.grammarVersion or "1.0.0Na";
  irVersion = if bundle.structure.present or false then bundle.irVersion else bundle.irVersion or "1.0.0Na";
  bundleDigest = builtins.hashString "sha256" (builtins.toJSON bundle);
  inherit maxDepth packageDepth;
  queries = map query queryPaths;
  root = if !(bundle.structure.present or false) then branch { } null
    else if requests != [ ] then unqueried
    else if !(evaluated.options ? zenos) then unsupported "evaluated context has no mounted zenos option"
    else walk maxDepth [ ] evaluated.options.zenos;
}
