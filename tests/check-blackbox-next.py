"""Compatibility entry point for the renamed Blankbox module check."""
from pathlib import Path
import runpy
runpy.run_path(str(Path(__file__).with_name("check-blankbox.py")), run_name="__main__")
