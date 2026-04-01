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
      # do NOT stop on your custom dialect _type nodes or mkIfs.
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

  # update to accept keepMeta flag
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

  # inside zen-core.nix
  mkPackageTree =
    zpkgBuilder: pkgs: root:
    let
      # look for both .nix and .zpkg
      isPkg = n: t: t == "regular" && (lib.hasSuffix ".nix" n || lib.hasSuffix ".zpkg" n);
      files = walkDir root isPkg;

      toPackageAttr =
        entry:
        let
          isZpkg = lib.hasSuffix ".zpkg" entry.name;
          pname = if isZpkg then lib.removeSuffix ".zpkg" entry.name else lib.removeSuffix ".nix" entry.name;
          attrPath = entry.relPath ++ [ pname ];
          # fix: use zpkgBuilder for .zpkg, callPackage for .nix
          pkg = if isZpkg then zpkgBuilder pkgs entry.absPath else pkgs.callPackage entry.absPath { };
        in
        lib.setAttrByPath attrPath pkg;
    in
    lib.foldl' lib.recursiveUpdate { } (map toPackageAttr files);

  importZcfg =
    path: args:
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
            args@{ pkgs, ... }: # Capture pkgs from the module args
            let
              raw =
                if (lib.hasSuffix ".zcfg" entry.name || lib.hasSuffix ".nzo" entry.name) then
                  importZcfg entry.absPath (args // { inherit pkgs; }) # Pass it here
                else
                  import entry.absPath args;

              # SCRUB BEFORE IT ENTERS THE MODULE SYSTEM
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
