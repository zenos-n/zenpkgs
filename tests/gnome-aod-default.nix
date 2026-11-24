{ nixpkgs, moduleFile }:
let
 lib = import (nixpkgs + "/lib");
 module = import moduleFile { inherit lib; cfg = {}; pkgs = {}; config = {}; };
 defaults = (lib.evalModules { modules = [ module.schema ]; }).config;
 disabled = (lib.evalModules { modules = [ module.schema { aod.enable = false; } ]; }).config;
in
assert defaults.aod.enable;
assert !disabled.aod.enable;
{ gnomeDefaultOn = true; explicitOff = true; }
