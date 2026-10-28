{ pkgs, registry }:
let
  lib = pkgs.lib;
  expected = builtins.fromJSON (builtins.readFile ./fixtures/migration-imports.json);
  byId = builtins.listToAttrs (map (entry: { name = entry.id; value = entry; }) registry.packages);
  matches = map (record:
    let
      entry = byId.${record.id};
      provider = lib.getAttrFromPath (lib.splitString "." record.source) pkgs.zenos.legacy;
      package = lib.getAttrFromPath entry.target pkgs.zenos;
      leaf = lib.last entry.categoryTarget;
    in entry.id == "pkgs.unknown.${leaf}"
      && entry.target == [ "unknown" leaf ]
      && entry.provider.kind == "import"
      && entry.sourcePath == lib.splitString "." record.source
      && package.drvPath == provider.drvPath && package.outPath == provider.outPath
      && (package.version or null) == (provider.version or null)
  ) expected;
in
assert builtins.length expected == 50;
assert lib.all (value: value) matches;
pkgs.runCommand "zenos-migration-import-providers" {} "touch $out"
