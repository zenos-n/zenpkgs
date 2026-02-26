{
  lib,
  inputs ? { },
}:
let
  zDialect = import ./z-dialect.nix { inherit lib; };
  maintainers = import ./maintainers.nix;
  licenses = import ./licenses.nix;

  mapZType =
    ztype:
    if !builtins.isAttrs ztype then
      lib.types.unspecified
    else if ztype.name == "boolean" || ztype.name == "bool" then
      lib.types.bool
    else if ztype.name == "string" then
      lib.types.str
    else if ztype.name == "int" then
      lib.types.int
    else if ztype.name == "float" then
      lib.types.float
    else if ztype.name == "null" then
      lib.types.nullOr lib.types.anything
    else if ztype.name == "set" then
      lib.types.attrs
    else if ztype.name == "list" then
      lib.types.listOf lib.types.anything
    else if ztype.name == "path" then
      lib.types.path
    else if ztype.name == "package" then
      lib.types.package
    else if ztype.name == "packages" then
      lib.types.attrsOf lib.types.anything
    else if ztype.name == "color" then
      lib.types.str
      // {
        # Transforms standard Hex/RGB strings by stripping the hashtag at compile time
        apply = v: if builtins.isString v then builtins.replaceStrings [ "#" ] [ "" ] v else v;
      }
    else if ztype.name == "enum" then
      lib.types.enum ztype.values
    else if ztype.name == "either" then
      lib.types.either (mapZType (builtins.elemAt ztype.values 0)) (
        mapZType (builtins.elemAt ztype.values 1)
      )
    else if ztype.name == "function" then
      lib.types.unspecified
    else
      lib.types.unspecified;

  mkOptions =
    ast:
    let
      walk =
        node:
        if node ? _type && node._type == "enableOption" then
          lib.mkEnableOption (node._meta.brief or "Enable module")
        else if node ? _meta && node._meta ? type then
          lib.mkOption {
            type = mapZType node._meta.type;
            default = node._meta.default or null;
            description = node._meta.description or node._meta.brief or "";
          }
        else if builtins.isAttrs node then
          lib.mapAttrs (n: v: walk v) (
            builtins.removeAttrs node [
              "_meta"
              "_action"
              "_saction"
              "_uaction"
              "_type"
              "_v"
            ]
          )
        else
          { };
    in
    walk ast;

  mkConfig =
    cfgPath: ast: isUserScope: globalConfig:
    let
      # Deep replaces dynamic Freeform Identifiers mapped from the transpiler's __Z_FREEFORM_ID__
      replaceFreeform =
        freeformValue: attrset:
        let
          walk =
            val:
            if builtins.isString val then
              builtins.replaceStrings [ "__Z_FREEFORM_ID__" ] [ freeformValue ] val
            else if builtins.isAttrs val then
              lib.listToAttrs (
                map (name: {
                  name = builtins.replaceStrings [ "__Z_FREEFORM_ID__" ] [ freeformValue ] name;
                  value = walk val.${name};
                }) (builtins.attrNames val)
              )
            else if builtins.isList val then
              map walk val
            else
              val;
        in
        walk attrset;

      walk =
        cfgNode: astNode:
        let
          isEnabled = if astNode ? _type && astNode._type == "enableOption" then cfgNode else true;

          # SCOPE AWARENESS: Filter actions based on where this module is currently mounted
          action = if isUserScope then { } else astNode._action or { };
          saction = if isUserScope then { } else astNode._saction or { };

          uaction =
            if isUserScope then
              # If in user scope, _uaction applies directly to this specific user
              astNode._uaction or { }
            else if astNode ? _uaction then
              {
                # If enabled globally, _uaction cascades down to all registered users
                # We iteratively map the action, injecting the username directly to freeform references
                zenos.users = lib.mapAttrs (u: v: replaceFreeform u astNode._uaction) (
                  globalConfig.zenos.users or { }
                );
              }
            else
              { };

          mergedAction = lib.mkMerge [
            action
            saction
            uaction
          ];
          currentConfig = lib.mkIf (isEnabled && mergedAction != { }) mergedAction;

          children = builtins.removeAttrs astNode [
            "_meta"
            "_action"
            "_saction"
            "_uaction"
            "_type"
            "_v"
          ];
          childConfigs = lib.mapAttrsToList (n: v: walk (cfgNode.${n} or { }) v) children;
        in
        lib.mkMerge ([ currentConfig ] ++ childConfigs);
    in
    walk cfgPath ast;

