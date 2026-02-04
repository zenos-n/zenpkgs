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
        # [ UPDATED ] Simplified Type Mapping
        simplify =
          t:
          if t == "boolean" then
            "boolean"
          else if lib.hasPrefix "string" t then
            "string"
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
            "set" # Mapped to set as per user preference/standard
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
        # We don't filter "meta" here because formatOptions generates valid meta docs.
        # We only remove internal module system artifacts.
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

  formatOptions =
    tree:
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

        subFormatted = lib.mapAttrs (n: v: formatOptions v) finalSubOpts;
        cleanSub = lib.filterAttrs (n: v: v != { }) subFormatted;
        processed = processDesc (tree.description or null) (tree.longDescription or null);
      in
      {
        meta = {
          description = processed.description;
          type = resolveType tree.type;
          default = safeVal (tree.default or null);
          example = safeVal (tree.example or null);
          longDescription = processed.longDescription;
        };
      }
      // (if cleanSub != { } then { sub = cleanSub; } else { })
    else if lib.isAttrs tree then
      let
        sub = lib.mapAttrs (n: v: formatOptions v) tree;
        cleanSub = lib.filterAttrs (n: v: v != { }) sub;
      in
      if cleanSub == { } then { } else { inherit sub; }
    else
      { };

  formatPackages =
    tree:
    if lib.isDerivation tree then
      let
        rawPlatforms = tree.meta.platforms or [ ];
        finalPlatforms = if rawPlatforms == zenosPlatforms then [ "zenos" ] else rawPlatforms;
        processed = processDesc (tree.meta.description or null) (tree.meta.longDescription or null);
      in
      {
        meta = {
          description = processed.description;
          longDescription = processed.longDescription;
          homepage = tree.meta.homepage or null;
          license = tree.meta.license.shortName or tree.meta.license.fullName or null;
          platforms = finalPlatforms;
          maintainers = map (m: m.name) (tree.meta.maintainers or [ ]);
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
        sub = lib.mapAttrs (n: v: formatPackages v) cleanTree;
        cleanSub = lib.filterAttrs (n: v: v != { }) sub;
      in
      if cleanSub == { } then { } else { inherit sub; }
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
      # [ REVERTED ] Include user-wrapper.nix again
      name != "structure.nix" && name != "gen-docs.nix"
    ) modules;

  zenosModules = filterModules (lib.collect builtins.isPath (flake.nixosModules.zenos or { }));
  legacyModules = filterModules (lib.collect builtins.isPath (flake.nixosModules.legacy or { }));
  programModules = filterModules (lib.collect builtins.isPath (flake.nixosModules.programs or { }));

  # Filter for Local Options Only
  isLocal =
    opt:
    let
      declStrs = map toString (opt.declarations or [ ]);
      roots = [
        (toString flake.outPath)
        (toString ../.)
      ];
    in
    # Allow empty decls (for inline mocks/modules) or paths matching project
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
      ++ legacyModules
      ++ programModules
      ++ [
        # 1. Mock structure.nix
        (
          { config, lib, ... }:
          {
            options.zenos.config = lib.mkOption {
              type = lib.types.attrs;
              default = { };
              description = "The raw, sandboxed user configuration entry point.";
            };
            # Dummy user to trigger submodule evaluation
            config.zenos.users.docs-user = { };
          }
        )
        # 2. Mock program injection + users
        (
          { lib, ... }:
          {
            options.users.users = lib.mkOption {
              default = { };
              type = lib.types.attrsOf (
                lib.types.submodule {
                  imports = [
                    {
                      options.programs = {
                        imports = programModules;
                      };
                    }
                  ];
                }
              );
            };
          }
        )
        # 3. System Mocks
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
        # 4. CRITICAL: Override zenUserModules to be EMPTY
        # We purposely prevent the user-wrapper from loading HM modules here
        # to avoid context/eval errors. We will graft them in later.
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

  # --- EVALUATION 2: Home Manager (User Modules) ---

  zenHmTree = loader.generateTree ../hm-modules;
  zenUserModules = lib.collect builtins.isPath zenHmTree;

  hmEval = lib.evalModules {
    modules = zenUserModules ++ [
      {
        home.homeDirectory = "/home/docs";
        home.stateVersion = "24.11";
        home.username = "docs";
        xdg.enable = true;
        _module.args.pkgs = pkgs;
      }
      # HM Option Stubs + Mock Meta
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

  # --- PROCESSING & GRAFTING ---

  # 1. Process NixOS Options (Now Clean!)
  rawTree = pruneTree nixosEval.options;
  localTree = if rawTree != null then removeAttrs rawTree [ "packages" ] else null;
  baseOptions = if localTree != null then formatOptions localTree else { };
  baseOptionsClean = cleanModuleArtifacts baseOptions;

  # [ FIX ] Remove User Wrapper Shim Options (Manual Strip)
  # We clean the user submodule to hide the HM passthrough options
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

        # Shim keys to strip (defined in user-wrapper.nix)
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

        # Remove them from the submodule
        cleanedSub = removeAttrs namedUser.sub shimKeys;

        newNamedUser = namedUser // {
          sub = cleanedSub;
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

  # 2. Process Home Manager Options
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
  hmRawTreeClean = if hmRawTree != null then removeAttrs hmRawTree hmStubKeys else null;
  hmOptions = if hmRawTreeClean != null then formatOptions hmRawTreeClean else { };
  hmOptionsClean = cleanModuleArtifacts hmOptions;

  # 3. Graft HM Options into zenos.users.<name>
  treeWithHm =
    let
      base = baseOptionsRefined.sub or { };
      hmZenosChildren = hmOptionsClean.sub.zenos.sub or null;
    in
    if
      (
        base ? zenos
        && base.zenos.sub ? users
        && base.zenos.sub.users.sub ? "<name>"
        && hmZenosChildren != null
      )
    then
      # Merge HM 'zenos' children directly into user submodule root
      lib.recursiveUpdate base {
        zenos.sub.users.sub."<name>".sub = hmZenosChildren;
      }
    else
      base;

  # 4. Strip 'zenos' prefix (Promote zenos.* to *)
  finalOptions =
    if treeWithHm ? zenos && treeWithHm.zenos ? sub then
      let
        zenosChildren = treeWithHm.zenos.sub;
        rootWithoutZenos = removeAttrs treeWithHm [ "zenos" ];
      in
      lib.recursiveUpdate rootWithoutZenos zenosChildren
    else
      treeWithHm;

  # 5. Packages & Maintainers
  packagesTree = flake.packages.${system} or { };
  packagesJson = formatPackages packagesTree;

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
  pkgs = packagesJson.sub or { };
  maintainers = usedMaintainers;
}
