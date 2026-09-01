{ lib }:

let
  activeEntries = registry: builtins.filter (entry: entry.status == "active") registry.packages;

  duplicateValues =
    values:
    builtins.filter (
      value: builtins.length (builtins.filter (candidate: candidate == value) values) > 1
    ) (lib.unique values);

  pathString = path: lib.concatStringsSep "." path;

  validate =
    registry:
    let
      entries = registry.packages;
      ids = map (entry: entry.id) entries;
      targets = map (entry: pathString entry.target) entries;
      aliases = lib.concatMap (entry: map pathString entry.aliases) entries;
      statusesValid = lib.all (
        entry:
        builtins.elem entry.status [
          "active"
          "unavailable"
          "deprecated"
        ]
      ) entries;
      activeValid = lib.all (
        entry: entry.status != "active" || (entry.sourcePath != null && entry.aliases != [ ])
      ) entries;
    in
    assert registry.schemaVersion == 1;
    assert duplicateValues ids == [ ];
    assert duplicateValues targets == [ ];
    assert duplicateValues aliases == [ ];
    assert lib.intersectLists targets aliases == [ ];
    assert statusesValid;
    assert activeValid;
    registry;

  decorate =
    entry: package:
    package
    // {
      meta = (package.meta or { }) // {
        zenos = entry.meta // {
          registryId = entry.id;
          inherit (entry)
            aliases
            sourcePath
            status
            target
            ;
          legacyPath = entry.sourcePath;
        };
      };
      passthru = (package.passthru or { }) // {
        zenosRegistry = entry.id;
        zenosMetadata = entry.meta;
      };
      _zmeta = {
        schemaVersion = 1;
        mode = "interface";
        interface = {
          from = "nixpkgs";
          path = entry.sourcePath;
        };
        inherit (entry)
          aliases
          id
          status
          target
          ;
        inherit (entry) meta;
      };
    };

  resolve =
    pkgs: entry:
    let
      package = lib.attrByPath entry.sourcePath null pkgs;
    in
    if package == null then
      throw "ZenPkgs interface '${entry.id}' cannot resolve nixpkgs.${pathString entry.sourcePath}"
    else if !lib.isDerivation package then
      throw "ZenPkgs interface '${entry.id}' did not resolve to a derivation"
    else
      decorate entry package;

  addEntry =
    pkgs: tree: entry:
    let
      package = resolve pkgs entry;
      paths = [ entry.target ] ++ entry.aliases;
    in
    lib.foldl' (result: path: lib.recursiveUpdate result (lib.setAttrByPath path package)) tree paths;
in
rec {
  buildPackageTree =
    pkgs: registry: lib.foldl' (addEntry pkgs) { } (activeEntries (validate registry));

  registryDocs =
    registry:
    let
      checked = validate registry;
    in
    {
      inherit (checked) schemaVersion;
      packages = map (entry: {
        inherit (entry)
          id
          target
          aliases
          sourcePath
          status
          meta
          ;
      }) checked.packages;
    };

  mkOptionModule = mappings: {
    imports = map (entry: lib.mkAliasOptionModule entry.target entry.legacyPath) mappings;
  };

  mkCheck =
    {
      pkgs,
      registry,
      name,
    }:
    let
      checked = validate registry;
      entries = activeEntries checked;
      identities = map (
        entry:
        let
          upstream = lib.attrByPath entry.sourcePath null pkgs;
          wrapped = lib.attrByPath ([ "zenos" ] ++ entry.target) null pkgs;
        in
        assert upstream != null;
        assert wrapped != null;
        assert wrapped.drvPath == upstream.drvPath;
        assert wrapped.outPath == upstream.outPath;
        true
      ) entries;
    in
    assert lib.all (value: value) identities;
    pkgs.runCommand name { } ''
      cat > "$out" <<'EOF'
      ${builtins.toJSON (registryDocs checked)}
      EOF
    '';
}
