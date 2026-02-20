{ lib }:
let
  removeExt = name: lib.removeSuffix ".zmdl" (lib.removeSuffix ".nix" name);

  mapType =
    t: v:
    let
      types = lib.types;
    in
    {
      "bool" = types.bool;
      "string" = types.str;
      "int" = types.ints.any;
      "integer" = types.ints.any;
      "float" = types.float;
      "enum" = types.enum v;
      "list" = types.listOf types.anything;
      "set" = types.attrsOf types.anything;
      "null" = types.nullOr types.anything;
      "freeform" = types.anything;
      "function" = types.functionTo types.anything;
    }
    .${t} or types.anything;

  mkZenModule =
    pathList: file:
    {
      pkgs,
      lib,
      config,
      ...
    }@args:
    let
      attrPath = lib.concatStringsSep "." ([ "zenos" ] ++ pathList);
      cfgPath = "config.${attrPath}";
      name = lib.last pathList;

      enableOption =
        {
          meta ? { },
          action ? { },
        }:
        {
          _isZenLeaf = true;
          type = "bool";
          default = false;
          inherit meta action;
        };

      maintainers = if builtins.pathExists ../maintainers.nix then import ../maintainers.nix else { };

      imported =
        if lib.hasSuffix ".zmdl" file then
          let
            rawContent = builtins.readFile file;
            trimmed = lib.trim rawContent;
            templated = lib.replaceStrings [ "$path" "$cfg" "$name" ] [ attrPath cfgPath name ] rawContent;

            wrapped =
              if lib.hasPrefix "{" trimmed then
                ''
                  { pkgs, lib, config, enableOption, maintainers, ... }@args:
                  let f = ${templated}; in if builtins.isFunction f then f args else f
                ''
              else
                ''
                  { pkgs, lib, config, enableOption, maintainers, ... }: { ${templated} }
                '';
            storeFile = builtins.toFile "zen-module-${name}.nix" wrapped;
          in
          import storeFile (args // { inherit enableOption maintainers; })
        else
          let
            raw = import file;
          in
          if builtins.isFunction raw then raw (args // { inherit enableOption maintainers; }) else raw;

      processZmdlOptions =
        path: opts:
        let
          isLeaf = o: builtins.isAttrs o && (o._isZenLeaf or false || o ? type);
          leaves = lib.filterAttrs (n: v: isLeaf v) opts;
          nodes = lib.filterAttrs (
            n: v: !isLeaf v && n != "_meta" && n != "_action" && n != "meta" && n != "action" && n != "legacy"
          ) opts;
          processedNodes = lib.mapAttrs (n: v: processZmdlOptions (path ++ [ n ]) v) nodes;
        in
        {
          option =
            (lib.mapAttrs (
              n: v:
              lib.mkOption {
                type = mapType (v.type or "freeform") (v.enum or [ ]);
                default = v.default or (if v.type or "" == "bool" then false else null);
                description = v._meta.brief or v.meta.brief or "";
              }
            ) leaves)
            // (lib.mapAttrs (n: v: v.option) processedNodes);

          action =
            config:
            let
              nodeCfg = lib.attrByPath ([ "zenos" ] ++ path) { } config;
            in
            lib.mkMerge (
              (lib.mapAttrsToList (
                n: v:
                if (v.type or "") == "bool" then
                  lib.mkIf (nodeCfg.${n} or false) (v.action or { })
                else if v ? action then
                  (v.action nodeCfg.${n})
                else
                  { }
              ) leaves)
              ++ (lib.mapAttrsToList (n: v: v.action config) processedNodes)
            );
        };

      tree = processZmdlOptions pathList (imported.options or { });
    in
    {
      options.zenos = lib.setAttrByPath pathList tree.option;
      config = lib.mkMerge [
        (imported.action or { })
        (imported.legacy or { }) # Non-recursive promotion
        (tree.action config)
      ];
    };

  mapZenModules =
    dir: currentPath:
    let
      contents = if builtins.pathExists dir then builtins.readDir dir else { };
      processItem =
        name: type:
        let
          path = dir + "/${name}";
          newPathList = currentPath ++ [ (removeExt name) ];
        in
        if type == "directory" then
          mapZenModules path newPathList
        else if type == "regular" && (lib.hasSuffix ".nix" name || lib.hasSuffix ".zmdl" name) then
          [ (mkZenModule newPathList path) ]
        else
          [ ];
    in
    lib.flatten (lib.mapAttrsToList processItem contents);
in
{
  inherit mapZenModules;
}
