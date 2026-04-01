{ lib, inputs }:
let
  zDialect = import ./zone-dialect.nix { inherit lib; };
in
pkgs: filepath:
let
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
      RUSTFLAGS = "-C prefer-dynamic";
      postConfigure = ''
        echo "[ZenOS ADL] Forcing cdylib injection..."
        find $CARGO_HOME/registry/src/ -name "Cargo.toml" -exec sed -i 's/crate-type = \["rlib"\]/crate-type = \["cdylib"\]/g' {} + || true
        ${buildConf.postConfigure or ""}
      '';
      postFixup = ''
        echo "[ZenOS ADL] Managing RPATH..."
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
  pkgs.stdenv.mkDerivation (drvArgs // buildConf)
