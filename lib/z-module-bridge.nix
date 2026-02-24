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

  processNode =
    node:
    if node ? _type && node._type == "enableOption" then
      lib.mkOption {
        default = false;
        example = true;
        type = lib.types.bool;
        description = node._meta.description or node._meta.brief or "Enable module";
      }
      // {
        meta = {
          brief = node._meta.brief or null;
        };
      }
    else if node ? _meta && node._meta ? type then
      lib.mkOption {
        type = mapZType node._meta.type;
        default = node._meta.default or null;
        description = node._meta.description or node._meta.brief or "";
      }
      // {
        meta = {
          brief = node._meta.brief or null;
        };
      }
    else if builtins.isAttrs node then
      let
        cleaned = builtins.removeAttrs node [
          "_meta"
          "_action"
          "_saction"
          "_uaction"
          "legacy"
        ];
        mappedChildren = lib.mapAttrs' (
          n: v:
          if lib.hasPrefix "__freeform_" n then
            let
              freeformName = lib.removePrefix "__freeform_" n;
            in
            lib.nameValuePair freeformName (
              lib.mkOption {
                type = lib.types.attrsOf (lib.types.submodule { options = processNode v; });
                description = v._meta.description or v._meta.brief or "";
                meta = {
                  brief = v._meta.brief or null;
                };
              }
            )
          else
            lib.nameValuePair n (processNode v)
        ) cleaned;
        namespaceMeta = lib.optionalAttrs (node ? _meta) {
          _meta = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = node._meta;
            internal = true;
            description = "Internal ZenOS metadata for namespace";
          };
        };
      in
      mappedChildren // namespaceMeta
    else
      { };

  mkOptions = ast: processNode ast;

  mkConfig =
    cfgPath: ast: isUserScope: globalConfig:
    let
      walk =
        path: node:
        if node ? _type && node._type == "enableOption" then
          let
            enabled = lib.attrByPath (cfgPath ++ path) false globalConfig;
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
          let
            cleanNode = builtins.removeAttrs node [
              "_meta"
              "_action"
              "_saction"
              "_uaction"
              "_type"
              "_deps"
              "_vars"
            ];
          in
          lib.mkMerge (
            lib.mapAttrsToList (
              n: v:
              if lib.hasPrefix "__freeform_" n then
                let
                  freeformName = lib.removePrefix "__freeform_" n;
                  userConfiguredDict = lib.attrByPath (cfgPath ++ path ++ [ freeformName ]) { } globalConfig;
                in
                lib.mkMerge (
                  lib.mapAttrsToList (
                    actualKey: actualVal:
                    walk (
                      path
                      ++ [
                        freeformName
                        actualKey
                      ]
                    ) v
                  ) userConfiguredDict
                )
              else
                walk (path ++ [ n ]) v
            ) cleanNode
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
    { config, ... }:
    let
      name = lib.removeSuffix ".zmdl" (builtins.baseNameOf file);
      cfgPath = namespacePath ++ [ name ];

      ast = zDialect.evalZString {
        inherit name file isUserScope;
        path = cfgPath;
        extraArgs = {
          pkgs = {
            zenos = inputs.self.packages;
          };
          inherit lib maintainers licenses;
          contextArgs = lib.attrByPath cfgPath { } config;
        };
      };
    in
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
        extraArgs = {
          pkgs = {
            zenos = inputs.self.packages;
          };
          inherit lib maintainers licenses;
        };
      };

      processStructure =
        node:
        let
          freeformKeys = builtins.filter (k: lib.hasPrefix "__freeform_" k) (builtins.attrNames node);
          hasFreeform = builtins.length freeformKeys > 0;
          freeformKey = if hasFreeform then builtins.head freeformKeys else null;
          freeformName = if hasFreeform then lib.removePrefix "__freeform_" freeformKey else "";

          cleanNode = builtins.removeAttrs node (
            [ "_meta" ] ++ (if hasFreeform then [ freeformKey ] else [ ])
          );
          mappedChildren = lib.mapAttrs (n: v: processStructure v) cleanNode;

          isZmdl = builtins.any (x: builtins.isAttrs x && x ? _type && x._type == "zmdl") (
            builtins.attrValues node
          );

          namespaceMeta = lib.optionalAttrs (node ? _meta) {
            _meta = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = node._meta;
              internal = true;
              description = "Internal ZenOS metadata for namespace";
            };
          };
        in
        if hasFreeform then
          lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                # This makes the metadata a formal part of the NixOS option tree
                options = (processStructure node.${freeformKey}) // {
                  _meta = lib.mkOption {
                    default = {
                      brief = node._meta.brief or null;
                      description = node._meta.description or null;
                      maintainers = node._meta.maintainers or null;
                      license = node._meta.license or null;
                    };
                  };
                };
              }
            );
            # Keep the top-level description for basic Nix tools
            description = node._meta.description or "Freeform configuration for ${freeformName}";
          }
        else if isZmdl then
          mappedChildren
          // (lib.optionalAttrs (!(mappedChildren ? legacy)) {
            legacy = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = { };
              description = "Raw configuration bypass";
            };
          })
          // namespaceMeta
        else if builtins.isAttrs node then
          mappedChildren // namespaceMeta
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
