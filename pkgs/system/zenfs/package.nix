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
      ps.mutagen # For Music Janitor
    ]))
    libnotify
    util-linux
    fuse
  ];

  installPhase = ''
    mkdir -p $out/bin $out/libexec/scripts/core $out/libexec/scripts/janitor

    # Core
    install -Dm755 scripts/core/*.py -t $out/libexec/scripts/core/

    # Janitor
    install -Dm755 scripts/janitor/*.py -t $out/libexec/scripts/janitor/

    # --- WRAPPERS ---

    # 1. Main ZenFS CLI
    makeWrapper ${python3}/bin/python3 $out/bin/zenfs \
      --add-flags "$out/libexec/scripts/core/dispatcher.py" \
      --prefix PATH : ${
        lib.makeBinPath [
          libnotify
          util-linux
        ]
      } \
      --set PYTHONPATH "$out/libexec/scripts/core"

    # 2. ZenFS FUSE (Core)
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

    # 3. ZenFS Janitor CLI
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
    description = "ZenFS Filesystem Manager & Janitor";
    longDescription = ''
      ZenFS Core Utilities.
      Includes:
      - mint/attach/detach: Drive Management
      - core: Config categorization
      - roaming: Database Sync
      - fuse: Custom User Union Filesystem
      - janitor: Automated organization daemon (Dumb/Music/ML)
    '';
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
