# Preserve native HDR while optionally correcting SDR content per output.
# Keep the implementation and its native rendering tests in the package source.
{ mutter, fetchFromGitHub }:
if mutter.version != "50.4" || (mutter.zenosSdrHdrCorrection or false) then mutter else
import (fetchFromGitHub {
  owner = "doromiert";
  repo = "zenos-mutter";
  rev = "e73570c5881a6baa5362a2b447cd3914023de5f3";
  hash = "sha256-DHEAlzerHLWPIy17u7TTq+pI78DZJfHuh1wzClcd5TE=";
}) { inherit mutter; }
