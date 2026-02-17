{ lib, pkgs, ... }:
{


    package = pkgs.stdenv.mkDerivation {
        pname = "name";
        version = "1.0.0";
    };
}
