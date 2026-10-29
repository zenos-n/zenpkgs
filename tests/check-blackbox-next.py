"""Compile and evaluate the Black Box module without a system build."""
import argparse
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "lib/zen-dsl"))
from zenlang import parse_file
from zenlang.compiler import compile_zmdl_mount

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--nixpkgs", type=Path, required=True)
parser.add_argument("--home-manager", type=Path, required=True)
args = parser.parse_args()
with tempfile.TemporaryDirectory(prefix="blackbox-module-") as directory:
    compiled = Path(directory) / "module.nix"
    compiled.write_text(compile_zmdl_mount(
        parse_file(ROOT / "modules/programs/blackbox-next.zmdl"), root=ROOT))
    subprocess.run(["nix-instantiate", "--eval", "--strict", "--json",
                    str(ROOT / "tests/blackbox-next-module.nix"),
                    "--arg", "nixpkgs", str(args.nixpkgs.resolve()),
                    "--arg", "homeManager", str(args.home_manager.resolve()),
                    "--arg", "moduleFile", str(compiled)], check=True)
