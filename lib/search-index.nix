{ lib }:
let
  attempt = value: builtins.tryEval (builtins.deepSeq value value);
  text =
    value:
    let
      result = attempt (
        if builtins.isString value then
          value
        else if builtins.isAttrs value && value ? text && builtins.isString value.text then
          value.text
        else
          null
      );
    in
    if result.success then result.value else null;
  # Only bounded JSON data, never derivation outputs, functions or arbitrary config.
  jsonValue =
    depth: value:
    if builtins.isFunction value || depth == 0 then
      throw "non-documentable value"
    else if builtins.isAttrs value then
      if lib.isDerivation value || builtins.length (builtins.attrNames value) > 64 then
        throw "non-documentable attribute set"
      else
        lib.mapAttrs (_: jsonValue (depth - 1)) value
    else if builtins.isList value then
      if builtins.length value > 64 then
        throw "non-documentable list"
      else
        map (jsonValue (depth - 1)) value
    else if builtins.isPath value then
      toString value
    else
      value;
  safe =
    fallback: value:
    let
      result = attempt (jsonValue 6 value);
    in
    if result.success then result.value else fallback;
  publicPath = map (
    part: if lib.hasPrefix "{" part && lib.hasSuffix "}" part then "<name>" else part
  );
  key = builtins.toJSON;
  clean = tree: lib.filterAttrs (name: _: !lib.hasPrefix "_" name) tree;
  license =
    value:
    if builtins.isList value then
      map license value
    else if builtins.isAttrs value then
      value.spdxId or value.shortName or value.fullName or null
    else
      value;
  describe = meta: {
    name = text (meta.name or null);
    summary = text (meta.summary or null);
    description = text (meta.summary or meta.description or null);
    longDescription = text (meta.longDescription or meta.description or null);
    license = safe null (license (meta.license or null));
    maintainers = safe [ ] (
      map (m: if builtins.isAttrs m then m.name or m.github or null else lib.removePrefix "$m." m) (
        meta.maintainers or [ ]
      )
    );
    tags = safe [ ] (meta.tags or [ ]);
    platforms = safe [ ] (meta.platforms or [ ]);
    zenosVersion = text (meta.zenosVersion or null);
  };
  clientType =
    type:
    let
      name = type.name or "unknown";
    in
    if name == "enum" then
      { enum = safe [ ] (type.functor.payload.values or [ ]); }
    else if name == "bool" then
      "boolean"
    else if lib.hasPrefix "str" name || name == "path" then
      "string"
    else if
      builtins.elem name [
        "int"
        "float"
      ]
    then
      "number"
    else if name == "listOf" then
      "array"
    else if
      builtins.elem name [
        "attrsOf"
        "lazyAttrsOf"
        "attrs"
        "submodule"
        "package"
      ]
    then
      "set"
    else
      text (type.description or name);

  # Read descriptive fields from the compiler's data IR, never execute metadata
  # expressions as defaults. Schema discovery remains exclusively type-driven.
  adapter = import ./dsl-bundle.nix { inherit lib; };
  metadataRecords =
    prefix: statements:
    lib.concatMap (
      statement:
      if statement.type == "resolved-import" && statement.binding == null then
        metadataRecords prefix statement.document.statements
      else if statement.type != "assignment" then
        [ ]
      else
        let
          target = statement.target;
          parts =
            if builtins.isList target then
              map (p: p.value or "<dynamic>") target
            else if (target.kind or null) == "freeform" then
              [ "<name>" ]
            else
              [ ];
          path = prefix ++ parts;
          value = statement.value;
          metaIndex = lib.lists.findFirstIndex (p: p == "_meta") null path;
          fields = [
            "name"
            "summary"
            "description"
            "tags"
            "maintainers"
            "license"
            "zenosVersion"
          ];
        in
        if metaIndex != null then
          let
            fieldPath = lib.drop (metaIndex + 1) path;
            decoded =
              if fieldPath == [ ] then
                lib.mapAttrs (_: v: safe null (adapter.decodeValue v)) (
                  builtins.listToAttrs (
                    map
                      (s: {
                        name = (builtins.head s.target).value;
                        value = s.value;
                      })
                      (
                        builtins.filter (
                          s:
                          s.type == "assignment"
                          && builtins.isList s.target
                          && builtins.length s.target == 1
                          && builtins.elem (builtins.head s.target).value fields
                        ) (value.statements or [ ])
                      )
                  )
                )
              else
                lib.optionalAttrs (builtins.length fieldPath == 1 && builtins.elem (builtins.head fieldPath) fields)
                  {
                    ${builtins.head fieldPath} = safe null (adapter.decodeValue value);
                  };
          in
          [
            {
              path = lib.take metaIndex path;
              meta = decoded;
            }
          ]
        else if value.type == "attr-set" then
          metadataRecords path value.statements
        else if value.type == "enable-option" then
          metadataRecords path value.body.statements
        else
          [ ]
    ) statements;

  # Collection placeholders are explicit nodes. Submodule freeform schemas are
  # merged below their owning node; declared children take precedence in both
  # schema and provenance. A freeform mirror marks its owner, not declared children.
  typeChildren =
    fuel: path: upstream: type:
    if fuel == 0 then
      throw "option wrapper depth limit"
    else
      let
        name = type.name or "unknown";
        nested = type.nestedTypes or { };
        inherited = upstream || name == "zstr-upstream-mirror";
      in
      if nested ? finalType then
        typeChildren (fuel - 1) path inherited nested.finalType
      else if
        builtins.elem name [
          "nullOr"
          "unique"
        ]
        && nested ? elemType
      then
        typeChildren (fuel - 1) path inherited nested.elemType
      else if
        builtins.elem name [
          "attrsOf"
          "lazyAttrsOf"
          "listOf"
        ]
      then
        {
          upstream = inherited;
          children.${if name == "listOf" then "*" else "<name>"} = {
            tree = lib.mkOption { type = nested.elemType; };
            upstream = inherited;
          };
        }
      else
        let
          raw = type.getSubOptions path;
          declared = lib.mapAttrs (_: tree: {
            inherit tree;
            upstream = inherited;
          }) (clean raw);
          freeform =
            if nested ? freeformType then
              typeChildren (fuel - 1) path inherited nested.freeformType
            else
              {
                upstream = inherited;
                children = lib.mapAttrs (_: tree: {
                  inherit tree;
                  upstream = inherited;
                }) (raw._freeformOptions or { });
              };
        in
        {
          upstream = freeform.upstream;
          children = freeform.children // declared;
        };
