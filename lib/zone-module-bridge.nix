{
  lib,
  inputs ? { },
  ...
}:
let

  zDialect = import ./zone-dialect.nix { inherit lib; };
  maintainers = import ./maintainers.nix;
  licenses = import ./licenses.nix;
  attachMeta = type: meta: type // { _zmeta = meta; };

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
      lib.types.listOf (
        if (ztype.elemType or null) != null then mapZType ztype.elemType else lib.types.anything
      )
    else if ztype.name == "path" then
      lib.types.path
    else if ztype.name == "package" then
      lib.types.package
    else if ztype.name == "packages" then
      lib.types.attrsOf lib.types.anything
    else if ztype.name == "color" then
      lib.types.coercedTo lib.types.str (v: builtins.replaceStrings [ "#" ] [ "" ] v) lib.types.str
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
        else if builtins.isAttrs node then
          let
            freeformKey = lib.findFirst (n: lib.hasPrefix "__z_freeform_" n) null (builtins.attrNames node);
            hasFreeform = freeformKey != null;
            hasMeta = node ? _meta;
            hasType = hasMeta && node._meta ? type;

            children = builtins.removeAttrs node [
              "_meta"
              "_action"
              "_saction"
              "_uaction"
              "_action_unconditional"
              "_saction_unconditional"
              "_uaction_unconditional"
              "_type"
              "_v"
            ];

            cleanChildren = builtins.removeAttrs children (if hasFreeform then [ freeformKey ] else [ ]);
            hasChildren = cleanChildren != { };

            # extract the internal schema
            innerOptions =
              if hasFreeform then walk node.${freeformKey} else lib.mapAttrs (n: v: walk v) cleanChildren;

            actualType =
              if hasType then
                let
                  zt = node._meta.type;
                in
                if zt.name == "list" && hasFreeform then
                  lib.types.listOf (lib.types.submodule { options = innerOptions; })
                else if zt.name == "list" && zt ? elemType && zt.elemType != null then
                  lib.types.listOf (mapZType zt.elemType)
                else if zt.name == "packages" && hasFreeform then
                  lib.types.attrsOf (lib.types.submodule { options = innerOptions; })
                else
                  mapZType zt
              else if hasFreeform then
                lib.types.attrsOf (lib.types.submodule { options = innerOptions; })
              else if hasChildren then
                lib.types.submodule { options = innerOptions; }
              else
                lib.types.unspecified;

          in
          if hasMeta || hasFreeform || hasChildren then
            # wrap in mkOption if it has meta, meaning parent container descriptions survive
            if hasMeta || hasFreeform then
              lib.mkOption {
                type = actualType // (if hasMeta then { _zmeta = node._meta; } else { });
                default =
                  if hasMeta && node._meta ? default then
                    node._meta.default
                  else if !hasType && !hasFreeform && hasChildren then
                    { }
                  else
                    lib.modules.mkOptionDefault null;
                description =
                  if hasMeta then
                    (node._meta.description or node._meta.brief or "")
                  else if hasFreeform then
                    "Collection of ${lib.removePrefix "__z_freeform_" freeformKey}"
                  else
                    "";
              }
            else
              # naked directory with no meta, return raw
              innerOptions
          else
            { }
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
          # Detect freeform scope
          freeformKey = lib.findFirst (k: lib.hasPrefix "__z_freeform_" k) null (builtins.attrNames astNode);
          isFreeform = freeformKey != null;

          # For freeform nodes, expand an action across all live config instances
          expandFreeform =
            rawAction:
            if isFreeform && builtins.isAttrs cfgNode && cfgNode != { } then
              lib.mkMerge (lib.mapAttrsToList (inst: _: replaceFreeform inst rawAction) cfgNode)
            else
              rawAction;

          isEnabled = if astNode ? _type && astNode._type == "enableOption" then cfgNode else true;

          # SCOPE AWARENESS: Filter actions based on where this module is currently mounted
          action = if isUserScope then { } else expandFreeform (astNode._action or { });
          saction = if isUserScope then { } else expandFreeform (astNode._saction or { });

          uaction =
            if isUserScope then
              expandFreeform (astNode._uaction or { })
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

          # Extract conditional actions
          condActionKeys = lib.filterAttrs (k: v: lib.hasPrefix "__z_action_cond_" k) astNode;
          condUncondKeys = lib.filterAttrs (k: v: lib.hasPrefix "__z_action_uncond_cond_" k) astNode;

          condActions =
            if isUserScope then { } else expandFreeform (lib.mkMerge (builtins.attrValues condActionKeys));
          condUncondActions = expandFreeform (lib.mkMerge (builtins.attrValues condUncondKeys));

          # Merge unconditional actions
          unconditionalAction = lib.mkMerge [
            (expandFreeform (astNode._action_unconditional or { }))
            (if isUserScope then { } else expandFreeform (astNode._saction_unconditional or { }))
            (if isUserScope then expandFreeform (astNode._uaction_unconditional or { }) else { })
            condUncondActions
          ];

          # Existing logic for standard actions
          mergedAction = lib.mkMerge [
            action
            saction
            uaction
            condActions
          ];

          currentConfig = lib.mkMerge [
            unconditionalAction
            (lib.mkIf (isEnabled && mergedAction != { }) mergedAction)
          ];

          children = builtins.removeAttrs astNode (
            [
              "_meta"
              "_action"
              "_saction"
              "_uaction"
              "_action_unconditional"
              "_saction_unconditional"
              "_uaction_unconditional"
              "_type"
              "_v"
            ]
            ++ builtins.attrNames condActionKeys
            ++ builtins.attrNames condUncondKeys
          );

          # For freeform nodes iterate over actual config instances rather than the __z_freeform_* key
          childConfigs =
            if isFreeform then
              let
                subAst = astNode.${freeformKey};
              in
              lib.mapAttrsToList (inst: instCfg: walk instCfg (replaceFreeform inst subAst)) (
                if builtins.isAttrs cfgNode then cfgNode else { }
              )
            else
              lib.mapAttrsToList (n: v: walk (cfgNode.${n} or { }) v) children;
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
      # Removed the default legacy mapping hack!
      options = lib.setAttrByPath (namespacePath ++ [ name ]) (mkOptions ast);
      config = mkConfig scopeConfig ast isUserScope config;
    };

  zstrToModule =
    { file }:
    {
      config,
      lib,
      pkgs,
      isDocs ? false,
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
        if isAlias && children == { } then
          lib.mkOption {
            # Attach meta to the type object directly
            type = attachMeta (lib.types.attrsOf lib.types.anything) node._meta;
            description = node._meta.brief or "Alias to ${node._meta.type.target}";
            default = { };
          }
        else if isPackages then
          lib.mkOption {
            type = attachMeta (lib.types.attrsOf lib.types.anything) node._meta;
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
        else if isAlias then
          lib.mkOption {
            # Submodule with metadata attached to the type
            type = attachMeta (lib.types.submoduleWith {
              modules = [
                {
                  freeformType = lib.types.attrsOf lib.types.anything;
                  options = mappedChildren;
                }
              ];
            }) node._meta;
            description = node._meta.brief or "Alias to ${node._meta.type.target}";
            default = { };
          }
        else if isPrograms || isZmdl then
          # For categories, we add a hidden internal option that carries the meta on its TYPE
          mappedChildren
          // (lib.optionalAttrs isDocs {
            _zmeta_carrier = lib.mkOption {
              internal = true; # This stops the doc generator from tracing it as a "naked" option
              visible = false;
              type = lib.types.anything // {
                _zmeta = node._meta;
              };
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

  generateDocs =
    {
      optionsTree,
      pkgsTree ? { },
      maintainersData ? maintainers,
    }:
    let
      processNode =
        path: node:
        # 1. Check if this is an evaluated option (NixOS options tree)
        if (node ? _type && node._type == "option") || (node ? definitions && node ? type) then
          let
            # Metadata is stored on the type object
            zmeta = node.type._zmeta or null;
            hasMeta = zmeta != null && zmeta != { };
            isLegacy = builtins.elem "legacy" path;
            isInternal = node.internal or false;

            traceWarning =
              if (!hasMeta && !isLegacy && !isInternal) then
                builtins.trace "ZONE DOC WARNING: Missing metadata for option ${lib.concatStringsSep "." path}"
              else
                (x: x);
          in
          traceWarning {
            _meta =
              if hasMeta then
                zmeta
              else
                { brief = node.description or (if node ? default then builtins.toJSON node.default else null); };
          }
        # 2. Check if this is a category (attribute set)
        else if builtins.isAttrs node then
          let
            # Look for our carrier option to get category metadata
            zmeta = node._zmeta_carrier.type._zmeta or null;
            hasMeta = zmeta != null;
            isLegacy = builtins.elem "legacy" path;

            children = lib.filterAttrs (k: v: k != "_module" && k != "_type" && k != "_zmeta_carrier") node;

            traceWarning =
              if (!hasMeta && !isLegacy) then
                builtins.trace "ZONE DOC WARNING: Missing metadata for category ${lib.concatStringsSep "." path}"
              else
                (x: x);
          in
          traceWarning (
            (if hasMeta then { _meta = zmeta; } else { })
            // lib.mapAttrs (k: v: processNode (path ++ [ k ]) v) children
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
