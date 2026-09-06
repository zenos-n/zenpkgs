path:
let
  text = builtins.readFile path;
  context = builtins.getContext text;
  bundle = builtins.fromJSON (builtins.unsafeDiscardStringContext text);
  restoreCode = record: record // builtins.listToAttrs (map (name: {
    inherit name;
    value = builtins.appendContext record.${name} context;
  }) (builtins.filter (name: builtins.isString (record.${name} or null)) [
    "compiledNix" "mountNix" "optionNix"
  ]));
in
# JSON data cannot carry Nix context; executable strings must retain asset roots.
bundle // {
  sources = map restoreCode bundle.sources;
  structure = bundle.structure // {
    nodes = map restoreCode (bundle.structure.nodes or [ ]);
  };
}
