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

      zenBuilder = import ./lib/module-builder.nix { inherit lib; };
      zenCore = import ./lib/zen-core.nix { inherit lib inputs; };

      zenOSModules = zenBuilder.mapZenModules ./modules [ ];

      coreModule =
        {
          config,
          lib,
          pkgs,
          options,
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
                      lib.flatten (
                        lib.mapAttrsToList (
                          name: pVal:
                          let
                            cVal = if builtins.isAttrs cNode then cNode.${name} or { } else { };
                            childDisabled = cVal == false || (builtins.isAttrs cVal && cVal ? _enable && !cVal._enable);
                          in
                          if childDisabled then
                            [ ]
                          else if cVal != { } then
                            traverse pVal cVal
                          else
                            traverse pVal true
                        ) pNode
                      )
                  else
                    [ ]
                else if builtins.isAttrs cNode then
                  lib.flatten (
                    lib.mapAttrsToList (
                      name: cVal: if name != "_enable" && pNode ? ${name} then traverse pNode.${name} cVal else [ ]
                    ) cNode
                  )
                else
                  [ ];
            in
            traverse pTree cTree;
        in
        {
          # Evaluate the custom DSL structure file into standard mkOption mappings here
          options.zenos = zenCore.parseZstr lib options ./structure.zstr;

          config = {
            programs = config.zenos.system.programs.legacy;
            environment.systemPackages = resolvePackages pkgs.zenos config.zenos.system.packages;

            users.users = lib.mapAttrs (
              name: userCfg: builtins.removeAttrs userCfg.legacy [ "home-manager" ]
            ) config.zenos.users;

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
            modules = map (e: e.absPath) (getFiles ./modules);
          };
      };
    };
}
