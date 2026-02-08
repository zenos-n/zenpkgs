{ lib, pkgs, ... }:

let
  # --- MOCK TYPES ---
  # We return a simple representation of types for the docs.
  # Crucially, we handle submodules by recursively evaluating them.
  mockTypes = rec {
    str = "string";
    int = "int";
    bool = "bool";
    path = "path";
    package = "package";
    listOf = t: "list of ${t}";
    attrsOf = t: "map of ${if builtins.isString t then t else "submodule"}";

    # THE MAGIC: Recursively evaluate submodules to get their options
    submodule =
      module:
      let
        # Evaluate the submodule with our mock infrastructure
        eval = module {
          lib = mockLib;
          pkgs = pkgs; # Mock pkgs passed down
          config = { };
          name = "<name>";
        };
      in
      {
        _type = "submodule_schema";
        options = eval.options;
      };

    # Fallback for complex types
    oneOf = _: "choice";
    nullOr = t: "null or ${if builtins.isString t then t else "submodule"}";
  };

  # --- MOCK LIB ---
  mockLib = lib // {
    # Override mkOption to return raw data instead of processing it
    mkOption =
      attrs:
      attrs
      // {
        _type = "zen_option";
        # Ensure description is present
        description = attrs.description or "No description provided.";
      };

    # Override mkIf/mkMerge to just return the content (simplification)
    mkIf = _cond: content: content;
    mkMerge = contents: builtins.head contents; # Just take the first one for doc purposes

    # Inject our mock types
    types = lib.types // mockTypes;
  };
in
mockLib
