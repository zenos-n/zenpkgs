{
  pkgs,
  lib,
  modules,
}:

let
  mockLib = import ./lib_mock.nix { inherit lib pkgs; };

  # CRITICAL: This set MUST match the arguments expected by framework.nix
  mockArgs = {
    lib = mockLib;
    pkgs = pkgs;
    config = {
      zenos = { };
      users = { };
    }; # Dummy config
    options = { };

    # 1. Satisfy 'zenpkgsInputs' argument
    zenpkgsInputs = {
      self = { };
      nixpkgs = { };
      home-manager = { };
    };

    # 2. Satisfy 'loaders' argument (and its usage of loadModules)
    loaders = {
      loadLib = _: { };
      # Return empty list to bypass module imports during doc gen
      loadModules = _: [ ];
    };
  };

  # Evaluate the framework to get the option tree
  frameworkEval =
    if builtins.isPath (builtins.head modules) then
      import (builtins.head modules) mockArgs
    else
      (builtins.head modules) mockArgs;

  optionsJson = pkgs.writeText "zenos-raw-options.json" (builtins.toJSON frameworkEval.options);

in
pkgs.writeShellScriptBin "zen-doc-gen" ''
  echo "[ZenDoc] Generating documentation schema..."
  ${pkgs.python3}/bin/python3 ${./doc_gen.py} "${optionsJson}"
  echo "[ZenDoc] Done. Output written to zenos-options.json"
''
