{ lib }:

let
  emptyNode = { children = { }; definitions = [ ]; mount = null; optionNix = null; };
  put = path: change: node:
    if path == [ ] then change node else
    let key = builtins.head path; in node // {
      children = node.children // {
        ${key} = put (builtins.tail path) change (node.children.${key} or emptyNode);
      };
    };
  wildcard = key: lib.hasPrefix "{" key && lib.hasSuffix "}" key;
  identifier = key: lib.removeSuffix "}" (lib.removePrefix "{" key);
  resolve = env: path: map (part:
    if builtins.isAttrs part then env.${part.freeform}
    else if wildcard part then env.${identifier part} else part
  ) path;

  # Project before evaluating action values. The module system must know its
  # definition roots without consulting the configuration fixed point.
  emptyDefinition = value: (value._type or "") == "merge" && value.contents == [ ];
  selectDefinition = path: value:
    if path == [ ] then value
    else if (value._type or "") == "merge" then
      lib.mkMerge (builtins.filter (value: !emptyDefinition value) (map (selectDefinition path) value.contents))
    else if (value._type or "") == "if" then
      let content = selectDefinition path value.content; in
      if emptyDefinition content then content else lib.mkIf value.condition content
    else if (value._type or "") == "override" then
      let content = selectDefinition path value.content; in
      if emptyDefinition content then content else lib.mkOverride value.priority content
    else if (value._type or "") == "definition" then
      builtins.addErrorContext "while forwarding a ZSTR alias defined in ${value.file}:"
        (selectDefinition path value.value)
    else selectDefinition (builtins.tail path) (value.${builtins.head path} or (lib.mkMerge [ ]));
  project = root: selectDefinition [ root ];

  removeDefinitionAttrs = names: value:
    if (value._type or "") == "merge" then lib.mkMerge (map (removeDefinitionAttrs names) value.contents)
    else if (value._type or "") == "if" then
      if value.condition then removeDefinitionAttrs names value.content else lib.mkMerge [ ]
    else if (value._type or "") == "override" then lib.mkOverride value.priority (removeDefinitionAttrs names value.content)
    else builtins.removeAttrs value names;

  schemaAt = options: path:
    let
      walk = node: rest: prefix:
        if lib.isOption node then
          if builtins.elem node.type.name [ "attrsOf" "lazyAttrsOf" ] && rest != [ ] then
            walk (builtins.removeAttrs
              (node.type.nestedTypes.elemType.getSubOptions (prefix ++ [ (builtins.head rest) ]))
              [ "zenos" "_module" ])
              (builtins.tail rest) (prefix ++ [ (builtins.head rest) ])
          else walk (builtins.removeAttrs (node.type.getSubOptions prefix) [ "zenos" "_module" ]) rest prefix
        else if rest == [ ] then builtins.removeAttrs node [ "zenos" "_module" ]
        else let key = builtins.head rest; in
          if builtins.hasAttr key node then walk node.${key} (builtins.tail rest) (prefix ++ [ key ])
          else throw "ZSTR alias target has no upstream option: ${lib.showOption (prefix ++ [ key ])}";
    in walk (builtins.removeAttrs options [ "zenos" "_module" ]) path [ ];

  mirrorOptions = tree: lib.mapAttrs (_: option:
    if lib.isOption option then lib.mkOption {
      inherit (option) type;
      description = option.description or "Upstream option";
    } else mirrorOptions option
  ) tree;
  schemaValues = value:
    if (value._type or "") == "merge" then lib.concatMap schemaValues value.contents
    else if (value._type or "") == "if" then
      if value.condition then schemaValues value.content else [ ]
    else if (value._type or "") == "override" then schemaValues value.content
    else [ value ];
  activeChildren = values:
    lib.filterAttrs (_: children: children != [ ])
      (lib.mapAttrs (_: lib.concatMap schemaValues)
        (lib.zipAttrsWith (_: children: children) (lib.concatMap schemaValues values)));
  selectedSchema = schema: values:
    lib.mapAttrs (key: children:
      if !builtins.hasAttr key schema then throw "Unknown ZSTR upstream option: ${key}"
      else if lib.isOption schema.${key} then (mirrorOptions { ${key} = schema.${key}; }).${key}
      else selectedSchema schema.${key} children
    ) (activeChildren values);
  pruneInactive = schema: value:
    if (value._type or "") == "merge" then
      lib.mkMerge (builtins.filter (child: !emptyDefinition child) (map (pruneInactive schema) value.contents))
    else if (value._type or "") == "if" then
      if value.condition then pruneInactive schema value.content else lib.mkMerge [ ]
    else if (value._type or "") == "override" then
      let content = pruneInactive schema value.content; in
      if emptyDefinition content then content else lib.mkOverride value.priority content
    else if lib.isOption schema || !builtins.isAttrs value then value
    else let children = lib.filterAttrs (_: child: !emptyDefinition child)
      (lib.mapAttrs (key: child: pruneInactive (schema.${key} or { }) child) value);
    in if children == { } then lib.mkMerge [ ] else children;

  definitionShape = values: lib.mapAttrs (_: children:
    if builtins.all (value: builtins.isAttrs value && !lib.isDerivation value && value != { }) children
    then definitionShape children else null
  ) (activeChildren values);
  inheritValues = shape: values: lib.mapAttrs (key: child:
    if child == null then lib.mkDefault values.${key}
    else inheritValues child values.${key}
  ) shape;

  # Remove undefined leaves without forcing them. Defaults on upstream root
  # options must not become new definitions merely because an alias was mounted.
  definedConfig = options: config:
    lib.mapAttrs (key: option:
      if lib.isOption option then config.${key}
      else definedConfig option config.${key}
    ) (lib.filterAttrs (_: option:
      if lib.isOption option then option.isDefined
      else hasDefinitions option
    ) options);
  hasDefinitions = tree: builtins.any (option:
    if lib.isOption option then option.isDefined else hasDefinitions option
  ) (builtins.attrValues tree);

