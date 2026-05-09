{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zenos-fastfetch-theme";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zenos-n";
    repo = "fastfetch-config";
    rev = version;
    sha256 = "sha256-Rhq5uFVZ/KOvHZucfFA+5Aoa1pl9NQf0xJQHnINQumQ=";
  };

  # we don't need to build anything, just move files
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fastfetch
    cp config.jsonc $out/share/fastfetch/config.jsonc
    cp ascii.txt $out/share/fastfetch/ascii.txt
  '';

  meta = with lib; {
    description = "Fastfetch theme for ZenOS";
    homepage = "https://github.com/zenos-n/fastfetch-config";
    license = licenses.napalm;
    maintainers = [ maintainers.doromiert ];
  };
}
