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
              assetName = "Popcorn-1.1.0${info.variant}-${info.device}.zip";
              kver = "7.0.2";

              # this now represents the full unpacked source + binary
              unpacked = final.stdenv.mkDerivation {
                pname = "${name}-bin-unpacked";
                version = kver;
                src = final.fetchurl {
                  url = "https://github.com/zenos-n/popcorn/releases/download/1.1.0/${assetName}";
                  sha256 = hashes.${assetName} or lib.fakeSha256;
                };
                nativeBuildInputs = [ final.unzip ];
                unpackPhase = "unzip $src";
                # we organize the outputs so nixos can find them
                installPhase = ''
                  mkdir -p $out/lib/modules/${kver}
                  mkdir -p $dev/lib/modules/${kver}

                  # move bzImage/System.map to out
                  cp bzImage System.map $out/
                  cp -r lib/modules/${kver}/* $out/lib/modules/${kver}/

                  # move everything else (headers/scripts) to dev for module building
                  cp -r * $dev/lib/modules/${kver}/
                  ln -s $dev/lib/modules/${kver} $out/lib/modules/${kver}/build
                '';
                outputs = [
                  "out"
                  "dev"
                ];
              };

              rawKernel = unpacked // {
                override = _: rawKernel;
                config = { }; # if you can, grab the actual .config from the zip here
                features = {
                  efiBootStub = true;
                  ia32Emulation = true;
                };
                kernelOlder = lib.versionOlder kver;
                kernelAtLeast = lib.versionAtLeast kver;
                commonMakeFlags = [ ];
              };
            in
            final.linuxPackagesFor rawKernel;

          # 3. nesting logic: (src|bin) -> variant -> device
          nestKernels =
            pkgs:
            let
              variants = lib.unique (map (n: (parse n).variant) (lib.attrNames pkgs));
            in
            lib.genAttrs variants (
              v:
              let
                matching = lib.filterAttrs (n: _: (parse n).variant == v) pkgs;
              in
              lib.mapAttrs' (
                n: pkg:
                let
                  device = (parse n).device;
                  # the trick: if it's already a set (from mkBin), grab the kernel.
                  # if it's a raw derivation (src), it IS the kernel.
                  kernel = if pkg ? kernel then pkg.kernel else pkg;

                  # ensure it's overridable so linuxPackagesFor doesn't choke
                  overridable = if kernel ? override then kernel else (kernel // { override = _: overridable; });

                  # get the full package set nixos wants
                  pkgSet = if pkg ? kernel then pkg else (final.linuxPackagesFor overridable);
                in
                # Merge them. kernel // pkgSet makes it a derivation (leaf) that HAS set attributes.
                lib.nameValuePair device (kernel // pkgSet)
              ) matching
            );

          popcornBin = lib.mapAttrs mkBin popcornFiltered;

        in
        {
          lib = lib;
          zenos = (zenCore.mkPackageTree final ./pkgs) // {
            legacy = prev;
            system.kernels.popcorn = {
              src = nestKernels popcornFiltered;
              # bin = nestKernels popcornBin;
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
