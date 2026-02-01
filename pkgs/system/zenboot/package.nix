{
  lib,
  stdenv,
  pkgs,
  python3,
  resolution ? "max",
  scannedDevices ? [
    "external"
    "optical"
    "manual"
  ],
  extraIncludedFiles ? null,
  extraConfig ? null,
  timeout ? 5,
  use_nvram ? false,
  enable_mouse ? true,
  maxGenerations ? 10,
  profileDir ? "/nix/var/nix/profiles/system",
  espMountPoint ? "/boot",
  osIcon ? "zenos",
  ...
}:

stdenv.mkDerivation {
  pname = "zenboot";
  version = "1.0";

  src = ./src;

  dontUnpack = true;

  nativeBuildInputs = with pkgs; [
    refind
    python3
  ];

  buildInputs = with pkgs; [
    # Assumes this package exists in the overlay/scope as requested in the input
    # If not, it might need to be passed or referenced differently.
    zenos.theming.system.zenos-refind-theme
  ];

  buildPhase = ''
    mkdir -p build/config
    mkdir -p build/bin

    # --- Build refind.conf ---
    cat > build/config/refind.conf << EOF
    # rEFInd Configuration for ZenOS
    timeout ${toString timeout}
    use_nvram ${if use_nvram then "true" else "false"}
    ${lib.optionalString enable_mouse "enable_mouse"}
    resolution ${resolution}
    scanfor ${lib.concatStringsSep ", " scannedDevices}

    # Include the dynamically generated entries file
    include zenboot-entries.conf

    # Include the theme
    include theme/theme.conf

    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n: v: "include ${v}") (
        if extraIncludedFiles != null then extraIncludedFiles else { }
      )
    )}
    ${if extraConfig != null then extraConfig else ""}
    EOF
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/zenboot

    cp build/config/refind.conf $out/share/zenboot/

    cp $src/scripts/zenboot-setup.py $out/share/zenboot/zenboot-setup.py

    mkdir -p $out/share/zenboot/theme
    # Adjust path if needed based on actual package structure
    cp -r ${pkgs.zenos.theming.system.zenos-refind-theme}/boot/EFI/refind/themes/zenos-refind-theme/* $out/share/zenboot/theme/

    cat > $out/bin/zenboot-setup << EOF
    #!${pkgs.bash}/bin/bash
    export PATH=${
      lib.makeBinPath [
        pkgs.refind
        pkgs.coreutils
        pkgs.python3
      ]
    }:\$PATH
    export ESP_MOUNT="${espMountPoint}"
    export PROFILE_DIR="${profileDir}"
    export OS_ICON="${osIcon}"
    export GEN_COUNT="${toString maxGenerations}"
    export ZENBOOT_SHARE="$out/share/zenboot"

    exec ${pkgs.python3}/bin/python3 $out/share/zenboot/zenboot-setup.py
    EOF

    chmod +x $out/bin/zenboot-setup
  '';

  meta = with lib; {
    description = "ZenOS bootloader automation based on rEFInd";
    longDescription = ''
      **ZenBoot** is an automated bootloader management tool for ZenOS, built on top of rEFInd.
      It handles the generation of boot entries, manages EFI variables, and applies the ZenOS
      theme to the bootloader.

      **Features:**
      - Automatic generation of rEFInd configuration.
      - Integration with NixOS generations.
      - Theming support via `zenos-refind-theme`.
    '';
    homepage = "https://zenos.neg-zero.com";
    license = licenses.napl;
    maintainers = with maintainers; [ doromiert ];
    platforms = platforms.zenos;
  };
}
