{
  config,
  lib,
  pkgs,
  zenUserModules ? [ ],
  ...
}:

let
  cfg = config.zenos;

  # Recursively resolves attribute sets into a flat list of derivations
  resolvePackages =
    path: set:
    lib.concatLists (
      lib.mapAttrsToList (
        name: value:
        let
          currentPath = path ++ [ name ];
          pkgFromPath = lib.attrByPath currentPath null pkgs;
        in
        if lib.isDerivation value then
          [ value ]
        else if lib.isAttrs value && value != { } then
          resolvePackages currentPath value
        else if pkgFromPath != null && lib.isDerivation pkgFromPath then
          [ pkgFromPath ]
        else
          [ ]
      ) set
    );

  userSubmodule =
    { name, ... }:
    {
      # Inject the collected HM modules + the Shim
      imports = zenUserModules;

      options = {
        packages = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = ''
            User-specific packages with structural auto-resolution
            (System-level installation, mapped to users.users.<name>.packages)
          '';
        };

        # 'programs' option is handled by the Shim above.

        # groups = lib.mkOption {
        #   type = lib.types.listOf lib.types.str;
        #   default = [ ];
        #   description = "Additional user group memberships";
        # };

        # keys = lib.mkOption {
        #   type = lib.types.listOf lib.types.str;
        #   default = [ ];
        #   description = "Authorized SSH public keys";
        # };

        # shell = lib.mkOption {
        #   type = lib.types.nullOr lib.types.package;
        #   default = null;
        #   description = "Default login shell for the user";
        # };

        legacy = lib.mkOption {
          type = lib.types.lazyAttrsOf lib.types.raw;
          readOnly = true;
          default = (config.users.users.${name} or { }) // {
            homeManager = builtins.removeAttrs (config.home-manager.users.${name} or { }) [ "zenos" ];
          };
          description = "Lazy NixOS user mirror with Home Manager attached";
        };
      };
    };
  meta = {
    description = ''
      Enhanced user management for ZenOS

      This module provides a unified interface for managing user-specific 
      configurations. It includes a recursive package resolver and a 
      Home Manager Shim that allows HM-native modules to be configured directly.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };
in
{

  options.zenos = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
      default = { };
      description = ''
        Declarative user configurations with automatic integration.
        Includes direct support for ZenOS Home Manager modules.
      '';
    };
  };

  config = {
    # 1. Map ZenOS users to standard NixOS user configuration
    users.users = lib.mapAttrs (
      name: userCfg:
      {
        # Note: userCfg.packages are system-level (users.users.pkg),
        # whereas userCfg.home.packages are HM-level.
        packages = resolvePackages [ ] userCfg.packages;
        extraGroups = userCfg.groups or [ ];
        openssh.authorizedKeys.keys = userCfg.keys or [ ];
      }
      // (lib.optionalAttrs ((userCfg.shell or null) != null) { inherit (userCfg) shell; })
    ) cfg.users;

    # User modules share one ZenOS tree. Forward all backend-owned values
    # without maintaining a manual list of Home Manager roots.
    home-manager.users = lib.mapAttrs (
      _name: userCfg:
      builtins.removeAttrs userCfg [
        "_meta"
        "groups"
        "keys"
        "legacy"
        "packages"
        "shell"
      ]
    ) cfg.users;
  };
}
