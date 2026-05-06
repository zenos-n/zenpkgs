{
  lib,
  inputs,
  isDocs ? false,
}:
let
  scrubMeta =
    keepMeta: node:
    if isDocs then
      node
    else if keepMeta then
      node
    else if builtins.isAttrs node then
      # ESCAPE HATCH: ONLY stop on actual derivations or module definitions.
      if lib.isDerivation node || node ? outPath || node ? _module then
        node
      else
        let
          cleanAttrs = builtins.removeAttrs node [
            "_meta"
            "_zmeta_passthrough"
            "_zmeta_carrier"
          ];
        in
        lib.mapAttrs (k: v: scrubMeta keepMeta v) cleanAttrs
    else if builtins.isList node then
      map (scrubMeta keepMeta) node
    else
      node;

  cleanLegacyBlocks =
    node:
    if isDocs then
      node
    else if builtins.isAttrs node then
      lib.mapAttrs (k: v: if k == "legacy" then scrubMeta v else cleanLegacyBlocks v) node
    else if builtins.isList node then
      map cleanLegacyBlocks node
    else
      node;

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

  # much cleaner now
  mkPackageTree =
    pkgs: root:
    let
      isPkg = n: t: t == "regular" && lib.hasSuffix ".nix" n;
      files = walkDir root isPkg;

      toPackageAttr =
        entry:
        let
          pname = lib.removeSuffix ".nix" entry.name;
          attrPath = entry.relPath ++ [ pname ];
          pkg = pkgs.callPackage entry.absPath { };
        in
        lib.setAttrByPath attrPath pkg;
    in
    lib.foldl' lib.recursiveUpdate { } (map toPackageAttr files);

  importZcfg =
    path: args:
    let
      hostDir = builtins.dirOf path;
      content = builtins.readFile path;

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

      squashEnables =
        path: val:
        if builtins.isAttrs val then
          let
            isPkgPath = builtins.elem "packages" path;
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
            args@{ pkgs, ... }:
            let
              raw =
                if (lib.hasSuffix ".zcfg" entry.name || lib.hasSuffix ".nzo" entry.name) then
                  importZcfg entry.absPath (args // { inherit pkgs; })
                else
                  import entry.absPath args;

              safeRaw = scrubMeta false raw;

              legacyConfig = safeRaw.legacy or { };
              zenosConfig = builtins.removeAttrs safeRaw [ "legacy" ];
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
              isDocs = false;
            };
            modules = modules ++ [ hostModule ];
          };
        };
    in
    builtins.listToAttrs (map mkSystem files);

in
{
  inherit
    mkHosts
    walkDir
    mkPackageTree
    ;
}
