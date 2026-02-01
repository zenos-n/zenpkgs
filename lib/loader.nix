# LOCATION: lib/loader.nix
{ lib }:
rec {
  # [ FUNCTION ] scanDir
  # Returns a list of .nix file paths in a directory.
  # Usage: imports = scanDir ./path;
  scanDir =
    path:
    let
      entries = builtins.readDir path;
      filter = name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix";
    in
    lib.mapAttrsToList (name: _: path + "/${name}") (lib.filterAttrs filter entries);

  # [ FUNCTION ] mergeDir
  # Imports every file in a directory and merges the resulting attribute sets.
  # Usage: map = mergeDir ./packages { pkgs = ... };
  mergeDir =
    path: args:
    let
      paths = scanDir path;
      imported = map (p: import p args) paths;
    in
    lib.foldl lib.recursiveUpdate { } imported;
}
