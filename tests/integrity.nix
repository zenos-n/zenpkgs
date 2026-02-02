{
  system ? builtins.currentSystem,
}:

let
  lockFlake = builtins.getFlake (toString ../.);

  # [SAFETY] Use clean pkgs for test infrastructure to avoid contamination
  cleanPkgs = import lockFlake.inputs.nixpkgs { inherit system; };
  lib = cleanPkgs.lib;

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
      overlays = [ flake.overlays.default ];
      config.allowUnfree = true;
    }
  );

  # --- Guidelines ---
  requiredMeta = [
    "description"
    "longDescription"
    "license"
    "maintainers"
    "platforms"
  ];

  # Style Validators
  validateDescription =
    desc:
    let
      len = builtins.stringLength desc;
      first = if len > 0 then builtins.substring 0 1 desc else "";
      last = if len > 0 then builtins.substring (len - 1) 1 desc else "";
      isCapitalized = first == lib.toUpper first;
      hasTrailingPeriod = last == ".";
    in
    if len == 0 then
      "Description is empty."
    else if !isCapitalized then
      "Description must start with a capital letter."
    else if hasTrailingPeriod then
      "Description must not end with a period."
    else
      null;

  # --- Mocks ---
  mkPermissive =
    default:
    lib.mkOption {
      description = "Mocked Permissive Option";
      type = lib.types.submodule { freeformType = lib.types.attrs; };
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

  mockHMLib = lib.extend (
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

  mockNixOS =
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
        zenos = mkPermissive { };
        # [FIX] Removed 'packages' from mock because it's defined by the ZenOS modules themselves.
        # Defining it here causes a "already declared" collision during global integration tests.
        # packages = mkPermissive {};
        legacy = mkPermissive { };
        system = mkPermissive { };
      };
      config._module.check = false;
    };

  mockHomeManager =
    { ... }:
    {
      imports = [ mockMeta ];
      options = {
        home = mkPermissive {
          stateVersion = "25.11";
          username = "mock";
          homeDirectory = "/tmp";
        };
        xdg = mkPermissive { };
        programs = mkPermissive { };
        services = mkPermissive { };
        systemd = mkPermissive { };
        wayland = mkPermissive { };
        zenos = mkPermissive { };
        legacy = mkPermissive { };
      };
      config._module.check = false;
    };

  # --- Auditors ---

  # 1. Strict Package Auditor
  auditPackage =
    name: pkg:
    let
      # CHECK 1: Metadata Existence
      meta = pkg.meta or { };
      missingMeta = lib.filter (field: !(meta ? ${field})) requiredMeta;

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

      # CHECK 3: Build Plan Evaluation (The "Strictest" Check)
      # This tries to evaluate the derivation path. If dependencies are missing or syntax is wrong inside the package, this fails.
      drvEval = builtins.tryEval (pkg.drvPath or (throw "Not a derivation"));
      buildError =
        if !drvEval.success then
          "Build Plan Failed: Syntax error or unresolvable dependency in derivation."
        else
          null;

      errors =
        (if missingMeta != [ ] then [ "Missing fields: ${toString missingMeta}" ] else [ ])
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
      };

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
      isHM = type == "home-manager";
      isValid = lib.hasSuffix ".nix" pathStr;

      checkMetaBlock =
        let
          modFn = import path;
          modResult =
            if lib.isFunction modFn then
              modFn {
                inherit pkgs lib;
                config = { };
                options = { };
              }
            else
              modFn;
          meta = modResult.meta or { };
          missing = lib.filter (field: !(meta ? ${field})) requiredMeta;
          descError = if (meta ? description) then validateDescription meta.description else null;
        in
        if missing != [ ] then
          "Missing top-level meta: ${toString missing}"
        else if descError != null then
          "Meta Style: ${descError}"
        else
          null;

    in
    if !isValid then
      null
    else
      let
        eval =
          if !isHM then
            lib.evalModules {
              modules = [
                mockNixOS
                path
                (
                  { ... }:
                  {
                    nixpkgs.system = system;
                  }
                )
              ];
              specialArgs = { inherit pkgs; };
            }
          else
            lib.evalModules {
              modules = [
                mockHomeManager
                path
              ];
              specialArgs = {
                inherit pkgs;
                lib = mockHMLib;
              };
            };

        isLocal =
          opt: builtins.any (decl: lib.hasPrefix (toString ../.) (toString decl)) (opt.declarations or [ ]);
        localOpts = lib.filterAttrs (n: v: isLocal v) eval.options;

        # [FIX] Allow standard extensions and explicit aliases
        allowedPrefixes = [
          "zenos"
          "users"
          "home"
        ];
        allowedExact = [ "packages" ];

        checkNamespace =
          n: (lib.any (p: lib.hasPrefix p n) allowedPrefixes) || (builtins.elem n allowedExact);

        # Check descriptions AND types AND namespace
        badOptions = lib.mapAttrsToList (
          n: v:
          if !(checkNamespace n) then
            "${n} (Namespace Error: Option must start with 'zenos' or be a whitelisted alias.)"
          else if !(v ? description) || v.description == "No description" then
            "${n} (Missing Description)"
          else if !(v ? type) then
            "${n} (Missing Type)"
          else
            null
        ) localOpts;

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
          error = "Module Evaluation Crashed";
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
        };

  collectModules =
    tree: pathName:
    builtins.trace "Walk: ${pathName}" (
      if builtins.isAttrs tree then
        lib.flatten (
          lib.mapAttrsToList (k: v: if k == "default" then [ ] else collectModules v "${pathName}.${k}") tree
        )
      else if builtins.isPath tree || builtins.isString tree then
        [ tree ]
      else
        [ ]
    );

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

  # 2. Individual Module Audit
  nixosModules = lib.filter (x: x != null) (
    map (m: auditModule m "nixos") (collectModules flake.nixosModules.zenos "nixos.zenos")
  );
  programModules = lib.filter (x: x != null) (
    map (m: auditModule m "nixos") (collectModules flake.nixosModules.programs "nixos.programs")
  );
  legacyNixosModules = lib.filter (x: x != null) (
    map (m: auditModule m "nixos") (collectModules flake.nixosModules.legacy "nixos.legacy")
  );
  hmModules = lib.filter (x: x != null) (
    map (m: auditModule m "home-manager") (
      collectModules flake.homeManagerModules.zenos "home-manager.zenos"
    )
  );
  legacyHmModules = lib.filter (x: x != null) (
    map (m: auditModule m "home-manager") (
      collectModules flake.homeManagerModules.legacy "home-manager.legacy"
    )
  );

  # 3. Global Collision Check
  # This merges ALL ZenOS modules into one evaluation to detect option conflicts.
  globalEval = lib.evalModules {
    modules =
      (collectModules flake.nixosModules.zenos "global-check")
      ++ (collectModules flake.nixosModules.programs "global-check")
      ++ [ mockNixOS ];
    specialArgs = { inherit pkgs; };
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
  failedNixos = lib.filter (x: x.status == "FAILED") nixosModules;
  failedPrograms = lib.filter (x: x.status == "FAILED") programModules;
  failedLegacyNixos = lib.filter (x: x.status == "FAILED") legacyNixosModules;
  failedHm = lib.filter (x: x.status == "FAILED") hmModules;
  failedLegacyHm = lib.filter (x: x.status == "FAILED") legacyHmModules;
  failedGlobal = globalCheck;

in
{
  report = {
    status =
      if
        failedPackages == [ ]
        && failedNixos == [ ]
        && failedPrograms == [ ]
        && failedLegacyNixos == [ ]
        && failedHm == [ ]
        && failedLegacyHm == [ ]
        && failedGlobal == [ ]
      then
        "PASSED"
      else
        "FAILED";

    summary = {
      packagesChecked = builtins.length allPackageResults;
      zenosModulesChecked = builtins.length nixosModules;
      programModulesChecked = builtins.length programModules;
      legacyNixosModulesChecked = builtins.length legacyNixosModules;
      hmModulesChecked = builtins.length hmModules;
      legacyHmModulesChecked = builtins.length legacyHmModules;
      globalIntegrity = if failedGlobal == [ ] then "OK" else "COLLISION DETECTED";
    };

    errors = {
      packages = failedPackages;
      nixosModules = failedNixos;
      programModules = failedPrograms;
      legacyNixosModules = failedLegacyNixos;
      hmModules = failedHm;
      legacyHmModules = failedLegacyHm;
      global = failedGlobal;
    };
  };
}
