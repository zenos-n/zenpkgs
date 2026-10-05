let
  inputs = (import ../flake.nix).inputs;
  validInput =
    input:
    builtins.match "path:/nix/store/.*" input.url == null
    && builtins.match "github:[^/]+/[^/]+/.+" input.url != null;
in
assert builtins.all validInput (builtins.attrValues inputs);
{
  checkedInputs = builtins.attrNames inputs;
  explicitReleaseOrRevision = true;
  noFrozenStoreInputs = true;
  noLocalSourceInputs = true;
}
