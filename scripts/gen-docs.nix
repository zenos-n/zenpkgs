let
  system = builtins.currentSystem;
  # path: includes newly added files in a working checkout, without git staging.
  flake = builtins.getFlake "path:${toString ../.}";
  evaluated = flake.inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      flake.nixosModules.default
      { nixpkgs.config.allowUnfree = true; }
    ];
  };
  search = import ../lib/search-index.nix { lib = flake.inputs.nixpkgs.lib; };
in
search.mkIndex {
  inherit evaluated;
  bundle = flake.lib.dslBundleFor system;
  maintainers = import ../lib/maintainers.nix { };
  versionInfo = {
    inherit system;
    zenpkgsVersion = flake.rev or flake.dirtyRev or null;
    nixpkgsRevision = flake.inputs.nixpkgs.rev or null;
  };
}
