{ lib }:

let
  duplicates =
    values:
    lib.filter (value: builtins.length (lib.filter (item: item == value) values) > 1) (
      lib.unique values
    );

  require =
    condition: message: value:
    if condition then value else throw "ZenPkgs DSL adapter: ${message}";

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
      segmentsValid = lib.all (
        segment: builtins.match "^[A-Za-z0-9][A-Za-z0-9_-]*$" segment != null
      ) segments;
      leaf = builtins.elemAt segments (builtins.length segments - 1);
    in
    require locationValid "noncanonical ${source.kind} source location: ${toString source.path}" (
      require (segments != [ ] && segmentsValid) "invalid ${source.kind} source path: ${source.path}" (
        require (leaf != reservedLeaf) "reserved ${source.kind} leaf name: ${source.path}" segments
      )
    );

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
      require (builtins.head segments != "legacy") "pkgs/legacy is reserved for the virtual Nixpkgs view"
        {
          inherit segments source;
          id = lib.concatStringsSep "." ([ "pkgs" ] ++ segments);
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
      structures = builtins.filter (entry: entry.kind == "zstr") bundle.sources;
    in
    require (bundle.bundleVersion == "zenlang.bundle/2") "unsupported bundle version" (
      require (builtins.length structures <= 1) "repository permits only one root structure.zstr" (
        if structures == [ ] then [ ] else builtins.deepSeq sources sources
      )
    );

  pathFromDescriptor =
    segments:
    map (
      segment:
      if
        builtins.elem (segment.kind or null) [
          "identifier"
          "string"
        ]
      then
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
      "${"$"}${value.name}${
        lib.optionalString (
          value.path != [ ]
        ) ".${lib.concatStringsSep "." (pathFromDescriptor value.path)}"
      }"
    else
      throw "ZenPkgs DSL adapter cannot decode ${value.type or "an unknown value type"}";

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

  decodeDependencies = value:
    if value.type == "group" then decodeDependencies value.value
    else if value.type == "variable" && value.name == "pkgs" then {
      namespace = "pkgs";
      path = pathFromDescriptor value.path;
    }
    else if value.type == "list" then map decodeDependencies value.items
    else if value.type == "attr-set" then lib.foldl' (result: statement:
      require (statement.type == "assignment" && statement.operator == "=")
        "dependencies require plain scope assignments"
        (lib.recursiveUpdate result (lib.setAttrByPath (pathFromDescriptor statement.target)
          (decodeDependencies statement.value)))
    ) { } value.statements
    else throw "ZenPkgs DSL adapter: dependencies require structured package references";

  decodeInterfaceAt =
    identity: location: descriptor:
    let
      metadata = lib.mapAttrs (name: if name == "dependencies" then decodeDependencies else decodeValue)
        (descriptor.metadata or { });
      provider = descriptor.provider;
      packageImport = provider.expression;
      importPath = if provider.kind == "import" then pathFromDescriptor packageImport.path else [ ];
      dependenciesDeclared = descriptor.dependenciesDeclared;
      dependencies = metadata.dependencies or { };
      defaults = {
        name = "";
        summary = "";
        description = "";
        tags = [ ];
        maintainers = [ ];
        license = null;
        zenosVersion = "";
      };
      missing = builtins.filter (field: !(builtins.hasAttr field metadata)) (builtins.attrNames defaults);
      emptyDescriptions =
        builtins.filter
          (
            field:
            builtins.hasAttr field metadata
            && builtins.isString metadata.${field}
            && builtins.match "[[:space:]]*" metadata.${field} != null
          )
          [
            "name"
            "summary"
            "description"
          ];
      unknown = lib.subtractLists (
        (builtins.attrNames defaults)
        ++ [
          "dependencies"
          "packageVersion"
          "weight"
        ]
      ) (builtins.attrNames metadata);
      warnings =
        lib.optional (!(descriptor ? metadata) || descriptor.metadata == { }) "missing _meta"
        ++ map (field: "missing _meta.${field}") missing
        ++ map (field: "empty _meta.${field}") emptyDescriptions
        ++ map (
          field:
          "unknown _meta.${field}"
          + lib.optionalString (builtins.hasAttr (lib.removePrefix "_" field) defaults) "; use _meta.${lib.removePrefix "_" field}"
        ) unknown;
      normalizeMaintainer = value: lib.removePrefix "$m." value;
      meta =
        defaults
        // metadata
        // {
          packageVersion =
            if (metadata.packageVersion or "") == "" then
              metadata.zenosVersion or ""
            else
              metadata.packageVersion;
          maintainers = map normalizeMaintainer (metadata.maintainers or [ ]);
        }
        // lib.optionalAttrs dependenciesDeclared {
          dependencies = {
            general = dependencies.general or [ ];
            build = dependencies.build or [ ];
            runtime = dependencies.runtime or [ ];
          };
        };
    in
    assert descriptor.descriptorVersion == "zenlang.semantic/2";
    assert descriptor.kind == "zpkg";
    assert builtins.elem provider.kind [ "import" "build" ];
    assert provider.kind != "import" || (
      packageImport.type == "variable" && packageImport.name == "pkgs"
      && builtins.length importPath >= 2 && builtins.head importPath == "legacy"
    );
    assert builtins.isBool dependenciesDeclared && dependenciesDeclared == (metadata ? dependencies);
    assert builtins.isAttrs (descriptor.metadata or { });
    assert lib.all (field: !(metadata ? ${field}) || builtins.isString metadata.${field}) [
      "name"
      "summary"
      "description"
      "zenosVersion"
      "packageVersion"
    ];
    assert lib.all
      (
        field:
        !(metadata ? ${field})
        || (builtins.isList metadata.${field} && lib.all builtins.isString metadata.${field})
      )
      [
        "tags"
        "maintainers"
      ];
    assert !(metadata ? license) || builtins.isString metadata.license;
    assert !(metadata ? description) || (descriptor.metadata.description.multiline or false);
    assert builtins.isAttrs dependencies;
    assert lib.all (
      scope:
      builtins.elem scope [
        "general"
        "build"
        "runtime"
      ]
      && builtins.isList dependencies.${scope}
      && lib.all (reference: reference.namespace == "pkgs" && reference.path != [ ]) dependencies.${scope}
    ) (builtins.attrNames dependencies);
    lib.foldr
      (
        warning: value:
        builtins.trace "ZenPkgs metadata warning: ${identity} (${location}): ${warning}" value
      )
      ({
        inherit meta provider dependenciesDeclared;
        location = descriptor.location or location;
      } // lib.optionalAttrs (provider.kind == "import") { sourcePath = builtins.tail importPath; })
      warnings;

  decodeInterface =
    descriptor: decodeInterfaceAt (descriptor.name or "<zpkg>") "<descriptor>" descriptor;

in
{
  inherit decodeInterface decodeValue;

  modulesFromBundle =
    {
      bundle,
      bundlePath,
    }:
    let
      exposed = canonicalSources bundle;
      sources = builtins.filter (source: source.kind == "zmdl") exposed;
      moduleRecords =
        if exposed == [ ] then
          [ ]
        else if bundle ? modules && builtins.isList bundle.modules then
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
          record = require (
            builtins.length matches == 1
          ) "module ${canonical.identity} must have exactly one compiler record" (builtins.head matches);
          expectedOptionPath = [ "zenos" ] ++ canonical.modulePath;
          identity = record.identity or null;
          module = bundlePath + "/modules/${source.path}.nix";
        in
        require (identity == canonical.identity)
          "module ${source.path} compiler identity must be ${canonical.identity}, got ${toString identity}"
          (
            require ((record.optionPath or null) == expectedOptionPath)
              "module ${source.path} compiler option path must be ${builtins.toJSON expectedOptionPath}"
              (
                require (source ? compiledNix && builtins.isString source.compiledNix && source.compiledNix != "")
                  "module ${identity} has no compiled Nix"
                  (
                    require (builtins.pathExists module) "compiled module ${toString module} is missing" {
                      inherit identity module;
                      modulePath = canonical.modulePath;
                      optionPath = record.optionPath;
                      sourcePath = record.path;
                    }
                  )
              )
          );

      candidates = map candidateFor sources;
      validated =
        require (duplicateSources == [ ]) "duplicate ZMDL sources: ${builtins.toJSON duplicateSources}"
          (
            require (duplicateRecords == [ ]) "duplicate module records: ${builtins.toJSON duplicateRecords}" (
              require (duplicatePaths == [ ]) "duplicate module option paths: ${builtins.toJSON duplicatePaths}" (
                require (duplicateIdentities == [ ])
                  "duplicate module identities: ${builtins.toJSON duplicateIdentities}"
                  (
                    require (missingRecords == [ ])
                      "ZMDL sources without module records: ${builtins.toJSON missingRecords}"
                      (
                        require (
                          orphanRecords == [ ]
                        ) "module records without ZMDL sources: ${builtins.toJSON orphanRecords}" candidates
                      )
                  )
              )
            )
          );
    in
    validated;

  registryFromBundle =
    {
      bundle,
      bundlePath,
    }:
    let
      packageSources = builtins.filter (source: source.kind == "zpkg") (canonicalSources bundle);
      duplicateTargets = duplicates (map (source: source.id) packageSources);
      sources = require (
        duplicateTargets == [ ]
      ) "duplicate package identities: ${builtins.toJSON duplicateTargets}" packageSources;
      decoded = map (
        canonical:
        let
          source = canonical.source;
          entry = decodeInterfaceAt canonical.id source.path (
            import (bundlePath + "/interfaces/${source.path}.nix") { }
          );
        in
        {
          inherit source;
          entry = entry // {
            id = canonical.id;
            target = canonical.target;
            buildFile = bundlePath + "/builds/${source.path}.nix";
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
