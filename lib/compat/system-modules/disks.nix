{ config, lib, ... }:

let
  cfg = config.zenos.system.disks;
in
{
  options.zenos.system.disks = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "Declarative ZenOS disk layout forwarded to Disko.";
  };

  config = lib.mkIf (cfg != { }) {
    disko.devices = cfg;
  };
}
