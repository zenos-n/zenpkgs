{
  system ? builtins.currentSystem,
}:

let
  lockFlake = builtins.getFlake (toString ../.);

  # [SAFETY] Use clean pkgs for test infrastructure to avoid contamination
  cleanPkgs = import lockFlake.inputs.nixpkgs { inherit system; };
  lib = cleanPkgs.lib;

  # [TRAP] Custom Lib to detect forbidden attributes without crashing evaluation
  auditorLib = lib.extend (
    self: super: {
      mkOption =
        args:
        let
          hasLong = args ? longDescription;
          # 1. Sanitize arguments to prevent "unexpected argument" crash in Nixpkgs
          cleanArgs = removeAttrs args [ "longDescription" ];

          # 2. Inject detection marker if violation occurred
          # We prepend to description so it survives merging and visibility checks
          desc =
            if hasLong then
              "[VIOLATION-LONGDESC] " + (args.description or "No description")
            else
              (args.description or null);

          newArgs = cleanArgs // (if desc != null then { description = desc; } else { });
        in
        super.mkOption newArgs;
    }
  );

  # Mock Self to prevent recursion during flake output eval
  mockSelf = {
    outPath = ../.;
    version = {
      majorVer = "1.0";
      variant = "Test";
    };
    shortRev = "000000";
    dirtyShortRev = "000000";
    overlays = { };
    nixosModules = { };
  };

  mockInputs = lockFlake.inputs // {
    self = mockSelf;
    nixpkgs = lockFlake.inputs.nixpkgs;
  };

  # Evaluate the real flake
  flakeFile = import ../flake.nix;
  flake = builtins.trace ">> Evaluating Flake Outputs..." (flakeFile.outputs mockInputs);

  # Instantiate the Overlay-enabled PKGS
  pkgs = builtins.trace ">> Instantiating PKGS with Overlay..." (
    import lockFlake.inputs.nixpkgs {
      inherit system;
      # [FIX] Overlays must be a list, not an attribute set
      overlays = builtins.attrValues (flake.overlays or { });
      config.allowUnfree = true;
    }
  );

  # --- Guidelines ---
  requiredMeta = [
    "description"
    # "longDescription" -> Removed (Merged into description via First Line Rule)
    "license"
    "maintainers"
    "platforms"
  ];

  # Style Validators
  validateDescription =
    fullDesc:
    let
      # [FIRST LINE RULE] Extract only the first line for validation
      lines = lib.splitString "\n" fullDesc;
      desc = builtins.head lines;

      len = builtins.stringLength desc;
      first = if len > 0 then builtins.substring 0 1 desc else "";
      last = if len > 0 then builtins.substring (len - 1) 1 desc else "";
      isCapitalized = first == lib.toUpper first;
      hasTrailingPeriod = last == ".";
    in
    if len == 0 then
      "Description is empty."
    else if lib.hasPrefix "[VIOLATION-LONGDESC]" fullDesc then
      "Forbidden 'longDescription' detected in Options."
    else if !isCapitalized then
      "Description (First Line) must start with a capital letter."
    else if hasTrailingPeriod then
      "Description (First Line) must not end with a period."
    else
      null;

  # --- Mocks ---
  mkPermissive =
    default:
    auditorLib.mkOption {
      description = "Mocked Permissive Option";
      type = auditorLib.types.submodule { freeformType = auditorLib.types.attrs; };
      default = default;
    };

  mockMeta =
    { lib, ... }:
    {
      options.meta = lib.mkOption {
        description = "Mocked meta";
        type = lib.types.attrs;
        default = { };
      };
    };

  # Use auditorLib for HM as well
  mockHMLib = auditorLib.extend (
    self: super: {
      hm = {
        dag = {
          entryAfter = a: d: { inherit d a; };
          entryBefore = b: d: { inherit d b; };
          entryAnywhere = d: { inherit d; };
        };
      };
    }
  );

  # [UPDATE] Universal Mock (NixOS + HM + Zenos)
  # Merged capabilities to allow blind scanning of any module file
  mockUniversal =
    { lib, ... }:
    {
      imports = [ mockMeta ];
      options = {
        assertions = lib.mkOption {
          type = lib.types.listOf lib.types.attrs;
          default = [ ];
          description = "Mock assertions";
        };
        warnings = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Mock warnings";
        };
        boot = mkPermissive { };
        networking = mkPermissive { };
        fileSystems = mkPermissive { };
        systemd = mkPermissive { };
        services = mkPermissive { };
        programs = mkPermissive { };
        security = mkPermissive { };
        users = mkPermissive { };
        hardware = mkPermissive { };
        environment = mkPermissive { };
        fonts = mkPermissive { };
        legacy = mkPermissive { };
        system = mkPermissive { };

        # HM Specifics (added to allow universal eval)
        home = mkPermissive {
          stateVersion = "25.11";
          username = "mock";
          homeDirectory = "/tmp";
        };
        xdg = mkPermissive { };
        wayland = mkPermissive { };
      };
      config._module.check = false;
    };

  # Legacy mocks aliased to Universal for backward compat in logic
  mockNixOS = mockUniversal;
  mockHomeManager = mockUniversal;

  # --- Auditors ---

  # 1. Strict Package Auditor
  auditPackage =
    name: pkg:
    builtins.trace ">> Checking Package: ${name}" (
      let
        # CHECK 1: Metadata Existence
        meta = pkg.meta or { };
        missingMeta = lib.filter (field: !(meta ? ${field})) requiredMeta;

        # CHECK 1.1: Forbidden Attributes (Top-Level)
        hasLongDesc = meta ? longDescription;
        longDescError = if hasLongDesc then "Forbidden meta field 'longDescription' detected." else null;

        # CHECK 2: Style & Types
        descError = if (meta ? description) then validateDescription meta.description else null;
        maintainerError =
          if (meta ? maintainers) && !(builtins.isList meta.maintainers) then
            "Maintainers must be a list."
          else
            null;
        licenseError =
          if (meta ? license) && !(builtins.isAttrs meta.license) then
            "License must be an attribute set."
          else
            null;

        # CHECK 3: Build Plan Evaluation
        drvEval = builtins.tryEval (pkg.drvPath or (throw "Not a derivation"));
        buildError =
          if !drvEval.success then
            "Build Plan Failed: Syntax error or unresolvable dependency in derivation."
          else
            null;

        errors =
          (if missingMeta != [ ] then [ "Missing fields: ${toString missingMeta}" ] else [ ])
          ++ (if longDescError != null then [ longDescError ] else [ ])
          ++ (if descError != null then [ descError ] else [ ])
          ++ (if maintainerError != null then [ maintainerError ] else [ ])
          ++ (if licenseError != null then [ licenseError ] else [ ])
          ++ (if buildError != null then [ buildError ] else [ ]);
      in
      if errors != [ ] then
        {
          inherit name;
          status = "FAILED";
          error = lib.concatStringsSep " | " errors;
        }
      else
        {
          inherit name;
          status = "OK";
        }
    );

  auditPackageTree =
    path: tree: depth:
    let
      ignoredAttrs = [
        "lib"
        "pkgs"
        "inputs"
        "legacy"
        "config"
        "options"
        "override"
        "overrideDerivation"
        "newScope"
        "callPackage"
        "recurseForDerivations"
        "passthru"
        "meta"
        "cfg"
      ];
    in
    if depth > 50 then
      [
        {
          name = lib.concatStringsSep "." path;
          status = "FAILED";
          error = "Infinite Recursion";
        }
      ]
    else if lib.isDerivation tree then
      [ (auditPackage (tree.pname or tree.name or "unknown") tree) ]
    else if lib.isAttrs tree then
      lib.flatten (
        lib.mapAttrsToList (
          n: v: if builtins.elem n ignoredAttrs then [ ] else auditPackageTree (path ++ [ n ]) v (depth + 1)
        ) tree
      )
    else
      [ ];

  # 2. Module Auditor
  auditModule =
    path: type:
    let
      pathStr = toString path;
      # Type is less relevant now with mockUniversal, but kept for logging
      isHM = type == "home-manager";
      isValid = lib.hasSuffix ".nix" pathStr;

      # Check if file is a package/derivation (and thus NOT a module)
      isPkg =
        let
          imported = import path;
          # Try to call it if it's a function (mocking args)
          result =
            if lib.isFunction imported then
              imported {
                inherit pkgs;
                lib = auditorLib;
                config = { };
                options = { };
              }
            else
              imported;
        in
        lib.isDerivation result;

      checkMetaBlock =
        let
          modFn = import path;
          modResult =
            if lib.isFunction modFn then
              modFn {
                inherit pkgs;
                lib = auditorLib; # Use trapped lib
                config = { };
                options = { };
              }
            else
              modFn;
          meta = modResult.meta or { };
          missing = lib.filter (field: !(meta ? ${field})) requiredMeta;

          # NEW: Check for forbidden attributes in top-level meta
          hasLongDesc = meta ? longDescription;

          descError = if (meta ? description) then validateDescription meta.description else null;
        in
        if missing != [ ] then
          "Missing top-level meta: ${toString missing}"
        else if hasLongDesc then
          "Forbidden top-level meta: 'longDescription' is not allowed. Merge into 'description' using the First Line Rule."
        else if descError != null then
          "Meta Style: ${descError}"
        else
          null;

    in
    if !isValid || isPkg then
      null
    else
      builtins.trace ">> Checking Module: ${pathStr}" (
        let
          eval = lib.evalModules {
            modules = [
              mockUniversal # Use the merged mock
              path
              (
                { ... }:
                {
                  nixpkgs.system = system;
                }
              )
            ];
            specialArgs = {
              inherit pkgs;
              lib = auditorLib;
            };
          };

          isLocal =
            opt: builtins.any (decl: lib.hasPrefix (toString ../.) (toString decl)) (opt.declarations or [ ]);

          # [RECURSIVE WALKER]
          # Traverse the entire option tree to find deeply nested violations
          walkOptions =
            p: tree:
            if tree ? _type && tree._type == "option" then
              if isLocal tree then
                [
                  {
                    path = p;
                    option = tree;
                  }
                ]
              else
                [ ]
            else if lib.isAttrs tree then
              lib.flatten (lib.mapAttrsToList (n: v: walkOptions (p ++ [ n ]) v) tree)
            else
              [ ];

          # Collect all local options with their full paths
          allLocalOptions = walkOptions [ ] eval.options;

          allowedPrefixes = [
            "zenos"
            "users"
            "home"
          ];
          allowedExact = [ "packages" ];

          checkNamespace =
            n: (lib.any (p: lib.hasPrefix p n) allowedPrefixes) || (builtins.elem n allowedExact);

          badOptions = map (
            entry:
            let
              name = lib.concatStringsSep "." entry.path;
              v = entry.option;
            in
            if !(checkNamespace (builtins.head entry.path)) then
              "${name} (Namespace Error: Root option must start with 'zenos' or be a whitelisted alias.)"
            else if lib.hasPrefix "[VIOLATION-LONGDESC]" (v.description or "") then
              "${name} (Forbidden argument 'longDescription' used. Remove it and merge into 'description' via the First Line Rule.)"
            else if !(v ? description) || v.description == "No description" then
              "${name} (Missing Description)"
            else if !(v ? type) then
              "${name} (Missing Type)"
            else
              null
          ) allLocalOptions;

          optionErrors = lib.filter (x: x != null) badOptions;
          metaError = checkMetaBlock;

          errors =
            (if metaError != null then [ metaError ] else [ ])
            ++ (if optionErrors != [ ] then [ "Option Errors: ${toString optionErrors}" ] else [ ]);

          failed = builtins.tryEval eval.options;
        in
        if !failed.success then
          {
            file = pathStr;
            status = "FAILED";
            error = "Module Evaluation Crashed (Syntax or Import Error)";
          }
        else if errors != [ ] then
          {
            file = pathStr;
            status = "FAILED";
            error = lib.concatStringsSep " | " errors;
          }
        else
          {
            file = pathStr;
            status = "OK";
          }
      );

  # [NEW] Deep Filesystem Scanner
  # Recursively finds ALL .nix files in a directory, bypassing default.nix/package.nix masking
  deepFindModules =
    path:
    if !builtins.pathExists path then
      [ ]
    else
      let
        entries = builtins.readDir path;
        scan =
          name: type:
          let
            subPath = path + "/${name}";
          in
          if type == "directory" then
            deepFindModules subPath
          else if type == "regular" && lib.hasSuffix ".nix" name then
            [ subPath ]
          else
            [ ];
      in
      lib.flatten (lib.mapAttrsToList scan entries);

  # Helper to collect modules from flake attributes
  collectModules =
    tree:
    if builtins.isAttrs tree then
      lib.collect (x: builtins.isPath x || builtins.isString x) tree
    else
      [ ];

  # --- Execution ---

  # 1. Package Audit
  allPackageResults =
    if !(pkgs ? zenos) then
      [
        {
          status = "FAILED";
          error = "pkgs.zenos missing";
        }
      ]
    else
      auditPackageTree [ "zenos" ] pkgs.zenos 0;

  # 2. Module Audit (Hybrid: Exported + Raw Scan)

  # A. Exported Modules (from Flake)
  exportedModules =
    (collectModules flake.nixosModules.zenos)
    ++ (collectModules flake.nixosModules.programs)
    ++ (collectModules flake.nixosModules.legacy)
    ++ (collectModules flake.homeManagerModules.zenos)
    ++ (collectModules flake.homeManagerModules.legacy);

  # B. Raw Scan (from Disk)
  rawModules = deepFindModules ../modules;

  # C. Unique List (Paths)
  allModulePaths = lib.unique (exportedModules ++ rawModules);

  # Audit All Found Modules
  moduleResults = lib.filter (x: x != null) (map (m: auditModule m "universal") allModulePaths);

  # 3. Global Collision Check
  globalEval = lib.evalModules {
    modules =
      (collectModules flake.nixosModules.zenos)
      ++ (collectModules flake.nixosModules.programs)
      ++ [ mockUniversal ];
    specialArgs = {
      inherit pkgs;
      lib = auditorLib;
    };
  };

  globalCheck =
    let
      res = builtins.tryEval globalEval.config;
    in
    if !res.success then
      [
        {
          status = "FAILED";
          error = "Global Module Collision Detected. Two or more modules likely define the same option.";
        }
      ]
    else
      [ ];

  # Filters
  failedPackages = lib.filter (x: x.status == "FAILED") allPackageResults;
  failedModules = lib.filter (x: x.status == "FAILED") moduleResults;
  failedGlobal = globalCheck;

in
{
  report = {
    status =
      if failedPackages == [ ] && failedModules == [ ] && failedGlobal == [ ] then "PASSED" else "FAILED";

    summary = {
      packagesChecked = builtins.length allPackageResults;
      modulesChecked = builtins.length moduleResults;
      globalIntegrity = if failedGlobal == [ ] then "OK" else "COLLISION DETECTED";
    };

    errors = {
      packages = failedPackages;
      modules = failedModules;
      global = failedGlobal;
    };
  };
}
