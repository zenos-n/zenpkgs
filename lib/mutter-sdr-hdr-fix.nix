# Preserve native HDR while optionally correcting SDR content per output.
# Keep the implementation and its native rendering tests in the package source.
{ mutter, fetchFromGitHub }:
if mutter.version != "50.4" || (mutter.zenosSdrHdrCorrection or false) then mutter else
import (fetchFromGitHub {
  owner = "doromiert";
  repo = "zenos-mutter";
  rev = "0d5046e817b15995bed8bba15f6aacee2540f134";
  hash = "sha256-X61TXRS45+jsvSILh4bGZkjxfkZh8J1uu6dRztqSI2A=";
}) { inherit mutter; }
