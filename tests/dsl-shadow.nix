{
  candidateRegistry,
  interface,
  legacyRegistry,
  lib,
  pkgs,
}:

let
  normalize = registry: interface.registryDocs registry;
  pathString = path: lib.concatStringsSep "." path;
  packagePaths =
    registry:
    lib.sort builtins.lessThan (
      lib.concatMap (entry: map pathString ([ entry.target ] ++ entry.aliases)) registry.packages
    );
  packageContract =
    registry:
    map (entry: {
      inherit (entry)
        aliases
        id
        meta
        sourcePath
        status
        target
        ;
    }) registry.packages;
  candidateTree = interface.buildPackageTree pkgs candidateRegistry;
  activeLegacy = builtins.filter (entry: entry.status == "active") legacyRegistry.packages;
  expectedIdentityCount = lib.foldl' (
    count: entry: count + 1 + builtins.length entry.aliases
  ) 0 activeLegacy;
  activeIdentities = lib.concatMap (
    entry:
    map (
      path:
      let
        legacyPackage = lib.attrByPath ([ "zenos" ] ++ path) null pkgs;
        candidatePackage = lib.attrByPath path null candidateTree;
      in
      legacyPackage != null
      && candidatePackage != null
      && legacyPackage.drvPath == candidatePackage.drvPath
      && legacyPackage.outPath == candidatePackage.outPath
    ) ([ entry.target ] ++ entry.aliases)
  ) activeLegacy;
  pass = name: pkgs.runCommand name { } "touch $out";
in
{
  registry =
    assert builtins.toJSON (normalize candidateRegistry) == builtins.toJSON (normalize legacyRegistry);
    pass "zenpkgs-dsl-registry-parity";
  package-paths =
    assert packagePaths candidateRegistry == packagePaths legacyRegistry;
    pass "zenpkgs-dsl-package-paths-parity";
  package-contract =
    assert packageContract candidateRegistry == packageContract legacyRegistry;
    pass "zenpkgs-dsl-package-contract-parity";
  active-identities =
    assert builtins.length activeIdentities == expectedIdentityCount;
    assert lib.all (identity: identity) activeIdentities;
    pass "zenpkgs-dsl-active-identities-parity";
}
