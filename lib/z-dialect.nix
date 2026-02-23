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
      # Added the hyphen `-` at the start of the character class and literal `()`
      # This allows target paths like `nixpkgs.home-manager.users.($f.user)`
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

      # 3. Keyword Variables: $name, $path, $m, $l, $type
      s6 = replaceRegex "\\$(name|path|m|l|type)" (g: "__zargs.${builtins.elemAt g 0}") s5;
    in
    s6;

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
        __zargs: with __zargs; {
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
        m = maintainers;
        l = licenses;
        type = {
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
          enum = vals: {
            _type = "ztype";
            name = "enum";
            values = vals;
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
              if k == "_meta" || k == "_action" || k == "_saction" || k == "_uaction" then
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
