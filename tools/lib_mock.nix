{ lib, pkgs, ... }:

let
  # --- MOCK TYPES ---
  mockTypes = rec {
    str = "string";
    int = "int";
    bool = "bool";
    path = "path";
    package = "package";
    attrs = "attrs";
    anything = "any";
    raw = "raw";

    listOf = t: "list of ${if builtins.isString t then t else "complex"}";

    attrsOf =
      t:
      if builtins.isAttrs t && t ? _type && t._type == "submodule_schema" then
        t
      else
        "map of ${if builtins.isString t then t else "complex"}";

    # FIXED: Handle submodules that are Sets or Paths, not just Functions
    submodule =
      rawMod:
      let
        modContent = if builtins.isPath rawMod then import rawMod else rawMod;
        modSet =
          if builtins.isFunction modContent then
            modContent {
              lib = mockLib;
              pkgs = pkgs;
              config = { };
              name = "<name>";
            }
          else
            modContent;
      in
      {
        _type = "submodule_schema";
        options = modSet.options or { };
      };

    nullOr = t: "null or ${if builtins.isString t then t else "complex"}";
    oneOf = _: "choice";
    enum = _: "enum";
    mkOptionType = _: "custom_type";
  };

  # --- MOCK LIB ---
  mockLib = lib // {
    mkOption =
      attrs:
      let
        resolvedType = if attrs ? type then attrs.type else "unknown";

        resolvedDefault =
          if attrs ? default then
            (
              if builtins.isFunction attrs.default then
                "<function>"
              else if builtins.isAttrs attrs.default then
                "<set>"
              else
                attrs.default
            )
          else
            null;
      in
      {
        _type = "zen_option";
        description = attrs.description or "No description provided.";
        type = resolvedType;
        default = resolvedDefault;
        internal = attrs.internal or false;
        visible = attrs.visible or true;
        # PASS THROUGH EXTRA METADATA for doc-gen structure
        maintainers = attrs.maintainers or null;
        platforms = attrs.platforms or null;
      };

    mkIf = _cond: content: content;
    mkMerge = contents: builtins.head contents;
    mkDefault = val: val;
    mkForce = val: val;

    types = lib.types // mockTypes;
  };
in
mockLib
