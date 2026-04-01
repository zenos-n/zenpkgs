{
  lib,
  inputs,
  zenCore,
  isDocs ? false,
  ...
}:
let
  zenBuilder = import ./zone-module-bridge.nix { inherit lib inputs isDocs; };

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
      isDocs ? false,
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
      # options.zenos = {
      #   users = lib.mkOption {
      #     type = lib.types.attrsOf (
      #       lib.types.submodule {
      #         _module.args.pkgs = pkgs.zenos;
      #         imports = lib.flatten [
      #           (
      #             if builtins.pathExists ../modules/userModules then
      #               zenBuilder.mapZenModules ../modules/userModules [ ] true
      #             else
      #               [ ]
      #           )
      #           (
      #             if builtins.pathExists ../modules/programs then
      #               zenBuilder.mapZenModules ../modules/programs [ "programs" ] true
      #             else
      #               [ ]
      #           )
      #         ];
      #       }
      #     );
      #   };
      # };

      options = {
        # Catch-all for metadata at the root
        _meta = lib.mkOption {
          type = lib.types.anything;
          default = { };
          internal = true;
        };
        _zmeta_passthrough = lib.mkOption {
          type = lib.types.anything;
          default = { };
          internal = true;
        };

        # THE FIX: Allow zenos to have both formal options AND raw metadata
        zenos = lib.mkOption {
          type = lib.types.submodule {
            freeformType = lib.types.lazyAttrsOf lib.types.anything;
            options = {
              # keep your existing formal options here
              # legacy = lib.mkOption {
              #   type = lib.types.anything;
              #   default = { };
              #   internal = true;
              # };
              # users is already defined in your options.zenos block elsewhere
            };
          };
          default = { };
        };
      };

      config = {
        zenos.legacy = config;
        environment.systemPackages = resolvePackages pkgs.zenos config.zenos.system.packages;

        users.users = lib.mapAttrs (
          name: userCfg:
          if isDocs then
            userCfg.legacy
          # keep meta for docs [cite: 4]
          else
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
