{ pkgs, ... }:

let
  # fetch the entire repository at once
  configSource = pkgs.fetchFromGitHub {
    owner = "zenos-n";
    repo = "fastfetch-config";
    rev = "main"; # or a specific commit hash for stability
    sha256 = "pkgs.lib.fakeHash"; # use the mismatch trick to get the real hash
  };
in
{
  # map the files directly from the fetched source
  xdg.configFile."fastfetch/config.jsonc".source = "${configSource}/config.jsonc";
  xdg.configFile."fastfetch/ascii.txt".source = "${configSource}/ascii.txt";
}
