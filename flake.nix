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
      pkgs = nixpkgs.legacyPackages.${system};

      # internal libs
      zenCore = import ./lib/zen-core.nix { inherit lib inputs; };
      zpkgBuilder = import ./lib/zone-pkg-builder.nix { inherit lib inputs; };
      zenOSModules = import ./lib/zen-module.nix { inherit lib inputs zenCore; };
    in
    {
      lib = lib // {
        core = zenCore;
      };
      overlays.default = final: prev: {
        zenos = (zenCore.mkPackageTree zpkgBuilder prev ./pkgs) // {
          legacy = prev;
        };
      };

      nixosModules.default = {
        imports = zenOSModules.all;
      };

      docs = import ./lib/docs.nix {
        inherit inputs self system;
        zenOSModules =
          (import ./lib/zen-module.nix {
            inherit lib inputs zenCore;
            isDocs = true;
          }).all;
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
            zDialect = import ./lib/zone-dialect.nix { inherit lib; };
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
        modules = zenOSModules.all;
      };
    };
}
