{
  system ? builtins.currentSystem,
}:

let
  # 1. Load the Flake from the parent directory
  flake = builtins.getFlake (toString ../.);

  # 2. Instantiate pkgs with your overlay so 'pkgs.zenos' exists
  pkgs = import flake.inputs.nixpkgs {
    inherit system;
    overlays = [ flake.overlays.default ];
    config.allowUnfree = true;
  };

  lib = pkgs.lib;

  # --- Validation Config ---
  requiredMeta = [
    "description"
    "license"
    "maintainers"
    "platforms"
  ];

  # --- Mocks ---
  # These allow modules to be evaluated in isolation without needing a full system.

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

  # Mock Lib for Home Manager specific types (dag)
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

  # Mock NixOS Environment
  mockNixOS =
    { lib, ... }:
    {
      imports = [ mockMeta ];
      options = {
        # Standard Mocks
        assertions = lib.mkOption {
          type = lib.types.listOf lib.types.attrs;
          default = [ ];
        };
        warnings = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        # Submodule Mocks
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

        # [UPDATED] ZenOS Specific Mocks
        zenos = mkPermissive { };
        packages = mkPermissive { }; # Handle the root alias
      };
      config._module.check = false;
    };

  # Mock Home Manager Environment
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

        # [UPDATED] ZenOS Specific Mocks
        zenos = mkPermissive { };
      };
      config._module.check = false;
    };

  # --- Auditors ---

  # 1. Audit Packages
  # Recursively walks pkgs.zenos to find broken derivations or missing meta
  auditPackage =
    name: pkg:
    let
      # Wrap in tryEval to catch build failures at eval time
      evalResult = builtins.tryEval pkg;
      meta = if evalResult.success then (pkg.meta or { }) else { };
      missing = lib.filter (field: !(meta ? ${field})) requiredMeta;
    in
    if !evalResult.success then
      {
        inherit name;
        error = "Evaluation Failed";
      }
    else if missing != [ ] then
      { inherit name missing; }
    else
      null;

  auditPackageTree =
    tree:
    if lib.isDerivation tree then
      auditPackage (tree.pname or tree.name or "unknown") tree
    else if lib.isAttrs tree then
      lib.flatten (lib.mapAttrsToList (_: v: auditPackageTree v) tree)
    else
      [ ];

  # 2. Audit Modules
  # Imports the module and evaluates it against the Mocks
  auditModule =
    path: type:
    let
      isHM = type == "home-manager";
      modFn = import path;

      # Mock Evaluation
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

      # Check for basic failures (tryEval on options)
      failed = builtins.tryEval eval.options;
    in
    if !failed.success then
      {
        file = toString path;
        error = "Module Evaluation Failed";
      }
    else
      null; # Success

  # Helpers
  collectModules =
    tree:
    if builtins.isAttrs tree then
      lib.flatten (lib.mapAttrsToList (_: v: collectModules v) tree)
    else if builtins.isPath tree || builtins.isString tree then
      [ tree ]
    else
      [ ];

in
{
  # The Report
  report = {
    # Check 1: All packages in pkgs.zenos
    packages = lib.filter (x: x != null) (auditPackageTree pkgs.zenos);

    # Check 2: NixOS Modules
    nixosModules = lib.filter (x: x != null) (
      map (m: auditModule m "nixos") (collectModules flake.nixosModules)
    );

    # Check 3: Home Manager Modules
    hmModules = lib.filter (x: x != null) (
      map (m: auditModule m "home-manager") (collectModules flake.homeManagerModules)
    );
  };
}
