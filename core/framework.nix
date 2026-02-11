{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib)
    mkOption
    types
    attrNames
    attrValues
    mapAttrs
    concatMap
    ;

  # Local import of loaders
  loaders = import ../lib/loaders.nix { inherit lib; };
  safeLoad = path: if builtins.pathExists path then loaders.loadModules path else [ ];

  userModules = safeLoad ../userModules;
  programModules = safeLoad ../programModules;

  # --- HELPERS ---

  # 1. Recursive Flattener
  # Converts { gnome = { gedit = true; }; } -> [ "gnome.gedit" ]
  flattenConfig =
    cfg:
    let
      walk =
        prefix: set:
        concatMap (
          name:
          let
            val = set.${name};
            path = if prefix == "" then name else "${prefix}.${name}";
          in
          if val == true then
            [ path ]
          else if builtins.isAttrs val then
            walk path val
          else
            [ ]
        ) (attrNames set);
    in
    walk "" cfg;

  # 2. Recursive Package Collector
  # Recursively extracts derivations from a set (e.g. pkgs.gnome -> [ gedit nautilus ... ])
  collectPackages =
    item:
    if lib.isDerivation item then
      [ item ]
    else if lib.isAttrs item then
      concatMap collectPackages (attrValues item)
    else
      [ ];

  # 3. Robust Package Lookup & Collection
  # Applies Flattening -> Lookup -> Collection
  getFromSource =
    source: cfg:
    let
      enabledPaths = flattenConfig cfg;

      resolvePackage =
        pathStr:
        let
          pathList = lib.splitString "." pathStr;
        in
        lib.attrByPath pathList
          (throw "ZenPkgs Error: Could not find package '${pathStr}' in the registry.")
          source;

      resolvedItems = map resolvePackage enabledPaths;
    in
    concatMap collectPackages resolvedItems;

  # --- SHARED SUBMODULES ---

  # 1. The Module Config Scope
  programScope = types.submodule {
    imports = programModules;
    options = {
      packages = mkOption {
        type = types.attrsOf types.package;
        default = { };
        internal = true;
        description = "Packages exported by program modules";
      };
    };
  };

  # 2. The Package Registry Scope
  packageRegistry = types.submodule {
    options = {
      legacy = mkOption {
        description = "Legacy packages from NixPkgs (Supports Deep Nesting & Set Installation)";
        type = types.attrs;
        default = { };
        example = {
          vim = true;
          gnome = true; # Installs entire gnome set
        };
      };

      programs = mkOption {
        description = "ZenOS Native Programs (Supports Deep Nesting & Set Installation)";
        type = types.attrs;
        default = { };
      };
    };
  };

  # The schema for a User
  userSubmodule =
    { name, ... }:
    {
      imports = userModules;
      options = {
        legacy = mkOption {
          description = "Raw Home Manager configuration";
          type = types.submodule { freeformType = types.attrs; };
          default = { };
        };

        programs = mkOption {
          description = "User-specific program modules configuration";
          default = { };
          type = programScope;
        };

        packages = mkOption {
          description = "Declarative package installation";
          type = packageRegistry; # Shared Logic
          default = { };
        };

        theme = mkOption {
          description = "User theme preferences";
          type = types.str;
          default = "dark";
        };
      };
    };

in
{
  options.zenos = {
    # --- SYSTEM ---
    system = {
      hostName = mkOption {
        type = types.str;
        description = "The hostname of the machine";
      };

      boot = mkOption {
        type = types.str;
        description = "Bootloader configuration mode (efi/bios)";
        default = "efi";
      };

      packages = mkOption {
        type = packageRegistry; # Shared Logic
        description = "System-wide package registry";
        default = { };
      };

      programs = mkOption {
        description = "System-wide program modules configuration";
        default = { };
        type = programScope;
      };
    };

    # --- DESKTOPS ---
    desktops = {
      gnome = mkOption {
        type = types.bool;
        description = "Enable GNOME Desktop Environment";
        default = false;
      };
      hyprland = mkOption {
        type = types.bool;
        description = "Enable Hyprland Window Manager";
        default = false;
      };
    };

    # --- ENVIRONMENT ---
    environment = {
      variables = mkOption {
        type = types.attrsOf types.str;
        description = "System-wide environment variables";
      };
    };

    # --- USERS ---
    users = mkOption {
      description = "Map of user configurations";
      type = types.attrsOf (types.submodule userSubmodule);
      default = { };
    };
  };

  # --- IMPLEMENTATION ---
  config = {
    # 1. System Configuration
    networking.hostName = config.zenos.system.hostName;

    environment.systemPackages =
      (getFromSource pkgs.legacy config.zenos.system.packages.legacy)
      ++ (getFromSource pkgs.zenos.programs config.zenos.system.packages.programs)
      ++ (attrValues config.zenos.system.programs.packages);

    environment.variables = config.zenos.environment.variables;

    # 2. User Configuration
    users.users = mapAttrs (name: userCfg: {
      isNormalUser = true;
      # Logic matches systemPackages exactly
      packages =
        (getFromSource pkgs.legacy userCfg.packages.legacy)
        ++ (getFromSource pkgs.zenos.programs userCfg.packages.programs)
        ++ (attrValues userCfg.programs.packages);
    }) config.zenos.users;

    # 3. Home Manager Bridge
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users = mapAttrs (
      name: userCfg:
      { ... }:
      {
        imports = [ userCfg.legacy ];
        home.stateVersion = config.system.stateVersion;
      }
    ) config.zenos.users;
  };
}
