# Legacy OpenAL Soft defaults to DONT_MOVE, stranding games on lost outputs.
{ config, lib, ... }:
{
  environment.etc."openal/alsoft.conf" = lib.mkIf config.services.pipewire.pulse.enable {
    text = lib.mkDefault ''
      [pulse]
      allow-moves = true
    '';
  };
}
