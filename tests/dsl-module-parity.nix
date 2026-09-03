{ candidates, pkgs }:

let
  expectedModuleCount = 70;
  moduleCount = builtins.length candidates.all;
  categorizedCount = builtins.length candidates.records.system + builtins.length candidates.records.user;
  moduleIds = map (candidate: candidate.moduleId) candidates.all;
  generatedModules = map (candidate: candidate.module) candidates.all;
in
assert moduleCount == expectedModuleCount;
assert categorizedCount == expectedModuleCount;
assert builtins.length (pkgs.lib.unique moduleIds) == expectedModuleCount;
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
