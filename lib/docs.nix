{
  inputs,
  self,
  system,
  moduleTree,
}:
let
  # 1. Prepare Pkgs with Overlays
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ self.overlays.default ];
    config = {
      allowUnfree = true;
      allowAliases = false;
    };
  };

  # 2. Evaluate Full NixOS System
  eval = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      self.nixosModules.structure
      "${inputs.nixpkgs}/nixos/modules/misc/nixpkgs/read-only.nix"
      {
        nixpkgs.pkgs = pkgs;
        fileSystems."/".device = "/dev/null";
        boot.loader.systemd-boot.enable = true;
        system.stateVersion = "25.11";
        _module.check = false;
      }
    ];
  };

  lib = pkgs.lib;

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
    else if (matches ".*attribute set of.*" descLower) then
      "set"
    else if (matches ".*attrsof.*" lower) then
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

  # --- METADATA HARVESTER ---
  moduleMetadata =
    let
      allFiles = lib.flatten (lib.attrValues moduleTree);

      processFile =
        path:
        let
          imported = import path;
          mod =
            if lib.isFunction imported then
              imported {
                inherit lib pkgs;
                config = { };
                options = { };
              }
            else
              imported;

          meta = {
            brief = mod.brief or null;
            description = mod.description or null;
            maintainers = mod.maintainers or null;
            license = mod.license or null;
            dependencies = mod.dependencies or [ ];
            _file = toString path;
          };

          keys = lib.attrNames (mod.options or { });
        in
        if keys == [ ] then
          [
            {
              name = toString path;
              value = meta;
            }
          ]
        else
          map (k: {
            name = k;
            value = meta;
          }) keys;

      rawMap = lib.flatten (map processFile allFiles);
    in
    lib.listToAttrs rawMap;

  # 3. Recursive Package Walker
  showPackages =
    strict: maxDepth: path: v:
    # TRACE: Re-enabled
    builtins.trace "PKG: ${lib.concatStringsSep "." path}" (
      let
        pathStr = lib.concatStringsSep "." path;
        name = lib.last path;

        isZenPkg = builtins.isAttrs v && (v ? package) && (v ? brief);
        triedDrv = builtins.tryEval (lib.isDerivation v);
        isDrv = triedDrv.success && triedDrv.value;
        isLegacy = path == [ "legacy" ];

        # Assigned Logic
        brief =
          if isLegacy then
            "legacy options/packages don't support briefs, read docs below"
          else if isZenPkg then
            v.brief
          else if isDrv then
            (v.meta.description or "")
          else
            "";

        description =
          if isZenPkg then
            v.description or ""
          else if isDrv then
            v.meta.longDescription or v.meta.description or ""
          else
            "";

        maintainers = if isZenPkg then v.maintainers or [ ] else (v.meta.maintainers or [ ]);
        license = if isZenPkg then v.license or "napalm" else (v.meta.license.shortName or "unknown");
        dependencies = if isZenPkg then v.dependencies or [ ] else [ ];

        checkRecurse =
          if strict then
            let
              res = builtins.tryEval (v.recurseForDerivations or false);
            in
            res.success && res.value
          else
            true;

        isNested = builtins.isAttrs v && !isDrv && !isZenPkg && checkRecurse;
        depth = builtins.length path;
        isRepeating = name != "<name>" && lib.count (x: x == name) path > 1;
      in
      if isRepeating || depth > maxDepth then
        {
          meta = {
            type = {
              name = "set";
            };
            inherit brief;
            debug = {
              status = "recursion blocked";
            };
          };
          sub = { };
        }
      else
        {
          meta = {
            type = {
              name = "set";
            };
            inherit
              brief
              description
              maintainers
              license
              dependencies
              ;
            # DEBUG INFO
            debug = {
              found = {
                isZenPkg = isZenPkg;
                isDrv = isDrv;
                rawBrief = if isZenPkg then v.brief else null;
                rawDesc = if isZenPkg then v.description else (if isDrv then v.meta.description or null else null);
              };
              assigned = {
                inherit
                  brief
                  description
                  maintainers
                  license
                  dependencies
                  ;
              };
            };
          };
          sub =
            if isNested then
              let
                keys = builtins.attrNames v;
                safeKeys = builtins.filter (
                  n:
                  !lib.hasPrefix "_" n
                  && !(builtins.elem n [
                    "pkgs"
                    "lib"
                    "out"
                    "dev"
                    "bin"
                    "man"
                    "stdenv"
                    "override"
                    "overrideDerivation"
                    "recurseForDerivations"
                    "nixosTests"
                    "tests"
                    "debugPackages"
                  ])
                ) keys;

                process =
                  n:
                  let
                    attempt = builtins.tryEval v.${n};
                  in
                  if attempt.success then
                    {
                      name = n;
                      value = showPackages strict maxDepth (path ++ [ n ]) attempt.value;
                    }
                  else
                    null;

                results = map process safeKeys;
              in
              builtins.listToAttrs (builtins.filter (x: x != null) results)
            else
              { };
        }
    );

  # 4. Robust Option Walker
  showOptions =
    path: v:
    # TRACE: Re-enabled
    builtins.trace "OPT: ${lib.concatStringsSep "." path}" (
      let
        name = lib.last path;
        isRepeating = name != "<name>" && lib.count (x: x == name) path > 1;

        metaLookup = moduleMetadata.${name} or null;
        hasMeta = metaLookup != null;
      in
      if isRepeating then
        {
          meta = {
            type = {
              name = "unknown";
            };
            brief = "Infinite loop detected";
          };
        }
      else
        let
          isOption = v: builtins.isAttrs v && (v._type or "") == "option";
          isContainer = v: builtins.isAttrs v && (v._type or "") == "_container";

          # SAFE DEFAULT EXTRACTION
          safeDefault =
            if isOption v && (v ? default) then
              if (builtins.elem "legacy" path) then
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

          # NORMALIZE TYPE
          normTypeName = if isOption v then normalizeType v.type else "set";

          # Construct Type Object
          typeBase = {
            name = normTypeName;
          };

          typeWithEnum =
            if normTypeName == "enum" && (v.type.functor.payload or [ ]) != [ ] then
              typeBase // { enum = v.type.functor.payload; }
            else
              typeBase;

          typeFinal =
            if safeDefault != null then typeWithEnum // { default = safeDefault; } else typeWithEnum;

          # ASSIGNED VALUES
          brief =
            if name == "legacy" then
              "legacy options/packages don't support briefs, read docs below"
            else if hasMeta && metaLookup.brief != null then
              metaLookup.brief
            else
              v.description or "Missing brief";

          description = if hasMeta then metaLookup.description else v.description or "";

          maintainers = if hasMeta then metaLookup.maintainers else [ ];
          license = if hasMeta then metaLookup.license else "napalm";
          dependencies = if hasMeta then metaLookup.dependencies else [ ];

          getRawChildren =
            v:
            if
              path == [
                "zenos"
                "legacy"
              ]
            then
              builtins.removeAttrs eval.options [
                "zenos"
                "users"
                "nixpkgs"
                "systemd"
                "networking"
                "environment"
                "hardware"
                "documentation"
                "_module"
                "_args"
                "specialArgs"
              ]
            else if
              (builtins.length path == 4) && (name == "legacy") && (builtins.elemAt path 1 == "users")
            then
              eval.options.users.users.type.nestedTypes.elemType.getSubOptions [ ]
            else if isOption v then
              let
                t = v.type;
                elem = t.nestedTypes.elemType or null;
                elemSub = if elem != null then (elem.getSubOptions or null) else null;
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
                # FIX: Intercept and Rename _freeformOptions
                let
                  children = directSub [ ];
                in
                if children ? _freeformOptions then
                  builtins.removeAttrs children [ "_freeformOptions" ] // { "<name>" = children._freeformOptions; }
                else
                  children
              else
                null
            else if isContainer v then
              v.content
            else if builtins.isAttrs v then
              v
            else
              null;

          rawChildren = getRawChildren v;
          validChildren =
            if rawChildren != null then
              builtins.removeAttrs rawChildren (
                [
                  "_module"
                  "_args"
                  "freeformType"
                  "specialisation"
                  "containers"
                  "vmVariant"
                ]
                ++ (if path == [ "zenos" ] then [ "sandbox" ] else [ ])
              )
            else
              { };

          hasChildren = validChildren != { };
        in
        {
          meta = {
            inherit
              brief
              description
              maintainers
              license
              dependencies
              ;
            type = typeFinal;

            # DEBUG INFO
            debug = {
              found = if hasMeta then metaLookup else { status = "none found in source modules"; };
              assigned = {
                inherit
                  brief
                  description
                  maintainers
                  license
                  dependencies
                  ;
              };
            };
          };
        }
        // (
          if hasChildren then
            {
              sub = lib.mapAttrs (n: child: showOptions (path ++ [ n ]) child) validChildren;
            }
          else
            { }
        )
    );

  # 6. Generate Trees
  optionRoot = showOptions [ "zenos" ] eval.options.zenos;
