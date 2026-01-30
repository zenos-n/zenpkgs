{
  lib,
  stdenv,
  python3,
  ...
}:

stdenv.mkDerivation rec {
  pname = "zenos-maintenance";
  version = "0.1.0";

  src = ./src;

  nativeBuildInputs = [ python3.pkgs.wrapPython ];
  buildInputs = [ python3 ];
  propagatedBuildInputs = [ python3.pkgs.dbus-python ];

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src/zenos_maintenance.py $out/bin/zenos-maintenance
    buildPythonPath "$out $pythonPath"
    patchPythonScript $out/bin/zenos-maintenance
  '';

  meta = with lib; {
    description = "Automated system maintenance and optimization utility";
    longDescription = ''
      The ZenOS Maintenance package provides an intelligent background service that
      optimizes the system during idle periods. 

      Features:
      - **Smart Idle Detection:** Monitors CPU load and input devices to run only when truly idle.
      - **Sleep Inhibition:** Prevents the system from suspending during maintenance.
      - **Auto-Updates:** Runs configured system update commands.
      - **Garbage Collection:** Automatically clears old Nix store paths.
      - **Notifications:** Alerts the user when maintenance is required or completed.
    '';
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
