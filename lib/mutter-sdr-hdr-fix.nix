# Preserve native HDR while optionally correcting SDR content per output.
# Keep the implementation and its native rendering tests in the package source.
{ mutter, fetchFromGitHub }:
if mutter.version != "50.4" || (mutter.zenosSdrHdrCorrection or false) then mutter else
import (fetchFromGitHub {
  owner = "doromiert";
  repo = "zenos-mutter";
  rev = "c3169c82997c4f0d5b8be14f94a51ed11ab69591";
  hash = "sha256-Kgu2sDXi+HJqF5J4vePy/Wm62cWn6moHThsNkq/SzSQ=";
}) { inherit mutter; }
