# Explorer-compatible view of native user options and their package selectors.
let
  index = import ./gen-docs.nix;
  nativeNode = node: node // (
    if node ? sub then {
      sub = builtins.mapAttrs (_: nativeNode) (builtins.removeAttrs node.sub [ "legacy" ]);
    } else {}
  );
in index // {
  options = if index.options ? users then { users = nativeNode index.options.users; } else {};
  pkgs = builtins.removeAttrs index.pkgs [ "legacy" ];
  metadata = index.metadata // {
    view = "native-user-options";
    omitted = [ "non-user options" "legacy aliases" "upstream package tree" ];
    warnings = builtins.filter (warning:
      let path = warning.mountedAt or [];
      in path != [] && builtins.elem (builtins.head path) [ "users" "pkgs" ]
    ) index.metadata.warnings;
  };
}
