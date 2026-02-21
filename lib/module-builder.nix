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
      # Check if this module is in the programs namespace
      isProgram = builtins.length pathList > 0 && builtins.head pathList == "programs";

      # Adjust path pointers for $path / $cfg replacements
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
                  let f = ${templated};
                  in if builtins.isFunction f then f args else f
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
                default = v.default or (if (v.type or "") == "bool" then false else null);
                description = v._meta.brief or v.meta.brief or "";
              }
            ) leaves)
            // (lib.mapAttrs (n: v: v.option) processedNodes);

          # NEW: action now accepts a relative namespace configuration
          # In lib/module-builder.nix
          action =
            localConfig: isUser: # <-- ADD isUser parameter here
            let
              nodeCfg = lib.attrByPath path { } localConfig;
            in
            lib.mkMerge (
              (lib.mapAttrsToList (
                n: v:
                if (v.type or "") == "bool" then
                  let
                    # If action is a function, pass the dynamic context
                    evaluatedAction =
                      if builtins.isFunction (v.action or { }) then
                        (v.action or { }) {
                          cfg = nodeCfg;
                          inherit isUser;
                        }
                      else
                        (v.action or { });
                  in
                  lib.mkIf (nodeCfg.${n} or false) evaluatedAction
                else if v ? action then
                  if builtins.isFunction v.action then
                    v.action nodeCfg.${n} # Keep existing behavior for non-bools
                  else
                    v.action
                else
                  { }
              ) leaves)
              ++ (lib.mapAttrsToList (
                n: v: v.action localConfig isUser # <-- Pass isUser down the tree
              ) processedNodes)
            );
        };

      tree = processZmdlOptions pathList (imported.options or { });
    in
    if isProgram then
      {
        # 1. Map options to system.programs
        options.zenos.system = lib.setAttrByPath pathList tree.option;

        # 2. Map options inside the users.<name> submodule
        options.zenos.users = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule (
              { config, ... }:
              {
                options = lib.setAttrByPath pathList tree.option;
                config = lib.mkMerge [
                  (imported.action or { })
                  (imported.legacy or { })
                  (tree.action config true) # <-- Pass true for isUser
                ];
              }
            )
          );
        };

        # 3. Apply the system action logic to the top-level
        config = lib.mkMerge [
          (imported.action or { })
          (imported.legacy or { })
          (tree.action config.zenos.system false)
        ];
      }
    else
      {
        # Default behavior for non-programs (e.g. system core options)
        options.zenos = lib.setAttrByPath pathList tree.option;
        config = lib.mkMerge [
          (imported.action or { })
          (imported.legacy or { })
          (tree.action config.zenos false)
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
