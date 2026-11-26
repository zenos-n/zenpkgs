# Preserve native HDR while optionally correcting SDR content per output.
# Keep the implementation and its native rendering tests in the package source.
{ mutter, fetchFromGitHub }:
if mutter.version != "50.4" || (mutter.zenosSdrHdrCorrection or false) then mutter else
import (fetchFromGitHub {
  owner = "doromiert";
  repo = "zenos-mutter";
  rev = "faa74f2ca130c08b67a8a5a0eed849620b56f5aa";
  hash = "sha256-PDfSpZj4P8oyO88D/yop+Ow7pZRGab1UE5HBymeo4yU=";
}) { inherit mutter; }
