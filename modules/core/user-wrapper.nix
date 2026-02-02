{
  config,
  lib,
  pkgs,
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
    { name, config, ... }:
    {
      options = {
        packages = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "User-specific packages with structural auto-resolution";
        };

        programs = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "User-specific program configurations to be mapped to NixOS programs";
        };

        groups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Additional groups for the user";
        };

        keys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "SSH public keys to add to authorized_keys";
        };

        shell = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          default = null;
          description = "The default login shell for the user";
        };

        home = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Direct Home Manager configuration attributes";
        };

        legacy = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Standard NixOS users.users options to pass through";
        };
      };
    };
in
{
  meta = {
    description = "Enhanced user and system package management for ZenOS";
    longDescription = ''
      This module provides a unified interface for managing system-wide and user-specific 
      configurations. It includes a recursive package resolver that allows defining 
      software sets logically.

      It handles:
      - System packages via `zenos.system.packages`
      - User management via `zenos.users`
      - Automatic mapping to NixOS user settings and Home Manager
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos = {
    system.packages = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Attribute set of system packages to be automatically resolved and installed";
    };

    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule userSubmodule);
      default = { };
      description = "Declarative user configurations with automatic NixOS and Home Manager integration";
    };
  };

  config = {
    # System-wide package resolution
    environment.systemPackages = resolvePackages [ ] cfg.system.packages;

    # Map ZenOS users to standard NixOS user configuration
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

    # Map ZenOS users to Home Manager
    home-manager.users = lib.mapAttrs (name: userCfg: userCfg.home) cfg.users;
  };
}
