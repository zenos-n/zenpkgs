{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gobject-introspection
, wrapGAppsHook4
, python3
, gtk4
, libadwaita
, libgweather
, networkmanager
, gst_all_1
, gparted
, firefox
, gnome-console
, desktop-file-utils
, appstream
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "zenos-setup";
  version = "0.1.0";

  # switched to local path since there are no upstream releases yet
  src = /home/doromiert/Projects/ZenOS-Setup;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    python3
    desktop-file-utils # provides update-desktop-database
    appstream         # provides appstreamcli
    libxml2           # often needed for appstream/desktop validation
  ];

  buildInputs = [
    gtk4
    libadwaita
    libgweather
    networkmanager
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-libav
    python3
    python3.pkgs.pygobject3
    python3.pkgs.requests
    python3.pkgs.babel
  ];

  # since we aren't using buildPythonApplication, we handle the PATH and PYTHONPATH manually
  postInstall = ''
    wrapProgram $out/bin/zenos-setup \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix PATH : ${lib.makeBinPath [ gparted gnome-console firefox ]}
  '';

  meta = with lib; {
    description = "ZenOS Setup - Unified Installer and OOBE";
    license = licenses.napalm;
    platforms = platforms.linux;
  };
}
