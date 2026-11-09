"""Check typed progress switches without evaluating a full desktop configuration."""
import argparse
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'lib/zen-dsl'))
from zenlang import parse_file
from zenlang.compiler import compile_zmdl_mount

parser = argparse.ArgumentParser()
parser.add_argument('--nixpkgs', type=Path, required=True)
args = parser.parse_args()
with tempfile.TemporaryDirectory(prefix='zenos-progress-') as temporary:
    for module, backend in [('system/boot/verbose', 'services.bootvine.enable'),
                            ('system/nix/monitor', 'programs.zenosNixMonitor.enable')]:
        compiled = Path(temporary) / 'module.nix'
        compiled.write_text(compile_zmdl_mount(parse_file(ROOT / f'modules/{module}.zmdl'), root=ROOT))
        expression = '''let
 lib = import NIXPKGS_LIB;
 make = cfg: import MODULE {inherit lib cfg; pkgs={}; user=null; config={};};
 schema = (make {}).schema;
 disabled = (lib.evalModules {modules=[schema];}).config;
 enabled = (lib.evalModules {modules=[schema {enable=true;}];}).config;
 flatten = v: if builtins.isList v then map flatten v else if !builtins.isAttrs v then v else
  if (v._type or "") == "if" then (if v.condition then flatten v.content else {}) else
  if (v._type or "") == "override" then flatten v.content else
  if (v._type or "") == "merge" then lib.foldl' lib.recursiveUpdate {} (map flatten v.contents) else
  lib.mapAttrs (_: flatten) v;
 actions = flatten (lib.mkMerge (make enabled).actions);
 in assert disabled.enable == false; assert actions.BACKEND == true; true
'''.replace('NIXPKGS_LIB',str(args.nixpkgs.resolve()/'lib')).replace('MODULE',str(compiled)).replace('BACKEND',backend)
        subprocess.run(['nix-instantiate','--eval','--strict','--expr',expression],check=True)
