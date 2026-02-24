{
  inputs,
  self,
  system,
  moduleTree,
  zenOSModules ? [ ],
}:
let
  # --- DEBUG ---
  DEBUG = true;

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
      {
        nixpkgs.pkgs = pkgs;
        fileSystems."/".device = "/dev/null";
        boot.loader.systemd-boot.enable = true;
        system.stateVersion = "25.11";
        _module.check = false;
        _module.args.lib = lib;
        _module.args.isDocs = true;

        # --- FIX 1: Provide __zargs natively to prevent evaluation crashes ---
        _module.args.__zargs = {
          maintainers = lib.maintainers;
          licenses = lib.licenses;
          type = lib.types;
        };
      }
    ];
  };

  # 3. Clean Evaluation for Legacy Tree (Pure NixOS Options)
  legacyEval = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      {
        fileSystems."/".device = "/dev/null";
        boot.loader.systemd-boot.enable = true;
        system.stateVersion = "2.5.11";
      }
    ];
  };

  # --- HELPER: Metadata Validator & Tracer ---
  warnMissing =
    path: meta:
    let
      pathStr = lib.concatStringsSep "." path;
      isZenosPkg =
        (lib.hasPrefix "pkgs.zenos" pathStr || lib.hasPrefix "pkgs.zenpkgs" pathStr)
        && !(lib.any (s: s == "legacy") path);
      isZenosOption =
        (lib.hasPrefix "zenos" pathStr || lib.hasPrefix "zenpkgs" pathStr)
        && !(lib.any (s: s == "legacy") path);
      shouldWarn = isZenosPkg || isZenosOption;

      missing =
        (if (meta.brief or null) == null then [ "brief" ] else [ ])
        ++ (if (meta.description or null) == null then [ "description" ] else [ ]);
    in
    if !shouldWarn || missing == [ ] then
      meta
    else
      # Embed the warning into the meta object instead of tracing immediately
      meta
      // {
        _warning = "${pathStr} is missing metadata: ${lib.concatStringsSep ", " missing}";
      };

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
      allFiles = lib.flatten (lib.attrValues moduleTree);
      processFile =
        path:
        let
          mod = importZenMetadata path;

          # --- FIX 2: Target the top-level _meta block used in .zmdl files ---
          rawMeta = mod._meta or mod.meta or mod;

          meta = {
            brief = rawMeta.brief or null;
            description = rawMeta.description or null;
            maintainers = rawMeta.maintainers or [ ];
            license = rawMeta.license or "napalm";
            dependencies = rawMeta.dependencies or [ ];
            _file = toString path;
          };
          name = lib.removeSuffix ".zmdl" (lib.removeSuffix ".nix" (baseNameOf path));
        in
        [
          {
            inherit name;
            value = meta;
          }
        ];
    in
    lib.listToAttrs (lib.flatten (map processFile allFiles));

  # --- PACKAGE WALKER ---
  showPackages =
    depth: path: v:
    let
      pathStr = lib.concatStringsSep "." path;
      maybeTrace = if DEBUG then builtins.trace "Crawl (Pkg): ${pathStr}" else (x: x);

      isSet = builtins.isAttrs v;
      isFunc = builtins.isFunction v;

      isZenPkg =
        isSet && ((v ? package && v ? brief) || (v ? _meta && (v._meta ? brief || v._meta ? description)));
      triedDrv = builtins.tryEval (if isSet then lib.isDerivation v else false);
      isDrv = triedDrv.success && triedDrv.value;
      isLegacy = lib.any (segment: segment == "legacy") path;

      isOpt = v ? _type && v._type == "option";

      rawBrief = if isOpt then (v.meta.brief or null) else (v._meta.value.brief or null);

      rawDescription =
        if isOpt then
          (v.description.value or v.description or null)
        else
          (v._meta.value.description or null);

      maintainers =
        if isZenPkg then
          (v._meta.maintainers or v.maintainers or [ ])
        else
          (if isSet then v.meta.maintainers or [ ] else [ ]);

      license =
        if isZenPkg then
          (v._meta.license or v.license or "napalm")
        else
          (if isDrv && isSet && v ? meta.license.shortName then v.meta.license.shortName else "unknown");

      metaObj = warnMissing path {
        brief = rawBrief;
        description = rawDescription;
        maintainers = if isZenPkg then maintainers else (if isSet then v.meta.maintainers or [ ] else [ ]);
        license =
          if isZenPkg then
            v.license or "napalm"
          else
            (if isDrv && isSet && v ? meta.license then license else "unknown");
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
          || (lib.length path > 40)
          || (lib.count (x: x == "specialisation") path > 1)
          || (lib.count (x: x == "configuration") path > 2)
          || (lib.count (x: x == "programs") path > 1 && name != "programs")
        );

      metaLookup = moduleMetadata.${name} or null;
      hasMeta = metaLookup != null;
      isLegacyPath = lib.any (segment: segment == "legacy") path;
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
            if isOption v && (v ? default) then
              if isLegacyPath then
                null
              else
                let
                  val = v.default;
                  typeName = v.type.name or "unknown";
                  isSafeType = builtins.elem typeName [
                    "boolean"
                    "integer"
                    "str"
                    "string"
                    "enum"
                    "port"
                    "path"
                  ];
                  res = if isSafeType then builtins.tryEval (builtins.deepSeq val val) else builtins.tryEval val;
                in
                if res.success then (if isSafeType then res.value else "<complex>") else "<dynamic>"
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
            v:
            if
              path == [
                "zenos"
                "legacy"
              ]
            then
              builtins.removeAttrs legacyEval.options [
                "zenos"
                "users"
                "nixpkgs"
              ]
            else if
              path == [
                "zenos"
                "users"
                "<name>"
                "legacy"
              ]
            then
              legacyEval.options.users.users.type.getSubOptions [ ]
            else if
              path == [
                "zenos"
                "system"
                "programs"
                "legacy"
              ]
              ||
                path == [
                  "zenos"
                  "users"
                  "<name>"
                  "programs"
                  "legacy"
                ]
            then
              legacyEval.options.programs
            else if isOption v then
              let
                t = v.type;
                elemSub = if t ? nestedTypes.elemType then (t.nestedTypes.elemType.getSubOptions or null) else null;
                directSub = t.getSubOptions or null;
              in
              if elemSub != null then
                {
                  "<name>" = {
                    _type = "_container";
                    content = elemSub [ ];
                  };
                }
              else if directSub != null then
                directSub [ ]
              else
                null
            else if isContainer v then
              v.content
            else if builtins.isAttrs v then
              v
            else
              null;

          rawChildren = getRawChildren v;
          extractedMeta =
            if rawChildren != null && rawChildren ? meta && rawChildren.meta ? default then
              rawChildren.meta.default
            else
              { };

          isOpt = v ? _type && v._type == "option";
          hasNamespaceMeta = builtins.isAttrs v && v ? _meta;
          isStructural = builtins.length path > 0 && (lib.last path) == "options";
          nsMeta = if hasNamespaceMeta then (v._meta.value or v._meta.default or { }) else { };

          # Safely extract description ONLY if the node is an actual option
          optDesc = if isOpt then (v.description.text or v.description or null) else null;

          rawMetaObj = {
            brief =
              extractedMeta.brief or (
                if hasNamespaceMeta && nsMeta ? brief then
                  nsMeta.brief
                else if hasMeta && metaLookup.brief != null then
                  metaLookup.brief
                else if isOpt then
                  (optDesc)
                else
                  null
              );
            description =
              extractedMeta.description or (
                if hasNamespaceMeta && nsMeta ? description then
                  nsMeta.description
                else if hasMeta then
                  metaLookup.description
                else
                  optDesc
              );
            maintainers =
              extractedMeta.maintainers or (
                if hasNamespaceMeta && nsMeta ? maintainers then
                  nsMeta.maintainers
                else if hasMeta then
                  metaLookup.maintainers
                else
                  [ ]
              );
            license =
              extractedMeta.license or (
                if hasNamespaceMeta && nsMeta ? license then
                  nsMeta.license
                else if hasMeta then
                  metaLookup.license
                else
                  "napalm"
              );
            dependencies = extractedMeta.dependencies or (if hasMeta then metaLookup.dependencies else [ ]);
            type = typeFinal;
          };

          metaObj = if isStructural then rawMetaObj else warnMissing path rawMetaObj;

          validChildren =
            if rawChildren != null then
              let
                base = builtins.removeAttrs rawChildren [
                  "_module"
                  "_args"
                  "freeformType"
                  "sandbox"
                  "_meta"
                  "_action"
                  "_saction"
                  "_uaction"
                  "_vars"
                  "_type"
                  "_deps"
                  "specialisation"
                  "containers"
                  "vmVariant"
                ];
              in
              if path == [ "zenos" ] then builtins.removeAttrs base [ "legacy" ] else base
            else
              { };

          subOptions = lib.mapAttrs (n: child: showOptions (path ++ [ n ]) child) validChildren;

          finalSub =
            if path == [ "zenos" ] then
              subOptions // { legacy = showOptions [ "zenos" "legacy" ] legacyEval.options; }
            else
              subOptions;
        in
        { meta = metaObj; } // (if finalSub != { } then { sub = finalSub; } else { })
    );
  # Generate the raw trees natively
  rawOptions = (showOptions [ "zenos" ] eval.options.zenos).sub;

  # Change the base namespace array and evaluation target
  rawPkgsSet = showPackages 3 [ "pkgs" "zenpkgs" ] (pkgs.zenpkgs or pkgs.zenos or { });

  rawPkgs = (builtins.removeAttrs (rawPkgsSet.sub or { }) [ "legacy" ]) // {
    legacy.sub = rawPkgsSet.sub.legacy.sub or { };
  };

  # Helper to pull all warnings out of the generated AST
  collectWarnings =
    node:
    (if node ? meta && node.meta ? _warning then [ node.meta._warning ] else [ ])
    ++ (
      if node ? sub then lib.flatten (lib.mapAttrsToList (k: v: collectWarnings v) node.sub) else [ ]
    );

  # Gather them all
  warnings = (collectWarnings { sub = rawOptions; }) ++ (collectWarnings { sub = rawPkgs; });
  warningReport = lib.concatStringsSep "\n" warnings;

in
# If there are warnings, trace them out in one block before returning the final set.
if warnings != [ ] then
  builtins.trace
    ''

      === MISSING METADATA REPORT ===
      ${warningReport}
      ===============================
    ''
    {
      maintainers = if builtins.pathExists ./maintainers.nix then import ./maintainers.nix else { };
      options = rawOptions;
      pkgs = rawPkgs;
    }
else
  {
    maintainers = if builtins.pathExists ./maintainers.nix then import ./maintainers.nix else { };
    options = rawOptions;
    pkgs = rawPkgs;
  }
