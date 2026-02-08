{
  config,
  lib,
  options,
  zenpkgsInputs,
  loaders ? import ../lib/loaders.nix { inherit lib; },
  ...
}@args:

with lib;

let
  # Safely extract pkgs from args, defaulting to null if not present.
  pkgs = args.pkgs or null;
  cfg = config.zenos;

  collectPackages =
    set: path:
    flatten (
      mapAttrsToList (
        name: value:
        if value == null || value == true then
          let
            pkgPath = path ++ [ name ];
            pkg = if pkgs != null then attrByPath pkgPath null pkgs.zenos else null;
          in
          if pkg == null && pkgs != null then
            throw "ZenPkgs: Package at pkgs.zenos.${concatStringsSep "." pkgPath} not found."
          else
            pkg
        else if isAttrs value then
          collectPackages value (path ++ [ name ])
        else
          [ ]
      ) set
    );

  userOptions = {
    options = {
      packages = mkOption {
        type = types.attrs;
        default = { };
        description = "User-specific set-based package installation";
      };

      legacy = mkOption {
        default = pkgs;
        description = "Access to raw nixpkgs for this user";
      };

      programs = mkOption {
        type = types.attrs;
        default = { };
        description = "User-specific program configurations";
      };

      home = mkOption {
        type = types.attrs;
        default = { };
        internal = true;
        description = "Internal Home Manager configuration";
      };
    };
  };

in
{
  imports = (loaders.loadModules ../modules) ++ (loaders.loadModules ../legacyMaps/modules);

  # CLEANED: No more root-level aliases. Only 'zenos' namespace options.
  options.zenos = {
    system = {
      packages = mkOption {
        type = types.attrs;
        default = { };
        description = ''
          Tree-based package installation

          Maps to `pkgs.zenos.*`.
        '';
      };
      programs = mkOption {
        type = types.attrs;
        default = { };
        description = "System-wide program configurations";
      };
    };

    desktops = mkOption {
      type = types.attrs;
      default = { };
      description = "Desktop environment configurations";
    };

    environment = mkOption {
      type = types.attrs;
      default = { };
      description = "Environment variables and shell settings";
    };

    legacy = mkOption {
      default = pkgs;
      description = "Direct access to legacy nixpkgs";
    };
  };

  options.users.users = mkOption {
    type = types.attrsOf (types.submodule userOptions);
  };

  # Config Implementation
  config = mkIf (pkgs != null) {
    nix.registry = {
      nixpkgs.flake = zenpkgsInputs.nixpkgs;
      zenpkgs.flake = zenpkgsInputs.self;
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # NOTE: Shim Wiring removed.
    # cfg.system.packages is now populated directly by the wrapped user module.

    # System Packages + zenos-shell
    environment.systemPackages = (collectPackages cfg.system.packages [ ]) ++ [
      pkgs.zenos.tools.zenos-shell
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users = mapAttrs (user: userCfg: {
      home.stateVersion = config.system.stateVersion;
      home.packages = collectPackages userCfg.packages [ ];
      imports = [ { inherit (userCfg) home; } ];
    }) config.users.users;
  };
}
