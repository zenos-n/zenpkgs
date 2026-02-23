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
        node:
        node
        // {
          type = "bool";
          _isZenLeaf = true;
        };

      maintainers = if builtins.pathExists ../maintainers.nix then import ../maintainers.nix else { };

      imported =
        if lib.hasSuffix ".zmdl" file then
          let
            rawContent = builtins.readFile file;
            trimmed = lib.trim rawContent;
            templated =
              lib.replaceStrings
                [ "$path" "$cfg" "$name" "$m" "$l" ]
                [ attrPath cfgPath name "lib.maintainers" "lib.licenses" ]
                rawContent;
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
        path: opts: parentMeta:
        let
          # 1. Resolve Metadata & Inheritance within the file scope
          metaRaw = opts._meta or (opts.meta or { });
          currentMeta = metaRaw // {
            license = metaRaw.license or parentMeta.license or null;
            maintainers = metaRaw.maintainers or parentMeta.maintainers or [ ];
            brief = metaRaw.brief or parentMeta.brief or "";
            description = metaRaw.description or parentMeta.description or "";
          };

          # 2. Identify Children (Everything not a reserved keyword)
          reserved = [
            "_meta"
            "_saction"
            "_uaction"
            "meta"
            "action"
            "legacy"
            "type"
            "default"
            "_isZenLeaf"
          ];
          childKeys = builtins.filter (n: !(builtins.elem n reserved)) (builtins.attrNames opts);

          # If a node has no children, it evaluates as a leaf option
          isLeaf = childKeys == [ ];

          # 3. Process Children Recursively
          childrenNodes = lib.getAttrs childKeys opts;
          processedChildren = lib.mapAttrs (
            n: v: processZmdlOptions (path ++ [ n ]) v currentMeta
          ) childrenNodes;
        in
        {
          option =
            if isLeaf then
              lib.mkOption {
                type = (mapType (opts.type or "bool") (opts.enum or [ ])) // {
                  _zenosMeta = currentMeta; # Inject metadata for docs.nix
                };
                default = opts.default or (if (opts.type or "bool") == "bool" then false else null);
                description = currentMeta.brief;
              }
            else
              lib.mapAttrs (n: v: v.option) processedChildren;

          action =
            localConfig: isUser:
            let
              # Retrieve the configuration value for the current path
              nodeCfg = lib.attrByPath path { } localConfig;

              # Action for this specific node
              thisAction =
                if isUser && opts ? _uaction then
                  if builtins.isFunction opts._uaction then
                    opts._uaction {
                      cfg = nodeCfg;
                      inherit isUser;
                    }
                  else
                    opts._uaction
                else if !isUser && opts ? _saction then
                  if builtins.isFunction opts._saction then
                    opts._saction {
                      cfg = nodeCfg;
                      inherit isUser;
                    }
                  else
                    opts._saction
                else
                  { };

              # If this is a leaf node and a boolean, only apply the action if `cfg == true`
              nodeActionWrapped =
                if isLeaf && (opts.type or "bool") == "bool" then
                  lib.mkIf (nodeCfg == true) thisAction
                else
                  thisAction;
            in
            lib.mkMerge (
              [ nodeActionWrapped ] ++ (lib.mapAttrsToList (n: v: v.action localConfig isUser) processedChildren)
            );
        };

      # Start the processing chain (pass empty parent meta initially)
      tree = processZmdlOptions pathList (imported.options or imported) { };
    in
    if isProgram then
      {
        options.zenos.system = lib.setAttrByPath pathList tree.option;

        options.zenos.users = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule (
              { config, ... }:
              {
                options = lib.setAttrByPath pathList tree.option;
                config = lib.mkMerge [
                  (imported.action or { })
                  (imported.legacy or { })
                  (tree.action config true)
                ];
              }
            )
          );
        };

        config = lib.mkMerge [
          (imported.action or { })
          (imported.legacy or { })
          (tree.action config.zenos.system false)
        ];
      }
    else
      {
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
