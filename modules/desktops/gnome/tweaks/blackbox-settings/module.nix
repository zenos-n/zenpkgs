{
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
  cfg = config.zenos.desktops.gnome.tweaks.blackBoxSettings;
  meta = {
    description = ''
      Native BlackBox terminal theming for ZenOS

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
in
{

  options.zenos.desktops.gnome.tweaks.blackBoxSettings = {
    _meta = lib.mkOption {
      internal = true;
      readOnly = true;
      default = meta;
      description = "Internal documentation metadata";
    };
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable BlackBox terminal theming

        Applies system-wide theming, font overrides, and layout configurations 
        specifically for the BlackBox terminal emulator.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      blackbox-terminal
      nerd-fonts.atkynson-mono
    ];

    programs.dconf.profiles.user.databases = [
      {
        settings = {
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
            window-height = mkUint32 550;
            window-width = mkUint32 900;
          };
        };
      }
    ];
  };
}
