{
  description = "ZenOS - System Architecture Framework";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";

      zenBuilder = import ./lib/z-module-bridge.nix { inherit lib inputs; };
      zenCore = import ./lib/zen-core.nix { inherit lib inputs; };

      zenOSModules = zenBuilder.mapZenModules ./modules [ "zenos" ];

      coreModule =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          resolvePackages =
            pTree: cTree:
            let
              traverse =
                pNode: cNode:
                let
                  # Node is enabled if explicitly true, or set via the zcfg hack
                  enabled = cNode == true || (builtins.isAttrs cNode && cNode._enable or false);
                in
                if enabled then
                  if lib.isDerivation pNode then
                    [ pNode ]
                  else if builtins.isAttrs pNode then
                    # Guard against OOM evaluation of legacy nixpkgs
                    if pNode ? system || pNode ? stdenv then
                      throw "ZenOS: Cannot evaluate entire legacy packages tree."
                    else
                      lib.flatten (lib.mapAttrsToList (n: v: if cNode ? ${n} then traverse v cNode.${n} else [ ]) pNode)
                  else
                    [ ]
                else
                  [ ];
            in
            traverse pTree cTree;
        in
        {
          options = {
            # Options are fully populated by structure.zstr in allZenModules
          };

          config = {
            # Legacy Fallback Injector
            zenos.legacy = config;

            # Build global packages
            environment.systemPackages = resolvePackages pkgs.zenos config.zenos.packages;

            # Configure root level home-manager legacy injection point
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users = lib.mapAttrs (
                name: userCfg:
                lib.recursiveUpdate {
                  home.stateVersion = config.system.stateVersion or "25.11";
                  home.packages = resolvePackages pkgs.zenos userCfg.packages;
                } (lib.recursiveUpdate (userCfg.legacy.home-manager or { }) { programs = userCfg.programs.legacy; })
              ) config.zenos.users;
            };
          };
        };

      allZenModules = zenOSModules ++ [
        coreModule
        home-manager.nixosModules.home-manager
        (zenBuilder.zstrToModule { file = ./structure.zstr; })
      ];

    in
    {
      lib.core = zenCore;
      overlays.default = final: prev: {
        zenos = (zenCore.mkPackageTree prev ./pkgs) // {
          legacy = prev;
        };
      };
      nixosModules.default = {
        imports = allZenModules;
      };
      nixosModules.structure = {
        imports = allZenModules;
      };

      docs = import ./lib/docs.nix {
        inherit inputs self system;
        zenOSModules = allZenModules;
        moduleTree =
          let
            getFiles =
              dir:
              if builtins.pathExists dir then
                zenCore.walkDir dir (n: t: t == "regular" && (lib.hasSuffix ".nix" n || lib.hasSuffix ".zmdl" n))
              else
                [ ];
          in
          {
            modules = map (
              e:
              if lib.hasSuffix ".zmdl" e.name then
                let
                  raw = builtins.readFile e.absPath;
                  # Sanitize custom Z-Dialect variables into valid Nix syntax
                  safe =
                    builtins.replaceStrings
                      [ "$m." "$l." "$type." "$name" "$path." ]
                      [ "lib.maintainers." "lib.licenses." "lib.types." "name" "config." ]
                      raw;
                  # Create the file and completely strip the string context so docs.nix
                  # doesn't crash when passing its filename into another toFile call.
                  # Converting via `/. +` guarantees it acts as a standard filesystem path.
                  safeFile = builtins.unsafeDiscardStringContext (builtins.toFile "${e.name}-doc.nix" safe);
                in
                /. + safeFile
              else
                e.absPath
            ) (getFiles ./modules);
            packages = map (e: e.absPath) (getFiles ./pkgs);
          };
      };

      hosts = zenCore.mkHosts {
        root = ./systems;
        modules = allZenModules;
      };
    };
}
