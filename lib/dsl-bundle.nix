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
        segments = canonicalSegments {
          inherit source;
          root = "modules";
          suffix = ".zmdl";
          reservedLeaf = "module";
        };
      in
      {
        inherit segments source;
        compileTarget = if builtins.head segments == "users" then "user" else "system";
        kind = "zmdl";
        moduleId = lib.concatStringsSep "." segments;
        sourceModule = lib.removeSuffix ".zmdl" source.path;
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
    require (bundle.bundleVersion == "zenlang.bundle/1") "unsupported bundle version"
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
      fields = lib.foldl' (
        result: field:
        lib.recursiveUpdate result (lib.setAttrByPath field.path (decodeValue field.value))
      ) { } descriptor.fields;
      expectedFields = [
        "aliases"
        "id"
        "meta"
        "sourcePath"
        "status"
      ];
    in
    assert descriptor.descriptorVersion == "zenlang.semantic/1";
    assert descriptor.kind == "zpkg";
    assert descriptor.imports == [ ];
    assert descriptor.dependencies == {
      global = [ ];
      build = [ ];
      run = [ ];
      export = [ ];
    };
    assert builtins.attrNames fields == expectedFields;
    {
      inherit (fields)
        aliases
        id
        meta
        sourcePath
        status
        ;
    };

  valuesAtPath =
    path: statements:
    lib.concatMap (
      statement:
      if
        statement.type != "assignment"
        || statement.operator != "="
        || !builtins.isList statement.target
      then
        [ ]
      else
        let
          target = pathFromDescriptor statement.target;
          nested =
            builtins.length target < builtins.length path
            && lib.take (builtins.length target) path == target
            && statement.value.type == "attr-set";
        in
        if target == path then
          [ statement.value ]
        else if nested then
          valuesAtPath (lib.drop (builtins.length target) path) statement.value.statements
        else
          [ ]
    ) statements;

  moduleMetadataId =
    source:
    let
      values = valuesAtPath [ "_meta" "id" ] source.descriptor.statements;
      value = require (builtins.length values == 1) "${source.path} must declare exactly one _meta.id" (
        builtins.head values
      );
      id = decodeValue value;
    in
    require (builtins.isString id && id != "") "${source.path} has an invalid _meta.id" id;
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
      attachments =
        if bundle ? structure && bundle.structure ? attachments then
          bundle.structure.attachments
        else
          throw "ZenPkgs DSL adapter: bundle has no structure attachments";
      sourcePaths = map (entry: entry.source.path) sources;
      moduleIds = map (entry: entry.moduleId) sources;
      sourceModules = map (entry: entry.sourceModule) sources;
      attachmentModules = map (attachment: attachment.module) attachments;
      attachmentPaths = map (attachment: builtins.toJSON attachment.path) attachments;
      duplicateSources = duplicates sourcePaths;
      duplicateModules = duplicates moduleIds;
      duplicateAttachments = duplicates attachmentModules;
      duplicateAttachmentPaths = duplicates attachmentPaths;
      missingAttachments = lib.subtractLists attachmentModules sourceModules;
      orphanAttachments = lib.subtractLists sourceModules attachmentModules;

      candidateFor =
        canonical:
        let
          source = canonical.source;
          moduleId = canonical.moduleId;
          matches = builtins.filter (attachment: attachment.module == canonical.sourceModule) attachments;
          attachment = require (builtins.length matches == 1) "module ${moduleId} must have exactly one attachment" (
            builtins.head matches
          );
          module = bundlePath + "/modules/${source.path}.nix";
          attachmentTarget = attachment.target or null;
          compileTarget = canonical.compileTarget;
          metadataId = moduleMetadataId source;
          expectedMetadataId = canonical.moduleId;
        in
        require (metadataId == expectedMetadataId)
          "module ${source.path} _meta.id must be ${expectedMetadataId}, got ${metadataId}"
          (require (attachment.path == canonical.segments)
            "module ${source.path} attachment must be ${builtins.toJSON canonical.segments}"
            (require (attachmentTarget == compileTarget)
              "module ${source.path} must compile for ${canonical.compileTarget}"
              (require (source ? compiledNix && builtins.isString source.compiledNix && source.compiledNix != "")
                "module ${moduleId} has no compiled Nix"
                (require (builtins.pathExists module) "compiled module ${toString module} is missing" {
                  inherit
                    compileTarget
                    module
                    moduleId
                    ;
                  attachmentPath = canonical.segments;
                  sourcePath = source.path;
                }))));

      candidates = map candidateFor sources;
      validated =
        require (duplicateSources == [ ]) "duplicate ZMDL sources: ${builtins.toJSON duplicateSources}"
            (require (duplicateModules == [ ]) "duplicate compiled modules: ${builtins.toJSON duplicateModules}"
              (require (duplicateAttachments == [ ])
                "duplicate module attachments: ${builtins.toJSON duplicateAttachments}"
                (require (duplicateAttachmentPaths == [ ])
                  "duplicate attachment paths: ${builtins.toJSON duplicateAttachmentPaths}"
                  (require (missingAttachments == [ ])
                    "missing module attachments: ${builtins.toJSON missingAttachments}"
                    (require (orphanAttachments == [ ])
                      "attachments without ZMDL sources: ${builtins.toJSON orphanAttachments}"
                      candidates)))));
    in
    {
      all = validated;
      records = {
        system = builtins.filter (candidate: candidate.compileTarget == "system") validated;
        user = builtins.filter (candidate: candidate.compileTarget == "user") validated;
      };
      system = map (candidate: candidate.module) (
        builtins.filter (candidate: candidate.compileTarget == "system") validated
      );
      user = map (candidate: candidate.module) (
        builtins.filter (candidate: candidate.compileTarget == "user") validated
      );
    };

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
        require (entry.id == canonical.id)
          "package ${source.path} id must match leaf ${canonical.id}, got ${entry.id}"
          {
            inherit source;
            entry = entry // { target = canonical.target; };
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
