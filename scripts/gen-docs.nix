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
  # We use the utils exposed by the flake to ensure we match the system's logic exactly.
  # flake.lib.utils is defined in flake.nix outputs.
  utils = flake.lib.utils;

  # Maintainers are injected in the overlay in flake.nix, but not exposed in flake.lib.
  # We manually import them to ensure the docs list *all* potential maintainers, not just active ones.
  maintainers =
    if builtins.pathExists ../lib/maintainers.nix then
      import ../lib/maintainers.nix { inherit lib; }
    else
      { };

  # [ FIX ] Extend lib with ZenOS utils and Maintainers
  # This matches the environment packages see inside the 'inflate' function in flake.nix
  extendedLib = lib.recursiveUpdate lib (
    utils
    // {
      inherit maintainers;
    }
  );

  # --- Configuration ---
  zenosPlatforms = utils.platforms.zenos;

  # --- Helpers ---

  # Helper to prevent JSON serialization errors on functions/derivations
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
        # Remove prefix if present
        content = if lib.hasPrefix prefix desc then lib.removePrefix prefix desc else desc;
        # Split by ", " sequence
        parts = lib.splitString ", " content;
        # Remove surrounding quotes from elements
        options = map (s: lib.removeSuffix "\"" (lib.removePrefix "\"" s)) parts;
      in
      {
        name = "enum";
        inherit options;
      }
    else
      type.description or "unknown";

  # Recursively format the option tree
  formatOptions =
    tree:
    if tree ? "_type" && tree._type == "option" then
      {
        meta = {
          description = tree.description or "No description";
          type = resolveType tree.type;
          default = safeVal (tree.default or null);
          example = safeVal (tree.example or null);
          longDescription = tree.longDescription or null;
        };
      }
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
        # Visual Mapping:
        # If the package's platforms match the ZenOS definition exactly (x86_64-linux),
        # we display "zenos" in the documentation to distinguish it from generic packages.
        finalPlatforms = if rawPlatforms == zenosPlatforms then [ "zenos" ] else rawPlatforms;
      in
      {
        meta = {
          description = tree.meta.description or "No description";
          longDescription = tree.meta.longDescription or null;
          homepage = tree.meta.homepage or null;
          license = tree.meta.license.shortName or tree.meta.license.fullName or null;
          platforms = finalPlatforms;
          maintainers = map (m: m.name) (tree.meta.maintainers or [ ]);
          version = tree.version or null;
        };
      }
    else if lib.isAttrs tree && !(tree ? _type && tree._type == "option") then
      let
        # Clean up internal attributes before recursing
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

  # --- Evaluator ---

  # 1. NixOS Modules Evaluation

  # [ FIX ] Aggressive Module Filtering
  # We define a filter to explicitly exclude 'structure.nix' and 'gen-docs.nix'
  # from the evaluation to prevent recursion or invalid attribute errors if
  # these files are accidentally picked up by the module loader.
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

  # Collect and filter modules
  zenosModules = filterModules (lib.collect builtins.isPath (flake.nixosModules.zenos or { }));
  legacyModules = filterModules (lib.collect builtins.isPath (flake.nixosModules.legacy or { }));
  programModules = filterModules (lib.collect builtins.isPath (flake.nixosModules.programs or { }));

  nixosEval = lib.evalModules {
    modules =
      zenosModules
      ++ legacyModules
      ++ programModules
      ++ [
        # Mock to replace structure.nix options
        (
          { config, lib, ... }:
          {
            options.zenos.config = lib.mkOption {
              type = lib.types.attrs;
              default = { };
              description = "The raw, sandboxed user configuration entry point.";
            };

            # [ ADDED ] Mock User Instance
            # This ensures that any module iterating over config.zenos.users
            # (like the User Manager) has data to process.
            config.zenos.users.docs-user = { };
          }
        )
        # Mock to replace structure.nix program injection and provide users.users
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
        # Mocks to prevent evaluation errors on system options
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
      ];
    specialArgs = {
      inherit pkgs;
      # Pass the extended library to modules so they can access utils (e.g. mkVersionString)
      lib = extendedLib;
    };
  };

  # 2. Home Manager Modules Evaluation
  # We use flake.homeManagerModules.default for the same reason.
  hmEval = lib.evalModules {
    modules = [
      flake.homeManagerModules.default
      # Mocks to prevent evaluation errors on Home Manager options
      (
        { lib, ... }:
        {
          options = {
            home = {
              username = lib.mkOption { default = "docs"; };
              homeDirectory = lib.mkOption { default = "/home/docs"; };
              stateVersion = lib.mkOption { default = "24.05"; };
            };
            xdg = {
              enable = lib.mkOption { default = true; };
              mime.enable = lib.mkOption { default = true; };
              userDirs.enable = lib.mkOption { default = true; };
            };
          };
          config._module.check = false;
        }
      )
    ];
    specialArgs = {
      inherit pkgs;
      # Pass the extended library to modules here as well
      lib = extendedLib;
    };
  };

  # Filter for Local Options Only
  # We check against flake.outPath (store path) to ensure we don't document
  # generic NixOS/HM options, only the ones defined in this flake.
  isLocal =
    opt:
    builtins.any (decl: lib.hasPrefix (toString flake.outPath) (toString decl)) (
      opt.declarations or [ ]
    );

  # Prune the tree: remove branches that contain NO local options
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

  # --- Processing ---

  # 1. NixOS Options
  # [ FIX ] Remove global 'packages' alias from documentation
  # The user confirmed that 'packages' appearing at the top level is duplicate behavior.
  # We enforce that only 'zenos.system.packages' and 'zenos.users' are documented.
  rawTree = pruneTree nixosEval.options;
  localTree = if rawTree != null then removeAttrs rawTree [ "packages" ] else null;
  optionsJson = if localTree != null then formatOptions localTree else { };

  # 2. Home Manager Options
  hmLocalTree = pruneTree hmEval.options;
  hmOptionsJson = if hmLocalTree != null then formatOptions hmLocalTree else { };

  # 3. Packages
  packagesTree = flake.packages.${system} or { };
  packagesJson = formatPackages packagesTree;

  # 4. Maintainers
  # We use the explicitly imported maintainers list
  usedMaintainersList = lib.attrValues maintainers;

  # Convert to attribute set { "handle" = { ... }; }
  # We use the github handle as the key if available, otherwise the name.
  usedMaintainers = lib.listToAttrs (
    map (m: {
      name = m.github or m.name;
      value = m;
    }) usedMaintainersList
  );

in
{
  options = optionsJson.sub or { };
  pkgs = packagesJson.sub or { };

  # Added: All maintainers defined in the repository
  maintainers = usedMaintainers;

  # Added: Home Manager options
  home-options = hmOptionsJson.sub or { };
}
