{ lib }:

{ pkgs, application, assignments, stateDirectory ? null }:
let
  python = pkgs.python3.withPackages (p: [ p.tomlkit ]);
  specification = pkgs.writeText "zenos-${application}-preferences.json" (builtins.toJSON {
    inherit application assignments stateDirectory;
  });
in
{
  after = [ "writeBoundary" ];
  before = [ ];
  data = lib.optionalString (assignments != [ ]) ''
    run ${python}/bin/python ${./program-config.py} ${specification}
  '';
}
