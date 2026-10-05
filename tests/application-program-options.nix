{ pkgs, sourceRoot }:

let
  python = pkgs.python3.withPackages (p: [ p.lark p.tomlkit p.jsonschema ]);
  codexSchema = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/openai/codex/rust-v0.159.0/codex-rs/core/config.schema.json";
    hash = "sha256-7aclG35G4LnQ89ju9dq0UeEaVdcj4rgC4VK3IIBFg2o=";
  };
  activation = (import ../lib/program-config.nix { inherit (pkgs) lib; }) {
    inherit pkgs;
    application = "codex";
    assignments = [
      { path = [ "analytics" "enabled" ]; value = false; }
      { path = [ "tui" "animations" ]; value = false; }
    ];
  };
in
pkgs.runCommand "zenpkgs-application-program-options" {
  nativeBuildInputs = [ python pkgs.nix ];
} ''
  export HOME="$TMPDIR/home"
  export CODEX_HOME="$HOME/codex"
  export NIX_STATE_DIR="$TMPDIR/nix-state"
  export NIX_CONF_DIR="$TMPDIR/nix-conf"
  mkdir -p "$CODEX_HOME" "$NIX_STATE_DIR/profiles" "$NIX_CONF_DIR"
  python ${sourceRoot}/tests/check-application-program-options.py \
    --nixpkgs ${pkgs.path} --codex-schema ${codexSchema}

  printf '# preserved comment\nmodel = "preserved-model"\n' > "$CODEX_HOME/config.toml"
  run() { "$@"; }
  ${activation.data}
  python - <<'PY'
  import os
  from pathlib import Path
  import tomllib
  path = Path(os.environ["CODEX_HOME"]) / "config.toml"
  value = tomllib.loads(path.read_text())
  assert value["model"] == "preserved-model"
  assert value["analytics"]["enabled"] is False
  assert value["tui"]["animations"] is False
  assert "# preserved comment" in path.read_text()
  assert path.with_name("config.toml.zenos-backup").read_text() == '# preserved comment\nmodel = "preserved-model"\n'
  PY
  touch "$out"
''
