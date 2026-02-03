{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.zenos;

  # Recursively resolves attribute sets into a flat list of derivations
  # Kept local here to resolve user-specific packages without external dependency
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
      options = {
        packages = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = ''
            User-specific packages with structural auto-resolution

            Allows defining software for a specific user using the same 
            recursive resolution logic as system packages.
          '';
        };

        programs = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = ''
            User-specific program configurations

            Attribute set of program-specific settings to be mapped 
            directly to NixOS program options.
          '';
        };

        groups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Additional user group memberships

            A list of secondary groups the user should be added to 
            (e.g., 'wheel', 'docker', 'video').
          '';
        };

        keys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Authorized SSH public keys

            List of strings representing public keys to be added to the 
            user's authorized_keys file.
          '';
        };

        shell = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          default = null;
          description = ''
            Default login shell for the user

            The package representing the user's preferred interactive 
            shell (e.g., pkgs.zsh).
          '';
        };

        home = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = ''
            Direct Home Manager configuration

            Raw attribute set passed directly to the Home Manager 
            user configuration block.
          '';
        };

        legacy = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = ''
            Standard NixOS user options passthrough

            Allows defining standard NixOS 'users.users.<name>' attributes 
            that are not explicitly covered by ZenOS options.
          '';
        };
      };
    };
in
{
  meta = {
    description = ''
      Enhanced user management for ZenOS

      This module provides a unified interface for managing user-specific 
      configurations. It includes a recursive package resolver that allows 
      defining software sets logically.

      It handles:
      - User management via `zenos.users`
      - Automatic mapping to NixOS user settings and Home Manager
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos = {
    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
      default = { };
      description = ''
        Declarative user configurations with automatic integration

        Defines ZenOS-specific user settings that are automatically 
        mapped to both standard NixOS user options and Home Manager.
      '';
    };
  };

  config = {
    # 1. Map ZenOS users to standard NixOS user configuration
    users.users = lib.mapAttrs (
      name: userCfg:
      (userCfg.legacy or { })
      // {
        packages = (userCfg.legacy.packages or [ ]) ++ (resolvePackages [ ] userCfg.packages);
        extraGroups = (userCfg.legacy.extraGroups or [ ]) ++ userCfg.groups;
        openssh.authorizedKeys.keys = (userCfg.legacy.openssh.authorizedKeys.keys or [ ]) ++ userCfg.keys;
      }
      // (lib.optionalAttrs (userCfg.shell != null) { inherit (userCfg) shell; })
    ) cfg.users;

    # 2. Map ZenOS users to Home Manager
    home-manager.users = lib.mapAttrs (name: userCfg: userCfg.home) cfg.users;
  };
}
