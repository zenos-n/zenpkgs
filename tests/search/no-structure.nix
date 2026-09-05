let
  root = toString ../..;
  source = builtins.path {
    path = ../..;
    name = "zenpkgs-search-without-structure";
    filter = path: _: path != root + "/structure.zstr" && baseNameOf path != ".git";
  };
  index = import (source + "/scripts/gen-docs.nix");
in
assert index.options == { };
assert index.pkgs == { };
{
  noStructureNoExposure = true;
}
