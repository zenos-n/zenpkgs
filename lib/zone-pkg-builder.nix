{ lib, ... }:

{
  pkgs,
  legacyPkgs,
  filepath,
}:

let
  zDialect = import ./zone-dialect.nix { inherit lib; };
  content = builtins.readFile filepath;
  name = lib.removeSuffix ".zpkg" (builtins.baseNameOf filepath);

  evaluated = zDialect.evalZString {
    inherit name pkgs content;
    licenses = lib.licenses;
    maintainers = lib.maintainers;
    extraArgs = {
      src = {
        github = args: pkgs.fetchFromGitHub args;
        url = args: pkgs.fetchurl args;
        tarball = args: pkgs.fetchzip args;
        git = args: pkgs.fetchgit args;
      };
      type.cargo = {
        _type = "ztype";
        name = "cargo";
      };
      deps = pkgs;
    };
  };

  meta = evaluated._meta or { };
  interface = evaluated._interface or null;
  hasBuildMode = evaluated ? _src || evaluated ? _build;

  interfacePath = if interface == null then [ ] else interface.path or [ ];
  interfaceSource = if interface == null then null else interface.from or null;
  target = lib.attrByPath interfacePath null legacyPkgs;

  buildPackage =
    let
      rawSrc = evaluated._src or (throw "ZenOS Error: Missing _src in ${toString filepath}");
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
          RUSTFLAGS = "-C prefer-dynamic";
          postConfigure = buildConf.postConfigure or "";
          postFixup = ''
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
in
if interface != null then
  assert !hasBuildMode;
  assert interfaceSource == "nixpkgs";
  assert interfacePath != [ ];
  if target == null then
    throw "ZenOS interface ${toString filepath} cannot resolve nixpkgs.${lib.concatStringsSep "." interfacePath}"
  else if !lib.isDerivation target then
    throw "ZenOS interface ${toString filepath} did not resolve to a derivation"
  else
    target
    // {
      _zmeta = {
        schemaVersion = 1;
        mode = "interface";
        interface = {
          from = "nixpkgs";
          path = interfacePath;
        };
        brief = meta.brief or (target.meta.description or name);
        description = meta.description or meta.brief or (target.meta.description or name);
        maintainers = meta.maintainers or [ ];
      };
    }
else
  assert hasBuildMode;
  buildPackage
