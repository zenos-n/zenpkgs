let
  system = builtins.currentSystem;
  flake = builtins.getFlake (toString ../.);

  # [ FIX ] Apply the overlay and config so modules can find pkgs.zenos
  pkgs = import flake.inputs.nixpkgs {
    inherit system;
    overlays = [ flake.overlays.default ];
    config.allowUnfree = true;
  };

  lib = pkgs.lib;

  # --- Context Recovery ---
  utils = flake.lib.utils;
  loader = flake.lib.loader;

  maintainers =
    if builtins.pathExists ../lib/maintainers.nix then
      import ../lib/maintainers.nix { inherit lib; }
    else
      { };

  extendedLib = lib.recursiveUpdate lib (
    utils
    // {
      inherit maintainers;
    }
  );

  zenosPlatforms = utils.platforms.zenos;

  # --- External Metadata Overlay ---
  # Load meta.json if it exists, otherwise empty
  metaJsonPath = ./meta.json;
  metaOverlay =
    if builtins.pathExists metaJsonPath then
      builtins.fromJSON (builtins.readFile metaJsonPath)
    else
      { };

  # --- Helpers ---

  safeVal =
    val:
    if lib.isFunction val then
      "<function>"
    else if lib.isDerivation val then
      "<derivation>"
    else
      val;

  resolveType =
    type:
    if (type.name or "") == "enum" then
      let
        desc = type.description or "";
        prefix = "one of ";
        content = if lib.hasPrefix prefix desc then lib.removePrefix prefix desc else desc;
        parts = lib.splitString ", " content;
        options = map (s: lib.removeSuffix "\"" (lib.removePrefix "\"" s)) parts;
      in
      {
        enum = options;
      }
    else
      let
        raw = type.description or "unknown";
        simplify =
          t:
          if t == "boolean" then
            "boolean"
          else if lib.hasPrefix "string" t then
            "string"
          else if lib.hasPrefix "function" t then
            "function"
          else if lib.hasPrefix "list of" t then
            "array"
          else if lib.hasPrefix "attribute set" t then
            "set"
          else if lib.hasPrefix "lazy attribute set" t then
            "set"
          else if
            lib.hasPrefix "integer" t
            || lib.hasPrefix "signed integer" t
            || lib.hasPrefix "unsigned integer" t
            || lib.hasPrefix "float" t
            || lib.hasPrefix "positive integer" t
          then
            "number"
          else if lib.hasPrefix "null or" t then
            let
              inner = lib.removePrefix "null or " t;
            in
            if inner == "" then "null" else simplify inner
          else if t == "null" then
            "null"
          else if lib.hasPrefix "package" t then
            "set"
          else if t == "path" || t == "absolute path" then
            "string"
          else
            "unknown"; # Fallback

        simple = simplify raw;
      in
      if simple == "unknown" then raw else simple;

  processDesc =
    desc: long:
    if desc == null then
      {
        description = "No description";
        longDescription = long;
      }
    else
      let
        parts = lib.splitString "\n" desc;
        head = lib.head parts;
        tail = lib.concatStringsSep "\n" (lib.tail parts);
        newLong = if tail != "" then (if long != null then tail + "\n\n" + long else tail) else long;
      in
      {
        description = if head == "" then "No description" else head;
        longDescription = newLong;
      };

  # Artifact Cleaner
  cleanModuleArtifacts =
    tree:
    if lib.isAttrs tree then
      let
        bannedKeys = [
          "_module"
          "check"
          "freeformType"
          "specialArgs"
          "warnings"
          "assertions"
        ];
        filterFunc = n: v: !(builtins.elem n bannedKeys) && (n == "_type" || !lib.hasPrefix "_" n);
        cleanedSub = lib.mapAttrs (n: v: cleanModuleArtifacts v) tree;
      in
      lib.filterAttrs filterFunc cleanedSub
    else
      tree;
  # formatOptions now takes a parallel 'jsonNode' to merge metadata
  formatOptions =
    tree: jsonNode:
    if tree ? "_type" && tree._type == "option" then
      let
        # Unwrap attrsOf/listOf
        innerType =
          if tree.type.name or "" == "attrsOf" || tree.type.name or "" == "listOf" then
            tree.type.nestedTypes.elemType or { }
          else
            tree.type;

        hasSubOptions = innerType ? getSubOptions;
        subOpts = if hasSubOptions then innerType.getSubOptions [ ] else { };

        finalSubOpts =
          if subOpts != { } && (tree.type.name or "" == "attrsOf" || tree.type.name or "" == "listOf") then
            { "<name>" = subOpts; }
          else
            subOpts;

        # Recurse with corresponding JSON sub-nodes
        subFormatted = lib.mapAttrs (n: v: formatOptions v (jsonNode.sub.${n} or { })) finalSubOpts;

        # Extract config metadata (from _meta or raw attrs)
        rawEmbedded = subFormatted._meta or null;
        configMeta =
          if rawEmbedded == null then
            { }
          else if rawEmbedded ? meta && rawEmbedded.meta ? default then
            rawEmbedded.meta.default
          else
            rawEmbedded;

        # Extract JSON metadata
        jsonMeta = jsonNode.meta or { };

        # Merge: Config wins
        mergedMeta = jsonMeta // configMeta;

        finalSubCleaned = removeAttrs subFormatted [ "_meta" ];
        cleanSub = lib.filterAttrs (n: v: v != { }) finalSubCleaned;

        # Determine final description
        rawDesc = tree.description or mergedMeta.description or null;
        rawLong = tree.longDescription or mergedMeta.longDescription or null;
        processed = processDesc rawDesc rawLong;
      in
      {
        meta = {
          description = processed.description;
          type = resolveType tree.type;
          default = safeVal (tree.default or null);
          example = safeVal (tree.example or null);
          longDescription = processed.longDescription;

          # Priority: Tree > Embedded _meta > JSON Overlay
          license =
            tree.license or configMeta.license.shortName or configMeta.license.fullName or configMeta.license
              or jsonMeta.license or null;
          maintainers = map (m: m.name or m) (
            tree.maintainers or configMeta.maintainers or jsonMeta.maintainers or [ ]
          );
          platforms = tree.platforms or configMeta.platforms or jsonMeta.platforms or [ ];
        };
      }
      # Merge children if they exist (for submodules)
      // (if cleanSub != { } then { sub = cleanSub; } else { })

    else if lib.isAttrs tree then
      let
        # Check for _meta in module
        rawMeta = tree._meta or null;
        isOption = rawMeta ? _type && rawMeta._type == "option";
        configMeta =
          if isOption then
            rawMeta.default or { }
          else if rawMeta != null then
            rawMeta
          else
            { };

        # Check for meta in JSON
        jsonMeta = jsonNode.meta or { };

        # Merge: Config wins
        mergedMeta = jsonMeta // configMeta;
        hasMeta = mergedMeta != { };

        # Clean tree for recursion
        cleanTree = if rawMeta != null then removeAttrs tree [ "_meta" ] else tree;

        # Recurse: Note that JSON structure uses 'sub' to nest children
        sub = lib.mapAttrs (n: v: formatOptions v (jsonNode.sub.${n} or { })) cleanTree;
        cleanSub = lib.filterAttrs (n: v: v != { }) sub;

        processedMeta =
          if hasMeta then
            processDesc (mergedMeta.description or null) (mergedMeta.longDescription or null)
          else
            {
              description = null;
              longDescription = null;
            };

        dirMeta =
          if hasMeta then
            {
              description = processedMeta.description;
              longDescription = processedMeta.longDescription;
              license = mergedMeta.license.shortName or mergedMeta.license.fullName or mergedMeta.license or null;
              maintainers = map (m: m.name or m) (mergedMeta.maintainers or [ ]);
              platforms = mergedMeta.platforms or [ ];
            }
          else
            null;
      in
      if cleanSub == { } then
        { }
      else
        ({ inherit sub; } // (if dirMeta != null then { meta = dirMeta; } else { }))
    else
      { };

  # Packages also support overlay
  formatPackages =
    tree: jsonNode:
    if lib.isDerivation tree then
      let
        rawPlatforms = tree.meta.platforms or [ ];
        finalPlatforms = if rawPlatforms == zenosPlatforms then [ "zenos" ] else rawPlatforms;

        jsonMeta = jsonNode.meta or { };

        # Merge descriptions
        rawDesc = tree.meta.description or jsonMeta.description or null;
        rawLong = tree.meta.longDescription or jsonMeta.longDescription or null;
        processed = processDesc rawDesc rawLong;
      in
      {
        meta = {
          description = processed.description;
          longDescription = processed.longDescription;
          homepage = tree.meta.homepage or jsonMeta.homepage or null;
          license = tree.meta.license.shortName or tree.meta.license.fullName or jsonMeta.license or null;
          platforms = finalPlatforms; # Pkgs usually have platforms defined, so we prefer tree
          maintainers = map (m: m.name) (tree.meta.maintainers or jsonMeta.maintainers or [ ]);
          version = tree.version or null;
        };
      }
    else if lib.isAttrs tree && !(tree ? _type && tree._type == "option") then
      let
        cleanTree = removeAttrs tree [
          "recurseForDerivations"
          "override"
          "overrideDerivation"
          "newScope"
          "callPackage"
        ];
        # Recurse
        sub = lib.mapAttrs (n: v: formatPackages v (jsonNode.sub.${n} or { })) cleanTree;
        cleanSub = lib.filterAttrs (n: v: v != { }) sub;

        # Allow directory-level meta for package sets (e.g. pkgs.gnomeExtensions)
        jsonMeta = jsonNode.meta or { };
        hasMeta = jsonMeta != { };
        dirMeta =
          if hasMeta then
            {
              description = jsonMeta.description or null;
              longDescription = jsonMeta.longDescription or null;
            }
          else
            null;
      in
      if cleanSub == { } then
        { }
      else
        ({ inherit sub; } // (if dirMeta != null then { meta = dirMeta; } else { }))
    else
      { };

  formatLegacyPackages =
    depth: tree:
    let
      evaluated = builtins.tryEval tree;
      value = if evaluated.success then evaluated.value else null;
      derivation = builtins.tryEval (value != null && lib.isDerivation value);
      blocked = [
        "__attrs"
        "__info"
        "__splicedPackages"
        "buildPackages"
        "debugPackages"
        "lib"
        "modules"
        "nixos"
        "nixosTests"
        "pkgs"
        "releaseTools"
        "source"
        "src"
        "stdenv"
        "targetPackages"
        "testers"
        "tests"
      ];
    in
    if !evaluated.success || value == null then
      { }
    else if derivation.success && derivation.value then
      formatPackages value { }
    else if builtins.isAttrs value then
      let
        names = builtins.filter (
          name:
          depth > 0
          && !(builtins.elem name blocked)
          && !(lib.hasPrefix "_" name)
          && !(lib.hasSuffix "Packages" name)
          && !(lib.hasPrefix "linuxPackages" name)
          && !(lib.hasPrefix "darwin" name)
          && !(lib.hasPrefix "pkgs" name)
          && (
            let
              child = builtins.tryEval value.${name};
            in
            child.success && child.value != null && !(builtins.isFunction child.value)
          )
        ) (builtins.attrNames value);
        children = lib.listToAttrs (
          map (name: {
            inherit name;
            value = formatLegacyPackages (depth - 1) value.${name};
          }) names
        );
        sub = lib.filterAttrs (_: child: child != { }) children;
      in
      {
        meta = {
          description = "Legacy Nixpkgs package set";
          longDescription = null;
          homepage = null;
          license = null;
          platforms = [ ];
          maintainers = [ ];
          version = null;
        };
      }
      // lib.optionalAttrs (sub != { }) { inherit sub; }
    else
      { };

  formatLegacyOptions =
    path: tree:
    let
      evaluated = builtins.tryEval tree;
      value = if evaluated.success then evaluated.value else null;
      name = if path == [ ] then "legacy" else lib.last path;
      repeating =
        name != "<name>"
        && (
          lib.count (item: item == name) path > 1
          || lib.length path > 15
          || lib.count (item: item == "specialisation") path > 1
          || lib.count (item: item == "configuration") path > 2
          || (lib.count (item: item == "programs") path > 1 && name != "programs")
        );
      isOption = value != null && lib.isOption value;
      safeDefault =
        if !isOption then
          null
        else if value ? defaultText then
          if builtins.isString value.defaultText then
            value.defaultText
          else if builtins.isAttrs value.defaultText && value.defaultText ? text then
            value.defaultText.text
          else
            "<complex>"
        else if value ? default then
          let
            typeName = value.type.name or "unknown";
            safeType = builtins.elem typeName [
              "bool"
              "boolean"
              "enum"
              "int"
              "integer"
              "port"
              "str"
              "string"
            ];
            result = builtins.tryEval (builtins.deepSeq value.default value.default);
          in
          if safeType && result.success then result.value else "<complex>"
        else
          null;
      optionChildren =
        if !isOption then
          { }
        else
          let
            type = value.type;
            nested = type.nestedTypes.elemType or null;
            childType = if nested != null then nested else type;
            attempted = builtins.tryEval (
              if childType ? getSubOptions then childType.getSubOptions [ ] else { }
            );
            children = if attempted.success then attempted.value else { };
          in
          if nested != null && children != { } then { "<name>" = children; } else children;
      rawChildren =
        if isOption then
          optionChildren
        else if builtins.isAttrs value then
          removeAttrs value [ "_module" ]
        else
          { };
      formattedChildren = lib.mapAttrs (
        childName: child: formatLegacyOptions (path ++ [ childName ]) child
      ) rawChildren;
      sub = lib.filterAttrs (
        childName: child: child != { } && !(lib.hasPrefix "_" childName)
      ) formattedChildren;
      description = if isOption then processDesc (value.description or null) null else null;
      meta =
        if isOption then
          {
            description = description.description;
            type = resolveType value.type;
            default = safeDefault;
            example = null;
            longDescription = description.longDescription;
            license = null;
            maintainers = [ ];
            platforms = [ ];
          }
        else
          {
            description = if repeating then "Recursion limit reached" else "Legacy option set";
            type = "set";
            default = null;
            example = null;
            longDescription = null;
            license = null;
            maintainers = [ ];
            platforms = [ ];
          };
    in
    if !evaluated.success || value == null then
      { }
    else if repeating then
      { inherit meta; }
    else if isOption then
      { inherit meta; } // lib.optionalAttrs (sub != { }) { inherit sub; }
    else if builtins.isAttrs value then
      { inherit meta; } // lib.optionalAttrs (sub != { }) { inherit sub; }
    else
      { };

  # --- Filtering ---

  filterModules =
    modules:
    builtins.filter (
      m:
      let
        pathStr = toString m;
        name = baseNameOf pathStr;
      in
      name != "structure.nix" && name != "gen-docs.nix"
    ) modules;

  zenosModules = filterModules (lib.collect builtins.isPath (flake.nixosModules.zenos or { }));

  isLocal =
    opt:
    let
      declStrs = map toString (opt.declarations or [ ]);
      roots = [
        (toString flake.outPath)
        (toString ../.)
      ];
    in
    declStrs == [ ] || builtins.any (decl: builtins.any (root: lib.hasPrefix root decl) roots) declStrs;

  pruneTree =
    tree:
    if tree ? "_type" && tree._type == "option" then
      if isLocal tree then tree else null
    else if lib.isAttrs tree then
      let
        mapped = lib.mapAttrs (n: v: pruneTree v) tree;
        filtered = lib.filterAttrs (n: v: v != null) mapped;
      in
      if filtered == { } then null else filtered
    else
      null;

  # --- EVALUATION 1: NixOS (System Options) ---

  nixosEval = lib.evalModules {
    modules =
      zenosModules
      ++ [
        (
          { config, lib, ... }:
          {
            options.zenos.config = lib.mkOption {
              type = lib.types.attrs;
              default = { };
              description = "The raw, sandboxed user configuration entry point.";
            };
            config.zenos.users.docs-user = { };
          }
        )
        (
          { lib, ... }:
          {
            options.users.users = lib.mkOption {
              default = { };
              type = lib.types.attrsOf (
                lib.types.submodule {
                  imports = [ ];
                }
              );
            };
          }
        )
        (
          { lib, ... }:
          {
            options = {
              networking.hostName = lib.mkOption { default = "docs"; };
              boot = lib.mkOption {
                type = lib.types.submodule { freeformType = lib.types.attrs; };
                default = { };
              };
              fileSystems = lib.mkOption {
                type = lib.types.submodule { freeformType = lib.types.attrs; };
                default = { };
              };
            };
            config._module.check = false;
          }
        )
        (
          { config, ... }:
          {
            _module.args.zenUserModules = [ ];
          }
        )
      ];
    specialArgs = {
      inherit pkgs;
      lib = extendedLib;
    };
  };

  legacyEval = flake.inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      flake.inputs.home-manager.nixosModules.home-manager
      {
        nixpkgs.pkgs = pkgs;
        fileSystems."/".device = "/dev/null";
        boot.loader.systemd-boot.enable = true;
        system.stateVersion = "26.05";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  # --- EVALUATION 2: Internal user-action backend ---

  zenUserBackendTree = loader.generateTree ../lib/compat/user-modules;
  zenUserModules = lib.collect builtins.isPath zenUserBackendTree;

  hmEval = lib.evalModules {
    modules = zenUserModules ++ [
      {
        home.homeDirectory = "/home/docs";
        home.stateVersion = "24.11";
        home.username = "docs";
        xdg = {
          enable = true;
          dataHome = "/home/docs/.local/share";
        };
        _module.args.pkgs = pkgs;
      }
      (
        { lib, ... }:
        {
          options = {
            meta = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
            home = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
            xdg = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
            programs = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
            services = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
            systemd = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
            wayland = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
            gtk = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
            qt = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
            dconf = lib.mkOption {
              type = lib.types.attrs;
              default = { };
            };
            warnings = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
            };
            assertions = lib.mkOption {
              type = lib.types.listOf lib.types.unspecified;
              default = [ ];
            };
          };
        }
      )
    ];
    specialArgs = {
      inherit pkgs;
      lib = extendedLib;
    };
  };

  # --- PROCESSING ---

  rawTree = pruneTree nixosEval.options;
  localTree =
    if rawTree != null then
      removeAttrs rawTree [
        "legacy"
        "packages"
      ]
    else
      { };

  # [ UPDATE ] Shim: Map 'zenos' attribute in Nix tree to 'metaOverlay.options' root (skipping 'zenos' key in JSON)
  baseOptions =
    if localTree != null then
      formatOptions localTree {
        sub = {
          zenos = {
            sub = metaOverlay.options.sub or metaOverlay.options;
          };
        };
      }
    else
      { };
  baseOptionsClean = cleanModuleArtifacts baseOptions;

  baseOptionsRefined =
    if
      (
        baseOptionsClean ? zenos
        && baseOptionsClean.zenos.sub ? users
        && baseOptionsClean.zenos.sub.users.sub ? "<name>"
      )
    then
      let
        zenos = baseOptionsClean.zenos;
        users = zenos.sub.users;
        namedUser = users.sub."<name>";

        # 1. Strip Shim Keys
        shimKeys = [
          "home"
          "xdg"
          "programs"
          "services"
          "systemd"
          "wayland"
          "gtk"
          "qt"
          "dconf"
        ];
        cleanedShims = removeAttrs namedUser.sub shimKeys;

        # 2. Flattening users.<user>.zenos -> users.<user>
        flattenedUserSub =
          if cleanedShims ? zenos && cleanedShims.zenos ? sub then
            let
              innerZenos = cleanedShims.zenos.sub;
              withoutZenos = removeAttrs cleanedShims [ "zenos" ];
            in
            lib.recursiveUpdate withoutZenos innerZenos
          else
            cleanedShims;

        newNamedUser = namedUser // {
          sub = flattenedUserSub;
        };
        newUsers = users // {
          sub = users.sub // {
            "<name>" = newNamedUser;
          };
        };
        newZenos = zenos // {
          sub = zenos.sub // {
            users = newUsers;
          };
        };
      in
      baseOptionsClean // { zenos = newZenos; }
    else
      baseOptionsClean;

  hmRawTree = pruneTree hmEval.options;
  hmStubKeys = [
    "meta"
    "home"
    "xdg"
    "programs"
    "services"
    "systemd"
    "wayland"
    "gtk"
    "qt"
    "dconf"
    "warnings"
    "assertions"
  ];

  hmRawTreeClean = if hmRawTree != null then removeAttrs hmRawTree hmStubKeys else { };

  # Map the backend's ZenOS tree to the unified metadata root.
  hmOptions =
    if hmRawTreeClean != null then
      formatOptions hmRawTreeClean {
        sub = {
          zenos = {
            sub = metaOverlay.options.sub or metaOverlay.options;
          };
        };
      }
    else
      { };
  hmOptionsClean = cleanModuleArtifacts hmOptions;

  treeWithHm =
    let
      base = baseOptionsRefined.sub or { };
      hmZenosChildren = hmOptionsClean.sub.zenos.sub or { };
    in
    if (base ? zenos && base.zenos.sub ? users && base.zenos.sub.users.sub ? "<name>") then
      lib.recursiveUpdate base {
        zenos.sub.users.sub."<name>".sub = hmZenosChildren;
      }
    else
      base;

  zenosOptions =
    if treeWithHm ? zenos && treeWithHm.zenos ? sub then
      let
        zenosChildren = treeWithHm.zenos.sub;
        rootWithoutZenos = removeAttrs treeWithHm [ "zenos" ];
      in
      lib.recursiveUpdate rootWithoutZenos zenosChildren
    else
      treeWithHm;

  legacyOptions = formatLegacyOptions [ "legacy" ] (
    removeAttrs legacyEval.options [
      "_module"
      "zenos"
    ]
  );
  nixosUserLegacy = legacyOptions.sub.users.sub.users.sub."<name>" or {
    meta = {
      description = "NixOS user options";
      type = "set";
    };
    sub = { };
  };
  homeManagerLegacy = legacyOptions.sub."home-manager".sub.users.sub."<name>" or {
    meta = {
      description = "Home Manager user options";
      type = "set";
    };
    sub = { };
  };
  userLegacy = nixosUserLegacy // {
    sub = (nixosUserLegacy.sub or { }) // {
      homeManager = homeManagerLegacy;
    };
  };
  finalOptions = lib.recursiveUpdate (zenosOptions // { legacy = legacyOptions; }) {
    users.sub."<name>".sub.legacy = userLegacy;
  };

  packagesTree = removeAttrs pkgs.zenos [ "legacy" ];

  # [ UPDATE ] Shim: Map 'zenos' pkg scope to 'metaOverlay.pkgs' root (skipping 'zenos' key in JSON)
  packagesJson = formatPackages packagesTree (metaOverlay.pkgs or { });
  legacyPackagesJson = formatLegacyPackages 2 pkgs.zenos.legacy;

  usedMaintainersList = lib.attrValues maintainers;
  usedMaintainers = lib.listToAttrs (
    map (m: {
      name = m.github or m.name;
      value = m;
    }) usedMaintainersList
  );

in
{
  options = finalOptions;
  pkgs = (packagesJson.sub or { }) // {
    legacy = legacyPackagesJson;
  };
  maintainers = usedMaintainers;
}
