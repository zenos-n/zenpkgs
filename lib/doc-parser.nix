{ lib, moduleTree }:
let
  # 1. Parse structure.zstr purely for metadata
  rawZstr = builtins.readFile ../structure.zstr;

  # Textual Transpilation: Prepare the custom DSL for Nix evaluation
  cleanZstr =
    let
      # Phase 1: Basic string replacements for known bash-style patterns
      manual =
        builtins.replaceStrings
          [
            "children.(freeform $user) ="
            "(freeform $user) ="
            "$user"
          ]
          [
            "\"<name>\" ="
            "\"<name>\" ="
            "<user>"
          ]
          rawZstr;

      # Phase 2: Quote type targets to prevent "expected a set but found a string" errors.
      # This converts (alias nixpkgs.foo) -> (alias "nixpkgs.foo")
      # Regex: matches (type_name path_with_dots)
      quoted =
        let
          parts = builtins.split "\\((alias|zmdl|zdml|packages|programs)[[:space:]]+([^)\"]+)\\)" manual;
          process = p: if builtins.isList p then "(${builtins.elemAt p 0} \"${builtins.elemAt p 1}\")" else p;
        in
        lib.concatStrings (map process parts);

      # Phase 3: Ensure semicolons after type assignments if missing
      semicolons =
        let
          parts = builtins.split "(type[[:space:]]*=[[:space:]]*\\([^)]+\\))([^;])" quoted;
          process = p: if builtins.isList p then "${builtins.elemAt p 0};${builtins.elemAt p 1}" else p;
        in
        lib.concatStrings (map process parts);
    in
    semicolons;

  zstrEnv = ''
    let
      alias = target: { _isZenType = true; name = "alias"; inherit target; };
      zmdl = target: { _isZenType = true; name = "zmdl"; inherit target; };
      zdml = target: { _isZenType = true; name = "zmdl"; inherit target; };
      packages = target: { _isZenType = true; name = "packages"; inherit target; };
      programs = target: { _isZenType = true; name = "programs"; inherit target; };
      
      nixpkgs = "nixpkgs";
      system = "system";
      desktops = "desktops";
      users = "users";
      user = "user";
    in {
  ''
  + cleanZstr
  + ''
    }
  '';

  parsedZstr = import (builtins.toFile "parsed-structure.nix" zstrEnv);

  # Extract metadata recursively from parsed ZSTR AST
  extractZstrMeta =
    node:
    let
      # Logic: All metadata MUST be inside _meta.
      # Everything else is a child node.
      metaData = node._meta or { };

      meta = {
        brief = metaData.brief or node.brief or null;
        description = metaData.description or node.description or null;
        maintainers = metaData.maintainers or node.maintainers or [ ];
        type = metaData.type or node.type or null;
      };

      # Children are all keys except reserved keywords and the _meta block
      reserved = [
        "_meta"
        "brief"
        "description"
        "maintainers"
        "type"
        "default"
        "children"
      ];
      rawChildren = builtins.removeAttrs node reserved;

      baseChildren = lib.mapAttrs (k: v: extractZstrMeta v) rawChildren;

      # Automatically inject 'legacy' child for program containers
      children =
        if (meta.type.name or "") == "programs" then
          baseChildren
          // {
            legacy = {
              meta = {
                brief = "Raw upstream options for this category";
                description = "Directly map native NixOS or Home-Manager options here to bypass ZenOS abstractions.";
                maintainers = meta.maintainers;
              };
              children = { };
            };
          }
        else
          baseChildren;
    in
    {
      inherit meta children;
    };

  baseMetaTree = {
    zenos = {
      meta = { };
      children = lib.mapAttrs (k: v: extractZstrMeta v) parsedZstr;
    };
  };

  # 2. Parse all .zmdl files for leaf metadata
  enableOption = args: args // { _isEnableOption = true; };

  zmdlFiles = builtins.filter (p: lib.hasSuffix ".zmdl" p) moduleTree.modules;
  modRoot = builtins.toString ../modules;

  processZmdl =
    absPath:
    let
      raw = builtins.readFile absPath;

      relStr = lib.removePrefix "${modRoot}/" (builtins.toString absPath);
      relPathRaw = lib.splitString "/" relStr;
      modNameWithExt = lib.last relPathRaw;
      modName = lib.removeSuffix ".zmdl" modNameWithExt;
      relPath = lib.init relPathRaw;

      pathList = relPath ++ [ modName ];
      isProgram = builtins.length pathList > 0 && builtins.head pathList == "programs";

      attrPath = lib.concatStringsSep "." (
        if isProgram then
          [
            "zenos"
            "system"
          ]
          ++ pathList
        else
          [ "zenos" ] ++ pathList
      );
      cfgPath = "config.${attrPath}";

      templated = builtins.replaceStrings [ "$path" "$cfg" "$name" ] [ attrPath cfgPath modName ] raw;

      wrapped = "{ enableOption, pkgs, lib, config, maintainers }: { ${templated} }";

      expr = import (builtins.toFile "static-zmdl-${modName}.nix" wrapped) {
        inherit enableOption lib;
        pkgs = { };
        config = { };
        maintainers = { };
      };

      modMeta = expr.meta or { };

      extractOptMeta = opt: {
        meta = {
          brief = opt.meta.brief or opt._meta.brief or opt.brief or null;
          description = opt.meta.description or opt._meta.description or opt.description or null;
          maintainers = opt.meta.maintainers or opt._meta.maintainers or opt.maintainers or [ ];
        };
        children = { };
      };

      optsMeta = lib.mapAttrs (k: v: extractOptMeta v) (expr.options or { });

      node = {
        meta = {
          brief = modMeta.brief or null;
          description = modMeta.description or null;
          maintainers = modMeta.maintainers or [ ];
        };
        children = optsMeta;
      };
    in
    {
      inherit pathList isProgram node;
    };

  zmdlParsed = map processZmdl zmdlFiles;

  # Recursive merge for assembling the final static tree
  mergeNode =
    tree: path: node:
    if path == [ ] then
      {
        meta = (tree.meta or { }) // (node.meta or { });
        children = (tree.children or { }) // (node.children or { });
      }
    else
      let
        head = builtins.head path;
        tail = builtins.tail path;
        child =
          tree.children.${head} or {
            meta = { };
            children = { };
          };
        newChild = mergeNode child tail node;
      in
      tree
      // {
        children = (tree.children or { }) // {
          ${head} = newChild;
        };
      };

  # 3. Assemble Final Meta Tree
  finalMetaTree = builtins.foldl' (
    acc: item:
    if item.isProgram then
      let
        acc1 = mergeNode acc (
          [
            "zenos"
            "system"
          ]
          ++ item.pathList
        ) item.node;
        acc2 = mergeNode acc1 (
          [
            "zenos"
            "users"
            "<name>"
          ]
          ++ item.pathList
        ) item.node;
      in
      acc2
    else
      mergeNode acc ([ "zenos" ] ++ item.pathList) item.node
  ) { children = baseMetaTree; } zmdlParsed;

in
finalMetaTree
