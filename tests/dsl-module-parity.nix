{ candidates, pkgs }:

let
  expectedModuleCount = 70;
  moduleCount = builtins.length candidates;
  sourcePaths = map (candidate: candidate.sourcePath) candidates;
  modulePaths = map (candidate: builtins.toJSON candidate.modulePath) candidates;
  optionPaths = map (candidate: builtins.toJSON candidate.optionPath) candidates;
  identities = map (candidate: candidate.identity) candidates;
  generatedModules = map (candidate: candidate.module) candidates;
  recordsArePathDerived = pkgs.lib.all (
    candidate:
    candidate.sourcePath == "modules/${pkgs.lib.concatStringsSep "/" candidate.modulePath}.zmdl"
    && candidate.optionPath == [ "zenos" ] ++ candidate.modulePath
    && candidate.identity == pkgs.lib.concatStringsSep "." candidate.optionPath
  ) candidates;
in
assert moduleCount == expectedModuleCount;
assert builtins.length (pkgs.lib.unique sourcePaths) == expectedModuleCount;
assert builtins.length (pkgs.lib.unique modulePaths) == expectedModuleCount;
assert builtins.length (pkgs.lib.unique optionPaths) == expectedModuleCount;
assert builtins.length (pkgs.lib.unique identities) == expectedModuleCount;
assert recordsArePathDerived;
pkgs.runCommand "zenpkgs-dsl-module-contract" { inherit generatedModules; } ''
  export HOME="$TMPDIR/home"
  export NIX_STATE_DIR="$TMPDIR/nix-state"
  export NIX_CONF_DIR="$TMPDIR/nix-conf"
  mkdir -p "$HOME" "$NIX_STATE_DIR/profiles" "$NIX_CONF_DIR"

  parsed=0
  for module in $generatedModules; do
    ${pkgs.nix}/bin/nix-instantiate --parse "$module" >/dev/null
    parsed=$((parsed + 1))
  done

  if [ "$parsed" -ne ${toString expectedModuleCount} ]; then
    echo "expected ${toString expectedModuleCount} generated ZMDL modules, parsed $parsed" >&2
    exit 1
  fi

  touch "$out"
''
