{ bootstrapPkgs, nixpkgs, home-manager }:
let
  bundle = bootstrapPkgs.runCommand "zstr-mounting-fixture" {
    nativeBuildInputs = [ bootstrapPkgs.python3 ];
  } ''
    export PYTHONPATH=${../../lib/zen-dsl}
    python3 -m zenlang compile-tree --root ${./fixtures} --output "$out" --mode interface
  '';
  result = import ./acceptance.nix {
    nixpkgsPath = nixpkgs.outPath;
    homeManagerPath = home-manager.outPath;
    runtimePath = ../../lib/zstr-runtime.nix;
    bundlePath = bundle;
  };
in
assert builtins.all (value: value) (builtins.attrValues result);
bootstrapPkgs.writeText "zstr-mounting-acceptance.json" (builtins.toJSON result)
