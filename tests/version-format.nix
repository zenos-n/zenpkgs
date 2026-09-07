{ lib }:
let
  format = (import ../lib/utils.nix {
    inherit lib;
    inputs = { };
    self.shortRev = "abc123";
  }).mkVersionString;
  rejects = value: !(builtins.tryEval value).success;
  checks = {
    defaultVersion = format { } == "1.0.0Nb (abc123)";
    alpha = format { major = "2.3.4"; type = "alpha"; } == "2.3.4Na (abc123)";
    beta = format { major = "2.3.4"; type = "beta"; } == "2.3.4Nb (abc123)";
    stable = format { major = "2.3.4"; type = "stable"; } == "2.3.4N";
    noVariant = format { major = "2.3.4"; type = "stable"; variant = ""; } == "2.3.4";
    shortVersionRejected = rejects (format { major = "1.0"; });
    invalidLifecycleRejected = rejects (format { type = "lts"; });
    invalidVariantRejected = rejects (format { variant = "n"; });
  };
in
assert builtins.all (value: value) (builtins.attrValues checks);
checks
