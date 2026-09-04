{ lib }:

let
  duplicates = values: lib.filter (value: builtins.length (lib.filter (item: item == value) values) > 1) (lib.unique values);

  require = condition: message: value: if condition then value else throw "ZenPkgs DSL adapter: ${message}";

  canonicalSegments =
    {
      source,
      root,
      suffix,
      reservedLeaf,
    }:
    let
      prefix = "${root}/";
      locationValid =
        builtins.isString source.path
        && lib.hasPrefix prefix source.path
        && lib.hasSuffix suffix source.path;
      relative = lib.removeSuffix suffix (lib.removePrefix prefix source.path);
      segments = lib.splitString "/" relative;
      segmentsValid = lib.all (segment: builtins.match "^[A-Za-z0-9][A-Za-z0-9_-]*$" segment != null) segments;
      leaf = builtins.elemAt segments (builtins.length segments - 1);
    in
    require locationValid "noncanonical ${source.kind} source location: ${toString source.path}"
      (require (segments != [ ] && segmentsValid) "invalid ${source.kind} source path: ${source.path}"
        (require (leaf != reservedLeaf) "reserved ${source.kind} leaf name: ${source.path}" segments));

  canonicalSource =
    source:
    if source.kind == "zpkg" then
      let
        segments = canonicalSegments {
          inherit source;
          root = "pkgs";
          suffix = ".zpkg";
          reservedLeaf = "package";
        };
      in
      {
        inherit segments source;
        id = builtins.elemAt segments (builtins.length segments - 1);
        kind = "zpkg";
        target = segments;
      }
    else if source.kind == "zmdl" then
      let
        modulePath = canonicalSegments {
          inherit source;
          root = "modules";
          suffix = ".zmdl";
          reservedLeaf = "module";
        };
      in
      {
        inherit modulePath source;
        identity = lib.concatStringsSep "." ([ "zenos" ] ++ modulePath);
        kind = "zmdl";
      }
    else if source.kind == "zstr" then
      require (source.path == "structure.zstr") "structure must be repository-root structure.zstr" {
        inherit source;
        kind = "zstr";
      }
    else
      throw "ZenPkgs DSL adapter: unsupported repository DSL source: ${source.path}";

  canonicalSources =
    bundle:
    let
      sources = map canonicalSource bundle.sources;
      structures = builtins.filter (entry: entry.kind == "zstr") sources;
    in
    require (bundle.bundleVersion == "zenlang.bundle/2") "unsupported bundle version"
      (require (builtins.length structures == 1) "repository requires exactly one root structure.zstr"
        (builtins.deepSeq sources sources));

  pathFromDescriptor =
    segments:
    map (
      segment:
      if builtins.elem (segment.kind or null) [ "identifier" "string" ] then
        segment.value
      else
        throw "ZenPkgs DSL adapter requires static attribute paths"
    ) segments;

  decodeValue =
    value:
    if value.type == "literal" then
      value.value
    else if value.type == "string" then
      lib.concatMapStrings (
        part:
        if part.type == "text" then
          part.value
        else
          throw "ZenPkgs DSL adapter does not allow string interpolation"
      ) value.parts
    else if value.type == "list" then
      map decodeValue value.items
    else if value.type == "attr-set" then
      decodeAssignments value.statements
    else if value.type == "group" then
      decodeValue value.value
    else if value.type == "variable" then
      "${"$"}${value.name}${lib.optionalString (value.path != [ ]) ".${lib.concatStringsSep "." (pathFromDescriptor value.path)}"}"
    else
      throw "ZenPkgs DSL adapter cannot decode ${value.type or "an unknown value type"}"
    ;

  decodeAssignments =
    statements:
    lib.foldl' (
      result: statement:
      if statement.type != "assignment" || statement.operator != "=" then
        throw "ZenPkgs DSL adapter accepts only plain assignments"
      else
        lib.recursiveUpdate result (
          lib.setAttrByPath (pathFromDescriptor statement.target) (decodeValue statement.value)
        )
    ) { } statements;

  decodeInterface =
    descriptor:
    let
      metadata = lib.mapAttrs (_: decodeValue) descriptor.metadata;
      packageImport = descriptor.packageImport;
      importPath = pathFromDescriptor packageImport.path;
      dependencies = metadata.dependencies or { };
      normalizeMaintainer = value: lib.removePrefix "$m." value;
      meta = removeAttrs metadata [ "dependencies" ] // {
        packageVersion =
          if (metadata.packageVersion or "") == "" then
            metadata.zenosVersion
          else
            metadata.packageVersion;
        maintainers = map normalizeMaintainer (metadata.maintainers or [ ]);
        dependencies = {
          general = dependencies._general or [ ];
          build = dependencies._build or [ ];
          runtime = dependencies._runtime or [ ];
        };
      };
    in
    assert descriptor.descriptorVersion == "zenlang.semantic/2";
    assert descriptor.kind == "zpkg";
    assert descriptor.imports == [ ];
    assert packageImport.type == "variable";
    assert packageImport.name == "pkgs";
    assert builtins.length importPath >= 2;
    assert builtins.head importPath == "legacy";
    assert builtins.all (field: builtins.hasAttr field metadata) [
      "description"
      "maintainers"
      "name"
      "summary"
      "tags"
      "zenosVersion"
    ];
    {
      inherit meta;
      sourcePath = builtins.tail importPath;
    };

