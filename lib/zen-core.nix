{ lib, inputs }:
let
  # Recursive Directory Walker
  walkDir =
    dir: criteriaFn:
    let
      read = if builtins.pathExists dir then builtins.readDir dir else { };
      entries = lib.mapAttrsToList (name: type: { inherit name type; }) read;
      processEntry =
        { name, type }:
        if type == "directory" then
          let
            children = walkDir (dir + "/${name}") criteriaFn;
          in
          map (child: child // { relPath = [ name ] ++ child.relPath; }) children
        else if criteriaFn name type then
          [
            {
              inherit name type;
              relPath = [ ];
              absPath = dir + "/${name}";
            }
          ]
        else
          [ ];
    in
    lib.flatten (map processEntry entries);

  # Package Tree Generator
  # Maps a directory (e.g., ./pkgs) to an attribute set of callPackage calls
  mkPackageTree =
    pkgs: root:
    let
      isPkg = n: t: n == "default.nix";
      files = walkDir root isPkg;
      toAttr = entry: {
        # Use the parent directory name as the attribute name
        name = lib.last entry.relPath;
        value = pkgs.callPackage entry.absPath { };
      };
    in
    builtins.listToAttrs (map toAttr files);

  # ZCFG / Flat File Importer (for host configs)
  # ZCFG / Flat File Importer (for host configs)
  importZcfg =
    path: args: # <-- Replaced strict { pkgs, lib, config, ... }@args: with loose args:
    let
      hostDir = builtins.dirOf path;
      content = builtins.readFile path;

      # THE HACK: Bypass Nix parser constraint by converting boolean assignments
      parts = builtins.split "([a-zA-Z0-9_.-]+)[ \t]*=[ \t]*(true|false)[ \t]*;" content;
      transformed = lib.concatStrings (
        map (
          p:
          if builtins.isList p then
            let
              lhs = builtins.elemAt p 0;
              rhs = builtins.elemAt p 1;
              cleanLhs = lib.trim lhs;
            in
            # Ignore .enable suffixes to protect standard Nix patterns
            if lib.hasSuffix "enable" cleanLhs || lib.hasSuffix "_enable" cleanLhs then
              "${lhs} = ${rhs};"
            else
              "${lhs}._enable = ${rhs};"
          else
            p
        ) parts
      );

      wrapped = "{ " + transformed + " }";
      tempFile = builtins.toFile "zen-config-wrapped.nix" wrapped;

      scope = args // {
        inherit hostDir;
        importZen = p: importZcfg p args;
        conf = f: importZcfg (hostDir + "/config/${f}") args;
      };

      raw = builtins.scopedImport scope tempFile;

      # AST CLEANUP: Revert isolated `._enable` sets back to booleans
      # to prevent breaking standard NixOS module options.
      squashEnables =
        path: val:
        if builtins.isAttrs val then
          let
            # Flag if we have entered the 'packages' namespace
            isPkgPath = builtins.elem "packages" path;

            # Squash only if it's an isolated _enable AND we aren't configuring packages
            canSquash = (val ? _enable) && (builtins.length (builtins.attrNames val) == 1) && !isPkgPath;
          in
          if canSquash then val._enable else lib.mapAttrs (n: v: squashEnables (path ++ [ n ]) v) val
        else if builtins.isList val then
          map (squashEnables path) val
        else
          val;

      squashedRaw =
        if builtins.isFunction raw then (a: squashEnables [ ] (raw a)) else squashEnables [ ] raw;
    in
    squashedRaw;

  # Host Generator
  mkHosts =
    {
      root,
      modules ? [ ],
      specialArgs ? { },
    }:
    let
      isHost = n: t: n == "host.nix" || n == "host.zcfg" || n == "host.nzo";
      files = walkDir root isHost;

      mkSystem =
        entry:
        let
          name = builtins.concatStringsSep "." entry.relPath;

          hostModule =
            args:
            let
              raw =
                if (lib.hasSuffix ".zcfg" entry.name || lib.hasSuffix ".nzo" entry.name) then
                  importZcfg entry.absPath args
                else
                  import entry.absPath args;

              legacyConfig = raw.legacy or { };
              zenosConfig = builtins.removeAttrs raw [ "legacy" ];
            in
            {
              config = lib.mkMerge [
                legacyConfig
                { zenos = zenosConfig; }
              ];
            };
        in
        {
          inherit name;
          value = lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = specialArgs // {
              inherit inputs;
            };
            modules = modules ++ [ hostModule ];
          };
        };
    in
    builtins.listToAttrs (map mkSystem files);

  parseZstr =
    lib: options: path:
    let
      rawZstr = builtins.readFile path;

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

      quoted =
        let
          parts = builtins.split "\\((alias|zmdl|zdml|packages|programs)[[:space:]]+([^)\"]+)\\)" manual;
          process = p: if builtins.isList p then "(${builtins.elemAt p 0} \"${builtins.elemAt p 1}\")" else p;
        in
        lib.concatStrings (map process parts);

      cleanSyntax =
        let
          parts = builtins.split "(type[[:space:]]*=[[:space:]]*\\([^)]+\\))([^;])" quoted;
          process = p: if builtins.isList p then "${builtins.elemAt p 0};${builtins.elemAt p 1}" else p;
        in
        lib.concatStrings (map process parts);

      dslEnv = ''
        let
            alias = target: { _isZenType = true; name = "alias"; inherit target; };
            zmdl = target: { _isZenType = true; name = "zmdl"; inherit target; };
            zdml = target: { _isZenType = true; name = "zmdl"; inherit target; };
            packages = target: { _isZenType = true; name = "packages"; inherit target; };
            programs = target: { _isZenType = true; name = "programs"; inherit target; };
        in {
      ''
      + cleanSyntax
      + ''
        }
      '';

      parsedStructure = import (builtins.toFile "parsed-structure.nix" dslEnv);

      mkZenType = meta: type: type // { _zenosMeta = meta; };

      resolveType =
        zType:
        if builtins.isAttrs zType && zType ? _isZenType then
          if zType.name == "alias" then
            let
              parts = lib.splitString "." zType.target;
              isRoot = parts == [ "nixpkgs" ];
              targetPath = if isRoot then [ ] else lib.tail parts;

              isUserPath = lib.last parts == "<user>";
              actualPath = if isUserPath then lib.init targetPath else targetPath;

              targetOpts = lib.attrByPath actualPath { } options;

              isLeaf = targetOpts ? _type && targetOpts._type == "option";

              finalOpts =
                if isUserPath && isLeaf && targetOpts.type ? getSubOptions then
                  targetOpts.type.getSubOptions [ ]
                else if isUserPath then
                  { }
                else
                  targetOpts;
            in
            if isRoot then
              lib.types.attrsOf lib.types.anything
            else if !isUserPath && isLeaf then
              targetOpts.type
            else
              lib.types.submodule {
                options = finalOpts;
              }
          else if zType.name == "packages" then
            lib.types.attrsOf lib.types.anything
          else
            lib.types.submodule { options = { }; }
        else
          lib.types.submodule { options = { }; };

      mkNode =
        node:
        let
          # Metadata logic: all metadata MUST be inside _meta
          metaData = node._meta or { };
          meta = {
            brief = metaData.brief or "";
            description = metaData.description or "";
            maintainers = metaData.maintainers or [ ];
          };
          nodeType = metaData.type or null;

          # Branching logic: Everything except _meta is a child node
          rawChildren = builtins.removeAttrs node [ "_meta" ];

          # Process children
          baseChildren = lib.mapAttrs (k: v: mkNode v) rawChildren;

          # Inject 'legacy' option for program containers
          processedChildren =
            if (nodeType.name or "") == "programs" then
              baseChildren
              // {
                legacy = lib.mkOption {
                  type = lib.types.attrsOf lib.types.anything;
                  default = { };
                  description = "Raw upstream options for this category.";
                };
              }
            else
              baseChildren;

          # Check for user freeform mapping
          hasFreeformUser = rawChildren ? "<name>";
        in
        if hasFreeformUser then
          lib.mkOption {
            type = mkZenType meta (
              lib.types.attrsOf (
                lib.types.submodule (
                  { name, ... }:
                  {
                    options = lib.mapAttrs (k: v: mkNode v) rawChildren."<name>";
                  }
                )
              )
            );
            default = { };
            description = meta.description;
          }
        else if processedChildren != { } then
          lib.mkOption {
            type = mkZenType meta (
              lib.types.submodule {
                options = processedChildren;
              }
            );
            default = { };
            description = meta.description;
          }
        else
          lib.mkOption {
            type = mkZenType meta (resolveType nodeType);
            default = node.default or (if (nodeType.name or "") == "alias" then { } else null);
            description = meta.description;
          };
    in
    lib.mapAttrs (k: v: mkNode v) parsedStructure;

in
{
  inherit
    mkHosts
    walkDir
    mkPackageTree
    parseZstr
    ;
}
