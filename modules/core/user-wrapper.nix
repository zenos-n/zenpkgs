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

  # --- Home Manager Shim ---
  # This module mocks the structure of Home Manager options.
  # It allows modules like 'webApps' (which write to xdg.* or home.*)
  # to function directly inside the zenos.users.<user> submodule.
  hmShim =
    { lib, ... }:
    {
      options = {
        # 1. Standard HM Options
        # We use freeform types (attrs) where possible to allow arbitrary HM config
        # that will be passed through to the real HM instance.

        xdg = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Passthrough for xdg.* configuration";
        };

        programs = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Passthrough for programs.* configuration";
        };

        services = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Passthrough for services.* configuration";
        };

        dconf = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };

        gtk = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };

        qt = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };

        systemd = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };

        wayland = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };

        # 2. The 'home' option requires special handling
        # It's usually a submodule in HM, but here we construct it
        # as a hybrid submodule to capture both strict options (packages)
        # and freeform attrs (everything else).
        home = lib.mkOption {
          type = lib.types.submodule {
            freeformType = lib.types.attrs;
            options = {
              packages = lib.mkOption {
                type = lib.types.listOf lib.types.package;
                default = [ ];
                description = "List of user packages (HM context)";
              };
              file = lib.mkOption {
                type = lib.types.attrs;
                default = { };
                description = "Files to link in $HOME";
              };
              sessionVariables = lib.mkOption {
                type = lib.types.attrs;
                default = { };
              };
              stateVersion = lib.mkOption {
                type = lib.types.str;
                default = "24.11"; # Default to recent
                description = "HM State Version";
              };
            };
          };
          default = { };
          description = "Home Manager 'home' configuration block";
        };
      };
    };

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
          type = lib.types.attrs;
          default = { };
          description = "Standard NixOS user options passthrough";
        };
      };
    };
in
{
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

  options.zenos = {
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
      (userCfg.legacy or { })
      // {
        # Note: userCfg.packages are system-level (users.users.pkg),
        # whereas userCfg.home.packages are HM-level.
        packages = (userCfg.legacy.packages or [ ]) ++ (resolvePackages [ ] userCfg.packages);
        extraGroups = (userCfg.legacy.extraGroups or [ ]) ++ userCfg.groups;
        openssh.authorizedKeys.keys = (userCfg.legacy.openssh.authorizedKeys.keys or [ ]) ++ userCfg.keys;
      }
      // (lib.optionalAttrs (userCfg.shell != null) { inherit (userCfg) shell; })
    ) cfg.users;

    # 2. Map ZenOS users to Home Manager
    # We take the configuration accumulated in the Shim (userCfg.home, userCfg.xdg, etc.)
    # and pipe it into the actual Home Manager instance.
    home-manager.users = lib.mapAttrs (name: userCfg: {
      home = userCfg.home;
      xdg = userCfg.xdg;
      programs = userCfg.programs;
      services = userCfg.services;
      dconf = userCfg.dconf;
      gtk = userCfg.gtk;
      qt = userCfg.qt;
      systemd = userCfg.systemd;
      wayland = userCfg.wayland;
    }) cfg.users;
  };
}
