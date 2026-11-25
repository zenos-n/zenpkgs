# Preserve native HDR while optionally correcting SDR content per output.
# Keep the implementation and its native rendering tests in the package source.
{ mutter, fetchFromGitHub }:
if mutter.version != "50.4" || (mutter.zenosSdrHdrCorrection or false) then mutter else
import (fetchFromGitHub {
  owner = "doromiert";
  repo = "zenos-mutter";
  rev = "04cdae75b3d3cad1326a26909dc2109356e5e7ea";
  hash = "sha256-HLmfWiN2sneXo8GpynKrXVHIHBInZIK5Rw2Dds3P4Uo=";
}) { inherit mutter; }
