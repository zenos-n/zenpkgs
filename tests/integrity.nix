{
  system ? builtins.currentSystem,
}:

let
  lockFlake = builtins.getFlake (toString ../.);
  cleanPkgs = import lockFlake.inputs.nixpkgs { inherit system; };
  lib = cleanPkgs.lib;

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

  flakeFile = import ../flake.nix;
  flake = builtins.trace ">> Evaluating Flake Outputs..." (flakeFile.outputs mockInputs);

  pkgs = builtins.trace ">> Instantiating PKGS with Overlay..." (
    import lockFlake.inputs.nixpkgs {
      inherit system;
      overlays = [ flake.overlays.default ];
      config.allowUnfree = true;
    }
  );

  requiredMeta = [
    "description"
    "license"
    "maintainers"
    "platforms"
  ];

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
        };
        warnings = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
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
        packages = mkPermissive { };
        # [UPDATED] Mocks for Legacy Mappers
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
          stateVersion = "24.05";
          username = "mock";
          homeDirectory = "/tmp";
        };
        xdg = mkPermissive { };
        programs = mkPermissive { };
        services = mkPermissive { };
        systemd = mkPermissive { };
        wayland = mkPermissive { };
        zenos = mkPermissive { };
        # [UPDATED] Mocks for Legacy Mappers
        legacy = mkPermissive { };
      };
      config._module.check = false;
    };

  # --- Auditors ---
  auditPackage =
    name: pkg:
    let
      evalResult = builtins.tryEval pkg;
      meta = if evalResult.success then (pkg.meta or { }) else { };
      missing = lib.filter (field: !(meta ? ${field})) requiredMeta;
    in
    if !evalResult.success then
      {
        inherit name;
        status = "FAILED";
        error = "Evaluation Failed";
      }
    else if missing != [ ] then
      {
        inherit name missing;
        status = "FAILED";
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

  auditModule =
    path: type:
    let
      pathStr = toString path;
      isHM = type == "home-manager";
      isValid = lib.hasSuffix ".nix" pathStr;
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
        failed = builtins.tryEval eval.options;
      in
      if !failed.success then
        {
          file = pathStr;
          status = "FAILED";
          error = "Module Evaluation Failed";
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

  # Categories
  # 1. ZenOS Modules (Core OS modules)
  nixosModules = lib.filter (x: x != null) (
    map (m: auditModule m "nixos") (collectModules flake.nixosModules.zenos "nixos.zenos")
  );

  # 2. Program Modules (User software modules)
  programModules = lib.filter (x: x != null) (
    map (m: auditModule m "nixos") (collectModules flake.nixosModules.programs "nixos.programs")
  );

  # 3. Legacy NixOS Modules (Mappings)
  legacyNixosModules = lib.filter (x: x != null) (
    map (m: auditModule m "nixos") (collectModules flake.nixosModules.legacy "nixos.legacy")
  );

  # 4. Home Manager Modules (ZenOS)
  hmModules = lib.filter (x: x != null) (
    map (m: auditModule m "home-manager") (
      collectModules flake.homeManagerModules.zenos "home-manager.zenos"
    )
  );

  # 5. Legacy Home Manager Modules (Mappings)
  legacyHmModules = lib.filter (x: x != null) (
    map (m: auditModule m "home-manager") (
      collectModules flake.homeManagerModules.legacy "home-manager.legacy"
    )
  );

  # Filters
  failedPackages = lib.filter (x: x.status == "FAILED") allPackageResults;
  failedNixos = lib.filter (x: x.status == "FAILED") nixosModules;
  failedPrograms = lib.filter (x: x.status == "FAILED") programModules;
  failedLegacyNixos = lib.filter (x: x.status == "FAILED") legacyNixosModules;
  failedHm = lib.filter (x: x.status == "FAILED") hmModules;
  failedLegacyHm = lib.filter (x: x.status == "FAILED") legacyHmModules;

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
    };

    errors = {
      packages = failedPackages;
      nixosModules = failedNixos;
      programModules = failedPrograms;
      legacyNixosModules = failedLegacyNixos;
      hmModules = failedHm;
      legacyHmModules = failedLegacyHm;
    };
  };
}
