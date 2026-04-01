{
  lib,
  inputs,
  zenCore,
}:
let
  zenBuilder = import ./zone-module-bridge.nix { inherit lib inputs; };

  # map the physical directories to the zos tree
  baseModules = lib.flatten [
    (
      if builtins.pathExists ../modules/system then
        zenBuilder.mapZenModules ../modules/system [ "zenos" "system" ] false
      else
        [ ]
    )
    (
      if builtins.pathExists ../modules/desktops then
        zenBuilder.mapZenModules ../modules/desktops [ "zenos" "desktops" ] false
      else
        [ ]
    )
    (
      if builtins.pathExists ../modules/programs then
        zenBuilder.mapZenModules ../modules/programs [ "zenos" "system" "programs" ] false
      else
        [ ]
    )
  ];

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
              enabled = cNode == true || (builtins.isAttrs cNode && cNode._enable or false);
            in
            if enabled then
              if lib.isDerivation pNode then
                [ pNode ]
              else if builtins.isAttrs pNode then
                lib.flatten (lib.mapAttrsToList (n: v: if cNode ? ${n} then traverse v cNode.${n} else [ ]) pNode)
              else
                [ ]
            else
              [ ];
        in
        traverse pTree cTree;
    in
    {
      options.zenos.users = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            _module.args.pkgs = pkgs.zenos;
            imports = lib.flatten [
              (
                if builtins.pathExists ../modules/userModules then
                  zenBuilder.mapZenModules ../modules/userModules [ ] true
                else
                  [ ]
              )
              (
                if builtins.pathExists ../modules/programs then
                  zenBuilder.mapZenModules ../modules/programs [ "programs" ] true
                else
                  [ ]
              )
            ];
          }
        );
      };

      config = {
        zenos.legacy = config;
        environment.systemPackages = resolvePackages pkgs.zenos config.zenos.system.packages;
        users.users = lib.mapAttrs (
          name: userCfg:
          builtins.removeAttrs (userCfg.legacy or { }) [
            "_zmeta_passthrough"
            "home-manager"
          ]
        ) config.zenos.users;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users = lib.mapAttrs (
            name: userCfg:
            lib.recursiveUpdate
              {
                home.stateVersion = config.system.stateVersion or "25.11";
                home.packages = resolvePackages pkgs.zenos (userCfg.packages or { });
              }
              (
                lib.recursiveUpdate (userCfg.legacy.home-manager or { }) {
                  programs = userCfg.programs.legacy or { };
                }
              )
          ) config.zenos.users;
        };
      };
    };
in
{
  all = baseModules ++ [
    coreModule
    inputs.home-manager.nixosModules.home-manager
    (zenBuilder.zstrToModule { file = ../structure.zstr; })
  ];
}
