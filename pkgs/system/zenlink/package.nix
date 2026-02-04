{
  lib,
  stdenv,
  makeWrapper,
  android-tools,
  scrcpy,
  pipewire,
  pulseaudio,
  procps,
  systemd,
  util-linux,
  bash,
  coreutils,
  gnugrep,
  which,
  gawk,
  iproute2,
  toybox,
  jq,
  uutils-findutils,
  libnotify,
  python3,
  gst_all_1,
  enableNotify ? true,
}:

let
  inherit (gst_all_1)
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    ;
in
stdenv.mkDerivation {
  pname = "zenlink";
  version = "1.0.0";

  src = ./src/scripts;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 zl-config.sh $out/bin/zl-config
    install -Dm755 zl-daemon.py $out/bin/zl-daemon
    install -Dm755 zl-installer.sh $out/bin/zl-installer
    install -Dm755 zl-debug-phone.sh $out/bin/zl-debug-phone
  '';

  fixupPhase = ''
    for script in zl-config zl-daemon zl-installer zl-debug-phone;
    do
        EXTRA_FLAGS=""
        if [ "$script" == "zl-daemon" ];
        then
            ${lib.optionalString enableNotify ''EXTRA_FLAGS="--add-flags -d"''}
        fi

        wrapProgram $out/bin/$script \
            $EXTRA_FLAGS \
            --prefix PATH : ${
              lib.makeBinPath [
                python3
                bash
                coreutils
                gnugrep
                iproute2
                uutils-findutils
                gawk
                jq
                libnotify
                which
                android-tools
                scrcpy
                pipewire
                gstreamer
                pulseaudio
                procps
                systemd
                toybox
                util-linux
              ]
            } \
            --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${
              lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
                gstreamer
                gst-plugins-base
                gst-plugins-good
                gst-plugins-bad
                gst-plugins-ugly
              ]
            }"
    done
  '';

  meta = with lib; {
    description = ''
      The Android to ZenOS communication bridge

      **ZenLink** (formerly ZeroBridge)

      ZenLink uses termux to stream PC audio to your phone and ADB to stream phone's mic and camera to your PC.
      It provides a seamless integration between mobile hardware and the ZenOS desktop environment.
      Configure using `zl-config` or the gnome extension (`pkgs.desktops.gnome.extensions.zenlink-indicator`).
    '';
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
