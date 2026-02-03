# LOCATION: lib/loader.nix
# DESCRIPTION: Recursive directory scanner for modules and packages.

{ lib }:
rec {
  # [ FUNCTION ] generateTree
  # Scans directories to build attribute trees (pkgs.a.b)
  generateTree =
    path:
    if !builtins.pathExists path then
      { }
    else
      let
        entries = builtins.readDir path;
      in
      lib.filterAttrs (n: v: v != null) (
        lib.mapAttrs (
          name: type:
          if type == "directory" then
            # Priority 1: Leaf Module (Standard)
            if builtins.pathExists (path + "/${name}/default.nix") then
              path + "/${name}/default.nix"
            # Priority 1.5: Leaf Module (Alternative)
            else if builtins.pathExists (path + "/${name}/package.nix") then
              path + "/${name}/package.nix"
            # Priority 1.6: Leaf Module (Name Match)
            # Detects /foo/foo.nix patterns
            else if builtins.pathExists (path + "/${name}/${name}.nix") then
              path + "/${name}/${name}.nix"
            # Priority 2: Branch (Recurse)
            else
              let
                subtree = generateTree (path + "/${name}");
              in
              if subtree == { } then null else subtree
          # Priority 3: Leaf File
          else if
            type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" && name != "package.nix"
          then
            path + "/${name}"
          else
            null
        ) entries
      );

  # [ FUNCTION ] scanPaths
  # Returns a flat list of all paths found in the tree (for imports).
  scanPaths =
    path:
    let
      tree = generateTree path;
    in
    if tree == { } then [ ] else lib.collect builtins.isPath tree;
}
