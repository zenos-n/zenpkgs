{
  lib,
  pkgs,
  path,
}:

let
  inherit (builtins) readDir pathExists;
  inherit (lib)
    filterAttrs
    mapAttrs'
    nameValuePair
    hasSuffix
    removeSuffix
    ;

  # Recursive function to walk a directory
  buildTree =
    dir:
    if !pathExists dir then
      { }
    else
      let
        entries = readDir dir;

        # We use mapAttrs' to allow renaming keys (removing .nix extension)
        tree = mapAttrs' (
          name: type:
          let
            nodePath = dir + "/${name}";
            isNix = hasSuffix ".nix" name;
            baseName = removeSuffix ".nix" name;
          in
          # Case 1: Directory
          if type == "directory" then
            # Support legacy folder-based packages (containing default.nix)
            if pathExists (nodePath + "/default.nix") then
              nameValuePair name (pkgs.callPackage nodePath { })
            # Otherwise treat as category/namespace
            else
              nameValuePair name (buildTree nodePath)

          # Case 2: Nix File (The new flat package standard)
          # e.g. "zenos-shell.nix" -> "zenos-shell"
          else if type == "regular" && isNix && name != "default.nix" then
            nameValuePair baseName (pkgs.callPackage nodePath { })

          # Case 3: Ignored files (README, etc)
          else
            nameValuePair name null
        ) entries;

      in
      # Filter out nulls
      filterAttrs (n: v: v != null) tree;
in
buildTree path
