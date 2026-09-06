{ lib }:

{
  checkLegacyOwnership =
    { registry, sourceTree }:
    let
      # Inspect the loader's source inventory, never import a recipe. Compare
      # segments so siblings containing hyphens or common text prefixes coexist.
      check =
        target: source:
        if builtins.isPath source then
          lib.all (
            entry:
            if
              lib.take (builtins.length target) entry.target == target
              || lib.take (builtins.length entry.target) target == entry.target
            then
              throw "ZenPkgs package ownership collision: pkgs/${lib.concatStringsSep "/" entry.target}.zpkg and compatibility recipe '${toString source}' at pkgs.zenos.${lib.concatStringsSep "." target}"
            else
              true
          ) registry.packages
        else if builtins.isAttrs source then
          lib.all (value: value) (
            lib.mapAttrsToList (name: child: check (target ++ [ name ]) child) source
          )
        else
          throw "ZenPkgs compatibility source inventory at pkgs.zenos.${lib.concatStringsSep "." target}: expected a recipe path or branch, got ${builtins.typeOf source}";
    in
    check [ ] sourceTree;

  # registry supplies canonical targets; tree is the corresponding package tree,
  # without the zenos prefix. Reserved public outputs are merged only after the
  # name-only check, so neither their values nor package derivations are forced.
  flatten =
    {
      registry,
      tree,
      reserved ? { },
    }:
    let
      entries = map (entry: {
        name = lib.concatStringsSep "-" ([ "zenos" ] ++ entry.target);
        owner = "pkgs/${lib.concatStringsSep "/" entry.target}.zpkg";
        value = lib.getAttrFromPath entry.target tree;
      }) registry.packages;
      owners = lib.foldl' (
        seen: entry:
        if builtins.hasAttr entry.name seen then
          throw "ZenPkgs package output collision for '${entry.name}': ${seen.${entry.name}} and ${entry.owner}"
        else
          seen // { ${entry.name} = entry.owner; }
      ) (lib.mapAttrs (name: _: "reserved public output '${name}'") reserved) entries;
    in
    builtins.seq owners (
      reserved // builtins.listToAttrs (map (entry: { inherit (entry) name value; }) entries)
    );
}
