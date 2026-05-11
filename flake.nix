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

          nestKernels =
            pkgs:
            let
              # instead of just taking the variant name, we decide which ones are "roots"
              # we want 'generic-release' to effectively become 'generic' in the final attrset
              allNames = lib.attrNames pkgs;
              variants = lib.unique (
                map (
                  n:
                  let
                    v = (parse n).variant;
                  in
                  if lib.hasSuffix "-release" v then lib.removeSuffix "-release" v else v
                ) allNames
              );
            in
            lib.genAttrs variants (
              v:
              let
                # grab both the normal and the -release version for this variant
                matching = lib.filterAttrs (
                  n: _:
                  let
                    var = (parse n).variant;
                  in
                  var == v || var == "${v}-release"
                ) pkgs;
              in
              lib.mapAttrs' (
                n: pkg:
                let
                  p = parse n;
                  device = p.device;
                  # if the variant is the release version, we might want to map it to 'default'
                  # or just keep it as the primary device name
                  kernel = if pkg ? kernel then pkg.kernel else pkg;
                  overridable = if kernel ? override then kernel else (kernel // { override = _: overridable; });
                  pkgSet = if pkg ? kernel then pkg else (final.linuxPackagesFor overridable);
                in
                lib.nameValuePair device (kernel // pkgSet)
              ) matching
            );
        in
        {
          lib = lib;
          zenos = (zenCore.mkPackageTree final ./pkgs) // {
            legacy = prev;
            system.kernels.popcorn = nestKernels popcornFiltered;
            # bin = nestKernels popcornBin;

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

        # Add binary cache settings here
        nix.settings = {
          substituters = [ "https://popcorn-kernel.cachix.org" ];
          trusted-public-keys = [
            "popcorn-kernel.cachix.org-1:K+G41DukvEC4G8sYrrb5ufsAmasSOkWx7KAYtoSmaww="
          ];
        };
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
