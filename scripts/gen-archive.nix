let
  sourceRevision = builtins.getEnv "ZENPKGS_ARCHIVE_SOURCE_REVISION";
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
assert sourceRevision == "" || builtins.match "[0-9a-f]{40}" sourceRevision != null;
search.mkIndex {
  inherit evaluated;
  registry = flake.lib.dslRegistryFor system;
  bundle = flake.lib.dslBundleFor system;
  # The Git archive is a bounded overview. Deeper alias schemas retain their
  # depth-limit markers and can be explored through the full generator.
  limits = search.defaultLimits // {
    legacyPackageDepth = 0;
    optionDepth = 10;
    typeDepth = 2;
  };
  maintainers = import ../lib/maintainers.nix { };
  versionInfo = {
    inherit system;
    zenpkgsVersion = if sourceRevision != "" then sourceRevision else flake.rev or flake.dirtyRev or null;
    nixpkgsRevision = flake.inputs.nixpkgs.rev or null;
  };
}
