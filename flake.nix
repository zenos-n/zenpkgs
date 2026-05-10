{
  description = "ZenOS - System Architecture Framework";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    illogical-impulse.url = "github:soymou/illogical-flake";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixcord.url = "github:kaylorben/nixcord";
    popcorn-kernel.url = "github:zenos-n/popcorn";
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

      # load custom metadata
      # paths are relative to flake.nix
      customLicenses = import ./lib/licenses.nix;
      customMaintainers = import ./lib/maintainers.nix;

      # internal libs
      zenCore = import ./lib/zen-core.nix { inherit lib inputs; };
      zenOSModules = import ./lib/zen-module.nix { inherit lib inputs zenCore; };
    in
    {
      lib = lib // {
        core = zenCore;
        licenses = lib.licenses // customLicenses;
        maintainers = lib.maintainers // customMaintainers;
      };
      overlays.default =
        final: prev:
        let
          lib = prev.lib // {
            # keeping your custom lib extensions
            licenses = prev.lib.licenses // customLicenses;
            maintainers = prev.lib.maintainers // customMaintainers;
          };

          # 1. get the raw packages and nix the "-release" junk
          popcornRaw = inputs.popcorn-kernel.packages.${system};
          popcornFiltered = lib.filterAttrs (n: _: !(lib.hasSuffix "-release" n)) popcornRaw;

          # helper to turn "popcorn-L-generic" into { variant = "L"; device = "generic"; }
          parse =
            name:
            let
              parts = lib.splitString "-" (lib.removePrefix "popcorn-" name);
            in
            {
              variant = lib.head parts;
              device = lib.concatStringsSep "-" (lib.tail parts);
            };

          # 2. auto-gen the -bin derivations
          # we import a generated file for hashes. if it doesn't exist yet, we fallback to fake
          hashes = if builtins.pathExists ./lib/popcorn-sha.nix then import ./lib/popcorn-sha.nix else { };

          mkBin =
            name: pkg:
            let
              info = parse name;
              assetName = "Popcorn-1.0.0${info.variant}-${info.device}.zip";
            in
            final.stdenv.mkDerivation {
              pname = "${name}-bin";
              version = "1.0.0";
              src = final.fetchurl {
                url = "https://github.com/zenos-n/popcorn/releases/download/1.0.0/${assetName}";
                sha256 = hashes.${assetName} or lib.fakeSha256;
              };
              nativeBuildInputs = [ final.unzip ];
              unpackPhase = "unzip $src";
              installPhase = "mkdir -p $out && cp -r * $out/";
            };

          # 3. nesting logic: (src|bin) -> variant -> device
          nestKernels =
            pkgs:
            let
              # get all unique variants: ["D" "L" "S"]
              variants = lib.unique (map (n: (parse n).variant) (lib.attrNames pkgs));
            in
            lib.genAttrs variants (
              v:
              let
                matching = lib.filterAttrs (n: _: (parse n).variant == v) pkgs;
              in
              lib.mapAttrs' (n: pkg: lib.nameValuePair (parse n).device pkg) matching
            );

          popcornBin = lib.mapAttrs mkBin popcornFiltered;

        in
        {
          lib = lib;
          zenos = (zenCore.mkPackageTree final ./pkgs) // {
            legacy = prev;
            system.kernels.popcorn = {
              src = nestKernels popcornFiltered;
              bin = nestKernels popcornBin;
            };
          };
        };
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
