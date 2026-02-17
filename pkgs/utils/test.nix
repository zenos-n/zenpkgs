{ lib, pkgs, ... }:
{
    brief = "test";
    description = "test";
    maintainers = [ lib.maintainers.doromiert ];
    license = lib.licenses.napalm;
    dependencies = [];
    version = "1.0.0";

    package = pkgs.stdenv.mkDerivation {
        version = "1.0.0";
    };
}
