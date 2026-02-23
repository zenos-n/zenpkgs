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

      # Manually map the directories to match the (zmdl ...) definitions in structure.zstr
      # Passed 'false' for isUserScope on global mounts
      zenOSModules = lib.flatten [
        (
          if builtins.pathExists ./modules/system then
            zenBuilder.mapZenModules ./modules/system [ "zenos" "system" ] false
          else
            [ ]
        )
        (
          if builtins.pathExists ./modules/desktops then
            zenBuilder.mapZenModules ./modules/desktops [ "zenos" "desktops" ] false
          else
            [ ]
        )
        (
          if builtins.pathExists ./modules/programs then
            zenBuilder.mapZenModules ./modules/programs [ "zenos" "system" "programs" ] false
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
            # We explicitly inject user modules and program modules into the freeform user submodule
            zenos.users = lib.mkOption {
              type = lib.types.attrsOf (
                lib.types.submodule {
                  # INJECT pkgs into submodule scope so home-manager and ZMDL files can access it
                  _module.args.pkgs = pkgs;

                  # Pass 'true' for isUserScope so the module bridge knows to isolate _saction
                  imports = lib.flatten [
                    (
                      if builtins.pathExists ./modules/userModules then
                        zenBuilder.mapZenModules ./modules/userModules [ ] true
                      else
                        [ ]
                    )
                    (
                      if builtins.pathExists ./modules/programs then
                        zenBuilder.mapZenModules ./modules/programs [ "programs" ] true
                      else
                        [ ]
                    )
                  ];
                }
              );
            };
          };

          config = {
            # Legacy Fallback Injector
            zenos.legacy = config;

            # Build global packages
            environment.systemPackages = resolvePackages pkgs.zenos config.zenos.system.packages;

            # Inject raw NixOS user legacy configurations so 'users.debug-user.legacy.isNormalUser' works
            users.users = lib.mapAttrs (
              name: userCfg: builtins.removeAttrs (userCfg.legacy or { }) [ "home-manager" ]
            ) config.zenos.users;

            # Configure root level home-manager legacy injection point
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

            allFiles = (getFiles ./modules) ++ [
              {
                name = "structure.zstr";
                type = "regular";
                relPath = [ ];
                absPath = ./structure.zstr;
              }
            ];
            zDialect = import ./lib/z-dialect.nix { inherit lib; };
          in
          {
            modules = map (
              e:
              if lib.hasSuffix ".zmdl" e.name || lib.hasSuffix ".zstr" e.name then
                let
                  raw = builtins.readFile e.absPath;
                  baseName = lib.removeSuffix ".zmdl" (lib.removeSuffix ".zstr" e.name);
                  transpiled = zDialect.transpileZString raw;
                  safe =
                    builtins.replaceStrings
                      [ "__zargs.m." "__zargs.l." "__zargs.type." "__zargs.name" "__zargs.path." ]
                      [ "lib.maintainers." "lib.licenses." "lib.types." ''"${baseName}"'' "config." ]
                      transpiled;

                  safeFile = builtins.unsafeDiscardStringContext (builtins.toFile "${e.name}-doc.nix" safe);
                in
                /. + safeFile
              else
                e.absPath
            ) allFiles;
            packages = map (e: e.absPath) (getFiles ./pkgs);
          };
      };

      hosts = zenCore.mkHosts {
        root = ./systems;
        modules = allZenModules;
      };
    };
}
