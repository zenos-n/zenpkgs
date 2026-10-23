{ pkgs }:
let
  package = pkgs.zenos.gay.nzp.nzportable;
  category = pkgs.zenos.byCategories.apps.gaming.nzportable;
  softwareGL = pkgs.buildEnv {
    name = "nzportable-software-gl";
    paths = [ pkgs.mesa.drivers pkgs.libglvnd ];
    pathsToLink = [ "/lib" "/share/glvnd" ];
  };
in
assert package.drvPath == category.drvPath;
assert package.outPath == category.outPath;
pkgs.runCommand "nzportable-native-startup" {
  nativeBuildInputs = [ pkgs.coreutils pkgs.gnugrep pkgs.xvfb-run pkgs.xorg-server ];
  env.software = softwareGL;
  # Only the small success marker is exported, never the game or startup log.
  allowedReferences = [ ];
} ''
  export HOME="$TMPDIR/home"
  export XDG_DATA_HOME="$TMPDIR/data"
  export XDG_RUNTIME_DIR="$TMPDIR/runtime"
  mkdir -p "$HOME" "$XDG_DATA_HOME" "$XDG_RUNTIME_DIR"
  chmod 700 "$XDG_RUNTIME_DIR"
  export LIBGL_ALWAYS_SOFTWARE=1
  export GALLIUM_DRIVER=llvmpipe
  export LIBGL_DRIVERS_PATH="$software/lib/dri"
  export LD_LIBRARY_PATH="$software/lib"
  export __EGL_VENDOR_LIBRARY_DIRS="$software/share/glvnd/egl_vendor.d"
  export SDL_AUDIODRIVER=dummy
  export SDL_VIDEODRIVER=x11

  # Baseline: the pinned official archive asset 665884245 supplies wahnsinn.bsp
  # (archive SHA256 6b07a8622e400d01d13e42ee0f9f28ceaded86860601759a0c6c89ed295bcfea).
  # The successful native smoke reaches "player entered the game" and stays alive.
  test -s ${package}/share/nzportable/nzp/maps/wahnsinn.bsp
  status=0
  xvfb-run -a timeout --kill-after=5s 12s \
    ${package}/bin/nzportable +map wahnsinn > startup.log 2>&1 || status=$?
  if [ "$status" -ne 124 ]; then
    tail -n 100 startup.log
    echo "NZPortable exited with $status; expected timeout 124" >&2
    exit 1
  fi
  if ! grep -Fq 'Nazi Zombies Portable Initialized' startup.log \
    || ! grep -Fq 'player entered the game' startup.log \
    || grep -Eiq "Couldn.t spawn server|Host_Error|Sys_Error|(^|[[:space:]])(error|fatal)([[:space:]:]|$)|could(n.t| not) (load|open|find).*\\.bsp|\\.bsp.*(not found|missing)" startup.log; then
    tail -n 100 startup.log
    echo "NZPortable failed initialization or map loading" >&2
    exit 1
  fi
  test -w "$XDG_DATA_HOME/nzportable/nzp/config.cfg"
  test -L "$XDG_DATA_HOME/nzportable/nzp/progs.dat"
  printf 'NZPortableInitialized: wahnsinn; software GL; timeout 124\n' > "$out"
''