in
{
  inherit decodeInterface decodeValue;

  modulesFromBundle =
    {
      bundle,
      bundlePath,
    }:
    let
      sources = builtins.filter (source: source.kind == "zmdl") (canonicalSources bundle);
      moduleRecords =
        if bundle ? modules && builtins.isList bundle.modules then
          bundle.modules
        else
          throw "ZenPkgs DSL adapter: bundle has no path-derived module records";
      sourcePaths = map (entry: entry.source.path) sources;
      recordPaths = map (record: record.path or null) moduleRecords;
      optionPaths = map (record: builtins.toJSON (record.optionPath or null)) moduleRecords;
      identities = map (record: record.identity or null) moduleRecords;
      duplicateSources = duplicates sourcePaths;
      duplicateRecords = duplicates recordPaths;
      duplicatePaths = duplicates optionPaths;
      duplicateIdentities = duplicates identities;
      missingRecords = lib.subtractLists recordPaths sourcePaths;
      orphanRecords = lib.subtractLists sourcePaths recordPaths;

      candidateFor =
        canonical:
        let
          source = canonical.source;
          matches = builtins.filter (record: (record.path or null) == source.path) moduleRecords;
          record = require (builtins.length matches == 1)
            "module ${canonical.identity} must have exactly one compiler record"
            (builtins.head matches);
          expectedOptionPath = [ "zenos" ] ++ canonical.modulePath;
          identity = record.identity or null;
          module = bundlePath + "/modules/${source.path}.nix";
        in
        require (identity == canonical.identity)
          "module ${source.path} compiler identity must be ${canonical.identity}, got ${toString identity}"
          (require ((record.optionPath or null) == expectedOptionPath)
            "module ${source.path} compiler option path must be ${builtins.toJSON expectedOptionPath}"
            (require (source ? compiledNix && builtins.isString source.compiledNix && source.compiledNix != "")
              "module ${identity} has no compiled Nix"
              (require (builtins.pathExists module) "compiled module ${toString module} is missing" {
                inherit identity module;
                modulePath = canonical.modulePath;
                optionPath = record.optionPath;
                sourcePath = record.path;
              })));

      candidates = map candidateFor sources;
      validated =
        require (duplicateSources == [ ]) "duplicate ZMDL sources: ${builtins.toJSON duplicateSources}"
          (require (duplicateRecords == [ ]) "duplicate module records: ${builtins.toJSON duplicateRecords}"
            (require (duplicatePaths == [ ]) "duplicate module option paths: ${builtins.toJSON duplicatePaths}"
              (require (duplicateIdentities == [ ])
                "duplicate module identities: ${builtins.toJSON duplicateIdentities}"
                (require (missingRecords == [ ]) "ZMDL sources without module records: ${builtins.toJSON missingRecords}"
                  (require (orphanRecords == [ ]) "module records without ZMDL sources: ${builtins.toJSON orphanRecords}"
                    candidates)))));
    in
    validated;

  registryFromBundle =
    {
      bundle,
      bundlePath,
    }:
    let
      sources = builtins.filter (source: source.kind == "zpkg") (canonicalSources bundle);
      decoded = map (
        canonical:
        let
          source = canonical.source;
          entry = decodeInterface (import (bundlePath + "/interfaces/${source.path}.nix") { });
        in
        {
          inherit source;
          entry = entry // {
            id = canonical.id;
            target = canonical.target;
          };
        }
      ) sources;
      ordered = lib.sort (
        left: right:
        lib.concatStringsSep "/" left.entry.target < lib.concatStringsSep "/" right.entry.target
      ) decoded;
    in
    {
      schemaVersion = 1;
      packages = map (record: record.entry) ordered;
    };
}
