{
  lib,
  stdenv,
  python3,
  ...
}:

stdenv.mkDerivation {
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
    description = ''
      Automated system maintenance and optimization utility

      The ZenOS Maintenance package provides an intelligent background service that
      optimizes the system during idle periods. 

      **Features:**
      - **Smart Idle Detection:** Monitors CPU load to run tasks when user is away.
      - **Garbage Collection:** Automatically clears old Nix store paths.
      - **Notifications:** Alerts the user when maintenance is completed.
    '';
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
