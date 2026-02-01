{
  options,
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib.gvariant)
    mkTuple
    mkUint32
    ;
  cfg = config.zenos.desktop.gnome.tweaks.blackBoxSettings;
in

{
  meta = {
    description = "Configures BlackBox terminal theming for ZenOS";
    longDescription = ''
      This module applies the ZenOS theme configuration to the BlackBox terminal.
      It sets the font to "Atkynson Mono", configures window dimensions, padding,
      and floating controls for a consistent look and feel.

      **Features:**
      - Installs BlackBox and Atkynson Mono font.
      - Sets default window size and padding via dconf.
      - Configures UI elements like headerbar and controls.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktop.gnome.tweaks.blackBoxSettings = {
    enable = lib.mkEnableOption "BlackBox theming for ZenOS";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      blackbox-terminal
      nerd-fonts.atkynson-mono
    ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          # --- BlackBox Terminal ---
          "com/raggesilver/BlackBox" = {
            floating-controls = true;
            font = "Atkynson Mono NF 11";
            show-headerbar = false;
            terminal-padding = mkTuple [
              (mkUint32 5)
              (mkUint32 5)
              (mkUint32 5)
              (mkUint32 5)
            ];
            window-height = mkUint32 744;
            window-width = mkUint32 828;
          };
        };
      }
    ];
  };
}
