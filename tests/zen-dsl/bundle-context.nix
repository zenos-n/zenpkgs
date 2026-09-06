{ bootstrapPkgs }:
let
  asset = builtins.toFile "dsl-context-asset.txt" "retained asset";
  code = "builtins.readFile ${asset}";
  bundleFile = bootstrapPkgs.writeText "dsl-context-bundle.json" (builtins.toJSON {
    sources = [ {
      path = "modules/demo.zmdl";
      compiledNix = code;
      mountNix = code;
      descriptor.kind = "zmdl";
    } ];
    structure.nodes = [ { path = [ "demo" ]; optionNix = code; } ];
  });
  bundle = import ../../lib/read-dsl-bundle.nix bundleFile;
  source = builtins.head bundle.sources;
  node = builtins.head bundle.structure.nodes;
  retained = value: builtins.hasAttr (builtins.unsafeDiscardStringContext asset) (builtins.getContext value);
  checks = {
    compiledContext = retained source.compiledNix;
    mountedContext = retained source.mountNix;
    optionContext = retained node.optionNix;
    dataHasNoContext = !(builtins.hasContext source.path) && !(builtins.hasContext source.descriptor.kind);
    compiledAsset = import (builtins.toFile "dsl-context-compiled.nix" source.compiledNix) == "retained asset";
    mountedAsset = import (builtins.toFile "dsl-context-mounted.nix" source.mountNix) == "retained asset";
    optionAsset = import (builtins.toFile "dsl-context-option.nix" node.optionNix) == "retained asset";
  };
in
assert builtins.all (value: value) (builtins.attrValues checks);
bootstrapPkgs.writeText "dsl-bundle-context-check.json" (builtins.toJSON checks)
