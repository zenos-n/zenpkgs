{
  lib,
  inputs,
}:
let
  zDialect = import ./z-dialect.nix { inherit lib; };
  maintainers = import ./maintainers.nix;
  licenses = import ./licenses.nix;

  mapZType =
    ztype:
    if ztype == "boolean" || ztype.name == "boolean" then
      lib.types.bool
    else if ztype == "string" || ztype.name == "string" then
      lib.types.str
    else if ztype == "int" || ztype.name == "int" then
      lib.types.int
    else if builtins.isAttrs ztype && ztype.name == "enum" then
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
              "_deps"
              "_vars"
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
        path: node:
        if node ? _type && node._type == "enableOption" then
          let
            # 1. Base Options Enablement
            enabled = lib.attrByPath (cfgPath ++ path) false globalConfig;

            # 2. Dependency Awareness & Assertions Processing
            deps = node._deps or { };
            depList =
              if builtins.isList deps then
                deps
              else if builtins.isAttrs deps then
                builtins.attrNames deps
              else
                [ ];
            assertions = map (
              dep:
              let
                depName = if builtins.isAttrs dep && dep._type == "needs" then dep.dep else dep;
              in
              {
                assertion = lib.attrByPath (builtins.split "\\." depName) false globalConfig;
                message = "ZenOS Module dependency missing: ${depName} is required by ${
                  lib.concatStringsSep "." (cfgPath ++ path)
                }.";
              }
            ) depList;

            # 3. Scope Promotion Logic
            currentUser = globalConfig.zenos.user or "doromiert";

            extractGroups =
              action:
              let
                groupsAttr = action.groups or [ ];
                groupNames = map (g: if builtins.isAttrs g && g._type == "group" then g.name else g) groupsAttr;
              in
              groupNames;

            mergedAction =
              if isUserScope then
                lib.mkMerge [
                  (node._action or { })
                  (node._uaction or { })
                ]
              else
                let
                  sAction = node._saction or { };
                  uAction = node._uaction or { };

                  # Broadcast System-level User Action logic to Home Manager
                  allUsers = builtins.attrNames (globalConfig.users.users or { });
                  broadcastAction =
                    if (node ? _uaction) then
                      {
                        home-manager.users = lib.genAttrs allUsers (user: {
                          zenos = uAction;
                        });
                      }
                    else
                      { };

                  # Handle immediate (group name) injections
                  extractedGroups = extractGroups uAction;
                  groupAction =
                    if (builtins.length extractedGroups > 0) then
                      {
                        users.users."${currentUser}".extraGroups = extractedGroups;
                      }
                    else
                      { };

                in
                lib.mkMerge [
                  (node._action or { })
                  sAction
                  broadcastAction
                  groupAction
                ];

          in
          lib.mkIf enabled (
            lib.mkMerge [
              mergedAction
              { inherit assertions; }
            ]
          )
        else if builtins.isAttrs node then
          lib.mapAttrs (n: v: walk (path ++ [ n ]) v) (
            builtins.removeAttrs node [
              "_meta"
              "_action"
              "_saction"
              "_uaction"
              "_type"
              "_deps"
              "_vars"
            ]
          )
        else
          { };
    in
    walk [ ] ast;

  zmdlToModule =
    {
      file,
      namespacePath,
      isUserScope ? false,
    }:
    let
      name = lib.removeSuffix ".zmdl" (builtins.baseNameOf file);
      cfgPath = namespacePath ++ [ name ];

      ast = zDialect.evalZString {
        inherit name file isUserScope;
        path = cfgPath;
        extraArgs = {
          __zargs.pkgs = {
            zenos = inputs.self.packages;
          };
          __zargs.lib = lib;
          __zargs.maintainers = maintainers;
          __zargs.licenses = licenses;
        };
      };

    in
    { config, ... }:
    {
      options = lib.setAttrByPath cfgPath (mkOptions ast);
      config = mkConfig cfgPath ast isUserScope config;
    };

  zstrToModule =
    { file }:
    let
      ast = zDialect.evalZString {
        name = lib.removeSuffix ".zstr" (builtins.baseNameOf file);
        inherit file;
      };

      processStructure =
        node:
        let
          mappedChildren = lib.mapAttrs (n: v: processStructure v) node;
          isZmdl = builtins.any (x: x ? _type && x._type == "zmdl") (builtins.attrValues node);
        in
        if isZmdl then
          mappedChildren
          // (lib.optionalAttrs (!(mappedChildren ? legacy)) {
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
in
{
  inherit
    mapZenModules
    mkOptions
    mkConfig
    zmdlToModule
    zstrToModule
    ;
}
