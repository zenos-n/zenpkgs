let
  system = builtins.currentSystem;
  flake = builtins.getFlake (toString ../.);
  pkgs = import flake.inputs.nixpkgs { inherit system; };
  lib = pkgs.lib;

  # --- Configuration ---
  # Matches lib.platforms.zenos in utils.nix
  zenosPlatforms = [ "x86_64-linux" ];

  # --- Helpers ---

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
          default = tree.default or null;
          example = tree.example or null;
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

  # Helper to collect unique maintainers from the package tree
  collectMaintainers =
    tree:
    if lib.isDerivation tree then
      tree.meta.maintainers or [ ]
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
        lists = lib.mapAttrsToList (n: v: collectMaintainers v) cleanTree;
      in
      lib.flatten lists
    else
      [ ];

  # --- Evaluator ---

  # 1. NixOS Modules Evaluation
  modulePaths = lib.collect builtins.isPath flake.nixosModules;

  eval = lib.evalModules {
    modules = modulePaths ++ [
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
    specialArgs = { inherit pkgs; };
  };

  # 2. Home Manager Modules Evaluation
  # We collect paths from flake.homeModules just like we did for nixosModules
  hmModulePaths = lib.collect builtins.isPath (flake.homeModules or { });

  hmEval = lib.evalModules {
    modules = hmModulePaths ++ [
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
    specialArgs = { inherit pkgs; };
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
  localTree = pruneTree eval.options;
  optionsJson = if localTree != null then formatOptions localTree else { };

  # 2. Home Manager Options
  hmLocalTree = pruneTree hmEval.options;
  hmOptionsJson = if hmLocalTree != null then formatOptions hmLocalTree else { };

  # 3. Packages
  packagesTree = flake.packages.${system} or { };
  packagesJson = formatPackages packagesTree;

  # 4. Maintainers
  # Extract all maintainers used in the local packages
  usedMaintainersList = collectMaintainers packagesTree;

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

  # Added: Only maintainers used in zenpkgs
  maintainers = usedMaintainers;

  # Added: Home Manager options defined in flake.homeModules
  home-options = hmOptionsJson.sub or { };
}
