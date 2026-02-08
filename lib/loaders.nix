# LOCATION: lib/loaders.nix

{ lib }:

let
  inherit (lib)
    filterAttrs
    hasSuffix
    mapAttrsToList
    flatten
    pathIsDirectory
    ;
  inherit (builtins) readDir;

in
rec {
  # Recursively find all .nix files in a directory to import as modules
  loadModules =
    dir:
    if !pathIsDirectory dir then
      [ ]
    else
      let
        entries = readDir dir;
        processEntry =
          name: type:
          let
            path = dir + "/${name}";
          in
          if type == "directory" then
            loadModules path
          else if hasSuffix ".nix" name && name != "default.nix" then
            [ path ]
          else if name == "default.nix" then
            [ path ]
          else
            [ ];
      in
      flatten (mapAttrsToList processEntry entries);

  # Recursively load ./lib files into a set
  loadLib =
    dir:
    if !pathIsDirectory dir then
      { }
    else
      let
        entries = readDir dir;
      in
      lib.foldl' (
        acc: name:
        let
          path = dir + "/${name}";
          isNix = hasSuffix ".nix" name;
          # FIX: Exclude loaders.nix because it returns a function, not a set.
          # Attempting to merge a function with '//' causes the evaluation error.
          isNotLoader = name != "loaders.nix";
        in
        if isNix && isNotLoader then acc // (import path) else acc
      ) { } (builtins.attrNames entries);
}
