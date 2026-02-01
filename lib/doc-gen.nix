{
  pkgs,
  flake,
  system,
}:

let
  lib = pkgs.lib;

  # --- Validation Helpers ---
  requiredMeta = [
    "description"
    "longDescription"
    "maintainers"
    "license"
    "platforms"
  ];

  validateMeta =
    name: meta: context:
    let
      missing = lib.filter (field: !(meta ? ${field})) requiredMeta;
    in
    if missing != [ ] then
      throw "ZenPkgs Validation Error: ${context} '${name}' is missing required metadata fields: ${toString missing}"
    else
      meta;

  validateOption =
    name: opt:
    if !(opt ? description) || opt.description == "No description" then
      throw "ZenPkgs Validation Error: Option '${name}' is missing a description."
    else
      opt;

  # --- Helper: Recursively collect module paths ---
  collectModules =
    tree:
    if builtins.isAttrs tree then
      lib.flatten (lib.mapAttrsToList (_: v: collectModules v) tree)
    else if builtins.isPath tree || builtins.isString tree then
      [ tree ]
    else
      [ ];

  # --- Helper: Get Derivation Name Safe ---
  getName = drv: if lib.isDerivation drv then drv.name else (toString drv);

  # --- Helper: Detect ZenOS Platform ---
  # Matches the strictly defined list in utils.nix
  zenosPlatforms = [ "x86_64-linux" ];

  # --- Helper: Extract Package Metadata ---
  getPkgMeta =
    name: pkg:
    let
      # Enforce validation
      rawMeta = pkg.meta or { };
      validMeta = validateMeta name rawMeta "Package";

      # Check if the platforms list matches our custom 'zenos' definition (deep equality check)
      resolvedPlatforms =
        if validMeta.platforms == zenosPlatforms then [ "zenos" ] else validMeta.platforms;
    in
    {
      name = name;
      version = pkg.version or "unknown";
      description = validMeta.description;
      longDescription = validMeta.longDescription;
      license = if validMeta ? license then validMeta.license.fullName else "Unknown";
      maintainers = map (m: m.name) (
        if builtins.isList validMeta.maintainers then validMeta.maintainers else [ validMeta.maintainers ]
      );
      platforms = resolvedPlatforms;

      # Build Details
      nativeBuildInputs = map getName (pkg.nativeBuildInputs or [ ]);
      buildInputs = map getName (pkg.buildInputs or [ ]);
      configurePhase =
        if builtins.isString (pkg.configurePhase or null) then pkg.configurePhase else null;
      buildPhase = if builtins.isString (pkg.buildPhase or null) then pkg.buildPhase else null;
      installPhase = if builtins.isString (pkg.installPhase or null) then pkg.installPhase else null;
    };

  # --- Helper: Recursive Package Tree Walker ---
  # Handles nested categories (e.g. desktops -> gnome -> pkg)
  processPackageTree =
    tree:
    if lib.isDerivation tree then
      # If it's a package, extract meta.
      getPkgMeta (tree.pname or tree.name) tree
    else if lib.isAttrs tree then
      # If it's a directory/category, recurse
      lib.mapAttrs (n: v: if lib.isDerivation v then getPkgMeta n v else processPackageTree v) tree
    else
      { };

  # --- Mocks ---

  # Helper for creating permissive options that allow nested definitions (boot.loader.efi...)
  mkPermissive =
    default:
    lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrs;
      };
      default = default;
      description = "Mock permissive option";
    };

  # 1. Mock Home Manager Libraries
  mockHMLib = lib.extend (
    self: super: {
      hm = {
        dag = {
          entryAfter = after: data: { inherit data after; };
          entryBefore = before: data: { inherit data before; };
          entryAnywhere = data: { inherit data; };
        };
      };
    }
  );

  # 2. Mock 'meta' option (Shared)
  mockMeta =
    { lib, ... }:
    {
      options.meta = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Mock meta option for documentation generation";
      };
    };

  # 3. Mock NixOS System Options
  mockNixOS =
    { lib, ... }:
    {
      imports = [ mockMeta ];
      options = {
        # Standard NixOS housekeeping
        assertions = lib.mkOption {
          type = lib.types.listOf lib.types.attrs;
          default = [ ];
        };
        warnings = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        # Common System Namespaces (Permissive Submodules)
        boot = mkPermissive {
          loader.efi.canTouchEfiVariables = false;
          loader.systemd-boot.enable = false;
          loader.grub.enable = false;
        };

        networking = mkPermissive { hostName = "mock"; };
        fileSystems = mkPermissive { };
        systemd = mkPermissive { };
        services = mkPermissive { };
        programs = mkPermissive { };
        security = mkPermissive { };
        users = mkPermissive { };
        hardware = mkPermissive { };
        environment = mkPermissive { systemPackages = [ ]; };
        fonts = mkPermissive { };
      };
      config = {
        _module.check = false;
      };
    };

  # 4. Mock Home Manager Options
  mockHomeManager =
    { ... }:
    {
      imports = [ mockMeta ];
      options = {
        home = mkPermissive {
          stateVersion = "24.05";
          username = "mock-user";
          homeDirectory = "/mock/home";
          packages = [ ];
          activation = { };
          file = { };
          sessionVariables = { };
        };
        xdg = mkPermissive { };
        programs = mkPermissive { };
        services = mkPermissive { };
        systemd = mkPermissive { };
        wayland = mkPermissive { };
      };
      config = {
        _module.check = false;
      };
    };

  # --- Helper: Extract Module Options ---
  getModuleDocs =
    modules: type:
    let
      isHM = type == "home-manager";

      # 1. Pre-Check: Validate Module Metadata
      checkModuleMeta =
        path:
        let
          modFn = import path;
          modResult =
            if lib.isFunction modFn then
              modFn {
                inherit pkgs lib;
                config = { };
              }
            else
              modFn;
        in
        if !(modResult ? meta) then
          throw "ZenPkgs Validation Error: Module '${toString path}' is missing the 'meta = { ... };' block."
        else
          validateMeta (toString path) modResult.meta "Module";

      _ = map checkModuleMeta modules;

      # 2. Eval for Options
      eval =
        if !isHM then
          lib.evalModules {
            modules = modules ++ [
              mockNixOS
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
            modules = modules ++ [
              mockHomeManager
              (
                { ... }:
                {
                  # Force these to avoid "option not defined" if user modules access them
                  home.stateVersion = "24.05";
                  home.username = "doc-gen";
                  home.homeDirectory = "/tmp";
                }
              )
            ];
            specialArgs = {
              inherit pkgs;
              lib = mockHMLib;
            };
          };

      isLocal =
        opt:
        let
          decls = opt.declarations or [ ];
        in
        builtins.any (decl: lib.hasPrefix (builtins.toString flake.outPath) (builtins.toString decl)) decls;

      options = lib.filterAttrs (n: v: isLocal v) eval.options;
    in
    lib.mapAttrs (
      name: opt:
      let
        validOpt = validateOption name opt;
      in
      {
        description = validOpt.description;
        default = opt.default or null;
        type = opt.type.description or "unknown";
        example = opt.example or null;
        longDescription = opt.longDescription or null;
      }
    ) options;

  # --- Main Extraction Logic ---

  packages =
    if flake.packages ? ${system} then
      # FIX: Use recursive processor instead of simple mapAttrs
      processPackageTree flake.packages.${system}
    else
      { };

  nixosModuleList = collectModules flake.nixosModules;
  nixosDocs = if nixosModuleList != [ ] then getModuleDocs nixosModuleList "nixos" else { };

  hmModuleList = collectModules flake.homeManagerModules;
  hmDocs = if hmModuleList != [ ] then getModuleDocs hmModuleList "home-manager" else { };

in
{
  inherit packages nixosDocs hmDocs;
  meta = {
    generatedAt = "timestamp-placeholder";
    flakeDescription = flake.description or "ZenPkgs";
  };
}
