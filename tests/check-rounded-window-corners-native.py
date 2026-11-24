"""Verify the alternate corner module's real Nix action merge."""
import argparse
from pathlib import Path
import subprocess
import sys
import tempfile
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'lib/zen-dsl'))
from zenlang import parse_file
from zenlang.compiler import compile_zmdl_mount
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--nixpkgs', type=Path, required=True)
args = parser.parse_args()
with tempfile.TemporaryDirectory(prefix='zenos-sharp-corners-') as directory:
    module = Path(directory) / 'module.nix'
    module.write_text(compile_zmdl_mount(parse_file(ROOT / 'modules/desktops/gnome/extensions/rounded-window-corners-native.zmdl'), root=ROOT))
    subprocess.run(['nix-instantiate', '--eval', '--strict', '--json', str(ROOT / 'tests/rounded-window-corners-native.nix'),
                    '--arg', 'nixpkgs', str(args.nixpkgs.resolve()), '--arg', 'moduleFile', str(module)], check=True)
