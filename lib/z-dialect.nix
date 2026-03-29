{ lib }:
let
  # Applies a regex and replaces matches using a mapping function
  replaceRegex =
    regex: f: str:
    let
      parts = builtins.split regex str;
    in
    lib.concatMapStrings (p: if builtins.isList p then f p else p) parts;

  # Transpiles custom ZenOS syntax into a valid Nix expression string
  transpileZString =
    str:
    let
      # 1. Functional RHS Constructs -> map to Typed Nodes
      s1 = replaceRegex "\\([[:space:]]*alias[[:space:]]+([-a-zA-Z0-9_.$()]+)[[:space:]]*\\)" (
        g: "{ _type = \"alias\"; target = \"${builtins.elemAt g 0}\"; }"
      ) str;
      s2 = replaceRegex "\\([[:space:]]*zmdl[[:space:]]+([-a-zA-Z0-9_.$()]+)[[:space:]]*\\)" (
        g: "{ _type = \"zmdl\"; target = \"${builtins.elemAt g 0}\"; }"
      ) s1;
      s3 = replaceRegex "\\([[:space:]]*programs[[:space:]]*\\)" (g: "{ _type = \"programs\"; }") s2;
      s4 = replaceRegex "\\([[:space:]]*packages[[:space:]]*\\)" (g: "{ _type = \"packages\"; }") s3;

      # 2. LHS Freeform Definitions: `(freeform name) =` -> `__z_freeform_name =`
      s5 =
        replaceRegex "\\([[:space:]]*freeform[[:space:]]+([-a-zA-Z0-9_]+)[[:space:]]*\\)[[:space:]]*="
          (g: "__z_freeform_${builtins.elemAt g 0} =")
          s4;

      # 3. Action Shorthands: `s! {`, `u! {`, `! {`
      s6 = replaceRegex "(^|[[:space:]]+)s![[:space:]]*\\{" (g: "${builtins.elemAt g 0}_saction = {") s5;
      s7 = replaceRegex "(^|[[:space:]]+)u![[:space:]]*\\{" (g: "${builtins.elemAt g 0}_uaction = {") s6;
      s8 = replaceRegex "(^|[[:space:]]+)![[:space:]]*\\{" (g: "${builtins.elemAt g 0}_action = {") s7;

      # 4. Typed _let Variable Bindings -> Maps to `_v` dict payload
      # e.g., `_let default_port: $type.int = 8080;` -> `_v.default_port = 8080;`
      s9 =
        replaceRegex "_let[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]*:[[:space:]]*[^=]+=[[:space:]]*([^;]+);"
          (g: "_v.${builtins.elemAt g 0} = ${builtins.elemAt g 1};")
          s8;

      # 5. Freeform & Variable Keyword Mappings
      # Path-embedded `$f` evaluates to a system string placeholder for dynamic replacement during `mkConfig`
      s10 = replaceRegex "\\(\\$f\\.([a-zA-Z0-9_]+)\\)" (g: "__Z_FREEFORM_ID__") s9;
      s11 = replaceRegex "\\$f\\.([a-zA-Z0-9_]+)" (g: "\"__Z_FREEFORM_ID__\"") s10;
      s12 = replaceRegex "\\$v\\.([a-zA-Z0-9_]+)" (g: "_v.${builtins.elemAt g 0}") s11;

      # 6. Global Variables: $cfg, $pkgs, $path, $name, $c, $lib, $l, $m, $type
      s13 = replaceRegex "\\$(cfg|pkgs|path|name|c|lib|l|m|type)" (
        g: "__zargs.${builtins.elemAt g 0}"
      ) s12;
    in
    s13;

  interpolateStrings =
    args: config:
    let
      walk =
        val:
        if builtins.isString val then
          builtins.replaceStrings [ "__zargs.name" ] [ args.name ] val
        else if builtins.isAttrs val then
          lib.mapAttrs (n: v: walk v) val
        else if builtins.isList val then
          map walk val
        else
          val;
    in
    walk config;

  evalZString =
    {
      name ? "unknown",
      path ? { },
      content,
      maintainers ? { },
      licenses ? { },
      pkgs ? null,
      extraArgs ? { },
    }:
    let
      transpiled = transpileZString content;

      nixExprString = ''
        __zargs: with __zargs; rec {
          ${transpiled}
        }
      '';

      tmpFile = builtins.toFile "zenos-transpiled-${name}.nix" nixExprString;
      rawModule = import tmpFile;

      __zargs = {
        inherit
          name
          path
          pkgs
          lib
          ;
        cfg = extraArgs.config or { };
        c = extraArgs.c or { };
        m = maintainers;
        l = licenses;
        type = {
          bool = {
            _type = "ztype";
            name = "bool";
          };
          boolean = {
            _type = "ztype";
            name = "boolean";
          };
          string = {
            _type = "ztype";
            name = "string";
          };
          int = {
            _type = "ztype";
            name = "int";
          };
          float = {
            _type = "ztype";
            name = "float";
          };
          null = {
            _type = "ztype";
            name = "null";
          };
          set = {
            _type = "ztype";
            name = "set";
          };
          list = {
            _type = "ztype";
            name = "list";
          };
          path = {
            _type = "ztype";
            name = "path";
          };
          package = {
            _type = "ztype";
            name = "package";
          };
          packages = {
            _type = "ztype";
            name = "packages";
          };
          color = {
            _type = "ztype";
            name = "color";
          };
          function = args: {
            _type = "ztype";
            name = "function";
            inherit args;
          };
          enum = vals: {
            _type = "ztype";
            name = "enum";
            values = vals;
          };
          either = types: {
            _type = "ztype";
            name = "either";
            values = types;
          };
        };
        enableOption = attrs: attrs // { _type = "enableOption"; };
      }
      // extraArgs;

      evaluated = rawModule __zargs;
      interpolated = interpolateStrings { inherit name; } evaluated;

      propagateMetaRecursive =
        parentLicense: parentMaintainers: node:
        if builtins.isAttrs node && !(node ? _type) then
          let
            nodeLicense = node._meta.license or parentLicense;
            nodeMaintainers = node._meta.maintainers or parentMaintainers;

            newNode =
              if node ? _meta then
                node
                // {
                  _meta = node._meta // {
                    license = nodeLicense;
                    maintainers = nodeMaintainers;
                  };
                }
              else
                node
                // {
                  _meta = {
                    license = nodeLicense;
                    maintainers = nodeMaintainers;
                  };
                };

            processChild =
              k: v:
              if k == "_meta" || k == "_action" || k == "_saction" || k == "_uaction" || k == "_v" then
                v
              else
                propagateMetaRecursive nodeLicense nodeMaintainers v;
          in
          lib.mapAttrs processChild newNode
        else
          node;

      finalConfig = propagateMetaRecursive (interpolated._meta.license or null
      ) (interpolated._meta.maintainers or [ ]) interpolated;

    in
    finalConfig;

in
{
  inherit transpileZString evalZString;
}
