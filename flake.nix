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

      # internal libs (zpkgBuilder is dead)
      zenCore = import ./lib/zen-core.nix { inherit lib inputs; };
      zenOSModules = import ./lib/zen-module.nix { inherit lib inputs zenCore; };
    in
    {
      lib = lib // {
        core = zenCore;
      };

      overlays.default = final: prev: {
        # using 'final' here so your packages can actually see each other
        zenos = (zenCore.mkPackageTree final ./pkgs) // {
          legacy = prev;
        };
      };

      # THIS is what you were missing to make `nix run` and `nix build` work
      packages.${system} =
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        pkgs.zenos;

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
                  t == "regular" && (lib.hasSuffix ".nix" n || lib.hasSuffix ".zmdl" n)
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
