{ pkgs, sourceRoot }:

let
  python = pkgs.python3.withPackages (p: [ p.lark p.tomlkit p.jsonschema ]);
  codexSchema = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/openai/codex/rust-v0.164.0/codex-rs/core/config.schema.json";
    hash = "sha256-6mEe4/EqbfMUs+SVhQFexuLrx8Pwcsy/Y8ITBqTNtdw=";
  };
  activation = (import ../lib/program-config.nix { inherit (pkgs) lib; }) {
    inherit pkgs;
    application = "codex";
    assignments = [
      { path = [ "analytics" "enabled" ]; value = false; }
      { path = [ "tui" "animations" ]; value = false; }
    ];
  };
  selectActivation = (import ../lib/program-config.nix { inherit (pkgs) lib; }) {
    inherit pkgs;
    application = "select-for-figma";
    assignments = [
      { path = [ "restore-session" ]; value = false; }
      { path = [ "zane-chat-model" ]; value = ""; }
      { path = [ "zane-chat-effort" ]; value = ""; }
    ];
  };
in
pkgs.runCommand "zenpkgs-application-program-options" {
  nativeBuildInputs = [ python pkgs.nix ];
} ''
  export HOME="$TMPDIR/home"
  export CODEX_HOME="$HOME/codex"
  export XDG_DATA_HOME="$HOME/data"
  export NIX_STATE_DIR="$TMPDIR/nix-state"
  export NIX_CONF_DIR="$TMPDIR/nix-conf"
  mkdir -p "$CODEX_HOME" "$NIX_STATE_DIR/profiles" "$NIX_CONF_DIR"
  python ${sourceRoot}/tests/check-application-program-options.py \
    --nixpkgs ${pkgs.path} --codex-schema ${codexSchema}

  NIX_REMOTE=dummy:// NIX_PATH=nixpkgs=${pkgs.path} \
    python ${sourceRoot}/tests/check-codex-usage.py

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
  mkdir -p "$XDG_DATA_HOME/figma-gtk/chromium/Default"
  printf '{"restore-session":true,"open-files":["preserved-file"]}\n' > "$XDG_DATA_HOME/figma-gtk/state.json"
  printf 'private-cookie-sentinel' > "$XDG_DATA_HOME/figma-gtk/chromium/Default/Cookies"
  ${selectActivation.data}
  python - <<'PY'
  import json
  import os
  from pathlib import Path
  root = Path(os.environ["XDG_DATA_HOME"]) / "select-for-figma"
  value = json.loads((root / "state.json").read_text())
  assert value["open-files"] == ["preserved-file"]
  assert value["restore-session"] is False
  assert value["zane-chat-model"] == value["zane-chat-effort"] == ""
  assert (root / "chromium/Default/Cookies").read_text() == "private-cookie-sentinel"
  assert json.loads((root / "state.json.zenos-backup").read_text())["restore-session"] is True
  assert (root / "state.json").stat().st_mode & 0o777 == 0o600
  PY
  touch "$out"
''
