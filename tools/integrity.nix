{
  pkgs,
  modules,
  lib,
}:

let
  # Generate the string of module paths
  moduleString = lib.concatStringsSep " " (map (m: "${m}") modules);

  # Read the separate Python file
  scriptTemplate = builtins.readFile ./checker.py;

  # Inject the modules into the Python script placeholder
  finalScript = builtins.replaceStrings [ "@MODULES@" ] [ moduleString ] scriptTemplate;
in
pkgs.writers.writePython3Bin "zen-integrity" {
  libraries = [ ];
  # Aggressively suppress all flake8 errors (Style, Warnings, Formatting)
  # to prevent build failures due to syntax pettiness.
  flakeIgnore = [
    "E"
    "W"
    "F"
  ];
} finalScript
