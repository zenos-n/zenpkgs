{ lib }:

let
  pathString = path: lib.concatStringsSep "." path;
  validate = registry:
    let
      entries = registry.packages;
      ids = map (entry: entry.id) entries;
      paths = map (entry: builtins.toJSON entry.target) entries;
      categoryPaths = map (entry: builtins.toJSON entry.categoryTarget) entries;
      targetSet = builtins.listToAttrs (map (path: { name = path; value = true; }) paths);
      categorySet = builtins.listToAttrs (map (path: { name = path; value = true; }) categoryPaths);
      noAncestor = set: path:
        lib.all (length: !(builtins.hasAttr (builtins.toJSON (lib.take length path)) set))
          (lib.range 1 (builtins.length path - 1));
      validPath = path:
        builtins.isList path && path != [ ] && lib.all (segment:
          builtins.isString segment && builtins.match "^[A-Za-z0-9][A-Za-z0-9_-]*$" segment != null
        ) path;
      entriesValid = lib.all (entry:
        validPath entry.target
        && builtins.length entry.target >= 2
        && lib.all (segment: builtins.match "[A-Za-z][A-Za-z0-9_-]*" segment != null) entry.target
        && !(builtins.elem (builtins.head entry.target) [ "legacy" "byCategories" ])
        && validPath entry.categoryTarget
        && lib.last entry.categoryTarget != "package"
        && (entry.meta.id or null) == pathString entry.target
        && entry.id == "pkgs.${pathString entry.target}"
        && builtins.elem entry.provider.kind [ "import" "build" ]
        && builtins.isBool entry.dependenciesDeclared
        && (if entry.provider.kind == "import" then
          builtins.isList entry.sourcePath && entry.sourcePath != [ ]
          && lib.all (segment: builtins.isString segment && segment != "") entry.sourcePath
        else !(entry ? sourcePath))
        && noAncestor targetSet entry.target
        && noAncestor categorySet entry.categoryTarget
      ) entries;
    in
    assert registry.schemaVersion == 1;
    assert builtins.length (builtins.attrNames (builtins.listToAttrs (map (id: { name = id; value = true; }) ids))) == builtins.length ids;
    assert builtins.length (builtins.attrNames targetSet) == builtins.length paths;
    assert builtins.length (builtins.attrNames categorySet) == builtins.length categoryPaths;
    assert entriesValid;
    registry;

  decorate = entry: package: package // {
    meta = (package.meta or { }) // {
      zenos = entry.meta // {
        registryId = entry.id;
        inherit (entry) target categoryTarget provider dependenciesDeclared;
      } // lib.optionalAttrs (entry.provider.kind == "import") {
        inherit (entry) sourcePath;
        legacyPath = entry.sourcePath;
      };
    };
    passthru = (package.passthru or { }) // {
      zenosRegistry = entry.id;
      zenosMetadata = entry.meta;
    };
    _zmeta = {
      schemaVersion = 1;
      mode = "build";
      interface = entry.provider;
      inherit (entry) id target categoryTarget meta dependenciesDeclared;
    };
  };

  # Shape insertion never asks whether a package value is an attribute set.
  # recursiveUpdate would inspect sibling derivations while merging branches.
  insert = path: value: tree:
    let head = builtins.head path; tail = builtins.tail path;
    in tree // {
      ${head} = if tail == [ ] then value else insert tail value (tree.${head} or { });
    };
in
rec {
  buildPackageTreeWith = {
    pkgs,
    legacyPkgs,
    registry,
    buildPackage ? (entry: context: import entry.buildFile context),
    packageArgs ? { },
  }:
    let
      checked = validate registry;
      contextLib = packageArgs.lib or pkgs.lib or lib;
      context = packageArgs // {
        lib = contextLib;
        pkgs = pkgs // {
          # Insert only registry leaves; preserve existing siblings in each branch.
          zenos = publicTree // { legacy = legacyPkgs; };
        };
        zpkgRuntime = import ./zen-dsl/zenlang/zpkg-runtime.nix { lib = contextLib; pkgs = legacyPkgs; };
      };
      resolve = entry: builtins.addErrorContext "ZPKG ${entry.id} (${entry.location or "<registry>"})" (
        let package = buildPackage entry context;
        in if !lib.isDerivation package then
          throw "ZPKG ${entry.id}: compiled provider did not produce a derivation"
        else decorate entry package
      );
      canonicalTree = lib.foldl' (result: entry: insert entry.target (resolve entry) result) { } checked.packages;
      categoryTree = lib.foldl' (result: entry:
        insert entry.categoryTarget (lib.getAttrFromPath entry.target canonicalTree) result
      ) { } checked.packages;
      tree = canonicalTree // { byCategories = categoryTree; };
      # Keep compatibility siblings in the provider context only. Insert by
      # registry paths so constructing the context never inspects derivations.
      contextCategoryTree = lib.foldl' (result: entry:
        insert entry.categoryTarget (lib.getAttrFromPath entry.target canonicalTree) result
      ) (pkgs.zenos.byCategories or { }) checked.packages;
      publicTree = lib.foldl' (result: entry:
        insert entry.target (lib.getAttrFromPath entry.target tree) result
      ) ((pkgs.zenos or { }) // { byCategories = contextCategoryTree; }) checked.packages;
    in tree;

  buildPackageTree = pkgs: registry: buildPackageTreeWith {
    inherit pkgs registry;
    legacyPkgs = pkgs.zenos.legacy or pkgs;
  };

  registryDocs = registry:
    let checked = validate registry;
    in {
      inherit (checked) schemaVersion;
      packages = map (entry: {
        inherit (entry) id target categoryTarget provider dependenciesDeclared meta;
      } // lib.optionalAttrs (entry.provider.kind == "import") {
        inherit (entry) sourcePath;
      }) checked.packages;
    };

  mkCheck = { pkgs, registry, name }:
    let
      checked = validate registry;
      identities = map (entry:
        let
          wrapped = lib.attrByPath ([ "zenos" ] ++ entry.target) null pkgs;
          upstream = lib.attrByPath entry.sourcePath null (pkgs.zenos.legacy or pkgs);
          category = lib.attrByPath ([ "zenos" "byCategories" ] ++ entry.categoryTarget) null pkgs;
        in assert lib.isDerivation wrapped;
          assert lib.isDerivation category && category.drvPath == wrapped.drvPath && category.outPath == wrapped.outPath;
          assert entry.provider.kind != "import" || entry.dependenciesDeclared || (
            wrapped.drvPath == upstream.drvPath && wrapped.outPath == upstream.outPath
          );
          true
      ) checked.packages;
    in assert lib.all (value: value) identities;
      pkgs.runCommand name { } ''
        cat > "$out" <<'EOF'
        ${builtins.toJSON (registryDocs checked)}
        EOF
      '';
}
