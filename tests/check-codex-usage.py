"""Validate the optional Codex Usage module's package and user activation scopes."""
from pathlib import Path
import json
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'lib/zen-dsl'))
from zenlang import parse_file
from zenlang.compiler import compile_zmdl_mount

with tempfile.TemporaryDirectory(prefix='zen-codex-usage-') as temporary:
    source = Path(temporary) / 'module.nix'
    source.write_text(compile_zmdl_mount(parse_file(ROOT / 'modules/desktops/gnome/extensions/codex-usage.zmdl'), root=ROOT))
    expression = f'''
let
  lib = import <nixpkgs/lib>;
  package = {{ type = "derivation"; outPath = "/codex-usage"; extensionUuid = "codex-usage@kevinpita.dev"; }};
  pkgs.zenos.byCategories.desktops.gnome.extensions.codex-usage = package;
  make = values: user: (import {source}) {{ inherit lib pkgs user; cfg = values; config = {{}}; }};
  schema = (make {{}} null).schema;
  evaluate = enabled: (lib.evalModules {{ modules = [schema {{ enable = enabled; }}]; }}).config;
in {{ system = (make (evaluate true) null).actions; enabled = (make (evaluate true) "alice").actions; disabled = (make (evaluate false) "alice").actions; }}
'''
    result = subprocess.run(['nix-instantiate', '--eval', '--strict', '--json', '--expr', expression], check=True, capture_output=True, text=True)
    data = json.loads(result.stdout)
    enabled = data['enabled']
    system = data['system'][0]['content']
    user = enabled[1]['home-manager']['users']['alice']
    assert system['environment']['systemPackages'][0] == '/codex-usage'
    assert user['content']['dconf']['settings']['org/gnome/shell']['enabled-extensions'] == ['codex-usage@kevinpita.dev']
    assert data['disabled'][1]['home-manager']['users']['alice']['condition'] is False
    print('Codex Usage module: package and per-user activation PASS')
