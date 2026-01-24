{
  lib,
  stdenv,
  pkgs,
  refind-theme ? "zenos-refind-theme",
  resolution ? "max",
  scannedDevices ? "external, optical, manual",
  extraIncludedFiles ? null,
  extraConfig ? null,
  timeout ? 5,
  use_nvram ? false,
  enable_mouse ? true,
  maxGenrations ? 10,
  ...
}:
stdenv.mkDerivation {
  pname = "zenboot";
  version = "1.0";

  src = ./src;

  unpackPhase = "null";

  nativeBuildInputs = with pkgs; [
    refind
    atkinson-hyperlegible
    zenos-plymouth
    zenos-refind-theme
  ];

  buildPhase = "
  cat > $out/refind.conf << EOF
  # rEFInd Configuration for ZenOS 
  timeout ${timeout}
  use_nvram ${use_nvram}
  ${
      if enable_mouse then "enable_mouse" else ""
    }

  resolution ${resolution}

  scanfor ${scannedDevices}

  # Boot entries
  include zenboot-entries.conf

  # Theme include
  include theme/${refind-theme}/theme.conf

  # Extra included files if present
  ${
      if extraIncludedFiles != null then
        lib.mapAttrs (name: value: "include ${value}") extraIncludedFiles
      else
        ""
    }

  # Extra config if present
  ${
      if extraConfig != null then extraConfig else ""
    }
  EOF

  maxGens = ${toString maxGenrations}
  ";

  installPhase = "";

  meta = with lib; {
    description = "ZenOS bootloader based on refind";
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [
      doromiert
    ];
    platforms = platforms.linux;
  };
}
