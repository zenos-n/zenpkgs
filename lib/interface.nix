{ lib }:

let
  activeEntries = registry: registry.packages;

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
      entriesValid = lib.all (entry: entry.sourcePath != null) entries;
    in
    assert registry.schemaVersion == 1;
    assert duplicateValues ids == [ ];
    assert duplicateValues targets == [ ];
    assert entriesValid;
    registry;

  decorate =
    entry: package:
    package
    // {
      meta = (package.meta or { }) // {
        zenos = entry.meta // {
          registryId = entry.id;
          inherit (entry)
            sourcePath
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
          id
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
    in
    lib.recursiveUpdate tree (lib.setAttrByPath entry.target package);
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
          sourcePath
          meta
          ;
      }) checked.packages;
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
