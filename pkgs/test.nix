{ lib, pkgs, ... }:
let
  drv = pkgs.stdenv.mkDerivation rec {
    pname = "hello-zenos";
    version = "2.12.1";

    src = pkgs.fetchurl {
      url = "mirror://gnu/hello/hello-${version}.tar.gz";
      sha256 = "sha256-jZkG7x066XDU9hZQH0QHSf/ZkEt9S866AAbv9n6n9mc=";
    };

    meta = with lib; {
      description = "A classic GNU Hello world for testing the Zenos overlay";
      maintainers = [ ];
      license = licenses.gpl3Plus;
    };
  };
in
{
  # This matches the 'isZenPkg' check in docs.nix
  package = drv;
  brief = "A short summary of what this package does";
  description = "A longer, more detailed explanation for the docs.";
  dependencies = [ "zenos.system.core" ];
  maintainers = [ "doromiert" ];
}
