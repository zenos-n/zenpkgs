{
  pkgs,
  flake,
  system,
}:

let
  lib = pkgs.lib;
  requiredMeta = [
    "description"
    "longDescription"
    "maintainers"
    "license"
    "platforms"
  ];

  # --- Mocks (Required to eval without crashing) ---
  mkPermissive =
    default:
    lib.mkOption {
      type = lib.types.submodule { freeformType = lib.types.attrs; };
      default = default;
    };

  mockMeta =
    { lib, ... }:
    {
      options.meta = lib.mkOption {
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
      };
      config._module.check = false;
    };

  mockHomeManager =
    { lib, ... }:
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
      };
      config._module.check = false;
    };

  # --- Audit Logic ---

  # 1. Packages
  auditPackage =
    name: pkg:
    let
      meta = pkg.meta or { };
      missing = lib.filter (field: !(meta ? ${field})) requiredMeta;
    in
    if missing == [ ] then null else { inherit name missing; };

  auditPackageTree =
    tree:
    if lib.isDerivation tree then
      auditPackage (tree.pname or tree.name) tree
    else if lib.isAttrs tree then
      lib.filter (x: x != null) (lib.flatten (lib.mapAttrsToList (_: v: auditPackageTree v) tree))
    else
      [ ];

  # 2. Modules
  auditModule =
    path: type:
    let
      isHM = type == "home-manager";
      # Check 1: Top-level meta block
      modFn = import path;
      modResult =
        if lib.isFunction modFn then
          modFn {
            inherit pkgs lib;
            config = { };
          }
        else
          modFn;
      metaMissing =
        if !(modResult ? meta) then
          [ "meta_block_missing" ]
        else
          lib.filter (field: !(modResult.meta ? ${field})) requiredMeta;

      # Check 2: Option descriptions
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
        opt:
        builtins.any (decl: lib.hasPrefix (builtins.toString flake.outPath) (builtins.toString decl)) (
          opt.declarations or [ ]
        );

      localOptions = lib.filterAttrs (n: v: isLocal v) eval.options;
      badOptions = lib.mapAttrsToList (
        name: opt: if !(opt ? description) || opt.description == "No description" then name else null
      ) localOptions;

      missingOpts = lib.filter (x: x != null) badOptions;
    in
    if metaMissing == [ ] && missingOpts == [ ] then
      null
    else
      {
        file = toString path;
        missing_meta = metaMissing;
        missing_option_descriptions = missingOpts;
      };

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
  packages = auditPackageTree (flake.packages.${system} or { });
  nixosModules = lib.filter (x: x != null) (
    map (m: auditModule m "nixos") (collectModules flake.nixosModules)
  );
  hmModules = lib.filter (x: x != null) (
    map (m: auditModule m "home-manager") (collectModules flake.homeManagerModules)
  );
}
