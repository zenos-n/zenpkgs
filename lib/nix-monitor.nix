{ config, lib, pkgs, ... }:
let package = pkgs.zenos.byCategories.system.zenos-shell-defaults;
in {
  options.programs.zenosNixMonitor.enable = lib.mkEnableOption "automatic Nix progress in interactive shells";
  config = lib.mkIf config.programs.zenosNixMonitor.enable {
    environment.systemPackages = [ package pkgs.nix-output-monitor ];
    environment.interactiveShellInit = ''
      nix() { ${package}/bin/zenos-nix "$@"; }
    '';
    programs.fish.interactiveShellInit = ''
      function nix --wraps nix
        ${package}/bin/zenos-nix $argv
      end
    '';
  };
}
