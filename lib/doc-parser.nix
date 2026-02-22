{ lib, moduleTree }:
let
  # 1. Parse structure.zstr purely for metadata
  rawZstr = builtins.readFile ../structure.zstr;

  cleanZstr =
    builtins.replaceStrings
      [
        "type = (zdml users)\n"
        "type = (zdml users)\r\n"
        "children.(freeform $user) ="
        "nixpkgs.users.users.$user"
        "type = (programs user)\n"
        "type = (programs user)\r\n"
      ]
      [
        "type = (zdml users);\n"
        "type = (zdml users);\r\n"
        "children.\"<name>\".children ="
        "nixpkgs_users_user"
        "type = (programs user);\n"
        "type = (programs user);\r\n"
      ]
      rawZstr;

  zstrEnv = ''
    let
      alias = target: { _isZenType = true; name = "alias"; };
      zmdl = target: { _isZenType = true; name = "zmdl"; };
      zdml = target: { _isZenType = true; name = "zmdl"; };
      packages = target: { _isZenType = true; name = "packages"; };
      programs = target: { _isZenType = true; name = "programs"; };
      
      nixpkgs = "nixpkgs";
      system = "system";
      desktops = "desktops";
      users = "users";
      user = "user";
      nixpkgs_users_user = "nixpkgs";
    in {
  ''
  + cleanZstr
  + ''
    }
  '';

  parsedZstr = import (builtins.toFile "parsed-structure.nix" zstrEnv);

  # Extract metadata recursively from parsed ZSTR
  extractZstrMeta =
    node:
    let
      meta = {
        brief = node.brief or null;
        description = node.description or null;
        maintainers = node.maintainers or [ ];
      };
      children = if node ? children then lib.mapAttrs (k: v: extractZstrMeta v) node.children else { };
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

  # 2. Parse all .zmdl files
  enableOption = args: args // { _isEnableOption = true; };

  zmdlFiles = builtins.filter (p: lib.hasSuffix ".zmdl" p) moduleTree.modules;
  modRoot = builtins.toString ../modules;

  processZmdl =
    absPath:
    let
      raw = builtins.readFile absPath;

      # Parse path to get logical module placement
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

      # Template replacements
      templated = builtins.replaceStrings [ "$path" "$cfg" "$name" ] [ attrPath cfgPath modName ] raw;

      # Wrap to catch the module exports natively without evaluating Nixpkgs or Options
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

  # Merge logic for assembling the tree
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
