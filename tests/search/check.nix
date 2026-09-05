{
  bootstrapPkgs,
  nixpkgs,
  home-manager,
}:
let
  bundleFile =
    bootstrapPkgs.runCommand "search-fixture-bundle.json"
      {
        nativeBuildInputs = [ bootstrapPkgs.python3 ];
      }
      ''
        export PYTHONPATH=${../../lib/zen-dsl}
        python3 -m zenlang compile-tree --root ${./fixtures} --output "$out" --mode interface
      '';
  result = import ./acceptance.nix {
    inherit nixpkgs home-manager;
    bundle = builtins.fromJSON (builtins.readFile bundleFile);
  };
in
bootstrapPkgs.writeText "search-acceptance.json" (builtins.toJSON result)
