{
  description = "ZenOS - System Architecture Framework";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    illogical-impulse.url = "github:soymou/illogical-flake";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixcord.url = "github:kaylorben/nixcord";

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
      zDialect = import ./lib/z-dialect.nix { inherit lib; };

      # ZenOS Package Builder: Evaluates .zpkg and maps to derivations
      zpkgBuilder =
        pkgs: filepath:
        let
          content = builtins.readFile filepath;
          name = lib.removeSuffix ".zpkg" (builtins.baseNameOf filepath);

          evaluated = zDialect.evalZString {
            inherit name pkgs content;
            licenses = lib.licenses;
            maintainers = lib.maintainers;
            extraArgs = {
              # Inject Dynamic Fetchers
              src = {
                github = args: pkgs.fetchFromGitHub args;
                url = args: pkgs.fetchurl args;
                tarball = args: pkgs.fetchzip args;
                git = args: pkgs.fetchgit args;
              };
              # Inject Cargo type into the evaluation context
              type = {
                cargo = {
                  _type = "ztype";
                  name = "cargo";
                };
              };
              # Inject Dependencies Alias ($deps)
              deps = pkgs;
            };
          };

          meta = evaluated._meta or { };

          # Default Source: Fallback to fetchTarball if _src is a string
          rawSrc = evaluated._src or (throw "ZenOS Error: Missing _src in ${filepath}");
          src = if builtins.isString rawSrc then builtins.fetchTarball rawSrc else rawSrc;

          buildConf = evaluated._build or { };
          buildType = buildConf.type.name or "stdenv";

          drvArgs = {
            pname = name;
            version = meta.version or "0.1.0";
            inherit src;
            meta = {
              description = meta.brief or "";
              license = meta.license or null;
            };
            buildInputs = meta.deps or [ ];
            nativeBuildInputs = meta.buildDeps or [ ];
            propagatedBuildInputs = meta.exportDeps or [ ];
          };

        in
        if buildType == "cargo" then
          pkgs.rustPlatform.buildRustPackage (
            drvArgs
            // {
              cargoHash = buildConf.cargoHash or lib.fakeHash;
              # ZenOS Cargo ADL (Auto-Dynamic Linking) Logic
              RUSTFLAGS = "-C prefer-dynamic";
              postConfigure = ''
                echo "[ZenOS ADL] Forcing cdylib injection for ${name} dependencies..."
                # ADL Spec: Force crate-type = ["cdylib"] on registry crates
                find $CARGO_HOME/registry/src/ -name "Cargo.toml" -exec sed -i 's/crate-type = \["rlib"\]/crate-type = \["cdylib"\]/g' {} + || true
                ${buildConf.postConfigure or ""}
              '';
              postFixup = ''
                echo "[ZenOS ADL] Managing RPATH for dynamic crates..."
                # ADL Spec: Point binary RPATH exactly to the hashed shared crates
                for bin in $out/bin/*; do
                  patchelf --add-rpath "${pkgs.lib.makeLibraryPath drvArgs.buildInputs}" "$bin" || true
                done
                ${buildConf.postFixup or ""}
              '';
            }
            // (builtins.removeAttrs buildConf [
              "type"
              "cargoHash"
              "postConfigure"
              "postFixup"
            ])
          )
        else
          pkgs.stdenv.mkDerivation (drvArgs // buildConf);

      # Manually map the directories to match the (zmdl ...) definitions in structure.zstr
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
            zenos.users = lib.mkOption {
              type = lib.types.attrsOf (
                lib.types.submodule {
                  _module.args.pkgs = pkgs.zenos;
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
            zenos.legacy = config;
            environment.systemPackages = resolvePackages pkgs.zenos config.zenos.system.packages;

            users.users = lib.mapAttrs (
              name: userCfg: builtins.removeAttrs (userCfg.legacy or { }) [ "home-manager" ]
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

      allZenModules = zenOSModules ++ [
        coreModule
        home-manager.nixosModules.home-manager
        (zenBuilder.zstrToModule { file = ./structure.zstr; })
      ];

    in
    {
      lib.core = zenCore;
      overlays.default = final: prev: {
        # Bridge zpkgBuilder into the ZenOS package tree overlay
        zenos = (zenCore.mkPackageTree prev ./pkgs) // {
          legacy = prev;
          # Expose the test application built directly from a .zpkg spec
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
                zenCore.walkDir dir (
                  n: t:
                  t == "regular" && (lib.hasSuffix ".nix" n || lib.hasSuffix ".zmdl" n || lib.hasSuffix ".zpkg" n)
                )
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