in rec {
  packageExposure = bundle:
    (bundle.structure.present or false)
    && builtins.any (mount: mount.kind == "packages") (bundle.structure.mounts or [ ]);

  moduleFromBundle = { bundle, packageTree ? null, extraLib ? { } }:
    { config, options, pkgs, ... }:
    let
      rootConfig = config;
      present = bundle.structure.present or false;
      mounts = if present then bundle.structure.mounts else [ ];
      sources = builtins.listToAttrs (map (source: {
        name = source.path;
        value = source;
      }) (builtins.filter (source: source.kind == "zmdl") bundle.sources));
      moduleRecords = bundle.modules or [ ];
      initial = lib.foldl' (tree: node: put node.path
        (x: x // { optionNix = node.optionNix or null; }) tree) emptyNode
        (if present then bundle.structure.nodes or [ ] else [ ]);
      tree = lib.foldl' (tree: mount:
        if mount.kind != "zmdl" then put mount.path (node: node // { inherit mount; }) tree
        else let
          matches = builtins.filter (record:
            lib.take (builtins.length mount.target) (builtins.tail record.optionPath) == mount.target
          ) moduleRecords;
        in if matches == [ ] then throw "ZSTR module mount has no source: ${lib.showOption mount.target}"
        else lib.foldl' (result: record:
          put (mount.path ++ lib.drop (builtins.length mount.target) (builtins.tail record.optionPath))
            (node: node // { definitions = node.definitions ++ [ record.path ]; }) result
        ) tree matches
      ) initial mounts;
      packages = if packageTree != null then packageTree else pkgs.zenos or { };
      nodeAt = path: lib.foldl' (node: key: node.children.${key} or emptyNode) tree path;
      hasUserProgramMount = path: source: builtins.any (key:
        builtins.elem source (nodeAt ([ "users" key ] ++ builtins.tail path)).definitions
      ) (builtins.attrNames (nodeAt [ "users" ]).children);
      instantiate = source: cfg: env: user: shareUserActions:
        import (builtins.toFile "zstr-mounted-module.nix" sources.${source}.mountNix) {
          inherit config cfg pkgs user shareUserActions;
          lib = lib // extraLib;
          freeform = env;
        };
      aliasTarget = mount: env:
        let target = resolve env mount.target; in
        if target == [ ] || builtins.head target != "nixpkgs" then
          throw "ZSTR aliases must target nixpkgs options"
        else builtins.tail target;
      aliasType = schema: lib.types.mkOptionType {
        name = "zstr-upstream-mirror";
        description = "ZSTR-mounted upstream options";
        check = builtins.isAttrs;
        merge = loc: defs:
          let evaluated = lib.evalModules {
            modules = [ { options = selectedSchema schema (map (def: def.value) defs); } ]
              ++ map (def: { _file = def.file; config = pruneInactive schema def.value; }) defs;
          }; in definedConfig (builtins.removeAttrs evaluated.options [ "_module" ]) evaluated.config;
        getSubOptions = _: mirrorOptions schema;
      };
      selectorType = path: lib.types.mkOptionType {
        name = "zstr-package-selectors";
        description = "boolean selectors for public pkgs paths";
        check = builtins.isAttrs;
        merge = loc: defs:
          let
            merge = prefix: values:
              let combined = lib.zipAttrsWith (_: children: children) values; in
              lib.mapAttrs (key: children:
                let full = prefix ++ [ key ]; package = lib.attrByPath full null packages; in
                if package == null then throw "Unknown ZSTR package selector pkgs.${lib.showOption full}"
                else if lib.isDerivation package then
                  if !builtins.all builtins.isBool children then
                    throw "ZSTR package selector must be boolean: pkgs.${lib.showOption full}"
                  else lib.types.bool.merge (loc ++ full)
                  (map (value: { inherit value; file = "ZSTR package selector"; }) children)
                else if builtins.all builtins.isAttrs children then merge full children
                else throw "ZSTR package branch requires an attribute set: pkgs.${lib.showOption full}"
              ) combined;
          in merge [ ] (map (def: def.value) defs);
      };
      nodeOption = node: path: env: user:
        if node.optionNix != null then
          import (builtins.toFile "zstr-option.nix" node.optionNix) {
            inherit pkgs config;
            lib = lib // extraLib;
            freeform = env;
          }
        else lib.mkOption { type = nodeType node path env user; default = { }; };
      nodeType = node: path: env: user:
        if node.mount != null && node.mount.kind == "packages" then selectorType path
        else let
          wildcards = builtins.filter wildcard (builtins.attrNames node.children);
          children = lib.filterAttrs (key: _: !wildcard key) node.children;
          systemPath = [ "system" ] ++ lib.drop 2 path;
          inheritsProgram = lib.take 1 path == [ "users" ]
            && lib.take 1 (lib.drop 2 path) == [ "programs" ]
            && (nodeAt systemPath).definitions == node.definitions;
          baseType = lib.types.submodule ({ config, ... }: let localConfig = config; in {
            imports = map (source: (instantiate source localConfig env user true).schema) node.definitions;
            options = lib.mapAttrs (key: child: nodeOption child (path ++ [ key ]) env user)
              children // lib.optionalAttrs (node.definitions != [ ] && !builtins.any
              (source: (instantiate source localConfig env user true).schema.options ? enable)
              node.definitions) {
              enable = lib.mkOption { type = lib.types.bool; default = false; };
            };
          } // lib.optionalAttrs inheritsProgram {
            # Read resolved system values only at authored paths. Enumerating
            # the whole config would force unrelated required options.
            config = inheritValues
              (definitionShape (map (value:
                if builtins.isBool value && node.definitions != [ ] then { enable = value; }
                else builtins.removeAttrs value (builtins.attrNames node.children)
              ) (lib.concatMap (definition: schemaValues (selectDefinition systemPath definition.value))
                options.zenos.definitionsWithLocations)))
              (lib.getAttrFromPath systemPath rootConfig.zenos);
          } // lib.optionalAttrs ((node.mount != null && node.mount.kind == "alias") || wildcards != [ ]) {
            freeformType =
              if node.mount != null && node.mount.kind == "alias" then
                aliasType (schemaAt options (aliasTarget node.mount env))
              else if wildcards != [ ] then
                let key = builtins.head wildcards; in
                assert builtins.length wildcards == 1;
                lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
                  imports = (nodeType node.children.${key} (path ++ [ key ])
                    (env // { ${identifier key} = name; })
                    (if path == [ "users" ] then name else user)).getSubModules;
                }))
              else null;
          });
        in if node.definitions == [ ] then baseType
        else lib.types.coercedTo lib.types.bool (enable: { inherit enable; }) baseType;
      selectedPackages = prefix: values: lib.concatLists (lib.mapAttrsToList (key: value:
        if builtins.isAttrs value then selectedPackages (prefix ++ [ key ]) value
        else lib.optional value (lib.getAttrFromPath (prefix ++ [ key ]) packages)
      ) values);
      actionsFor = root: node: path: env: user: value:
        if !(builtins.elem root (staticRoots node)) then [ ] else
        let
          definitions = if node.mount != null && node.mount.kind == "packages" then [ ] else
            builtins.filter (source: builtins.elem root (instantiate source { } { } null true).actionRoots) node.definitions;
          own = lib.concatMap (source: (instantiate source value env user
            (!(lib.take 2 path == [ "system" "programs" ] && hasUserProgramMount path source))).actions) definitions;
          mountActions = if node.mount == null then [ ]
            else if node.mount.kind == "packages" then [
              (if user == null then { environment.systemPackages = selectedPackages [ ] value; }
               else { home-manager.users.${user}.home.packages = selectedPackages [ ] value; })
            ]
            else map (definition: lib.mkDefinition {
              inherit (definition) file;
              value = lib.setAttrByPath (aliasTarget node.mount env)
                (builtins.seq value (pruneInactive (schemaAt options (aliasTarget node.mount env))
                  (removeDefinitionAttrs (builtins.attrNames node.children)
                    (selectDefinition (resolve env path) definition.value))));
            }) options.zenos.definitionsWithLocations;
          nested = lib.concatLists (lib.mapAttrsToList (key: child:
            if wildcard key then lib.concatLists (lib.mapAttrsToList (name: childValue:
              actionsFor root child (path ++ [ key ]) (env // { ${identifier key} = name; })
                (if path == [ "users" ] then name else user) childValue
            ) (builtins.removeAttrs value (builtins.attrNames node.children)))
            else actionsFor root child (path ++ [ key ]) env user (value.${key} or { })
          ) node.children);
        in own ++ mountActions ++ nested;
      staticRoots = node:
        lib.concatMap (source: (instantiate source { } { } null true).actionRoots) node.definitions
        ++ (if node.mount == null then [ ]
            else if node.mount.kind == "packages" then [ "environment" "home-manager" ]
            else if node.mount.target == [ "nixpkgs" ] then
              builtins.attrNames (builtins.removeAttrs options [ "zenos" "_module" ])
            else [ (builtins.elemAt node.mount.target 1) ])
        ++ lib.concatMap staticRoots (builtins.attrValues node.children);
      mountedSources = node: node.definitions ++ lib.concatMap mountedSources (builtins.attrValues node.children);
      exposedSources = lib.unique ([ "structure.zstr" ] ++ mountedSources tree);
      metadataWarnings = lib.concatMap (source:
        map (diagnostic:
          "ZenPkgs ${diagnostic.code} ${diagnostic.source}:${toString diagnostic.line}:${toString diagnostic.column}: ${diagnostic.message}"
        ) (builtins.filter (diagnostic: diagnostic.severity == "warning") (source.diagnostics or [ ]))
      ) (builtins.filter (source: builtins.elem source.path exposedSources) bundle.sources);
    in lib.optionalAttrs present {
      options.zenos = lib.mkOption {
        type = nodeType tree [ ] { } null;
        default = { };
      };
      config = lib.genAttrs (lib.unique (staticRoots tree ++ lib.optional (metadataWarnings != [ ]) "warnings")) (root:
        lib.mkMerge ((map (project root) (actionsFor root tree [ ] { } null config.zenos))
          ++ lib.optional (root == "warnings") metadataWarnings)
      );
    };
}
