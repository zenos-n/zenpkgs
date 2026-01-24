# LOCATION: zenpkgs/lib/utils.nix
# DESCRIPTION: The actual implementation of utility functions.

{
  lib,
  inputs,
  self,
}:

rec {
  osVersionString =
    let
      major = inputs.self.version.majorVer;
      variant = inputs.self.version.variant;
      type = inputs.self.version.type;
    in
    "${major}${variant}${type}${
      if type != "stable" then
        "b (${if (self ? shortRev) then self.shortRev else "${self.dirtyShortRev or "unknown"}"})"
      else
        ""
    }";

  # Recursively find all .nix files in a directory
  recursiveImports =
    path:
    let
      contents = builtins.readDir path;
      processEntry =
        name: type:
        let
          fullPath = path + "/${name}";
        in
        if type == "directory" then
          recursiveImports fullPath
        else if type == "regular" && lib.hasSuffix ".nix" name && name != "structure.nix" then
          [ fullPath ]
        else
          [ ];
      entries = lib.mapAttrsToList processEntry contents;
    in
    lib.flatten entries;

  # Helper to check if a module is enabled via the new config syntax
  isModuleEnabled =
    config: category: name:
    let
      categoryConfig = config.zenos.modules.${category} or [ ];
    in
    (categoryConfig == "*") || (lib.elem name categoryConfig);
}
