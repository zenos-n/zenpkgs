# Preserve native HDR while optionally correcting SDR content per output.
# Keep the implementation and its native rendering tests in the package source.
{ mutter, fetchFromGitHub }:
if mutter.version != "50.4" || (mutter.zenosSdrHdrCorrection or false) then mutter else
import (fetchFromGitHub {
  owner = "doromiert";
  repo = "zenos-mutter";
  rev = "b191aeabf82f35711b6b447ef2254aa72b69c81a";
  hash = "sha256-uWCzpkE7FPPYoepAs0KGNIbSGbxAkzue4bEQt7xm0i8=";
}) { inherit mutter; }
