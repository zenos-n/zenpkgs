{ pkgs }:
let
  vencord = pkgs.zenos.byCategories.apps.communication.vencord;
  vesktop = pkgs.zenos.byCategories.apps.communication.vesktop;
  # Nixcord explicitly passes these arguments to the selected Vesktop package.
  nixcordVesktop = vesktop.override {
    withSystemVencord = true;
    withMiddleClickScroll = true;
    inherit vencord;
  };
in
assert vencord.drvPath == pkgs.zenos.unknown.vencord.drvPath;
assert vesktop.drvPath == pkgs.zenos.dev.vencord.Vesktop.drvPath;
pkgs.runCommand "vencord-webpack-compatibility" {
  nativeBuildInputs = [ pkgs.nodejs ];
} ''
  node ${./check-vencord.mjs} ${vencord}/vencordDesktopRenderer.js.map
  grep -aqF '${vencord}' ${vesktop}/opt/Vesktop/resources/app.asar
  grep -aqF '${vencord}' ${nixcordVesktop}/opt/Vesktop/resources/app.asar
  touch "$out"
''
