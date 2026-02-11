# LOCATION: tools/doc-gen.nix

{
  pkgs,
  lib,
  modules,
}:

let
  loaders = import ../lib/loaders.nix { inherit lib; };

  zenpkgsInputs = {
    self = {
      outPath = ./..;
    };
    nixpkgs = {
      outPath = pkgs.path;
    };
    home-manager = {
      outPath = ./..;
    };
  };

  # 1. Full System Evaluation
  eval = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit loaders zenpkgsInputs; };
    modules = modules ++ [
      (
        { pkgs, ... }:
        {
          system.stateVersion = lib.versions.majorMinor lib.version;
          boot.loader.grub.enable = false;
          fileSystems."/".device = "/dev/null";
          nixpkgs.config.allowUnfree = true;
        }
      )
      # Fix collision shadow
      (
        { lib, ... }:
        {
          options.users.users = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                options.home = lib.mkOption { visible = false; };
              }
            );
          };
        }
      )
    ];
  };

  # 2. Extract Options
  optionsDoc = pkgs.nixosOptionsDoc {
    options = eval.options;
    transformOptions = opt: opt // { declarations = [ ]; };
  };

  # 3. Extract Package Catalog & Dependencies
  zenPackagesJson = pkgs.writeText "zen-packages.json" (
    builtins.toJSON (
      let
        getDeps =
          drv:
          let
            inputs =
              (drv.buildInputs or [ ]) ++ (drv.nativeBuildInputs or [ ]) ++ (drv.propagatedBuildInputs or [ ]);
          in
          map (
            d:
            if lib.isDerivation d then
              (d.pname or d.name or "unknown")
            else if builtins.isString d then
              d
            else
              "unknown"
          ) inputs;

        getLicense =
          meta:
          let
            l = meta.license or "Unknown";
          in
          if builtins.isList l then
            lib.concatStringsSep ", " (map (x: x.fullName or x.shortName or "Unknown") l)
          else
            l.fullName or l.shortName or "Unknown";

        walk =
          set:
          lib.mapAttrs (
            name: value:
            if name == "legacy" then
              { } # SKIP LEGACY
            else if lib.isDerivation value then
              {
                _type = "zen_package";
                pname = value.pname or value.name;
                version = value.version or "0.0.0";
                dependencies = getDeps value;
                meta = {
                  description = value.meta.description or "No description.";
                  license = getLicense value.meta;
                  maintainers = map (m: m.name or m.email or "Unknown") (value.meta.maintainers or [ ]);
                  platforms = value.meta.platforms or [ ];
                };
              }
            else if builtins.isAttrs value && !lib.isFunction value then
              walk value
            else
              { }
          ) set;
      in
      walk pkgs.zenos
    )
  );

in
pkgs.writeShellScriptBin "zen-doc-gen" ''
  echo "[ZenDoc] Extracting FULL NixOS Option Tree..."
  OPTIONS_JSON="${optionsDoc.optionsJSON}/share/doc/nixos/options.json"
  PACKAGES_JSON="${zenPackagesJson}"

  echo "[ZenDoc] Processing options and packages..."
  ${pkgs.python3}/bin/python3 ${./doc_gen.py} "$OPTIONS_JSON" "$PACKAGES_JSON"

  echo "[ZenDoc] Done. Generated options.json"
''
