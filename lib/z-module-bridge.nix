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
    cfgPath: ast:
    let
      walk =
        cfgNode: astNode:
        let
          isEnabled = if astNode ? _type && astNode._type == "enableOption" then cfgNode else true;

          action = astNode._action or { };
          saction = astNode._saction or { };
          uaction =
            if astNode ? _uaction then
              {
                zenos.users = lib.mapAttrs (u: v: astNode._uaction) cfgPath.users or { };
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
    { file, namespacePath }:
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
      options = lib.setAttrByPath (namespacePath ++ [ name ]) (mkOptions ast);
      config = mkConfig scopeConfig ast;
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
      };

      processStructure =
        node:
        if node ? _meta && node._meta ? type && node._meta.type._type == "alias" then
          lib.mkOption {
            type = lib.types.attrs;
            description = node._meta.brief or "Alias to ${node._meta.type.target}";
          }
        else if node ? _meta && node._meta ? type && node._meta.type._type == "packages" then
          lib.mkOption {
            type = lib.types.attrsOf lib.types.package;
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
        else if builtins.isAttrs node then
          lib.mapAttrs (n: v: processStructure v) (builtins.removeAttrs node [ "_meta" ])
        else
          { };

    in
    {
      options.zenos = processStructure ast;
    };

  mapZenModules =
    dir: namespacePath:
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
            mapZenModules path (namespacePath ++ [ name ])
          else if type == "regular" then
            if lib.hasSuffix ".zmdl" name then
              [
                (zmdlToModule {
                  file = path;
                  inherit namespacePath;
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
