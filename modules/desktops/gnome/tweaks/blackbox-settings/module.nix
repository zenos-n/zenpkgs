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
  options.zenos.desktop.gnome.tweaks.blackBoxSettings = {
    enable = lib.mkEnableOption "BlackBox theming for ZenOS.";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      blackbox-terminal
      nerd-fonts.atkynson-mono
    ];

    programs.dconf.profiles.user.databases = [
      {

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
      }
    ];
  };
}