in
rec {
  zmdlToModule =
    {
      file,
      namespacePath,
      isUserScope ? false,
    }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      name = lib.removeSuffix ".zmdl" (builtins.baseNameOf file);
      scopeConfig = lib.attrByPath (namespacePath ++ [ name ]) { } config;

      ast = zDialect.evalZString {
        inherit
          name
          pkgs
          maintainers
          licenses
          ;
        content = builtins.readFile file;
        path = scopeConfig;
        extraArgs = { inherit config; };
      };

    in
    {
      # Add a default legacy mapping for every program module
      options = lib.recursiveUpdate (lib.setAttrByPath (namespacePath ++ [ name ]) (mkOptions ast)) (
        lib.setAttrByPath
          (
            namespacePath
            ++ [
              name
              "legacy"
            ]
          )
          (
            lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = { };
            }
          )
      );
      config = mkConfig scopeConfig ast isUserScope config;
    };

  zstrToModule =
    { file }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      ast = zDialect.evalZString {
        inherit pkgs maintainers licenses;
        content = builtins.readFile file;
        name = "structure";
        extraArgs = { inherit config; };
      };

      processStructure =
        node:
        let
          isAlias = node ? _meta && node._meta ? type && node._meta.type._type == "alias";
          isPackages = node ? _meta && node._meta ? type && node._meta.type._type == "packages";
          isPrograms = node ? _meta && node._meta ? type && node._meta.type._type == "programs";
          isZmdl = node ? _meta && node._meta ? type && node._meta.type._type == "zmdl";

          children = builtins.removeAttrs node [ "_meta" ];
          mappedChildren = lib.mapAttrs (n: v: processStructure v) children;
        in
        if isAlias then
          if children == { } then
            lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              description = node._meta.brief or "Alias to ${node._meta.type.target}";
              default = { }; # Ensure structural aliases have a default empty set
            }
          else
            lib.mkOption {
              # Dynamically promote alias to a submodule if it has children!
              # attrsOf anything allows it to properly merge loose arbitrary variables natively
              type = lib.types.submodule {
                freeformType = lib.types.attrsOf lib.types.anything;
                options = mappedChildren;
              };
              description = node._meta.brief or "Alias to ${node._meta.type.target}";
              default = { };
            }
        else if isPackages then
          lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = node._meta.brief or "Packages scope";
          }
        else if node ? __z_freeform_user then
          lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = processStructure node.__z_freeform_user;
              }
            );
            default = { };
          }
        else if isPrograms || isZmdl then
          mappedChildren
          // (lib.optionalAttrs (!(mappedChildren ? legacy)) {
            # Automatically establish legacy fallback inside structural domains
            legacy = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = { };
              description = "Raw configuration bypass";
            };
          })
        else if builtins.isAttrs node then
          mappedChildren
        else
          { };

    in
    {
      options.zenos = processStructure ast;
    };

  mapZenModules =
    dir: namespacePath: isUserScope:
    if !builtins.pathExists dir then
      [ ]
    else
      let
        entries = builtins.readDir dir;
        processEntry =
          name: type:
          let
            path = dir + "/${name}";
          in
          if type == "directory" then
            mapZenModules path (namespacePath ++ [ name ]) isUserScope
          else if type == "regular" then
            if lib.hasSuffix ".zmdl" name then
              [
                (zmdlToModule {
                  file = path;
                  inherit namespacePath isUserScope;
                })
              ]
            else if lib.hasSuffix ".zstr" name then
              [ (zstrToModule { file = path; }) ]
            else if lib.hasSuffix ".nix" name then
              [ path ]
            else
              [ ]
          else
            [ ];
      in
      lib.flatten (lib.mapAttrsToList processEntry entries);

  # Auto-Documentation Generator Export
  generateDocs =
    {
      optionsTree,
      pkgsTree ? { },
      maintainersData ? maintainers,
    }:
    let
      processNode =
        path: node:
        if lib.isOption node then
          let
            hasMeta = node ? meta && node.meta != { };
            isLegacy = builtins.elem "legacy" path;

            # Trace missing metadata at evaluation time
            traceWarning =
              if (!hasMeta && !isLegacy) then
                builtins.trace "ZONE DOC WARNING: Missing metadata for option ${lib.concatStringsSep "." path}"
              else
                (x: x);

          in
          traceWarning {
            _meta = if hasMeta then node.meta else { brief = node.description or null; };
          }
        else if builtins.isAttrs node then
          lib.mapAttrs (k: v: processNode (path ++ [ k ]) v) (
            lib.filterAttrs (k: v: k != "_module" && k != "_type") node
          )
        else
          { };

      optDocs = processNode [ "zenos" ] (optionsTree.zenos or { });
      pkgDocs = processNode [ "pkgs" ] (pkgsTree.zenos or { });

    in
    builtins.toJSON {
      maintainers = maintainersData;
      options = optDocs;
      pkgs = pkgDocs;
    };
}
