{
  lib,
}:
let
  zDialect = import ./z-dialect.nix { inherit lib; };
  maintainers = import ./maintainers.nix;
  licenses = import ./licenses.nix;

  mapZType =
    ztype:
    if ztype.name == "boolean" then
      lib.types.bool
    else if ztype.name == "string" then
      lib.types.str
    else if ztype.name == "int" then
      lib.types.int
    else if ztype.name == "enum" then
      lib.types.enum ztype.values
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
            ]
          )
        else
          { };
    in
    walk ast;

  mkConfig =
    cfgPath: ast: isUserScope: globalConfig:
    let
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
                zenos.users = lib.mapAttrs (u: v: astNode._uaction) (globalConfig.zenos.users or { });
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
      lib,
      pkgs,
      ...
    }:
    let
      ast = zDialect.evalZString {
        inherit pkgs maintainers licenses;
        content = builtins.readFile file;
        name = "structure";
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
}
