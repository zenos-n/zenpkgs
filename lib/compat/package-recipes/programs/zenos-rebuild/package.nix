{
  fetchFromGitHub,
  lib,
  makeWrapper,
  stdenv,
  pkgs,
  ...
}:

stdenv.mkDerivation {
  pname = "zenos-rebuild";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "zenos-n";
    repo = "zenos-rebuild";
    rev = "aefdcb87f40bdb432e91ffdb76887b669a4a4690";
    hash = "sha256-lFu+UmiLwu9A71MgBTymjfmMoIqsF624r6LNw9BrgkM=";
  };

  propagatedBuildInputs = with pkgs; [
    libnotify
    tmux
  ];

  nativeBuildInputs = with pkgs; [
    bash
    makeWrapper
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 $src/scripts/zenos-rebuild.sh $out/bin/zenos-rebuild
    patchShebangs $out/bin/zenos-rebuild
    wrapProgram $out/bin/zenos-rebuild \
      --prefix PATH : ${lib.makeBinPath [ pkgs.tmux ]}
  '';

  meta = with lib; {
    description = ''
      Convenience wrapper for nixos-rebuild switch

      **zenos-rebuild** is a wrapper script around `nixos-rebuild switch` 
      specifically designed for the ZenOS environment. It provides automated 
      session management and user feedback.

      **Features:**
      - Automates the rebuild and switch process.
      - Provides desktop notifications via libnotify.
      - Runs inside a tmux session for resilience.
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
