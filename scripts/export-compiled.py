"""Prepare a source worktree for the generated compiled-unstable branch."""

import argparse
import gzip
import json
from pathlib import Path
import re
import shutil

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("bundle", type=Path)
parser.add_argument("worktree", type=Path)
parser.add_argument("revision")
args = parser.parse_args()
if not re.fullmatch(r"[0-9a-f]{40}", args.revision):
    parser.error("revision must be a full source Git commit hash")
manifest = json.loads((args.bundle / "manifest.json").read_text())
if manifest.get("version") != 1:
    parser.error("unsupported compiled artifact version")
destination = args.worktree / ".compiled"
shutil.copytree(args.bundle, destination, ignore=shutil.ignore_patterns("bundle.json"))
destination.chmod(0o755)
with (args.bundle / "bundle.json").open("rb") as source:
    with (destination / "bundle.json.gz").open("wb") as output:
        with gzip.GzipFile(filename="", fileobj=output, mode="wb", mtime=0) as compressed:
            shutil.copyfileobj(source, compressed)
revision_file = args.worktree / ".zenpkgs-revision.new"
revision_file.write_text(args.revision[:7] + "\n")
revision_file.replace(args.worktree / ".zenpkgs-revision")
