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
      s5 = replaceRegex "\\([[:space:]]*group[[:space:]]+([-a-zA-Z0-9_.$]+)[[:space:]]*\\)" (
        g: "{ _type = \"group\"; name = \"${builtins.elemAt g 0}\"; }"
      ) s4;
      s6 =
        replaceRegex
          "\\([[:space:]]*import[[:space:]]+([^[:space:]]+)[[:space:]]*[{]([^}]+)[}][[:space:]]*\\)"
          (g: "{ _type = \"import\"; path = \"${builtins.elemAt g 0}\"; args = {${builtins.elemAt g 1}}; }")
          s5;
      s7 = replaceRegex "\\([[:space:]]*needs[[:space:]]+([-a-zA-Z0-9_.$]+)[[:space:]]*\\)" (
        g: "{ _type = \"needs\"; dep = \"${builtins.elemAt g 0}\"; }"
      ) s6;

      # 2. _let hook translations
      s8 = replaceRegex "\\([[:space:]]*freeform[[:space:]]+([-a-zA-Z0-9_.$]+)[[:space:]]*\\)" (
        g: "\"__freeform_${builtins.elemAt g 0}\""
      ) s7;

      # 2. _let hook translations (Update this to take s8 as input!)
      s9 = replaceRegex "_let[[:space:]]+([a-zA-Z0-9_-]+)[[:space:]]*:[[:space:]]*[^=]+=" (
        g: "_vars.\"${builtins.elemAt g 0}\" ="
      ) s8;

      # 4. Zen Namespaces ($ variables mapping)
      s10 =
        builtins.replaceStrings
          [
            "$name"
            "$path"
            "$pkgs"
            "$c"
            "$v"
            "$m"
            "$l"
            "$type"
            "$lib"
            "$f"
          ]
          [
            "__zargs.name"
            "__zargs.path"
            "__zargs.pkgs.zenos"
            "__zargs.colors"
            "_vars"
            "__zargs.maintainers"
            "__zargs.licenses"
            "__zargs.type"
            "lib"
            "__zargs.context"
          ]
          s9;

    in
    s10;

  evalZString =
    {
      name,
      path ? [ ],
      isUserScope ? false,
      file,
      extraArgs ? { },
    }:
    let
      raw = builtins.readFile file;
      transpiled = transpileZString raw;

      # We wrap in `with __zargs; rec { ... }` so `_vars` and variables are safely localized
      tmpFile = builtins.unsafeDiscardStringContext (
        builtins.toFile "${name}-transpiled.nix" ''
          __zargs: with __zargs; rec {
            ${transpiled}
          }
        ''
      );

      rawModule = import tmpFile;

      # Overloaded enableOption implementation
      enableOptionImpl =
        arg1:
        if
          builtins.isAttrs arg1
          && (arg1 ? _action || arg1 ? _meta || arg1 ? _saction || arg1 ? _uaction || arg1 ? _vars)
        then
          arg1
          // {
            _type = "enableOption";
            _deps = { };
          }
        else
          (
            body:
            body
            // {
              _type = "enableOption";
              _deps = arg1;
            }
          );

      __zargs = {
        inherit name path isUserScope;
        enableOption = enableOptionImpl;

        # Zen Type System Registry
        type = {
          string = "string";
          int = "int";
          float = "float";
          boolean = "boolean";
          array = "array";
          set = "set";
          enum = vals: {
            name = "enum";
            values = vals;
          };
        };

        # Global Colors Theme Tokens ($c)
        colors = {
          primary = "#0055ff";
          secondary = "#00aaff";
          accent = "#ff0055";
          bg = "#111111";
          fg = "#eeeeee";
          white = "#ffffff";
          black = "#000000";
          error = "#ff0000";
          warning = "#ffaa00";
        };

        # Execution Context Variables ($f)
        context = {
          user = "doromiert"; # Configurable/dynamic target username
        };
      }
      // extraArgs;

      evaluated = rawModule __zargs;

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
              if k == "_meta" || k == "_action" || k == "_saction" || k == "_uaction" || k == "_vars" then
                v
              else
                propagateMetaRecursive nodeLicense nodeMaintainers v;
          in
          lib.mapAttrs processChild newNode
        else
          node;

      finalConfig = propagateMetaRecursive (evaluated._meta.license or null) (evaluated._meta.maintainers
        or [ ]
      ) evaluated;

    in
    finalConfig;

in
{
  inherit transpileZString evalZString;
}
