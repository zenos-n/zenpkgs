{
  lib,
  writeShellScriptBin,
  pname,
}:

writeShellScriptBin "zenos-shell" ''
  # Wrapper for nix-shell that injects the ZenPkgs overlay
  # Relies on the system registry pinning 'zenpkgs' to the flake

  export NIX_PATH="nixpkgs=flake:nixpkgs:zenpkgs=flake:zenpkgs"

  exec nix-shell -E "with import <nixpkgs> { overlays = [ (builtins.getFlake \"flake:zenpkgs\").overlays.default ]; }; runCommand \"shell\" { buildInputs = [ $* ]; } \"\""
''
// {
  meta = with lib; {
    version = "1.0";
    description = ''
      Wrapper for nix-shell with ZenPkgs overlay

      Allows you to run commands like `zenos-shell zenos.themes.adwaita` to get a shell with ZenPkgs available, mimicking the legacy `nix-shell -p` behavior but with full access to the ZenOS ecosystem.
    '';
    maintainers = [ maintainers.doromiert ];
    license = licenses.napalm;
    platforms = platforms.zenos;
  };
}
