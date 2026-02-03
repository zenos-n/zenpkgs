{
  lib,
  stdenv,
  python3,
  makeWrapper,
  libnotify,
  util-linux,
  fuse,
  ...
}:

stdenv.mkDerivation rec {
  pname = "zenfs";
  version = "2.0";

  src = ./src;
  dontUnpack = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    (python3.withPackages (ps: [
      ps.psutil
      ps.watchdog
      ps.fusepy
      ps.mutagen
    ]))
    libnotify
    util-linux
    fuse
  ];

  installPhase = ''
    mkdir -p $out/bin $out/libexec/scripts/core $out/libexec/scripts/janitor

    # Install Scripts
    install -Dm755 scripts/core/*.py -t $out/libexec/scripts/core/
    install -Dm755 scripts/janitor/*.py -t $out/libexec/scripts/janitor/

    # --- WRAPPERS ---

    makeWrapper ${python3}/bin/python3 $out/bin/zenfs \
      --add-flags "$out/libexec/scripts/core/dispatcher.py" \
      --prefix PATH : ${
        lib.makeBinPath [
          libnotify
          util-linux
        ]
      } \
      --set PYTHONPATH "$out/libexec/scripts/core"

    makeWrapper ${python3}/bin/python3 $out/bin/zenfs-fuse \
      --add-flags "$out/libexec/scripts/core/fuse_fs.py" \
      --prefix PATH : ${
        lib.makeBinPath [
          libnotify
          util-linux
          fuse
        ]
      } \
      --set PYTHONPATH "$out/libexec/scripts/core"

    makeWrapper ${python3}/bin/python3 $out/bin/zenfs-janitor \
      --add-flags "$out/libexec/scripts/janitor/dispatcher.py" \
      --prefix PATH : ${
        lib.makeBinPath [
          libnotify
          util-linux
          fuse
        ]
      } \
      --set PYTHONPATH "$out/libexec/scripts/janitor:$out/libexec/scripts/core"
  '';

  meta = with lib; {
    description = ''
      ZenOS filesystem hierarchy manager and organization service

      Provides the core logic for the ZenFS filesystem abstraction, including 
      roaming user profile attachments, automated disk offloading, and the 
      Janitor background service for automated file organization.

      ### Components
      - **zenfs**: The primary dispatcher for system-level filesystem hierarchy operations.
      - **zenfs-fuse**: A FUSE-based implementation providing virtual metadata-driven views.
      - **zenfs-janitor**: A background service that manages rule-based file cleanup and categorization.
    '';
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