in
{
  inherit pkgs;

  tree = {
    pkgs =
      let
        zenoPkgs = if pkgs ? zenos then pkgs.zenos else { };
        customPkgs = lib.mapAttrs (n: v: showPackages false 10 [ n ] v) zenoPkgs;

        legacySet = {
          legacy = {
            meta = {
              type = {
                name = "set";
              };
              brief = "legacy options/packages don't support briefs, read docs below";
            };
            sub =
              let
                names = builtins.attrNames pkgs;
                problematic = [
                  "nixosTests"
                  "tests"
                  "pkgs"
                  "lib"
                  "modules"
                  "haskellPackages"
                  "python3Packages"
                  "perlPackages"
                  "nodePackages"
                  "legacyPackages"
                  "nixpkgs"
                  "stdenv"
                  "system"
                  "buildPackages"
                  "targetPackages"
                  "releaseTools"
                  "testers"
                  "debugPackages"
                  "nixos"
                  "src"
                  "source"
                  "recurseForDerivations"
                  "dwarfs"
                  "gimpPlugins"
                  "__splicedPackages"
                  "haskell"
                  "beam"
                  "agda"
                  "__info"
                  "__attrs"
                ];
                filteredNames = builtins.filter (n: !(builtins.elem n problematic) && !(lib.hasPrefix "_" n)) names;
                process =
                  name:
                  let
                    res = builtins.tryEval pkgs.${name};
                  in
                  if res.success && res.value != null then
                    {
                      name = name;
                      value = showPackages true 3 [ name ] res.value;
                    }
                  else
                    null;
                results = map process filteredNames;
              in
              builtins.listToAttrs (builtins.filter (x: x != null) results);
          };
        };
      in
      customPkgs // legacySet;

    options = (optionRoot).sub or optionRoot;
    maintainers = if builtins.pathExists ./maintainers.nix then import ./maintainers.nix else { };

    validation =
      let
        items = lib.mapAttrsToList (name: meta: {
          inherit name;
          missing =
            (if meta.brief == null then [ "brief" ] else [ ])
            ++ (if meta.description == null then [ "description" ] else [ ])
            ++ (if meta.maintainers == null then [ "maintainers" ] else [ ])
            ++ (if meta.license == null then [ "license" ] else [ ]);
          file = meta._file;
        }) moduleMetadata;
      in
      builtins.filter (x: x.missing != [ ]) items;
  };
}
