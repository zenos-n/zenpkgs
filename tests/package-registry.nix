{
  expectedRegistry,
  interface,
  lib,
  pkgs,
  publicPackages,
  registry,
}:

let
  normalize = value: interface.registryDocs value;
  pathKey = entry: lib.concatStringsSep "/" entry.target;
  sortPackages = value: value // { packages = lib.sort (left: right: pathKey left < pathKey right) value.packages; };
  actual = normalize (sortPackages registry);
  expected = normalize (sortPackages expectedRegistry);
  expectedSorted = sortPackages expectedRegistry;
  activeEntries = builtins.filter (entry: entry.status == "active") registry.packages;
  expectedActiveEntries = builtins.filter (entry: entry.status == "active") expectedRegistry.packages;
  registryPaths =
    value:
    map (entry: {
      inherit (entry)
        aliases
        id
        sourcePath
        target
        ;
    }) (sortPackages value).packages;
  packagePaths = value: lib.concatMap (entry: [ entry.target ] ++ entry.aliases) value.packages;
  activePaths = lib.concatMap (entry: [ entry.target ] ++ entry.aliases) activeEntries;
  registryPathKeys = map pathKey registry.packages;
  outputName = path: lib.concatStringsSep "-" ([ "zenos" ] ++ path);
  outputIdentities = lib.concatMap (
    entry:
    map (
      path:
      let
        upstream = lib.attrByPath entry.sourcePath null pkgs;
        overlayPackage = lib.attrByPath ([ "zenos" ] ++ path) null pkgs;
        publicPackage = publicPackages.${outputName path} or null;
      in
      upstream != null
      && overlayPackage != null
      && publicPackage != null
      && overlayPackage.drvPath == upstream.drvPath
      && overlayPackage.outPath == upstream.outPath
      && publicPackage.drvPath == upstream.drvPath
      && publicPackage.outPath == upstream.outPath
    ) ([ entry.target ] ++ entry.aliases)
  ) activeEntries;
  pass = name: pkgs.runCommand name { } "touch $out";
in
{
  registry-contract =
    assert builtins.toJSON actual == builtins.toJSON expected;
    pass "zenpkgs-package-registry-contract";

  registry-counts =
    assert builtins.length expectedRegistry.packages == 130;
    assert builtins.length expectedActiveEntries == 126;
    assert builtins.length registry.packages == 130;
    assert builtins.length activeEntries == 126;
    pass "zenpkgs-package-registry-counts";

  package-paths =
    assert builtins.length (registryPaths expectedRegistry) == 130;
    assert builtins.length (packagePaths expectedRegistry) == 256;
    assert builtins.length activePaths == 252;
    assert registryPathKeys == lib.sort builtins.lessThan registryPathKeys;
    assert registryPaths registry == registryPaths expectedRegistry;
    assert packagePaths registry == packagePaths expectedSorted;
    pass "zenpkgs-package-registry-paths";

  public-package-outputs =
    assert builtins.length outputIdentities == 252;
    assert lib.all (identity: identity) outputIdentities;
    pass "zenpkgs-public-package-outputs";
}
