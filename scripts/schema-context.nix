# Explicitly trusted context for `zen-dsl validate --trusted-context`.
{ requests }:
let
  system = builtins.currentSystem;
  flake = builtins.getFlake "path:${toString ../.}";
  evaluated = flake.inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [ flake.nixosModules.default { nixpkgs.config.allowUnfree = true; } ];
  };
in
import ../lib/schema-validation.nix { lib = flake.inputs.nixpkgs.lib; } {
  inherit evaluated requests;
  bundle = flake.lib.dslBundleFor system;
  packageTree = evaluated.pkgs.zenos;
}
