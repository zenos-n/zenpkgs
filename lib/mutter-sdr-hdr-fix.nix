# Preserve native HDR while optionally correcting SDR content per output.
# Keep the implementation and its native rendering tests in the package source.
{ mutter, fetchFromGitHub }:
if mutter.version != "50.4" || (mutter.zenosSdrHdrCorrection or false) then mutter else
import (fetchFromGitHub {
  owner = "doromiert";
  repo = "zenos-mutter";
  rev = "1dd4c27964ce914b3d23ac24c669620472454328";
  hash = "sha256-3WR1ylIha6ytWBoZYtwxpv5F0jaeBi9JRzOfM3lCRG8=";
}) { inherit mutter; }
