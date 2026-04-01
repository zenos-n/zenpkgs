{
  inputs,
  self,
  system,
  moduleTree,
  zenOSModules ? [ ],
}:
let
  # --- DEBUG ---
  DEBUG = false;

  # 1. Prepare Pkgs with Overlays
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ self.overlays.default ];
    config = {
      allowUnfree = true;
      allowAliases = false;
    };
  };

  # Extend pkgs.lib with custom licenses and maintainers
  lib = pkgs.lib.extend (
    lself: lsuper: {
      maintainers = lsuper.maintainers // (self.lib.maintainers or { });
      licenses = lsuper.licenses // (self.lib.licenses or { });
    }
  );

  # 2. Evaluate Full NixOS System
  eval = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = zenOSModules ++ [
      "${inputs.nixpkgs}/nixos/modules/misc/nixpkgs/read-only.nix"
      inputs.home-manager.nixosModules.home-manager
      {
        nixpkgs.pkgs = pkgs;
        fileSystems."/".device = "/dev/null";
        boot.loader.systemd-boot.enable = true;
        system.stateVersion = "25.05";
        _module.check = false;
        _module.args.lib = lib;
        _module.args.isDocs = true;
      }
    ];
  };

  # 3. Clean Evaluation for Legacy Tree (Pure NixOS Options)
  legacyEval = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      # 1. Include the HM NixOS module so the 'home-manager' attr exists
      inputs.home-manager.nixosModules.home-manager

      {
        fileSystems."/".device = "/dev/null";
        boot.loader.systemd-boot.enable = true;
        system.stateVersion = "25.05";

        # 2. Provide a dummy user to ensure the submodule types are processed
        # This helps the evaluator realize home-manager.users.<name> is a valid path
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  # --- HELPER: Metadata Validator & Tracer ---
  warnMissing =
    path: meta:
    let
      pathStr = lib.concatStringsSep "." path;
      isZenosPkg = lib.hasPrefix "pkgs.zenos" pathStr;
      isZenosOption = lib.hasPrefix "zenos" pathStr && !(lib.any (s: s == "legacy") path);
      shouldWarn = isZenosPkg || isZenosOption;

      missing =
        (if (meta.brief or null) == null then [ "brief" ] else [ ])
        ++ (if (meta.description or null) == null then [ "description" ] else [ ]);
    in
    if !shouldWarn || missing == [ ] then
      meta
    else
      builtins.trace "WARNING: ${pathStr} is missing metadata: ${lib.concatStringsSep ", " missing}" meta;

  # --- HELPER: Type Normalizer ---
  normalizeType =
    t:
    let
      raw = t.name or "unknown";
      desc = t.description or "";
      lower = lib.toLower raw;
      descLower = lib.toLower desc;
      matches = regex: str: builtins.match regex str != null;
    in
    if lower == "bool" || lower == "boolean" then
      "boolean"
    else if (matches ".*int.*" lower) then
      "integer"
    else if (matches ".*float.*" lower) then
      "float"
    else if lower == "str" || lower == "string" || (matches ".*string.*" lower) then
      "string"
    else if lower == "path" then
      "string"
    else if lower == "package" || lower == "derivation" then
      "set"
    else if lower == "enum" then
      "enum"
    else if (matches ".*list.*" lower) then
      "list"
    else if (matches ".*attribute set of.*" descLower) || (matches ".*attrsof.*" lower) then
      "set"
    else if lower == "set" || lower == "submodule" then
      "set"
    else if lower == "function" then
      "function"
    else if lower == "attrs" || (matches ".*attribute set.*" descLower) then
      "freeform"
    else if lower == "null" then
      "null"
    else
      "unknown";

  # --- HELPER: .zmdl Template Extraction ---
  importZenMetadata =
    path:
    let
      enableOption =
        {
          meta ? { },
          action ? { },
        }:
        {
          _isZenLeaf = true;
          inherit meta;
        };
      maintainers = if builtins.pathExists ../maintainers.nix then import ../maintainers.nix else { };
      imported =
        if lib.hasSuffix ".zmdl" path then
          let
            rawContent = builtins.readFile path;
            trimmed = lib.trim rawContent;
            templated =
              lib.replaceStrings [ "$path" "$cfg" "$name" ] [ "zenos.docs" "config.zenos.docs" "docs" ]
                rawContent;
            wrapped =
              if lib.hasPrefix "{" trimmed then
                "{ pkgs, lib, config, enableOption, maintainers, ... }@args: let f = ${templated}; in if builtins.isFunction f then f args else f"
              else
                "{ pkgs, lib, config, enableOption, maintainers, ... }: { ${templated} }";
            tempFile = builtins.toFile "meta-extract.nix" wrapped;
          in
          builtins.scopedImport {
            inherit
              lib
              pkgs
              enableOption
              maintainers
              ;
            config = { };
          } tempFile
        else
          let
            raw = import path;
          in
          if lib.isFunction raw then
            raw {
              inherit
                lib
                pkgs
                enableOption
                maintainers
                ;
              config = { };
            }
          else
            raw;
    in
    if lib.isFunction imported then
      imported {
        inherit
          lib
          pkgs
          enableOption
          maintainers
          ;
        config = { };
      }
    else
      imported;

  # --- METADATA HARVESTER ---
  moduleMetadata =
    let
      # Walk the moduleTree preserving namespace context
      collectFiles =
        prefix: tree:
        if builtins.isList tree then
          map (p: {
            path = p;
            ns = prefix;
          }) tree
        else if builtins.isAttrs tree then
          lib.flatten (
            lib.mapAttrsToList (k: v: collectFiles (if prefix == "" then k else "${prefix}.${k}") v) tree
          )
        else
          [ ];

      allEntries = collectFiles "" moduleTree;

      processEntry =
        { path, ns }:
        let
          mod = importZenMetadata path;
          meta = {
            brief = mod.meta.brief or mod.brief or null;
            description = mod.meta.description or mod.description or null;
            maintainers = mod.meta.maintainers or mod.maintainers or [ ];
            license = mod.meta.license or mod.license or "napalm";
            dependencies = mod.meta.dependencies or mod.dependencies or [ ];
            _file = toString path;
          };
          base = lib.removeSuffix ".zmdl" (lib.removeSuffix ".nix" (baseNameOf path));
          name = if ns == "" then base else "${ns}.${base}";
        in
        {
          inherit name;
          value = meta;
        };
    in
    lib.listToAttrs (map processEntry allEntries);

  # --- PACKAGE WALKER ---
  showPackages =
    depth: path: v:
    let
      pathStr = lib.concatStringsSep "." path;
      maybeTrace = if DEBUG then builtins.trace "Crawl (Pkg): ${pathStr}" else (x: x);

      isSet = builtins.isAttrs v;
      isFunc = builtins.isFunction v;

      isZenPkg = isSet && (v ? package) && (v ? brief);
      triedDrv = builtins.tryEval (if isSet then lib.isDerivation v else false);
      isDrv = triedDrv.success && triedDrv.value;
      isLegacy = lib.any (segment: segment == "legacy") path;

      rawBrief =
        if isZenPkg then
          v.brief
        else if isDrv && isSet then
          (v.meta.description or null)
        else if isFunc then
          "Builder function"
        else if isLegacy then
          "legacy package/set"
        else
          null;

      rawDescription =
        if isZenPkg then
          v.description or null
        else if isDrv && isSet then
          (v.meta.longDescription or v.meta.description or null)
        else
          null;

      metaObj = warnMissing path {
        brief = rawBrief;
        description = rawDescription;
        maintainers =
          if isZenPkg then v.maintainers or [ ] else (if isSet then v.meta.maintainers or [ ] else [ ]);
        license =
          if isZenPkg then
            v.license or "napalm"
          else
            (if isDrv && isSet && v ? meta.license.shortName then v.meta.license.shortName else "unknown");
        dependencies = if isZenPkg then v.dependencies or [ ] else [ ];
        type =
          if isFunc then
            "function"
          else if isDrv then
            "package"
          else
            "set";
        version = if isDrv && isSet then v.version or "unknown" else null;
      };
    in
    maybeTrace (
      if depth == 0 then
        {
          meta = metaObj // {
            debug = "recursion blocked";
          };
        }
      else if isDrv || isZenPkg || isFunc then
        { meta = metaObj; }
      else if isSet then
        let
          names = builtins.attrNames v;

          # Base problematic list for generic broken/circular trees
          problematic = [
            "nixpkgs"
            "buildPackages"
            "targetPackages"
            "nixos"
            "system"
            "source"
            "src"
            "recurseForDerivations"
            "nixosTests"
            "tests"
            "passthru"
            "releaseTools"
            "testers"
            "debugPackages"
            "__splicedPackages"
            "lib"
            "modules"
            "stdenv"
            "dwarfs"
            "gimpPlugins"
            "haskell"
            "beam"
            "agda"
            "__info"
            "__attrs"
            "pkgs"
          ];

          filteredNames = builtins.filter (
            n:
            let
              # AGGRESSIVE FILTERING: Kill language packages, legacy sub-trees, and OS-specific modules.
              notProblematic =
                !(builtins.elem n problematic)
                && !(lib.hasPrefix "_" n)
                && !(lib.hasSuffix "Packages" n) # <-- This saves your RAM (drops python3Packages, etc)
                && !(lib.hasPrefix "linuxPackages" n)
                && !(lib.hasPrefix "darwin" n)
                && !(lib.hasPrefix "pkgs" n && n != "pkgs");
            in
            if notProblematic then
              let
                val = builtins.tryEval v.${n};
              in
              val.success && val.value != null && !(builtins.isFunction val.value)
            else
              false
          ) names;

          process =
            name:
            let
              res = builtins.tryEval v.${name};
            in
            if res.success && res.value != null then
              {
                name = name;
                value = showPackages (depth - 1) (path ++ [ name ]) res.value;
              }
            else
              null;

          results = map process filteredNames;
        in
        {
          meta = metaObj;
          sub = lib.listToAttrs (builtins.filter (x: x != null) results);
        }
      else
        {
          meta = {
            type = "unknown";
          };
        }
    );

  # --- OPTION WALKER ---
  showOptions =
    path: v:
    let
      pathStr = lib.concatStringsSep "." path;
      name = lib.last path;
      maybeTrace = if DEBUG then builtins.trace "Crawl: ${pathStr}" else (x: x);

      isRepeating =
        (name != "<name>")
        && (
          (lib.count (x: x == name) path > 1)
          || (lib.length path > 15)
          || (lib.count (x: x == "specialisation") path > 1)
          || (lib.count (x: x == "configuration") path > 2)
          || (lib.count (x: x == "programs") path > 1 && name != "programs")
        );

      getZstrMeta =
        p: tree:
        let
          cleanPath = if builtins.length p > 0 && builtins.head p == "zenos" then builtins.tail p else p;
          step =
            attr: current:
            if current == null then
              null
            else if attr == "<name>" then
              let
                freeformKeys = builtins.filter (k: lib.hasPrefix "__z_freeform_" k) (builtins.attrNames current);
              in
              if builtins.length freeformKeys > 0 then current.${builtins.head freeformKeys} else null
            else if builtins.isAttrs current && current ? ${attr} then
              current.${attr}
            else
              null;
          node = builtins.foldl' (current: attr: step attr current) tree cleanPath;
        in
        if builtins.isAttrs node && node ? _meta then node._meta else null;

      zmeta =
        let
          isValid = m: builtins.isAttrs m && (m ? brief || m ? description);
          zstrMeta = getZstrMeta path moduleTree;
        in
        if lib.isOption v then
          let
            optMeta = if v.type ? _zmeta then v.type._zmeta else { };
            sub =
              if v.type ? getSubOptions then
                v.type.getSubOptions [ ]
              else if v.type ? nestedTypes.elemType && v.type.nestedTypes.elemType ? getSubOptions then
                v.type.nestedTypes.elemType.getSubOptions [ ]
              else
                { };
            cMeta =
              if builtins.isAttrs sub && sub ? _zmeta_carrier && sub._zmeta_carrier.type ? _zmeta then
                sub._zmeta_carrier.type._zmeta
              else
                { };
            pMeta =
              if builtins.isAttrs sub && sub ? _zmeta_passthrough && sub._zmeta_passthrough.type ? _zmeta then
                sub._zmeta_passthrough.type._zmeta
              else
                { };
          in
          if isValid optMeta then
            optMeta
          else if isValid cMeta then
            cMeta
          else if isValid pMeta then
            pMeta
          else
            zstrMeta
        else if builtins.isAttrs v then
          let
            cMeta =
              if v ? _zmeta_carrier && v._zmeta_carrier.type ? _zmeta then v._zmeta_carrier.type._zmeta else { };
            pMeta =
              if v ? _zmeta_passthrough && v._zmeta_passthrough.type ? _zmeta then
                v._zmeta_passthrough.type._zmeta
              else
                { };
            iMeta =
              if v ? _zmeta && v._zmeta.type ? _zmeta then
                v._zmeta.type._zmeta
              else
                (if v ? _zmeta then v._zmeta.default or { } else { });
          in
          if isValid cMeta then
            cMeta
          else if isValid pMeta then
            pMeta
          else if isValid iMeta then
            iMeta
          else
            zstrMeta
        else
          zstrMeta;

      hasMeta = zmeta != null;

    in
    maybeTrace (
      if isRepeating then
        {
          meta = {
            type = {
              name = "unknown";
            };
            brief = "Recursion Limit Reached";
          };
        }
      else
        let
          isOption = v: builtins.isAttrs v && (v._type or "") == "option";
          isContainer = v: builtins.isAttrs v && (v._type or "") == "_container";

          safeDefault =
            if isOption v then
              if v ? defaultText then
                let
                  dt = v.defaultText;
                in
                if builtins.isString dt then
                  dt
                else if builtins.isAttrs dt && dt ? text then
                  dt.text
                else
                  "<complex>"
              else if v ? default then
                let
                  val = v.default;
                  typeName = v.type.name or "unknown";
                  isSafeType = builtins.elem typeName [
                    "boolean"
                    "bool"
                    "integer"
                    "int"
                    "str"
                    "string"
                    "enum"
                    "port"
                  ];
                in
                if isSafeType then
                  let
                    res = builtins.tryEval (builtins.deepSeq val val);
                  in
                  if res.success then res.value else "<dynamic>"
                else
                  "<complex>"
              else
                null
            else
              null;

          normTypeName = if isOption v then normalizeType v.type else "set";

          typeFinal =
            let
              base = {
                name = normTypeName;
              };
              enum =
                if normTypeName == "enum" && (v.type.functor.payload or [ ]) != [ ] then
                  base // { enum = v.type.functor.payload; }
                else
                  base;
            in
            if safeDefault != null then enum // { default = safeDefault; } else enum;

          getRawChildren =
            v: meta:
            let
              metaObj = if meta != null then meta else { };
              metaType = metaObj.type or { };

              # CHECK: Is this node an alias?
              # We check the _zmeta directly attached to the option type
              isAlias = (metaType._type or "") == "alias" || (metaType.name or "") == "alias";
              aliasTarget = if isAlias then (metaType.target or null) else null;

              getSubs =
                opt:
                if opt.type ? getSubOptions then
                  opt.type.getSubOptions [ ]
                else if opt.type ? nestedTypes.elemType && opt.type.nestedTypes.elemType ? getSubOptions then
                  opt.type.nestedTypes.elemType.getSubOptions [ ]
                else
                  { };

              resolveAliasTarget =
                targetStr:
                let
                  rawParts = lib.splitString "." targetStr;

                  fixParts =
                    p:
                    let
                      res =
                        builtins.foldl'
                          (
                            acc: el:
                            if acc.open then
                              if lib.hasSuffix ")" el then
                                {
                                  open = false;
                                  list = acc.list ++ [ "${acc.buf}.${el}" ];
                                  buf = "";
                                }
                              else
                                {
                                  open = true;
                                  list = acc.list;
                                  buf = "${acc.buf}.${el}";
                                }
                            else if lib.hasPrefix "(" el && !lib.hasSuffix ")" el then
                              {
                                open = true;
                                list = acc.list;
                                buf = el;
                              }
                            else
                              {
                                open = false;
                                list = acc.list ++ [ el ];
                                buf = "";
                              }
                          )
                          {
                            open = false;
                            list = [ ];
                            buf = "";
                          }
                          p;
                    in
                    res.list;

                  parts = fixParts rawParts;
                  cleanParts =
                    if builtins.length parts > 0 && builtins.head parts == "nixpkgs" then lib.tail parts else parts;

                  walk =
                    currentTree: pathParts:
                    if pathParts == [ ] then
                      if currentTree == legacyEval.options then
                        builtins.removeAttrs currentTree [
                          "zenos"
                          "users"
                          "nixpkgs"
                        ]
                      else
                        currentTree
                    else
                      let
                        head = builtins.head pathParts;
                        tail = lib.tail pathParts;
                      in
                      if lib.isOption currentTree then
                        # THE FIX: Distinguish between attrsOf lists and standard submodules
                        if currentTree.type ? nestedTypes.elemType then
                          # It's an attrsOf mapping (like users.users). Drop the key/index (head) and extract.
                          let
                            sub = currentTree.type.nestedTypes.elemType.getSubOptions [ ];
                          in
                          walk sub tail
                        else if currentTree.type ? getSubOptions then
                          # It's a standard submodule (like home-manager). Extract, but KEEP the head and search for it.
                          let
                            sub = currentTree.type.getSubOptions [ ];
                          in
                          if builtins.isAttrs sub && sub ? ${head} then walk sub.${head} tail else { }
                        else
                          { }
                      else if builtins.isAttrs currentTree && currentTree ? ${head} then
                        walk currentTree.${head} tail
                      else
                        { };
                in
                walk legacyEval.options cleanParts;

              rawAlias = if isAlias && aliasTarget != null then resolveAliasTarget aliasTarget else { };
              aliasChildren = if lib.isOption rawAlias then getSubs rawAlias else rawAlias;

              nativeChildren =
                if lib.isOption v then
                  let
                    t = v.type;
                    elemSub =
                      if (!isAlias && t ? nestedTypes.elemType) then
                        (t.nestedTypes.elemType.getSubOptions or null)
                      else
                        null;
                    directSub = t.getSubOptions or null;

                    elemContent = if elemSub != null then elemSub [ ] else { };
                    directContent = if directSub != null then directSub [ ] else { };
                  in
                  if elemSub != null && elemContent != { } then
                    {
                      "<name>" = {
                        _type = "_container";
                        content = elemContent;
                      };
                    }
                  else if directSub != null && directContent != { } then
                    directContent
                  else
                    { }
                else if isContainer v then
                  v.content
                else if builtins.isAttrs v then
                  v
                else
                  { };
            in
            if isAlias then
              # MERGE logic:
              # 1. aliasChildren (from target)
              # 2. nativeChildren (defined in zstr)
              (
                if builtins.isAttrs aliasChildren && builtins.isAttrs nativeChildren then
                  aliasChildren // nativeChildren
                else if builtins.isAttrs aliasChildren then
                  aliasChildren
                else
                  nativeChildren
              )
            else
              nativeChildren;

          rawChildren = getRawChildren v zmeta;
          extractedMeta =
            if rawChildren != null && rawChildren ? meta && rawChildren.meta ? default then
              rawChildren.meta.default
            else
              { };

          baseMeta = {
            brief =
              if extractedMeta ? brief then
                extractedMeta.brief
              else if hasMeta && zmeta ? brief && zmeta.brief != null then
                zmeta.brief
              else if v ? description then
                v.description
              else
                null;
            description =
              if extractedMeta ? description then
                extractedMeta.description
              else if hasMeta && zmeta ? description && zmeta.description != null then
                zmeta.description
              else if v ? description then
                v.description
              else
                null;
            maintainers =
              if extractedMeta ? maintainers then
                extractedMeta.maintainers
              else if hasMeta && zmeta ? maintainers then
                zmeta.maintainers
              else
                [ ];
            license =
              if extractedMeta ? license then
                extractedMeta.license
              else if hasMeta && zmeta ? license then
                zmeta.license
              else
                "napalm";
            dependencies =
              if extractedMeta ? dependencies then
                extractedMeta.dependencies
              else if hasMeta && zmeta ? dependencies then
                zmeta.dependencies
              else
                [ ];
            type = typeFinal;
          };

          metaObj = warnMissing path baseMeta;

          validChildren =
            if rawChildren != null && builtins.isAttrs rawChildren then
              builtins.removeAttrs rawChildren [
                "_module"
                "_args"
                "freeformType"
                "sandbox"
                "meta"
                "specialisation"
                "containers"
                "vmVariant"
                "commonConfigurationFile"
                "commonConfiguration"
                "settings"
                "declarativeConfig"
                "package"
                "_zmeta"
                "_freeformOptions"
                "_zmeta_carrier"
                "_zmeta_passthrough"
                "_action_unconditional"
                "_saction_unconditional"
                "_uaction_unconditional"
              ]
            else
              { };

          subOptions = lib.mapAttrs (n: child: showOptions (path ++ [ n ]) child) validChildren;

          finalSub = subOptions;
        in
        { meta = metaObj; } // (if finalSub != { } then { sub = finalSub; } else { })
    );

in
{
  # Structural metadata
  maintainers = if builtins.pathExists ./maintainers.nix then import ./maintainers.nix else { };

  # Option documentation tree
  options = (showOptions [ "zenos" ] eval.options.zenos).sub;

  # Package documentation (filtered to requested namespaces)
  pkgs =
    let
      zenosSet = showPackages 3 [ "pkgs" "zenos" ] (pkgs.zenos or { });
    in
    (builtins.removeAttrs (zenosSet.sub or { }) [ "legacy" ])
    // {
      # Extract the custom ZenOS packages, removing the legacy pointer to avoid circular metadata

      # Extract the legacy nixpkgs tree from the nested pointer
      legacy.sub = zenosSet.sub.legacy.sub or { };
    };
}
