{ package, command, token, zenfs, symlinkJoin, makeWrapper, lib }:
symlinkJoin {
  name = "${package.name}-zenfs";
  paths = [ package ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    rm "$out/bin/${command}"
    makeWrapper ${zenfs}/bin/zen-compat "$out/bin/${command}" \
      --run 'if [ ! -d "$HOME/.private" ]; then exec ${package}/bin/${command} "$@"; fi' \
      --add-flags 'run ${token} -- ${package}/bin/${command}'
    for service in ${package}/share/dbus-1/services/*; do
      if [ -f "$service" ] && grep -Fq '${package}/bin/${command}' "$service"; then
        target="$out/share/dbus-1/services/$(basename "$service")"
        rm "$target"
        substitute "$service" "$target" \
          --replace-fail '${package}/bin/${command}' "$out/bin/${command}"
      fi
    done
  '';
  inherit (package) meta version;
  passthru = (package.passthru or { }) // lib.optionalAttrs (package ? src) { inherit (package) src; };
}
