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
    lib: path:
    let
      rawZstr = builtins.readFile path;
      cleanSyntax =
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
            "children.\"<user>\" ="
            "nixpkgs_users_user"
            "type = (programs user);\n"
            "type = (programs user);\r\n"
          ]
          rawZstr;

      dslEnv = ''
        let
          alias = target: { _isZenType = true; name = "alias"; inherit target; };
          zmdl = target: { _isZenType = true; name = "zmdl"; inherit target; };
          zdml = target: { _isZenType = true; name = "zmdl"; inherit target; }; # Typo handler
          packages = target: { _isZenType = true; name = "packages"; inherit target; };
          programs = target: { _isZenType = true; name = "programs"; inherit target; };

          nixpkgs = "nixpkgs";
          system = "system";
          desktops = "desktops";
          users = "users";
          user = "user";
          nixpkgs_users_user = "nixpkgs.users.users.<user>";
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
            lib.types.attrsOf lib.types.anything
          else if zType.name == "packages" then
            lib.types.attrsOf lib.types.anything
          else
            lib.types.submodule { options = { }; }
        else
          lib.types.submodule { options = { }; };

      mkNode =
        node:
        let
          meta = {
            brief = node.brief or "";
            description = node.description or "";
            maintainers = node.maintainers or [ ];
          };
          hasChildren = node ? children;
          hasFreeformUser = hasChildren && node.children ? "<user>";
        in
        if hasFreeformUser then
          lib.mkOption {
            type = mkZenType meta (
              lib.types.attrsOf (
                lib.types.submodule (
                  { name, ... }:
                  {
                    options = lib.mapAttrs (k: v: mkNode v) node.children."<user>";
                  }
                )
              )
            );
            default = node.default or { };
            description = meta.description;
          }
        else if hasChildren then
          lib.mkOption {
            type = mkZenType meta (
              lib.types.submodule {
                options = lib.mapAttrs (k: v: mkNode v) node.children;
              }
            );
            default = node.default or { };
            description = meta.description;
          }
        else
          lib.mkOption {
            type = mkZenType meta (resolveType (node.type or null));
            default = node.default or { };
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