in
rec {
  defaultLimits = {
    optionDepth = 16;
    typeDepth = 5;
    packageDepth = 16;
    legacyPackageDepth = 2;
  };

  serializeOptions =
    {
      tree,
      path ? [ ],
      limits ? defaultLimits,
      metadataAt ? (_: { }),
      mountPaths ? [ ],
      typeDepth ? 0,
      upstream ? false,
    }:
    let
      evaluated = builtins.tryEval tree;
      value = evaluated.value;
      isOption = evaluated.success && lib.isOption value;
      authored = metadataAt path;
      schema = typeChildren 8 path upstream value.type;
      provenance = attempt schema.upstream;
      isUpstream = upstream || (isOption && provenance.success && provenance.value);
      depth = if builtins.elem path mountPaths then 0 else typeDepth;
      limited = builtins.length path >= limits.optionDepth || depth >= limits.typeDepth;
      children =
        if limited || !evaluated.success then
          { }
        else if isOption then
          schema.children
        else if builtins.isAttrs value then
          lib.mapAttrs (_: tree: { inherit tree upstream; }) (clean value)
        else
          { };
      names = attempt (builtins.attrNames children);
      status =
        if !evaluated.success || !names.success then
          "unavailable"
        else if limited then
          "depth-limit"
        else
          "complete";
      optionDefault =
        if value ? defaultText then
          let
            documented = attempt (jsonValue 6 value.defaultText);
          in
          if documented.success && documented.value != null then
            {
              defaultStatus = "documented";
              defaultText = documented.value;
            }
          else
            { defaultStatus = "unavailable"; }
        else if !(value ? default) then
          { defaultStatus = if isUpstream then "unavailable" else "absent"; }
        else if
          builtins.any (
            part:
            builtins.elem part [
              "<name>"
              "*"
            ]
          ) path
        then
          {
            defaultStatus = "unavailable";
          }
        else if
          builtins.elem (value.type.name or "") [
            "bool"
            "int"
            "float"
            "str"
            "enum"
          ]
        then
          let
            result = attempt (
              let
                v = value.default;
              in
              if
                v == null || builtins.isBool v || builtins.isInt v || builtins.isFloat v || builtins.isString v
              then
                if value.type.check v then v else throw "invalid default"
              else
                throw "non-scalar default"
            );
          in
          if result.success then
            {
              defaultStatus = "value";
              default = result.value;
            }
          else
            { defaultStatus = "unavailable"; }
        else
          { defaultStatus = "unavailable"; };
      sub = lib.genAttrs (if names.success then names.value else [ ]) (
        name:
        serializeOptions {
          inherit (children.${name}) tree upstream;
          path = path ++ [ name ];
          inherit limits metadataAt mountPaths;
          typeDepth = depth + (if isOption then 1 else 0);
        }
      );
    in
    {
      meta =
        describe (
          lib.optionalAttrs isOption { description = text (value.description or null); } // authored
        )
        // {
          inherit path;
          upstream = isUpstream;
          traversal = status;
          type = if isOption then clientType value.type else "set";
          typeDescription = if isOption then text (value.type.description or value.type.name) else null;
          typeName = if isOption then value.type.name or "unknown" else "set";
          default = null;
          example = if isOption then safe null (value.example or null) else null;
        }
        // lib.optionalAttrs isOption optionDefault
        // lib.optionalAttrs (isOption && (value.type.name or "") == "zstr-package-selectors") {
          packageTree = "pkgs";
        };
    }
    // lib.optionalAttrs (sub != { }) { inherit sub; };

  serializePackages =
    {
      tree,
      path ? [ ],
      depth ? defaultLimits.packageDepth,
      upstream ? false,
    }:
    let
      evaluated = builtins.tryEval (
        if builtins.isAttrs tree then
          let
            derivation = lib.isDerivation tree;
          in
          builtins.seq derivation {
            value = tree;
            inherit derivation;
          }
        else
          null
      );
      valid = evaluated.success && evaluated.value != null;
      value = evaluated.value.value;
      derivation = valid && evaluated.value.derivation;
      blocked =
        name:
        lib.hasPrefix "_" name
        || builtins.elem name [
          "recurseForDerivations"
          "override"
          "overrideDerivation"
          "newScope"
          "callPackage"
        ]
        || (
          upstream
          && (
            lib.hasPrefix "pkgs" name
            || builtins.elem name [
              "buildPackages"
              "targetPackages"
              "lib"
              "stdenv"
              "nixos"
              "nixosTests"
              "testers"
              "tests"
              "releaseTools"
              "source"
              "src"
              "modules"
            ]
          )
        );
      names =
        if !valid || derivation || depth == 0 then
          [ ]
        else
          builtins.filter (
            name:
            !blocked name
            && (
              let
                child = builtins.tryEval (builtins.isAttrs value.${name});
              in
              !child.success || child.value
            )
          ) (builtins.attrNames value);
      sub = lib.genAttrs names (
        name:
        serializePackages {
          tree = value.${name};
          path = path ++ [ name ];
          depth = depth - 1;
          inherit upstream;
        }
      );
      meta = if derivation then value.meta.zenos or value.meta or { } else { };
    in
    if evaluated.success && evaluated.value == null then
      { }
    else
      {
        meta = describe meta // {
          inherit path upstream;
          id = lib.concatStringsSep "." ([ "pkgs" ] ++ path);
          kind = if derivation then "package" else "package-set";
          traversal =
            if !valid then
              "unavailable"
            else if !derivation && depth == 0 then
              "depth-limit"
            else
              "complete";
          version = if derivation then text (value.version or null) else null;
          packageVersion = text (meta.packageVersion or null);
          dependencies = safe null (meta.dependencies or null);
          homepage = if derivation then safe null (value.meta.homepage or null) else null;
        };
      }
      // lib.optionalAttrs (sub != { }) { inherit sub; };

  mkIndex =
    {
      evaluated,
      bundle,
      packageTree ? evaluated.pkgs.zenos or { },
      maintainers ? { },
      versionInfo ? { },
      limits ? defaultLimits,
    }:
    let
      present = bundle.structure.present or false;
      mounts = if present then bundle.structure.mounts or [ ] else [ ];
      sources = builtins.listToAttrs (
        map (source: {
          name = source.path;
          value = source;
        }) (bundle.sources or [ ])
      );
      exposed =
        lib.concatMap (
          mount:
          if mount.kind != "zmdl" then
            [ ]
          else
            map
              (record: {
                source = sources.${record.path};
                path = publicPath (
                  mount.path ++ lib.drop (builtins.length mount.target) (builtins.tail record.optionPath)
                );
              })
              (
                builtins.filter (
                  record: lib.take (builtins.length mount.target) (builtins.tail record.optionPath) == mount.target
                ) (bundle.modules or [ ])
              )
        ) mounts
        ++ lib.optional (present && sources ? "structure.zstr") {
          source = sources."structure.zstr";
          path = [ ];
        };
      records = lib.concatMap (
        entry:
        if entry.source.kind == "zmdl" then
          map (record: {
            path = entry.path ++ map (part: if builtins.isAttrs part then "<name>" else part) record.path;
            meta = lib.mapAttrs (_: value: safe null (adapter.decodeValue value)) record.metadata;
          }) entry.source.descriptor.nodeMetadata
        else
          metadataRecords entry.path (entry.source.descriptor.statements or [ ])
      ) exposed;
      metadata = lib.foldl' (
        acc: record: acc // { ${key record.path} = (acc.${key record.path} or { }) // record.meta; }
      ) { } records;
      formatted = serializeOptions {
        tree = evaluated.options.zenos;
        inherit limits;
        metadataAt = path: metadata.${key path} or { };
        mountPaths = map (mount: publicPath mount.path) mounts;
      };
      packageMount = builtins.any (mount: mount.kind == "packages") mounts;
      packages = serializePackages {
        tree = removeAttrs packageTree [ "legacy" ];
        depth = limits.packageDepth;
      };
      diagnosticSources =
        exposed
        ++ lib.optionals packageMount (
          map (source: {
            inherit source;
            path = [
              "pkgs"
            ]
            ++ lib.splitString "/" (lib.removeSuffix ".zpkg" (lib.removePrefix "pkgs/" source.path));
          }) (builtins.filter (source: source.kind == "zpkg") (bundle.sources or [ ]))
        );
      diagnostics = lib.concatMap (
        entry:
        map (diagnostic: diagnostic // { mountedAt = entry.path; }) (
          builtins.filter (d: d.severity == "warning") (entry.source.diagnostics or [ ])
        )
      ) diagnosticSources;
    in
    {
      inherit maintainers;
      metadata = versionInfo // {
        schemaVersion = 1;
        encoding = "zenpkgs-search/meta-sub";
        packageEncoding = "hierarchical-pkgs";
        inherit limits;
        warnings = diagnostics;
        complete = false;
      };
      options = if present && evaluated.options ? zenos then formatted.sub or { } else { };
      pkgs =
        if !present || !packageMount then
          { }
        else
          (packages.sub or { })
          // lib.optionalAttrs (packageTree ? legacy) {
            legacy = serializePackages {
              tree = packageTree.legacy;
              path = [ "legacy" ];
              depth = limits.legacyPackageDepth;
              upstream = true;
            };
          };
    };
}
